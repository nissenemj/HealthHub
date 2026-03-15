"""HealthHub – Flask web application for migraine management."""

import os
from datetime import datetime, date, timedelta
from flask import Flask, render_template, request, redirect, url_for, jsonify, flash

from models import (
    init_db, get_metrics_today, get_all_meals, get_all_migraines,
    get_migraines_since, get_meals_since, get_tags_today, get_all_baselines,
    get_risk_assessments_since,
    save_meal, save_migraine, save_context_tag,
    delete_meal, delete_migraine,
    MetricType, MigraineSeverity,
)
from risk_engine import calculate_daily_risk, recalculate_baselines
from oura_client import OuraClient

app = Flask(__name__)
app.secret_key = os.urandom(24)

OURA_TOKEN = os.environ.get("OURA_TOKEN", "CY5S3RLFDEG2BF74U4MMV5JCGZNNJQDG")

CONTEXT_CATEGORIES = [
    "Matkailu", "Stressi", "Alkoholi", "Hormonaalinen",
    "Sää", "Liikunta", "Ruutuaika", "Nestehukka", "Ateria väliin", "Muu",
]

COMMON_SYMPTOMS = [
    "Päänsärky", "Pahoinvointi", "Valoherkkyys",
    "Ääniherkkyys", "Näköhäiriöt", "Huimaus",
]


# ---------- Dashboard ----------

@app.route("/")
def dashboard():
    risk = calculate_daily_risk()
    metrics = get_metrics_today()
    migraines = get_all_migraines()[:5]
    tags = get_tags_today()

    # Migraine-free days
    migraine_free_days = 0
    if migraines:
        last = datetime.fromisoformat(migraines[0]["start_time"])
        migraine_free_days = (datetime.now() - last).days

    # Group metrics by type for display
    metric_display = {}
    type_labels = {
        "hrv": ("HRV", "ms"), "resting_hr": ("Leposyke", "bpm"),
        "sleep_duration": ("Uni", "h"), "sleep_quality": ("Unen laatu", "p"),
        "deep_sleep": ("Syvä uni", "p"), "rem_sleep": ("REM-uni", "p"),
        "steps": ("Askeleet", ""), "active_calories": ("Kalorit", "kcal"),
        "skin_temperature": ("Ihon lämpö", "°C"), "readiness_score": ("Valmius", "p"),
    }
    for m in metrics:
        mt = m["metric_type"]
        if mt not in metric_display:
            label, unit = type_labels.get(mt, (mt, ""))
            metric_display[mt] = {"label": label, "value": m["value"], "unit": unit}

    return render_template("dashboard.html",
        risk=risk,
        metrics=metric_display,
        migraines=migraines,
        tags=tags,
        migraine_free_days=migraine_free_days,
        categories=CONTEXT_CATEGORIES,
    )


# ---------- Meals ----------

@app.route("/meals")
def meals():
    all_meals = get_all_meals()
    return render_template("meals.html", meals=all_meals)


@app.route("/meals/add", methods=["POST"])
def add_meal():
    desc = request.form.get("description", "")
    ingredients = [i.strip() for i in request.form.get("ingredients", "").split(",") if i.strip()]
    triggers = [t.strip() for t in request.form.get("triggers", "").split(",") if t.strip()]
    meal_time = request.form.get("meal_time") or datetime.now().isoformat()
    notes = request.form.get("notes", "")
    save_meal(desc, ingredients, triggers, meal_time, notes)
    flash("Ateria tallennettu", "success")
    return redirect(url_for("meals"))


@app.route("/meals/delete/<meal_id>", methods=["POST"])
def remove_meal(meal_id):
    delete_meal(meal_id)
    flash("Ateria poistettu", "success")
    return redirect(url_for("meals"))


# ---------- Migraines ----------

@app.route("/migraines")
def migraines():
    all_events = get_all_migraines()
    return render_template("migraines.html",
        migraines=all_events,
        severities=list(MigraineSeverity),
        symptoms=COMMON_SYMPTOMS,
    )


@app.route("/migraines/add", methods=["POST"])
def add_migraine():
    start_time = request.form.get("start_time") or datetime.now().isoformat()
    severity = int(request.form.get("severity", 2))
    had_aura = request.form.get("had_aura") == "on"
    symptoms = request.form.getlist("symptoms")
    medications = [m.strip() for m in request.form.get("medications", "").split(",") if m.strip()]
    notes = request.form.get("notes", "")
    end_time = request.form.get("end_time") or None
    save_migraine(start_time, severity, had_aura, symptoms, medications, notes, end_time)
    flash("Migreeni kirjattu", "success")
    return redirect(url_for("migraines"))


@app.route("/migraines/delete/<event_id>", methods=["POST"])
def remove_migraine(event_id):
    delete_migraine(event_id)
    flash("Kirjaus poistettu", "success")
    return redirect(url_for("migraines"))


# ---------- Trends ----------

@app.route("/trends")
def trends():
    period = request.args.get("period", "week")
    days = {"week": 7, "month": 30, "quarter": 90}.get(period, 7)
    since = (datetime.now() - timedelta(days=days)).isoformat()

    migraine_list = get_migraines_since(since)
    risk_list = get_risk_assessments_since(
        (date.today() - timedelta(days=days)).isoformat()
    )
    meals_list = get_meals_since(since)

    avg_risk = 0
    if risk_list:
        avg_risk = sum(r["risk_score"] for r in risk_list) / len(risk_list)

    # Top triggers
    trigger_counts = {}
    for meal in meals_list:
        for t in meal["potential_triggers"]:
            trigger_counts[t] = trigger_counts.get(t, 0) + 1
    top_triggers = sorted(trigger_counts.items(), key=lambda x: -x[1])[:5]

    return render_template("trends.html",
        period=period,
        migraine_count=len(migraine_list),
        avg_risk=round(avg_risk, 1),
        top_triggers=top_triggers,
        risk_history=risk_list[:30],
    )


# ---------- Settings ----------

@app.route("/settings")
def settings():
    oura_connected = bool(OURA_TOKEN)
    baselines = get_all_baselines()
    return render_template("settings.html",
        oura_connected=oura_connected,
        baselines=baselines,
    )


@app.route("/settings/sync", methods=["POST"])
def sync_oura():
    if not OURA_TOKEN:
        flash("Oura-token puuttuu", "error")
        return redirect(url_for("settings"))

    try:
        client = OuraClient(OURA_TOKEN)
        result = client.sync_today()
        recalculate_baselines()
        flash(f"Synkronointi onnistui: {len(result)} mittaria", "success")
    except Exception as e:
        flash(f"Synkronointivirhe: {e}", "error")

    return redirect(url_for("settings"))


@app.route("/settings/test-oura", methods=["POST"])
def test_oura():
    if not OURA_TOKEN:
        flash("Oura-token puuttuu", "error")
        return redirect(url_for("settings"))

    try:
        client = OuraClient(OURA_TOKEN)
        info = client.test_connection()
        flash(f"Oura-yhteys toimii! ID: {info.get('id', 'ok')}", "success")
    except Exception as e:
        flash(f"Oura-yhteysvirhe: {e}", "error")

    return redirect(url_for("settings"))


# ---------- Context Tags (AJAX) ----------

@app.route("/tags/add", methods=["POST"])
def add_tag():
    category = request.form.get("category", "Muu")
    note = request.form.get("note", "")
    save_context_tag(category, note)
    flash(f"Konteksti '{category}' lisätty", "success")
    return redirect(url_for("dashboard"))


# ---------- Init & Run ----------

if __name__ == "__main__":
    init_db()
    # Initial Oura sync on startup
    if OURA_TOKEN:
        try:
            client = OuraClient(OURA_TOKEN)
            client.sync_today()
            recalculate_baselines()
            print("✓ Oura-synkronointi onnistui käynnistyksessä")
        except Exception as e:
            print(f"⚠ Oura-synkronointi epäonnistui: {e}")

    print("HealthHub käynnistyy: http://localhost:5000")
    app.run(host="0.0.0.0", port=5000, debug=True)

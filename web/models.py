"""Data models for HealthHub — mirrors the iOS Swift models."""

import sqlite3
import json
import uuid
from datetime import datetime, date, timedelta
from dataclasses import dataclass, field, asdict
from enum import Enum
from typing import Optional
from pathlib import Path

DB_PATH = Path(__file__).parent / "healthhub.db"


# ---------- Enums ----------

class MetricType(str, Enum):
    HRV = "hrv"
    RESTING_HR = "resting_hr"
    SLEEP_DURATION = "sleep_duration"
    SLEEP_QUALITY = "sleep_quality"
    DEEP_SLEEP = "deep_sleep"
    REM_SLEEP = "rem_sleep"
    STEPS = "steps"
    ACTIVE_CALORIES = "active_calories"
    SKIN_TEMPERATURE = "skin_temperature"
    READINESS_SCORE = "readiness_score"


class MetricSource(str, Enum):
    OURA = "oura"
    MANUAL = "manual"


class RiskLevel(str, Enum):
    LOW = "low"
    MODERATE = "moderate"
    ELEVATED = "elevated"
    HIGH = "high"

    @property
    def label(self) -> str:
        return {
            "low": "Matala", "moderate": "Kohtalainen",
            "elevated": "Kohonnut", "high": "Korkea",
        }[self.value]

    @property
    def color(self) -> str:
        return {
            "low": "#22c55e", "moderate": "#eab308",
            "elevated": "#f97316", "high": "#ef4444",
        }[self.value]


class MigraineSeverity(int, Enum):
    MILD = 1
    MODERATE = 2
    SEVERE = 3
    DEBILITATING = 4

    @property
    def label(self) -> str:
        return {1: "Lievä", 2: "Kohtalainen", 3: "Voimakas", 4: "Invalidisoiva"}[self.value]

    @property
    def color(self) -> str:
        return {1: "#eab308", 2: "#f97316", 3: "#ef4444", 4: "#a855f7"}[self.value]


# ---------- Database ----------

def get_db() -> sqlite3.Connection:
    conn = sqlite3.connect(str(DB_PATH))
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA journal_mode=WAL")
    return conn


def init_db():
    conn = get_db()
    conn.executescript("""
        CREATE TABLE IF NOT EXISTS health_metrics (
            id TEXT PRIMARY KEY,
            metric_type TEXT NOT NULL,
            value REAL NOT NULL,
            unit TEXT NOT NULL,
            source TEXT NOT NULL,
            recorded_at TEXT NOT NULL,
            created_at TEXT NOT NULL
        );
        CREATE INDEX IF NOT EXISTS idx_metrics_type_date
            ON health_metrics(metric_type, recorded_at);

        CREATE TABLE IF NOT EXISTS meal_entries (
            id TEXT PRIMARY KEY,
            meal_description TEXT DEFAULT '',
            ingredients TEXT DEFAULT '[]',
            potential_triggers TEXT DEFAULT '[]',
            meal_time TEXT NOT NULL,
            notes TEXT DEFAULT '',
            created_at TEXT NOT NULL
        );

        CREATE TABLE IF NOT EXISTS migraine_events (
            id TEXT PRIMARY KEY,
            start_time TEXT NOT NULL,
            end_time TEXT,
            severity INTEGER NOT NULL DEFAULT 2,
            had_aura INTEGER NOT NULL DEFAULT 0,
            symptoms TEXT DEFAULT '[]',
            medications TEXT DEFAULT '[]',
            notes TEXT DEFAULT '',
            created_at TEXT NOT NULL
        );

        CREATE TABLE IF NOT EXISTS context_tags (
            id TEXT PRIMARY KEY,
            category TEXT NOT NULL,
            note TEXT DEFAULT '',
            date TEXT NOT NULL,
            created_at TEXT NOT NULL
        );

        CREATE TABLE IF NOT EXISTS daily_risk_assessments (
            id TEXT PRIMARY KEY,
            date TEXT NOT NULL,
            risk_score REAL NOT NULL DEFAULT 0,
            risk_level TEXT NOT NULL DEFAULT 'low',
            factors TEXT DEFAULT '[]',
            recommendation TEXT,
            created_at TEXT NOT NULL
        );

        CREATE TABLE IF NOT EXISTS baselines (
            id TEXT PRIMARY KEY,
            metric_type TEXT NOT NULL UNIQUE,
            median_value REAL NOT NULL,
            sample_count INTEGER NOT NULL,
            last_updated TEXT NOT NULL
        );
    """)
    conn.commit()
    conn.close()


# ---------- CRUD Helpers ----------

def _now() -> str:
    return datetime.now().isoformat()


def _today_start() -> str:
    return datetime.combine(date.today(), datetime.min.time()).isoformat()


# -- Health Metrics --

def save_metric(metric_type: str, value: float, unit: str,
                source: str = "oura", recorded_at: str | None = None):
    conn = get_db()
    conn.execute(
        "INSERT OR REPLACE INTO health_metrics VALUES (?,?,?,?,?,?,?)",
        (str(uuid.uuid4()), metric_type, value, unit, source,
         recorded_at or _now(), _now())
    )
    conn.commit()
    conn.close()


def get_metrics_today() -> list[dict]:
    conn = get_db()
    rows = conn.execute(
        "SELECT * FROM health_metrics WHERE recorded_at >= ? ORDER BY recorded_at DESC",
        (_today_start(),)
    ).fetchall()
    conn.close()
    return [dict(r) for r in rows]


def get_metrics_since(metric_type: str, since: str) -> list[dict]:
    conn = get_db()
    rows = conn.execute(
        "SELECT * FROM health_metrics WHERE metric_type=? AND recorded_at>=? ORDER BY recorded_at",
        (metric_type, since)
    ).fetchall()
    conn.close()
    return [dict(r) for r in rows]


# -- Meals --

def save_meal(description: str, ingredients: list[str], triggers: list[str],
              meal_time: str, notes: str = "") -> str:
    mid = str(uuid.uuid4())
    conn = get_db()
    conn.execute(
        "INSERT INTO meal_entries VALUES (?,?,?,?,?,?,?)",
        (mid, description, json.dumps(ingredients), json.dumps(triggers),
         meal_time, notes, _now())
    )
    conn.commit()
    conn.close()
    return mid


def get_all_meals() -> list[dict]:
    conn = get_db()
    rows = conn.execute(
        "SELECT * FROM meal_entries ORDER BY meal_time DESC"
    ).fetchall()
    conn.close()
    result = []
    for r in rows:
        d = dict(r)
        d["ingredients"] = json.loads(d["ingredients"])
        d["potential_triggers"] = json.loads(d["potential_triggers"])
        result.append(d)
    return result


def get_meals_since(since: str) -> list[dict]:
    conn = get_db()
    rows = conn.execute(
        "SELECT * FROM meal_entries WHERE meal_time>=? ORDER BY meal_time DESC",
        (since,)
    ).fetchall()
    conn.close()
    result = []
    for r in rows:
        d = dict(r)
        d["ingredients"] = json.loads(d["ingredients"])
        d["potential_triggers"] = json.loads(d["potential_triggers"])
        result.append(d)
    return result


def delete_meal(meal_id: str):
    conn = get_db()
    conn.execute("DELETE FROM meal_entries WHERE id=?", (meal_id,))
    conn.commit()
    conn.close()


# -- Migraines --

def save_migraine(start_time: str, severity: int = 2, had_aura: bool = False,
                  symptoms: list[str] = None, medications: list[str] = None,
                  notes: str = "", end_time: str | None = None) -> str:
    mid = str(uuid.uuid4())
    conn = get_db()
    conn.execute(
        "INSERT INTO migraine_events VALUES (?,?,?,?,?,?,?,?,?)",
        (mid, start_time, end_time, severity, int(had_aura),
         json.dumps(symptoms or []), json.dumps(medications or []),
         notes, _now())
    )
    conn.commit()
    conn.close()
    return mid


def get_all_migraines() -> list[dict]:
    conn = get_db()
    rows = conn.execute(
        "SELECT * FROM migraine_events ORDER BY start_time DESC"
    ).fetchall()
    conn.close()
    result = []
    for r in rows:
        d = dict(r)
        d["symptoms"] = json.loads(d["symptoms"])
        d["medications"] = json.loads(d["medications"])
        d["had_aura"] = bool(d["had_aura"])
        d["severity_label"] = MigraineSeverity(d["severity"]).label
        d["severity_color"] = MigraineSeverity(d["severity"]).color
        result.append(d)
    return result


def get_migraines_since(since: str) -> list[dict]:
    conn = get_db()
    rows = conn.execute(
        "SELECT * FROM migraine_events WHERE start_time>=? ORDER BY start_time DESC",
        (since,)
    ).fetchall()
    conn.close()
    result = []
    for r in rows:
        d = dict(r)
        d["symptoms"] = json.loads(d["symptoms"])
        d["medications"] = json.loads(d["medications"])
        d["had_aura"] = bool(d["had_aura"])
        result.append(d)
    return result


def delete_migraine(event_id: str):
    conn = get_db()
    conn.execute("DELETE FROM migraine_events WHERE id=?", (event_id,))
    conn.commit()
    conn.close()


# -- Baselines --

def save_baseline(metric_type: str, median_value: float, sample_count: int):
    conn = get_db()
    conn.execute(
        """INSERT INTO baselines (id, metric_type, median_value, sample_count, last_updated)
           VALUES (?, ?, ?, ?, ?)
           ON CONFLICT(metric_type) DO UPDATE SET
             median_value=excluded.median_value,
             sample_count=excluded.sample_count,
             last_updated=excluded.last_updated""",
        (str(uuid.uuid4()), metric_type, median_value, sample_count, _now())
    )
    conn.commit()
    conn.close()


def get_all_baselines() -> dict[str, dict]:
    conn = get_db()
    rows = conn.execute("SELECT * FROM baselines").fetchall()
    conn.close()
    return {r["metric_type"]: dict(r) for r in rows}


# -- Risk Assessments --

def save_risk_assessment(risk_score: float, risk_level: str,
                         factors: list[dict], recommendation: str | None = None):
    conn = get_db()
    conn.execute(
        "INSERT INTO daily_risk_assessments VALUES (?,?,?,?,?,?,?)",
        (str(uuid.uuid4()), date.today().isoformat(), risk_score, risk_level,
         json.dumps(factors), recommendation, _now())
    )
    conn.commit()
    conn.close()


def get_risk_assessments_since(since: str) -> list[dict]:
    conn = get_db()
    rows = conn.execute(
        "SELECT * FROM daily_risk_assessments WHERE date>=? ORDER BY date DESC",
        (since,)
    ).fetchall()
    conn.close()
    result = []
    for r in rows:
        d = dict(r)
        d["factors"] = json.loads(d["factors"])
        result.append(d)
    return result


# -- Context Tags --

def save_context_tag(category: str, note: str = ""):
    conn = get_db()
    conn.execute(
        "INSERT INTO context_tags VALUES (?,?,?,?,?)",
        (str(uuid.uuid4()), category, note, date.today().isoformat(), _now())
    )
    conn.commit()
    conn.close()


def get_tags_today() -> list[dict]:
    conn = get_db()
    rows = conn.execute(
        "SELECT * FROM context_tags WHERE date=?",
        (date.today().isoformat(),)
    ).fetchall()
    conn.close()
    return [dict(r) for r in rows]

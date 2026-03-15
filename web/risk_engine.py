"""Rule-based migraine risk engine — port of iOS RiskEngine.swift."""

from models import (
    get_metrics_today, get_all_baselines, get_tags_today,
    get_metrics_since, save_baseline, save_risk_assessment,
    MetricType, RiskLevel,
)
from datetime import datetime, timedelta
import statistics


# Weight constants
W_HRV = 0.35
W_SLEEP = 0.25
W_RHR = 0.20
W_CONTEXT = 0.20

HIGH_RISK_TAGS = {"Stressi", "Alkoholi", "Nestehukka", "Ateria väliin"}


def calculate_daily_risk() -> dict:
    """Calculate today's risk assessment based on metrics, baselines, and context."""
    metrics = get_metrics_today()
    baselines = get_all_baselines()
    tags = get_tags_today()

    factors = []
    total_score = 0.0

    # Helper: get latest metric value by type
    def latest(metric_type: str) -> float | None:
        for m in metrics:
            if m["metric_type"] == metric_type:
                return m["value"]
        return None

    # HRV component (35%)
    hrv_val = latest(MetricType.HRV)
    hrv_bl = baselines.get(MetricType.HRV)
    if hrv_val is not None and hrv_bl:
        bl_median = hrv_bl["median_value"]
        if bl_median > 0:
            deviation = ((hrv_val - bl_median) / bl_median) * 100
            component = max(0, min(1, -deviation / 30)) * W_HRV * 100
            if component > 5:
                factors.append({
                    "name": "HRV poikkeama",
                    "contribution": W_HRV,
                    "detail": f"{-deviation:.0f}% alle perusviivan",
                })
            total_score += component

    # Sleep component (25%)
    sleep_val = latest(MetricType.SLEEP_DURATION)
    sleep_bl = baselines.get(MetricType.SLEEP_DURATION)
    if sleep_val is not None and sleep_bl:
        deficit = sleep_bl["median_value"] - sleep_val
        component = max(0, min(1, deficit / 3)) * W_SLEEP * 100
        if component > 5:
            factors.append({
                "name": "Univaje",
                "contribution": W_SLEEP,
                "detail": f"{deficit:.1f} h vajetta",
            })
        total_score += component

    # Resting HR component (20%)
    rhr_val = latest(MetricType.RESTING_HR)
    rhr_bl = baselines.get(MetricType.RESTING_HR)
    if rhr_val is not None and rhr_bl:
        bl_median = rhr_bl["median_value"]
        if bl_median > 0:
            elevation = ((rhr_val - bl_median) / bl_median) * 100
            component = max(0, min(1, elevation / 20)) * W_RHR * 100
            if component > 5:
                factors.append({
                    "name": "Leposyke koholla",
                    "contribution": W_RHR,
                    "detail": f"{elevation:.0f}% yli perusviivan",
                })
            total_score += component

    # Context component (20%)
    if tags:
        risky = [t for t in tags if t["category"] in HIGH_RISK_TAGS]
        component = min(1, len(risky) / 3) * W_CONTEXT * 100
        if component > 0:
            tag_names = ", ".join(t["category"] for t in tags)
            factors.append({
                "name": "Konteksti",
                "contribution": W_CONTEXT,
                "detail": tag_names,
            })
        total_score += component

    total_score = min(100, total_score)

    if total_score < 25:
        risk_level = RiskLevel.LOW
    elif total_score < 50:
        risk_level = RiskLevel.MODERATE
    elif total_score < 75:
        risk_level = RiskLevel.ELEVATED
    else:
        risk_level = RiskLevel.HIGH

    recommendation = _generate_recommendation(risk_level, factors)

    # Save to DB
    save_risk_assessment(total_score, risk_level.value, factors, recommendation)

    return {
        "risk_score": round(total_score, 1),
        "risk_level": risk_level.value,
        "risk_label": risk_level.label,
        "risk_color": risk_level.color,
        "factors": factors,
        "recommendation": recommendation,
    }


def _generate_recommendation(risk_level: RiskLevel, factors: list[dict]) -> str | None:
    if risk_level == RiskLevel.LOW:
        return None
    if not factors:
        return None

    top = max(factors, key=lambda f: f["contribution"])
    recommendations = {
        "HRV poikkeama": "HRV on laskenut – harkitse kevyempää päivää ja huolehdi nesteytyksestä.",
        "Univaje": "Palautuminen jäi vajaaksi – priorisoi unta tänä iltana.",
        "Leposyke koholla": "Leposyke on koholla – vältä raskasta kuormitusta ja pidä taukoja.",
        "Konteksti": "Riskitekijöitä havaittu – huomioi palautuminen tänään.",
    }
    return recommendations.get(
        top["name"],
        "Riskitaso koholla – kuuntele kehoasi ja pidä huolta palautumisesta."
    )


def recalculate_baselines():
    """Recalculate 14-day rolling median baselines for all metric types."""
    since = (datetime.now() - timedelta(days=14)).isoformat()

    for mt in MetricType:
        rows = get_metrics_since(mt.value, since)
        values = [r["value"] for r in rows]
        if values:
            median = statistics.median(values)
            save_baseline(mt.value, median, len(values))

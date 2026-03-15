"""Oura Ring API client for HealthHub."""

import requests
from datetime import date
from models import save_metric, MetricType

OURA_BASE = "https://api.ouraring.com/v2"


class OuraClient:
    def __init__(self, access_token: str):
        self.token = access_token
        self.session = requests.Session()
        self.session.headers["Authorization"] = f"Bearer {access_token}"

    def _get(self, endpoint: str, params: dict = None) -> dict:
        resp = self.session.get(f"{OURA_BASE}{endpoint}", params=params, timeout=10)
        resp.raise_for_status()
        return resp.json()

    def sync_today(self) -> dict:
        """Sync all available data for today. Returns summary of synced metrics."""
        today = date.today().isoformat()
        synced = {}

        try:
            sleep = self.sync_sleep(today)
            synced.update(sleep)
        except Exception as e:
            synced["sleep_error"] = str(e)

        try:
            readiness = self.sync_readiness(today)
            synced.update(readiness)
        except Exception as e:
            synced["readiness_error"] = str(e)

        try:
            hr = self.sync_heart_rate(today)
            synced.update(hr)
        except Exception as e:
            synced["hr_error"] = str(e)

        return synced

    def sync_sleep(self, day: str) -> dict:
        """Fetch and store sleep data."""
        data = self._get("/usercollection/daily_sleep", {"start_date": day, "end_date": day})
        result = {}

        if data.get("data"):
            item = data["data"][0]

            # Sleep contributors
            contributors = item.get("contributors", {})

            if "deep_sleep" in contributors:
                val = contributors["deep_sleep"]
                save_metric(MetricType.DEEP_SLEEP, val, "pistettä", "oura", item.get("day", day))
                result["deep_sleep"] = val

            if "rem_sleep" in contributors:
                val = contributors["rem_sleep"]
                save_metric(MetricType.REM_SLEEP, val, "pistettä", "oura", item.get("day", day))
                result["rem_sleep"] = val

            if item.get("score") is not None:
                save_metric(MetricType.SLEEP_QUALITY, item["score"], "pistettä", "oura", item.get("day", day))
                result["sleep_quality"] = item["score"]

            # Total sleep duration from contributors or timestamp
            if item.get("timestamp"):
                # Sleep document has contributors.total_sleep as score
                if "total_sleep" in contributors:
                    val = contributors["total_sleep"]
                    save_metric(MetricType.SLEEP_DURATION, val, "pistettä", "oura", item.get("day", day))
                    result["sleep_duration_score"] = val

        return result

    def sync_readiness(self, day: str) -> dict:
        """Fetch and store readiness data."""
        data = self._get("/usercollection/daily_readiness", {"start_date": day, "end_date": day})
        result = {}

        if data.get("data"):
            item = data["data"][0]

            if item.get("score") is not None:
                save_metric(MetricType.READINESS_SCORE, item["score"], "pistettä", "oura", item.get("day", day))
                result["readiness_score"] = item["score"]

            if item.get("temperature_deviation") is not None:
                save_metric(MetricType.SKIN_TEMPERATURE, item["temperature_deviation"], "°C", "oura", item.get("day", day))
                result["skin_temperature"] = item["temperature_deviation"]

            # HRV from readiness contributors
            contributors = item.get("contributors", {})
            if "hrv_balance" in contributors:
                result["hrv_balance"] = contributors["hrv_balance"]

        return result

    def sync_heart_rate(self, day: str) -> dict:
        """Fetch and store resting heart rate."""
        data = self._get("/usercollection/heartrate", {"start_date": day, "end_date": day})
        result = {}

        if data.get("data"):
            # Find the lowest HR as resting HR approximation
            hr_values = [item["bpm"] for item in data["data"] if item.get("bpm")]
            if hr_values:
                resting_hr = min(hr_values)
                save_metric(MetricType.RESTING_HR, resting_hr, "bpm", "oura", day)
                result["resting_hr"] = resting_hr

        return result

    def test_connection(self) -> dict:
        """Test if the token works by fetching personal info."""
        resp = self.session.get(f"{OURA_BASE}/usercollection/personal_info", timeout=10)
        resp.raise_for_status()
        return resp.json()

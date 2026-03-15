# HealthHub – Tietomalli

## Yleiskatsaus

Tietomalli on suunniteltu aikasarjadatan tehokkaaseen käsittelyyn. Pääentiteetit ovat:
- **User** – käyttäjä
- **HealthMetric** – automaattiset terveysmittaukset (HRV, syke, uni jne.)
- **MealEntry** – ruokakuvakirjaukset
- **MigraineEvent** – migreenikohtaukset
- **ContextTag** – kontekstuaaliset merkinnät
- **DailyRiskAssessment** – päivittäinen riskiarvio
- **TriggerHypothesis** – tunnistetut hypoteesit (V2)
- **Baseline** – henkilökohtaiset viitearvot

---

## Entiteetit

### User

| Kenttä | Tyyppi | Kuvaus |
|---|---|---|
| id | UUID | Primääriavain |
| created_at | DateTime | Tilin luonti |
| oura_token | String? | Oura OAuth token (salattu) |
| settings | JSON | Käyttäjäasetukset |

### HealthMetric

Aikasarjataulu – yksi rivi per mittaus.

| Kenttä | Tyyppi | Kuvaus |
|---|---|---|
| id | UUID | Primääriavain |
| user_id | UUID | FK → User |
| source | Enum | `apple_health`, `oura` |
| metric_type | Enum | Ks. alla |
| value | Float | Mittausarvo |
| unit | String | Yksikkö (ms, bpm, h, count) |
| recorded_at | DateTime | Mittauksen aikaleima |
| period_start | DateTime? | Jakson alku (esim. unijakso) |
| period_end | DateTime? | Jakson loppu |
| metadata | JSON? | Lisädata lähteestä |

**metric_type -arvot:**

| Arvo | Lähde | Yksikkö | Käyttö |
|---|---|---|---|
| `hrv_rmssd` | Oura / Apple | ms | Yön HRV-keskiarvo |
| `resting_heart_rate` | Oura / Apple | bpm | Leposyke |
| `sleep_duration` | Oura / Apple | h | Unen kokonaiskesto |
| `sleep_deep` | Oura | h | Syvän unen kesto |
| `sleep_rem` | Oura | h | REM-unen kesto |
| `sleep_efficiency` | Oura | % | Unen tehokkuus |
| `readiness_score` | Oura | 0-100 | Ouran Readiness Score |
| `skin_temperature_delta` | Oura | °C | Ihon lämpötilan poikkeama |
| `steps` | Apple | count | Askeleet |
| `active_calories` | Apple | kcal | Aktiivisuuskalorit |
| `exercise_minutes` | Apple | min | Harjoitteluaika |

### MealEntry

| Kenttä | Tyyppi | Kuvaus |
|---|---|---|
| id | UUID | Primääriavain |
| user_id | UUID | FK → User |
| image_path | String | Kuvan polku (lokaali) tai URL (pilvi) |
| recognized_items | [String] | AI:n tunnistamat raaka-aineet |
| potential_triggers | [String] | Tunnistetut potentiaaliset triggerit |
| photographed_at | DateTime | Kuvan ottamisen aika |
| user_corrections | JSON? | Käyttäjän korjaukset AI-tunnistukseen |
| meal_type | Enum? | `breakfast`, `lunch`, `dinner`, `snack` (arvioitu kellonajan perusteella) |

**Esimerkki JSON:**

```json
{
  "id": "a1b2c3d4-...",
  "user_id": "u1234-...",
  "image_path": "/meals/2026-03-15_1230.jpg",
  "recognized_items": ["pasta", "kypsytetty juusto", "tomaattikastike", "salaatti"],
  "potential_triggers": ["kypsytetty juusto"],
  "photographed_at": "2026-03-15T12:30:00+02:00",
  "user_corrections": {
    "removed": [],
    "added": ["parmesan"]
  },
  "meal_type": "lunch"
}
```

### MigraineEvent

| Kenttä | Tyyppi | Kuvaus |
|---|---|---|
| id | UUID | Primääriavain |
| user_id | UUID | FK → User |
| started_at | DateTime | Kohtauksen alkamisaika |
| ended_at | DateTime? | Kohtauksen päättymisaika (null = käynnissä) |
| intensity | Int (1-3) | 1=lievä, 2=kohtalainen, 3=vaikea |
| has_aura | Boolean? | Auraoireet (valinnainen) |
| laterality | Enum? | `unilateral`, `bilateral` (valinnainen) |
| has_nausea | Boolean? | Pahoinvointi (valinnainen) |
| notes | String? | Vapaa muistiinpano |

**Esimerkki JSON:**

```json
{
  "id": "m5678-...",
  "user_id": "u1234-...",
  "started_at": "2026-03-15T14:00:00+02:00",
  "ended_at": "2026-03-15T17:30:00+02:00",
  "intensity": 2,
  "has_aura": false,
  "laterality": "unilateral",
  "has_nausea": true,
  "notes": null
}
```

### ContextTag

| Kenttä | Tyyppi | Kuvaus |
|---|---|---|
| id | UUID | Primääriavain |
| user_id | UUID | FK → User |
| tag_type | Enum | `travel`, `alcohol`, `high_stress`, `hormone_phase`, `unusual_schedule`, `other` |
| tagged_at | DateTime | Merkinnän aikaleima |
| tagged_for_date | Date | Mille päivälle merkintä kohdistuu |
| value | String? | Lisätieto (esim. hormonivaihe) |

### DailyRiskAssessment

| Kenttä | Tyyppi | Kuvaus |
|---|---|---|
| id | UUID | Primääriavain |
| user_id | UUID | FK → User |
| date | Date | Arvioitava päivä |
| risk_level | Enum | `low`, `elevated`, `high` |
| risk_score | Float (0-1) | Numeerinen riskipistemäärä |
| contributing_factors | JSON | Mitkä tekijät vaikuttivat |
| recommendation | String? | Päivän pääsuositus |
| created_at | DateTime | Milloin arvio laskettiin |

**contributing_factors -esimerkki:**

```json
{
  "factors": [
    {
      "name": "sleep_duration",
      "value": 5.5,
      "baseline": 7.2,
      "deviation_pct": -24,
      "impact": "high"
    },
    {
      "name": "hrv_rmssd",
      "value": 28,
      "baseline": 42,
      "deviation_pct": -33,
      "impact": "high"
    },
    {
      "name": "resting_heart_rate",
      "value": 68,
      "baseline": 58,
      "deviation_pct": 17,
      "impact": "medium"
    }
  ]
}
```

### TriggerHypothesis (V2)

| Kenttä | Tyyppi | Kuvaus |
|---|---|---|
| id | UUID | Primääriavain |
| user_id | UUID | FK → User |
| factor | String | Tutkittava tekijä (esim. "kypsytetty_juusto", "lyhyt_uni") |
| factor_category | Enum | `food`, `sleep`, `physiological`, `context`, `activity` |
| direction | Enum | `trigger` (altistava) tai `protective` (suojaava) |
| confidence | Enum | `weak`, `moderate`, `strong` |
| occurrences_before_migraine | Int | Montako kertaa tekijä esiintyi ennen migreeniä |
| total_migraine_events | Int | Migreenikohtauksia kaikkiaan analyysissa |
| occurrences_non_migraine | Int | Montako kertaa tekijä esiintyi ei-migreenipäivinä |
| total_non_migraine_days | Int | Ei-migreenipäiviä kaikkiaan |
| relative_risk | Float | Suhteellinen riski |
| p_value | Float? | Tilastollinen merkitsevyys |
| bayesian_posterior | Float? | Bayesilainen posteriori-todennäköisyys |
| status | Enum | `monitoring`, `confirmed`, `refuted` |
| first_detected_at | DateTime | Milloin havainto tehtiin ensi kertaa |
| last_updated_at | DateTime | Viimeisin päivitys |
| evidence_detail | JSON | Yksityiskohtainen näyttö |

### Baseline

| Kenttä | Tyyppi | Kuvaus |
|---|---|---|
| id | UUID | Primääriavain |
| user_id | UUID | FK → User |
| hrv_14d_median | Float | HRV 14pv mediaani |
| resting_hr_14d_median | Float | Leposyke 14pv mediaani |
| sleep_duration_14d_median | Float | Unen kesto 14pv mediaani |
| sleep_deep_14d_median | Float? | Syvä uni 14pv mediaani |
| readiness_14d_median | Float? | Readiness 14pv mediaani |
| updated_at | DateTime | Viimeisin päivitys |

---

## Relaatiokaavio

```
User (1) ──── (N) HealthMetric
  │
  ├── (1) ──── (N) MealEntry
  │
  ├── (1) ──── (N) MigraineEvent
  │
  ├── (1) ──── (N) ContextTag
  │
  ├── (1) ──── (N) DailyRiskAssessment
  │
  ├── (1) ──── (N) TriggerHypothesis
  │
  └── (1) ──── (1) Baseline
```

---

## Indeksointistrategia

### HealthMetric (suurin taulu)
- `(user_id, metric_type, recorded_at)` – pääkysely: "anna HRV viimeiseltä 14 päivältä"
- `recorded_at` – TimescaleDB hypertable -partitiointi ajan mukaan

### MigraineEvent
- `(user_id, started_at)` – "anna migreenikohtaukset aikajärjestyksessä"

### MealEntry
- `(user_id, photographed_at)` – "anna ateriat tietyltä aikaväliltä"

### DailyRiskAssessment
- `(user_id, date)` – unique, yksi per päivä

---

## Core Data -skeema (iOS-lokaali, MVP)

MVP:ssä kaikki data tallennetaan lokaalisti Core Dataan. Skeema peilaa yllä olevaa, mutta:
- Ei `user_id` -kenttää (yksi käyttäjä per laite)
- `image_path` viittaa lokaaliin tiedostoon
- `Baseline` päivitetään laitteella reaaliajassa
- Ei `TriggerHypothesis`-entiteettiä MVP:ssä (tulee V2:ssa backendissä)

---

## Datan elinkaari

1. **Keräys:** HealthKit → automaattinen synkronointi 1x/tunti. Oura API → 1x/aamu.
2. **Tallennus:** Core Data (lokaali). Myöhemmin sync pilveen.
3. **Prosessointi:** Baseline-päivitys päivittäin. Riskiarvio aamulla.
4. **Analyysi (V2):** Hypoteesimoottori ajetaan viikottain tai kohtauksen jälkeen.
5. **Poisto:** Käyttäjä voi poistaa kaiken datan milloin tahansa. Vähintään GDPR-yhteensopiva "right to be forgotten".

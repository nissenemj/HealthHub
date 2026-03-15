# HealthHub – Tekninen arkkitehtuuri

## Yleiskatsaus

HealthHub on iOS-natiivi sovellus, joka kerää terveysdataa useista lähteistä, analysoi sitä sääntöpohjaisesti (MVP) ja myöhemmin tilastollisesti (V2), ja tarjoaa käyttäjälle personoituja riskiarvioita ja suosituksia.

---

## Arkkitehtuurikaavio

```
┌──────────────────────────────────────────────────────────┐
│                      iOS APP (SwiftUI)                    │
│                                                          │
│  ┌─────────┐ ┌──────────┐ ┌─────────┐ ┌──────────────┐ │
│  │Dashboard│ │Oire-     │ │Ruoka-   │ │Viikko/Trendi│ │
│  │View     │ │kirjaus   │ │kuva     │ │Views        │ │
│  └────┬────┘ └────┬─────┘ └────┬────┘ └──────┬───────┘ │
│       │           │            │              │         │
│  ┌────┴───────────┴────────────┴──────────────┴───────┐ │
│  │              ViewModel Layer (MVVM)                 │ │
│  │  RiskEngine │ MealAnalyzer │ WeeklySummary         │ │
│  └────┬───────────┬────────────┬──────────────────────┘ │
│       │           │            │                        │
│  ┌────┴───────────┴────────────┴──────────────────────┐ │
│  │              Repository Layer                       │ │
│  │  HealthMetricRepo │ MigraineRepo │ MealRepo        │ │
│  └────┬───────────┬────────────┬──────────────────────┘ │
│       │           │            │                        │
│  ┌────┴──────┐ ┌──┴────────┐ ┌┴────────────────┐      │
│  │Core Data  │ │HealthKit  │ │Oura API Client  │      │
│  │(lokaali)  │ │Manager    │ │(OAuth 2.0)      │      │
│  └───────────┘ └───────────┘ └─────────────────┘      │
└──────────────────────────────────────────────────────────┘
         │                              │
         │ HTTPS                        │ HTTPS
         ▼                              ▼
┌──────────────────┐        ┌──────────────────────┐
│ Vision API       │        │ Oura Cloud API       │
│ (ruokakuva-      │        │ (sleep, readiness,   │
│  analyysi)       │        │  HRV, temperature)   │
└──────────────────┘        └──────────────────────┘

         ▼  (V2: backend lisätään)

┌──────────────────────────────────────────────────────────┐
│                    BACKEND (V2+)                          │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │              FastAPI Application                   │   │
│  │                                                    │   │
│  │  ┌────────────┐ ┌─────────────┐ ┌──────────────┐ │   │
│  │  │Data Sync   │ │Hypoteesi-   │ │Suositus-     │ │   │
│  │  │Service     │ │moottori     │ │moottori      │ │   │
│  │  └────────────┘ └─────────────┘ └──────────────┘ │   │
│  │                                                    │   │
│  │  ┌────────────┐ ┌─────────────┐                   │   │
│  │  │Oura Sync   │ │Vision       │                   │   │
│  │  │Worker      │ │Processor    │                   │   │
│  │  └────────────┘ └─────────────┘                   │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │         PostgreSQL + TimescaleDB                   │   │
│  │  health_metrics (hypertable) │ migraine_events    │   │
│  │  meal_entries │ trigger_hypotheses │ baselines     │   │
│  └──────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────┘
```

---

## MVP-arkkitehtuuri (lokaali-first)

### Periaate
MVP:ssä **kaikki data pysyy laitteella**. Ainoa ulkoinen kutsu on ruokakuvan analyysi (Vision API). Tämä yksinkertaistaa kehitystä, poistaa backend-riippuvuuden ja minimoi tietosuojariskit.

### Komponentit

#### 1. HealthKit Manager
```
Vastuualue: Apple Health -datan lukeminen
Teknologia: HealthKit framework (HKHealthStore)
Luettavat tyypit:
  - HKQuantityType.heartRateVariabilitySDNN
  - HKQuantityType.restingHeartRate
  - HKCategoryType.sleepAnalysis
  - HKQuantityType.stepCount
  - HKQuantityType.activeEnergyBurned
Synkronointi: Background delivery + app foreground refresh
Päivitysväli: Automaattinen (HealthKit observer query)
```

#### 2. Oura API Client
```
Vastuualue: Oura Ring -datan hakeminen
Teknologia: URLSession + OAuth 2.0
Endpointit:
  - GET /v2/usercollection/daily_sleep
  - GET /v2/usercollection/daily_readiness
  - GET /v2/usercollection/heartrate
  - GET /v2/usercollection/daily_temperature
Synkronointi: 1x aamulla (BGAppRefreshTask) + app foreground
Autentikointi: OAuth 2.0 PKCE flow, token tallennetaan Keychainiin
```

#### 3. Core Data Store
```
Vastuualue: Kaiken datan pysyvä tallennus laitteella
Entiteetit: HealthMetric, MealEntry, MigraineEvent, ContextTag,
            DailyRiskAssessment, Baseline
Indeksointi: (metric_type, recorded_at) HealthMetricissä
Migraatio: Lightweight migration (Core Data automatic)
```

#### 4. Risk Engine (sääntöpohjainen)
```
Vastuualue: Päivittäisen riskiarvion laskeminen
Syötteet: Yön HRV, unen kesto, leposyke, Readiness Score, kontekstimerkinnät
Logiikka:

  risk_score = 0.0

  // HRV-poikkeama (paino 0.35)
  hrv_deviation = (baseline.hrv - current.hrv) / baseline.hrv
  if hrv_deviation > 0.15: risk_score += 0.35 * min(hrv_deviation / 0.30, 1.0)

  // Unen kesto (paino 0.25)
  sleep_deficit = max(0, baseline.sleep - current.sleep)
  if sleep_deficit > 1.0: risk_score += 0.25 * min(sleep_deficit / 2.5, 1.0)

  // Leposyke (paino 0.20)
  hr_elevation = (current.rhr - baseline.rhr) / baseline.rhr
  if hr_elevation > 0.10: risk_score += 0.20 * min(hr_elevation / 0.25, 1.0)

  // Konteksti (paino 0.20)
  if context contains [alcohol, travel, unusual_schedule]:
    risk_score += 0.20

  // Luokittelu
  if risk_score < 0.3: "low"
  elif risk_score < 0.6: "elevated"
  else: "high"

Ulostulo: DailyRiskAssessment
Ajoitus: Laskentaan aamulla kun Oura-data saatavilla
```

#### 5. Meal Analyzer
```
Vastuualue: Ruokakuvan analysointi
Teknologia: Claude Vision API (tai OpenAI Vision)
Flow:
  1. Käyttäjä ottaa kuvan → tallennetaan lokaalisti
  2. Kuva lähetetään Vision API:lle promptilla:
     "Tunnista tämän aterian pääraaka-aineet.
      Listaa ne JSON-muodossa.
      Merkitse erikseen tunnetut migreenitriggerit:
      kypsytetyt juustot, prosessoidut lihat, punaviini,
      suklaa, sitrushedelmät, MSG."
  3. Vastaus parsitaan → tallennetaan MealEntryyn
  4. Käyttäjä voi korjata tunnistusta

Vasteaika: < 3 sekuntia
Kustannus: ~$0.01-0.03 per kuva
```

#### 6. UI Layer (SwiftUI + MVVM)
```
Views:
  - DashboardView → DashboardViewModel
  - MigraineLogView → MigraineLogViewModel
  - MealCaptureView → MealCaptureViewModel
  - PostMigraineView → PostMigraineViewModel
  - WeeklySummaryView → WeeklySummaryViewModel
  - TrendsView → TrendsViewModel
  - SettingsView → SettingsViewModel

Navigaatio: TabView (5 tabia: Koti, Ruoka, Oire, Viikko, Trendit)
Teema: Tummansävyinen, vähäkontrastinen (migreeniystävällinen)
```

---

## V2-arkkitehtuuri (backend lisätään)

### Miksi backend V2:ssa

1. **Hypoteesimoottori** vaatii enemmän laskentaa kuin laitteella on järkevää ajaa
2. **Datan varmuuskopiointi** pilvisynkronoinnilla
3. **Oura webhookit** vaativat serverin vastaanottamaan
4. **Tulevaisuuden ML-mallit** ajetaan serverillä

### Backend-komponentit

#### FastAPI Application
```
Vastuualue: REST API iOS-appille + analytiikka
Teknologia: Python 3.12 + FastAPI + Pydantic v2
Deployment: Railway / Fly.io (yksinkertainen, edullinen)
Autentikointi: JWT (device-based, ei salasanaa)
```

#### Hypoteesimoottori
```
Vastuualue: Triggerien ja suojaavien tekijöiden tunnistaminen
Teknologia: Python + scipy.stats + numpy
Ajoitus: Viikoittain (cron) + migreenikohtauksen jälkeen (event-driven)

Prosessi:
  1. Hae kaikki migreenikohtaukset
  2. Jokaiselle kohtaukselle: kerää 48h aikaikkunan data
  3. Vertaa migreenipäivien profiilia ei-migreenipäiviin
  4. Laske Fisherin eksaktitesti + Bayesilainen posteriori
  5. Luokittele: monitoring / confirmed / refuted
  6. Tallenna TriggerHypothesis-tauluun
```

#### Suositusmoottori
```
Vastuualue: Kontekstuaaliset, ajoitetut suositukset
Syötteet: DailyRiskAssessment + TriggerHypothesis + kellonaika
Logiikka: Sääntöpohjainen (if-then), ei ML:ää V2:ssa
Ulostulo: 0-3 suositusta per päivä, push-notifikaatioina tai app-sisäisinä
```

#### Tietokanta
```
Teknologia: PostgreSQL 16 + TimescaleDB
Hypertable: health_metrics (partitioitu recorded_at:n mukaan)
Retention: Ei automaattista poistoa – käyttäjä kontrolloi
Varmuuskopiointi: Päivittäinen pg_dump → S3
```

---

## Integraatiorajapinnat

### Apple HealthKit

```
Protokolla: Natiivi iOS framework
Oikeudet (Info.plist):
  - NSHealthShareUsageDescription
  - NSHealthUpdateUsageDescription
Luettavat tyypit:
  - Heart Rate Variability (SDNN)
  - Resting Heart Rate
  - Sleep Analysis
  - Step Count
  - Active Energy Burned
  - Apple Exercise Time
Kirjoitettavat: Ei mitään (read-only)
Background: HKObserverQuery + BGAppRefreshTask
```

### Oura API v2

```
Protokolla: REST over HTTPS
Base URL: https://api.ouraring.com/v2
Autentikointi: OAuth 2.0 (Authorization Code + PKCE)
Scopes: daily, heartrate, session, workout
Rate limit: 5000 req/5min (riittävästi)
Endpointit:
  GET /usercollection/daily_sleep?start_date=YYYY-MM-DD
  GET /usercollection/daily_readiness?start_date=YYYY-MM-DD
  GET /usercollection/heartrate?start_date=YYYY-MM-DD
  GET /usercollection/daily_temperature?start_date=YYYY-MM-DD
Webhookit (V2): Oura lähettää notifikaation kun uusi data saatavilla
```

### Vision API (ruokakuva-analyysi)

```
Protokolla: REST over HTTPS
Vaihtoehdot:
  1. Claude Vision (Anthropic API) – suositus
  2. OpenAI Vision (GPT-4 Vision)
  3. Google Cloud Vision + custom prompt

MVP-valinta: Claude Vision
  - Hyvä raaka-aineiden tunnistus
  - Joustava promptaus (voidaan pyytää migreenitriggerien tunnistusta)
  - Kustannus: ~$0.01-0.03 / kuva

Prompt-template:
  "Analysoi tämä ruokakuva. Tunnista pääraaka-aineet ja ruokalajit.
   Palauta JSON-muodossa:
   {
     'items': ['raaka-aine1', 'raaka-aine2'],
     'potential_migraine_triggers': ['tunnistettu triggeri'],
     'meal_description': 'lyhyt kuvaus'
   }
   Tunnetut migreenitriggerit: kypsytetyt juustot (tyramiini),
   prosessoidut lihat (nitriitit), punaviini, suklaa,
   sitrushedelmät, MSG, aspartaami."
```

---

## Dataflow

```
                    KERÄYS
                      │
    ┌─────────────────┼─────────────────┐
    │                 │                 │
    ▼                 ▼                 ▼
HealthKit         Oura API          Ruokakuva
(auto, 1x/h)     (1x/aamu)        (käyttäjä)
    │                 │                 │
    ▼                 ▼                 ▼
    └────────► Core Data ◄─────────────┘
              (lokaali)
                  │
                  ▼
              PROSESSOINTI
                  │
    ┌─────────────┼──────────────┐
    │             │              │
    ▼             ▼              ▼
 Baseline     Riskiarvio     Ruoka-AI
 (14pv med.)  (sääntöpohj.)  (Vision API)
    │             │              │
    └──────► Tallennus ◄────────┘
              Core Data
                  │
                  ▼
              ESITYS
                  │
    ┌─────────────┼──────────────┐
    │             │              │
    ▼             ▼              ▼
 Dashboard    Jälkianalyysi  Viikkokooste
              (kohtauksen
               jälkeen)
                  │
                  ▼ (V2)
              ANALYYSI
                  │
    ┌─────────────┼──────────────┐
    │             │              │
    ▼             ▼              ▼
 Hypoteesi-   Suositus-     Trendi-
 moottori     moottori      näkymät
```

---

## Turvallisuus ja tietosuoja

### Lokaali data (MVP)
- Core Data -tiedosto salattu iOS Data Protection (Complete Protection)
- Oura OAuth token Keychainissä
- Ruokakuvat tallennettu appin sandboxiin (ei Photos-kirjastoon)
- Vision API -kutsut HTTPS:n yli, kuvia ei tallenneta palvelimelle pysyvästi

### Pilvidata (V2)
- End-to-end-salaus: client-side encryption ennen lähetystä
- JWT-tokenien lyhyt elinikä (15min access, 7d refresh)
- Tietokanta salattu at rest (PostgreSQL TDE)
- Ei PII:tä logeissa
- GDPR: data export + deletion API

---

## Teknologiapino yhteenveto

| Kerros | MVP | V2 |
|---|---|---|
| **Frontend** | SwiftUI (iOS 17+) | SwiftUI (iOS 17+) |
| **Arkkitehtuuri** | MVVM | MVVM |
| **Lokaali data** | Core Data | Core Data + CloudKit sync |
| **Backend** | Ei backendia | FastAPI (Python 3.12) |
| **Tietokanta** | Core Data (SQLite) | PostgreSQL + TimescaleDB |
| **HealthKit** | HKHealthStore | HKHealthStore |
| **Oura** | REST API (URLSession) | REST API + Webhookit |
| **Ruokakuva-AI** | Claude Vision API | Claude Vision API |
| **Riskiarvio** | Sääntöpohjainen (client) | Sääntö + tilastollinen (server) |
| **Hypoteesit** | – | scipy + numpy (server) |
| **Notifikaatiot** | UNUserNotificationCenter | + APNs (V2) |
| **CI/CD** | Xcode Cloud → TestFlight | Xcode Cloud + GitHub Actions |
| **Hosting** | – | Railway / Fly.io |
| **Monitorointi** | – | Sentry + custom health checks |

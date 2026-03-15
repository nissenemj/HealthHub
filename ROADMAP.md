# HealthHub – Etenemissuunnitelma

## Nykytila (43 % valmis)

Projektin pohja on luotu: 6 datamallia, 4 näkymää, 4 ViewModelia, 5 palvelua ja perustestit.
Alla oleva suunnitelma vie projektin MVP-julkaisuun ja sen jälkeen V2-vaiheeseen.

---

## Vaihe 0 – Validointi (viikko 0)

> Ennen koodausta: 1 viikon manuaalinen testijakso

| # | Tehtävä | Tarkoitus |
|---|---------|-----------|
| 0.1 | Seuraa Oura + Apple Health + muistiinpanot + ruokakuvat manuaalisesti 7 päivää | Arvioi, onko kirjaaminen realistista arjessa |
| 0.2 | Dokumentoi kokemukset: mikä tuntui raskaalta, mikä hyödylliseltä | Go/no-go -päätös |

**Exit-kriteeri:** Kirjaaminen tuntuu kestävältä → jatketaan kehitystä.

---

## Vaihe 1 – iOS-projektin perustus (viikko 1)

> Tavoite: Toimiva Xcode-projekti oikeilla oikeuksilla ja pysyvällä tietovarastolla

| # | Tehtävä | Prioriteetti | Tila |
|---|---------|-------------|------|
| 1.1 | Luo Xcode-projekti (.xcodeproj) ja siirrä Swift Package -koodi sinne | P0 | ⬜ |
| 1.2 | Luo Info.plist: NSHealthShareUsageDescription, NSCameraUsageDescription, NSPhotoLibraryUsageDescription | P0 | ⬜ |
| 1.3 | Luo .entitlements: HealthKit capability, Background Modes (fetch) | P0 | ⬜ |
| 1.4 | Korvaa UserDefaults-pohjainen DataStore → **Core Data** (.xcdatamodeld) | P0 | ⬜ |
| 1.5 | Luo Core Data -entiteetit: HealthMetricEntity, MealEntryEntity, MigraineEventEntity, ContextTagEntity, DailyRiskAssessmentEntity, BaselineEntity | P0 | ⬜ |
| 1.6 | Toteuta Core Data -repository-kerros (HealthMetricRepo, MealRepo, MigraineRepo) | P0 | ⬜ |
| 1.7 | Siirrä Oura-token UserDefaultsista → **Keychain** (Security framework) | P0 | ⬜ |
| 1.8 | Lisää datan validointi: endTime >= startTime, value > 0, ei tyhjiä listoja | P1 | ⬜ |

---

## Vaihe 2 – HealthKit + Oura (viikko 2)

> Tavoite: Automaattinen datasync molemmista lähteistä

| # | Tehtävä | Prioriteetti | Tila |
|---|---------|-------------|------|
| 2.1 | HealthKit: Lisää HKObserverQuery reaaliaikaiselle seurannalle | P0 | ⬜ |
| 2.2 | HealthKit: Toteuta BGAppRefreshTask taustapäivityksille | P0 | ⬜ |
| 2.3 | HealthKit: Lisää puuttuvat mittarityypit (Apple Exercise Time) | P1 | ⬜ |
| 2.4 | Oura: Toteuta OAuth 2.0 PKCE -autentikointivuo | P0 | ⬜ |
| 2.5 | Oura: Toteuta token refresh -logiikka (15min access token) | P0 | ⬜ |
| 2.6 | Oura: Lisää puuttuvat endpointit (heartrate, daily_temperature) | P1 | ⬜ |
| 2.7 | Virheenkäsittely: Korvaa print() → virheen propagointi ViewModeleihin | P0 | ⬜ |
| 2.8 | Verkkovirheet: Lisää retry-logiikka (exp. backoff, max 3 yritystä) | P1 | ⬜ |
| 2.9 | Dashboard: Toteuta automaattinen datasync aamuisin (baseline + riskiarvio) | P0 | ⬜ |

---

## Vaihe 3 – Kirjaaminen ja kamera (viikko 3)

> Tavoite: 2 napautuksen migreenikirjaus + ruokakuvan ottaminen

| # | Tehtävä | Prioriteetti | Tila |
|---|---------|-------------|------|
| 3.1 | Luo **MealCaptureView**: kameranäkymä + kuvan esikatselu | P0 | ⬜ |
| 3.2 | Toteuta kameraintegraatio (PHPickerViewController / Camera) | P0 | ⬜ |
| 3.3 | Toteuta kuvan tallennus appin sandboxiin (ei Photos-kirjastoon) | P0 | ⬜ |
| 3.4 | Toteuta **VisionService**: Claude Vision API -asiakas | P0 | ⬜ |
| 3.5 | Vision API: prompt-template migreenitriggerien tunnistamiseen (tyramiini, nitriitit, punaviini, suklaa, sitrus, MSG, aspartaami) | P0 | ⬜ |
| 3.6 | Vision API: JSON-vastauksen parsinta → MealEntry.ingredients + potentialTriggers | P0 | ⬜ |
| 3.7 | MealCaptureView: Käyttäjän korjausmahdollisuus AI-tunnistukselle | P1 | ⬜ |
| 3.8 | API-avaimen hallinta: turvattu tallennus (ei kovakoodattuna) | P0 | ⬜ |
| 3.9 | Luo **PostMigraineView**: 48h aikaikkuna-analyysi kohtauksen jälkeen | P1 | ⬜ |
| 3.10 | PostMigraineView: Näytä mittarit, ateriat ja konteksti ennen kohtausta | P1 | ⬜ |

---

## Vaihe 4 – Yhteenvedot ja ilmoitukset (viikko 4)

> Tavoite: Viikkoyhteenveto + proaktiiviset ilmoitukset

| # | Tehtävä | Prioriteetti | Tila |
|---|---------|-------------|------|
| 4.1 | Luo **WeeklySummaryView**: migreenikohtaukset, keskimääräinen riski, palautumistrendi | P0 | ⬜ |
| 4.2 | Viikkokooste: 1–2 merkittävintä havaintoa | P1 | ⬜ |
| 4.3 | Viikkokooste: vertailu edelliseen viikkoon | P1 | ⬜ |
| 4.4 | Luo **SettingsView**: Oura-kirjautuminen, asetukset, tietojen vienti/poisto | P0 | ⬜ |
| 4.5 | Toteuta UNUserNotificationCenter: ilmoitukset kohonneesta riskistä | P0 | ⬜ |
| 4.6 | Ilmoituslogiikka: max 1/päivä, vain kun riski koholla | P0 | ⬜ |
| 4.7 | Iltakysymys (valinnainen): "Oliko tänään jotain poikkeavaa?" → kontekstitunniste | P1 | ⬜ |
| 4.8 | Lisää DailyRiskAssessment-malliin recommendation-kenttä | P1 | ⬜ |
| 4.9 | Päivitä ContentView: 5 tabia (Koti, Ruoka, Oire, Viikko, Asetukset) | P0 | ⬜ |

---

## Vaihe 5 – Laatu ja julkaisuvalmius (viikko 5–6)

> Tavoite: Testaus, saavutettavuus, turvallisuus → TestFlight

| # | Tehtävä | Prioriteetti | Tila |
|---|---------|-------------|------|
| 5.1 | **Testit**: DataStore CRUD -operaatiot | P0 | ⬜ |
| 5.2 | **Testit**: RiskEngine kaikilla komponenteilla (HRV, uni, syke, konteksti) | P0 | ⬜ |
| 5.3 | **Testit**: BaselineCalculator reunatapaukset (1 arvo, tyhjä data) | P0 | ⬜ |
| 5.4 | **Testit**: ViewModel-tilasiirtymät | P1 | ⬜ |
| 5.5 | **Testit**: OuraService virheenkäsittely (mock HTTP) | P1 | ⬜ |
| 5.6 | **Saavutettavuus**: VoiceOver-tukilabelit kaikille interaktiivisille elementeille | P0 | ⬜ |
| 5.7 | **Saavutettavuus**: Dynamic Type -tuki | P1 | ⬜ |
| 5.8 | **Turvallisuus**: Core Data -tiedoston salaus (NSFileProtectionComplete) | P0 | ⬜ |
| 5.9 | **Turvallisuus**: Vision API -kutsujen HTTPS-varmistus | P0 | ⬜ |
| 5.10 | **UI-viimeistely**: Migreeniystävällinen tumma teema, vähäkontrastinen | P0 | ⬜ |
| 5.11 | **Lokalisointi**: Luo Localizable.strings (suomi) | P1 | ⬜ |
| 5.12 | Xcode Cloud → TestFlight -jakelu itsetestaus | P0 | ⬜ |

---

## MVP-julkaisun tarkistuslista

- [ ] HealthKit-synkronointi toimii (HRV, uni, syke, askeleet)
- [ ] Oura-synkronointi toimii (uni, valmius, HRV, lämpötila)
- [ ] Migreenikirjaus 2 napautuksella
- [ ] Ruokakuvan otto + AI-tunnistus toimii
- [ ] Päivittäinen riskiarvio lasketaan automaattisesti
- [ ] Dashboard näyttää riskin, mittarit, tekijät
- [ ] Migreenin jälkianalyysi (48h ikkuna)
- [ ] Viikkokooste
- [ ] Ilmoitukset kohonneesta riskistä
- [ ] Asetukset: Oura-auth, data export/delete
- [ ] Testikattavuus > 60 %
- [ ] VoiceOver-tuki
- [ ] Kaikki data salattu laitteella
- [ ] TestFlight-jakelu onnistuu

---

## Vaihe 6 – V2: Backend + Hypoteesimoottori (kuukausi 3–4)

> Tavoite: Pilvisynkronointi, tilastollinen analyysi, suositukset

| # | Tehtävä | Prioriteetti |
|---|---------|-------------|
| 6.1 | FastAPI-backend (Python 3.12): REST API iOS-appille | P0 |
| 6.2 | PostgreSQL + TimescaleDB: health_metrics hypertable | P0 |
| 6.3 | JWT-autentikointi (device-based, 15min access + 7d refresh) | P0 |
| 6.4 | Data Sync Service: iOS ↔ backend synkronointi | P0 |
| 6.5 | **Hypoteesimoottori**: Fisherin eksaktitesti + Bayesilainen posteriori | P0 |
| 6.6 | TriggerHypothesis-malli: monitoring / confirmed / refuted | P0 |
| 6.7 | **Suositusmoottori**: Kontekstuaaliset, ajoitetut suositukset (sääntöpohjainen) | P1 |
| 6.8 | Kuormituksen kumuloitumisen varoitus (3–5 päivän trendi) | P1 |
| 6.9 | Oura-webhookit: reaaliaikainen datapäivitys | P1 |
| 6.10 | GDPR: Data export API + deletion API | P0 |
| 6.11 | End-to-end-salaus: client-side encryption ennen lähetystä | P0 |
| 6.12 | Sentry-monitorointi + health checks | P1 |
| 6.13 | CI/CD: GitHub Actions + Xcode Cloud | P1 |
| 6.14 | Trendinäkymän laajennus: korrelaatiomatriisi, suojaavien tekijöiden seuranta | P1 |

---

## Aikataulu yhteenveto

| Vaihe | Kesto | Kuvaus |
|-------|-------|--------|
| **0** | 1 viikko | Manuaalinen validointi |
| **1** | 1 viikko | iOS-projektin perustus, Core Data |
| **2** | 1 viikko | HealthKit + Oura integraatiot |
| **3** | 1 viikko | Kamera, Vision API, kirjaaminen |
| **4** | 1 viikko | Yhteenvedot, ilmoitukset, asetukset |
| **5** | 1–2 viikkoa | Testaus, saavutettavuus, julkaisuvalmius |
| | **5–7 viikkoa** | **→ MVP TestFlightissa** |
| **6** | 6–8 viikkoa | V2: Backend + hypoteesimoottori |
| | **~4 kuukautta** | **→ Tuotantovalmis versio** |

---

## Riskianalyysi

| Riski | Todennäköisyys | Vaikutus | Mitigaatio |
|-------|---------------|----------|------------|
| Käyttäjä ei jaksa kirjata ruokakuvia | Korkea | Korkea | Minimoi manuaalinen työ, tee kirjaus 1 napautuksella |
| Pieni otoskoko (4–8 migreeniä/kk) | Korkea | Kohtalainen | Kommunikoi selkeästi: "2–3 kk dataa tarvitaan" |
| Vision API -tunnistus epätarkka | Kohtalainen | Kohtalainen | Käyttäjän korjausmahdollisuus + palautteen kerääminen |
| HealthKit-oikeudet evätty | Matala | Korkea | Graceful degradation: toimi Oura-datalla |
| Oura API -muutokset | Matala | Kohtalainen | Abstraktoi API-kerros, versiotuki |

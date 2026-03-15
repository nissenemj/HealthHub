# HealthHub – Testausohjeet

## Vaihtoehto 1: GitHub Actions CI (suositus ilman Macia)

Projekti voidaan testata automaattisesti GitHub Actionsin macOS-runnerilla.
Tämä on paras tapa, koska se ei vaadi omaa Macia.

### Käyttöönotto

1. Pusha koodi GitHubiin (jo tehty)
2. GitHub Actions workflow (`.github/workflows/test.yml`) ajaa testit automaattisesti
3. Tulokset näkyvät GitHub-repositorion Actions-välilehdellä

### Mitä testataan

- Swift-kääntäminen (iOS 17 target)
- Yksikkötestit (`swift test` tai `xcodebuild test`)
- Koodin laatu

---

## Vaihtoehto 2: Mac-pilvipalvelu

Jos haluat simulaattorin ilman omaa Macia:

| Palvelu | Hinta | Kuvaus |
|---------|-------|--------|
| **MacStadium** | ~$50/kk | Dedikoitu Mac mini pilvessä |
| **AWS EC2 Mac** | ~$1/h | Mac-instanssi AWS:ssä |
| **GitHub Codespaces (macOS)** | Rajoitettu | macOS-ympäristö |
| **Codemagic** | Ilmainen tier | CI/CD + simulaattori |

---

## Vaihtoehto 3: TestFlight (kun Mac on saatavilla)

1. Avaa projekti Xcodessa (kloonaa repo)
2. `Xcode → Product → Test` (⌘U) ajaa yksikkötestit
3. `Xcode → Product → Run` (⌘R) käynnistää simulaattorissa
4. Simulaattorissa: iPhone 15 Pro, iOS 17+
5. TestFlight-jakelu: `Product → Archive → Distribute`

---

## Yksikkötestien ajaminen

### macOS/Xcode
```bash
# Kloonaa repo
git clone <repo-url>
cd HealthHub

# Aja testit
swift test

# Tai Xcodella
xcodebuild test \
  -scheme HealthHub \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

### GitHub Actions (automaattinen)
Workflow ajetaan joka pushissa — ks. `.github/workflows/test.yml`

---

## Mitä testata manuaalisesti simulaattorissa

### Dashboard
- [ ] Riskitaso näkyy (värikoodi: vihreä/keltainen/oranssi/punainen)
- [ ] Mittarit latautuvat (HRV, uni, syke, askeleet)
- [ ] Suositus näkyy kun riski koholla
- [ ] Pull-to-refresh päivittää datan
- [ ] Migreenivapaat päivät näkyvät

### Ateriakirjaus
- [ ] Uusi ateria -lomake avautuu
- [ ] Ainesosat tallentuvat
- [ ] Ateria näkyy listassa
- [ ] Pyyhkäisypoisto toimii

### Migreenikirjaus
- [ ] Uusi migreeni -lomake avautuu
- [ ] Voimakkuus valittavissa (1-4)
- [ ] Oireet valittavissa
- [ ] Aura-toggle toimii
- [ ] Tallennus onnistuu

### Trendit
- [ ] Jaksojen vaihto toimii (viikko/kuukausi/3kk)
- [ ] Keskiarvot näkyvät
- [ ] Triggerit listataan

### Asetukset
- [ ] Oura-yhdistäminen käynnistää OAuth-flow
- [ ] Synkronoi nyt -painike toimii
- [ ] Tietojen poisto kysyy vahvistuksen

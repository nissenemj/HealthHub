# HealthHub – Migreenin hallinta ja terveyden optimointi

## Tuotesuunnitelma v1.0

---

# 1. Ydinongelma

## Mitä ongelmaa appi ratkaisee?

Migreeni on toistuva, toimintakykyä lamauttava neurologinen tila, jonka triggerit ovat **yksilöllisiä, monimuuttujaisia ja usein viivästyneitä**. Käyttäjä tietää, että uni, stressi, ruoka ja kuormitus vaikuttavat – mutta ei tiedä **miten ne vaikuttavat juuri häneen, missä yhdistelmässä ja millä viiveellä**.

Samaan aikaan käyttäjä työskentelee korkean kognitiivisen kuorman startup-ympäristössä, jossa:
- Palautuminen jää helposti riittämättömäksi
- Päivärytmi vaihtelee
- Stressin kumuloituminen on vaikea havaita reaaliajassa
- Migreenikohtaus voi viedä 1–3 työpäivää

**Todellinen ongelma ei ole datan puute – vaan datan hajanaisuus ja tulkinnan puuttuminen.**

## Mikä nykyisissä health-appeissa on riittämätöntä?

| Ongelma | Esimerkki |
|---|---|
| **Datan siiloittuminen** | Apple Health näyttää askeleita, Oura unta, migreenipäiväkirja oireita – mikään ei yhdistä näitä |
| **Geneerisyys** | "Nuku 7–9 tuntia" ei auta, kun käyttäjä tarvitsee tietää onko 6,5h + korkea HRV parempi kuin 8h + matala HRV |
| **Passiivisuus** | Dashboardit näyttävät dataa mutta eivät tee päätelmiä |
| **Manuaalisen kirjauksen taakka** | Migreenipäiväkirjat vaativat 5–10 min/päivä → loppuu 2 viikossa |
| **Väärien korrelaatioiden riski** | Pienet otoskoot + paljon muuttujia = helposti harhaanjohtavia päätelmiä |

## Mikä muuttuja ohjaa arvoa käyttäjälle?

**Toimintakyky.** Ei pelkkä terveys, vaan kyky toimia korkealla tasolla arjessa. Appin arvo mitataan sillä, vähenevätkö migreenikohtaukset ja parantuuko käyttäjän kyky ennakoida ja säädellä omaa tilaansa.

---

# 2. Arvolupaus

## Yksi kirkas arvolupaus

> **HealthHub yhdistää kehosi signaalit yhdeksi näkymäksi ja auttaa sinua tunnistamaan, mitkä tekijät todennäköisesti altistavat sinut migreenille – ja mitkä suojaavat siltä.**

## 3–5 tärkeintä käyttötapausta

### Käyttötapaus 1: Aamuinen riskiarvio
Käyttäjä herää ja näkee yhdellä vilkaisulla: unen laatu, palautuminen, HRV-trendi ja päivän riski­arvio. Jos riski on koholla, appi ehdottaa konkreettista toimenpidettä (esim. "HRV laski 15% – harkitse kevyempää päivää ja huolehdi nesteen­saannista").

### Käyttötapaus 2: Ruokakuvan nopea kirjaus
Käyttäjä ottaa kuvan lounaasta. Appi tunnistaa pääraaka-aineet ja tallentaa aterian ajankohdan. Ei vaadi manuaalista kirjaamista. Ajan myötä appi huomaa, jos tietyt ruoka-aineet toistuvat ennen migreeniä.

### Käyttötapaus 3: Migreenin jälkianalyysi
Kohtauksen jälkeen appi näyttää 48–72h aikaikkunan: mitä datapisteitä oli poikkeavaa? Uni, HRV, ateriarytmi, kuormitus? Käyttäjä saa hypoteesin, ei diagnoosia.

### Käyttötapaus 4: Viikkokoosteen oivallukset
Sunnuntaina appi tarjoaa viikkokoosteen: kuormitustaso, palautumis­trendi, migreeni­tilanne, ja mahdolliset kuviot jotka ovat vahvistuneet tai heikentyneet.

### Käyttötapaus 5: Kuormituksen kumuloitumisen varoitus
Appi havaitsee 3–5 päivän trendin: uni lyhenee, HRV laskee, leposyke nousee. Varoittaa ennen kuin käyttäjä itse huomaa olevansa ylikuormittunut.

## Mikä tekee tästä 10x hyödyllisemmän?

1. **Yhdistäminen:** Yksi paikka, joka kokoaa Oura + Apple Health + ruoka + oireet
2. **Tulkinta:** Ei pelkkää dataa, vaan hypoteeseja ja suosituksia
3. **Minimaali manuaalinen työ:** Kuvapohjainen ruokakirjaus, automaattinen datasync, oirekirjaus 2 napautuksella
4. **Yksilölliset kuviot:** Ei yleisiä vinkkejä, vaan käyttäjän omasta datasta nousevia havaintoja
5. **Rehellisyys:** Appi kertoo myös kun signaali on liian heikko päätelmien tekemiseen

---

# 3. Käyttäjäkokemus ja workflow

## Aamukäyttö (2 min)

1. Käyttäjä avaa appin herättyään
2. **Näkee välittömästi:**
   - Yön unidata (kesto, syvä uni, REM, heräilyt) – automaattisesti Ourasta
   - Aamu-HRV ja palautumisindeksi
   - Päivän riskitaso (matala / kohonnut / korkea) värikoodilla
3. **Jos riski koholla:** Yksi konkreettinen suositus näkyy heti
4. **Ei vaadi toimenpiteitä** – kaikki data tulee automaattisesti

## Päiväkäyttö (< 1 min per interaktio)

- **Ruokakuva:** Kuva lounaasta → appi prosessoi taustalla → ei vaadi muuta
- **Oirekirjaus tarvittaessa:** Jos migreeni alkaa → 2 napautusta: "migreeni alkoi" + intensiteetti (1–3)
- **Proaktiivinen notifikaatio:** Jos kuormitus kumuloituu → yksi hillitty ilmoitus konkreettisella ehdotuksella
- **Ei päivittäistä kyselyä** – appi ei lähetä "Miten voit?" -kyselyjä

## Iltakäyttö (1 min, valinnainen)

- Päivän yhteenveto: kuormitus, aktiivisuus, ateriarytmi
- **Yksi valinnainen kysymys** (ei pakollinen): "Oliko tänään jotain poikkeavaa?" → vapaakenttä tai pikavalinta (matkustus, alkoholi, erityinen stressi, hormonivaihe)
- Tämä on ainoa kohta, jossa appi kysyy aktiivisesti kontekstia

## Mitä kysyä aktiivisesti ja mitä ei

| Kysytään aktiivisesti | Ei kysytä |
|---|---|
| Migreenikohtauksen alkaminen | Mieliala |
| Migreenikohtauksen intensiteetti | Uneen menemisaika (tulee Ourasta) |
| Poikkeava konteksti (ilta, valinnainen) | Askelmäärä (tulee automaattisesti) |
| | Syke (tulee automaattisesti) |
| | Ruoan kalorit (ei relevantti) |

## Miten appi ei kuormita

- **Ei päivittäisiä pakollisia kirjauksia**
- **Notifikaatiot harvoin** – vain kun on oikeasti jotain sanottavaa
- **Ei gamifikaatiota** – ei putkia, pisteitä tai badgeja
- **Ei syyllistämistä** – "et nukkunut tarpeeksi" → sen sijaan "palautuminen jäi vajaaksi, tämä saattaa lisätä riskiä"
- **Tyhjä päivä on ok** – appi toimii myös ilman interaktiota

---

# 4. Ominaisuudet

## MVP (kuukausi 1–2)

| # | Ominaisuus | Perustelu |
|---|---|---|
| 1 | Apple Health -integraatio (uni, syke, askeleet, HRV) | Perusdata ilman ylimääräistä laitetta |
| 2 | Oura-integraatio (uni, palautuminen, HRV, lämpötila) | Tarkempi unidata ja valmiusindeksi |
| 3 | Migreenikohtauksen kirjaus (2 napautusta) | Koko appin ydindata |
| 4 | Päivän riskiarvio (sääntöpohjainen) | Käyttäjä saa heti arvoa ensimmäisestä päivästä |
| 5 | Ruokakuvan tallennus + AI-tunnistus (pääraaka-aineet) | Mahdollistaa ruoka-analyysin myöhemmin |
| 6 | Aamunäkymä (dashboard) | Päivittäinen käyttöpiste |
| 7 | Migreenin jälkianalyysi (48h aikaikkunan visualisointi) | Käyttäjä näkee mikä edelsi kohtausta |
| 8 | Viikkokooste | Trendit ja kuviot konkretisoituvat |

## V2 (kuukausi 3–4)

| # | Ominaisuus | Perustelu |
|---|---|---|
| 9 | Hypoteesimoottori (tilastollinen korrelaatioanalyysi) | Automatisoitu kuvioiden tunnistus |
| 10 | Kontekstimerkinnät (matkustus, alkoholi, hormonivaihe) | Rikastaa analyysiä minimaalisella vaivalla |
| 11 | Suositusmoottori (ajoitetut, kontekstuaaliset) | Proaktiivinen toiminnan tukeminen |
| 12 | Kuormituksen kumulaatiovaroitus | Ennaltaehkäisy |
| 13 | Trendien visualisointi (4+ viikon aikajänne) | Pitkän aikavälin kuviot |

## Myöhemmin (V3+)

| # | Ominaisuus | Arvio |
|---|---|---|
| 14 | ML-pohjainen ennustusmalli | **Arvokas mutta vaatii paljon dataa.** Ei kannata ennen 6kk käyttödataa. |
| 15 | Säädata-integraatio (ilmanpaine, lämpötila) | **Mahdollisesti hyödyllinen, mutta evidenssi migreenin ja sään välillä on heikko ja yksilöllistä.** Toteuta vasta kun perusdata on kunnossa. |
| 16 | Lääkekirjaus ja vaikuttavuuden seuranta | **Hyödyllinen, mutta regulaatioriski.** Vaatii huolellista suunnittelua. |
| 17 | Hormonisyklin automaattinen tunnistus | **Potentiaalinen, mutta vaatii luotettavaa lämpötiladataa ja käyttäjän vahvistusta.** |
| 18 | Sosiaalinen jakaminen / lääkäriraportti | **Turhaa MVP:ssä.** Voi harkita jos käyttäjät pyytävät. |

## Todennäköisesti turhaa tai liian aikaista

- **Chatbot / AI-assistentti**: Liian geneerinen, ei tuo tarpeeksi arvoa suhteessa monimutkaisuuteen
- **Ruoan kalorilaskenta**: Ei relevantti migreenin kannalta, lisää kohinaa
- **Mindfulness-harjoitukset**: Poistaa fokusta ydinongelmasta, saatavilla muualla
- **Yhteisöominaisuudet**: Ei ratkaise ydinongelmaa, monimutkaistaa tuotetta

---

# 5. Datalähteet

## Apple Watch / Apple Health

| Signaali | Hyödyllisyys | Johtava/laahaava | Kohina |
|---|---|---|---|
| **HRV (Heart Rate Variability)** | ⭐⭐⭐ Korkea | Johtava – laskee usein ennen migreenin puhkeamista | Keskitaso – vuorokausivaihtelu suurta, yksittäinen mittaus ei kerro paljoa. **Käytä yön keskiarvoa tai aamumittausta.** |
| **Leposyke** | ⭐⭐⭐ Korkea | Johtava – nousee kuormituksen kasvaessa | Matala – melko luotettava signaali trendien seuraamiseen |
| **Unen kesto** | ⭐⭐ Keskikorkea | Johtava – lyhyt uni nostaa riskiä | Matala – Apple Watchin unidetektio kohtuullinen |
| **Askeleet / aktiivisuus** | ⭐ Matala-keskitaso | Laahaava – kertoo mitä tehtiin, ei mikä on tulossa | Matala |
| **SpO2** | ⭐ Matala | Epäselvä | Korkea – Apple Watchin SpO2 on epätarkka |
| **Aktiivisuuskalorit** | ⭐ Matala | Laahaava | Keskitaso |

**Suositus:** Käytä ensisijaisesti HRV:tä, leposykettä ja unen kestoa. Sivuuta SpO2 ja kalorit.

## Oura Ring

| Signaali | Hyödyllisyys | Johtava/laahaava | Kohina |
|---|---|---|---|
| **Readiness Score** | ⭐⭐⭐ Korkea | Johtava – yhdistelmäindeksi joka korreloi kuormituksen kanssa | Matala – Ouran algoritmi hyödyntää useita signaaleja |
| **HRV (yön keskiarvo)** | ⭐⭐⭐ Korkea | Johtava | Matalampi kuin päivämittaus – Oura mittaa yöllä systemaattisesti |
| **Syvä uni / REM** | ⭐⭐ Keskikorkea | Johtava – unen rakenne voi vaikuttaa migreeniriskiin | Keskitaso – univaiheiden tunnistus sormuksen accelerometrillä on kohtuullinen muttei kliininen |
| **Ihon lämpötila (delta)** | ⭐⭐ Keskikorkea | Johtava – muutokset voivat liittyä tulehdukseen, hormonikieroon | Keskitaso – ympäristö vaikuttaa |
| **Aktiivisuusdata** | ⭐ Matala | Laahaava | Keskitaso |

**Suositus:** Readiness Score + yön HRV ovat arvokkaimmat. Lämpötiladata on kiinnostava mutta vaatii pitkää aikasarjaa tulkintaan.

## Ruokakuvat

| Signaali | Hyödyllisyys | Johtava/laahaava | Kohina |
|---|---|---|---|
| **Pääraaka-aineet** | ⭐⭐ Keskikorkea | Johtava (12–48h viiveellä) | Keskitaso – AI tunnistaa suuret kategoriat, ei kaikkia ainesosia |
| **Aterioiden ajoitus** | ⭐⭐⭐ Korkea | Johtava – paastojaksojen pituus ja säännöllisyys ovat relevantteja | Matala – kuvasta saa tarkan aikaleiman |
| **Annoskoko** | ⭐ Matala | Laahaava | Korkea – kuvasta ei luotettavasti pysty arvioimaan |

**Suositus:** Aterioiden ajoitus on arvokkain tieto. Raaka-aineiden tunnistus on hyödyllistä kun haetaan toistuvia kuvioita (esim. kypsytetty juusto, punaviini, prosessoidut lihat). Annoskokoa ei kannata yrittää arvioida.

**Kriittinen huomio:** Ruokakuva-analyysi ei tunnista kaikkia potentiaalisia triggeriaineita (tyramiini, histamiiini, nitriitit). Tämä tulee kommunikoida käyttäjälle rehellisesti.

## Manuaalinen kirjaus

| Signaali | Hyödyllisyys | Johtava/laahaava | Kohina |
|---|---|---|---|
| **Migreenikohtaus (kyllä/ei + intensiteetti)** | ⭐⭐⭐⭐⭐ Kriittinen | Laahaava (on lopputulos) | Matala – käyttäjän oma raportointi |
| **Poikkeava konteksti (matkustus, alkoholi, erityinen stressi)** | ⭐⭐⭐ Korkea | Johtava | Matala – yksinkertainen kyllä/ei |
| **Hormonivaihe** | ⭐⭐ Keskikorkea (jos relevantti) | Johtava | Matala |
| **Vapaa muistiinpano** | ⭐ Matala | – | Korkea – vaikea analysoida systemaattisesti |

**Suositus:** Pidä manuaalinen kirjaus minimissä. Migreenikirjaus on ainoa pakollinen. Kontekstimerkinnät ovat vapaaehtoisia. Vapaat muistiinpanot ovat käyttäjälle itselleen, eivät analyysiin.

---

# 6. Migreenin tunnistus- ja hypoteesimoottori

## Perusperiaatteet

1. **Migreeni on monimuuttuja-ilmiö.** Yksittäinen triggeri harvoin selittää kohtausta – kyse on usein usean tekijän yhteisvaikutuksesta.
2. **Viive vaihtelee.** Jotkut triggerit vaikuttavat tunnissa (kofeiinin puute), toiset 24–48h viiveellä (unimuutokset, ruoka-aineet).
3. **Yksilöllistä.** Populaatiotason triggerit (juusto, suklaa, punaviini) eivät koske kaikkia. Appin pitää löytää **tämän käyttäjän** kuviot.
4. **Pienet otoskoot.** 2–8 migreenikohtausta/kk tarkoittaa, että tilastollinen voima on heikko. Tarvitaan kuukausia dataa ennen luotettavia päätelmiä.

## Analysoitavat tekijät ja aikaikkunat

| Tekijä | Aikaikkunat ennen migreeniä | Miten mitataan |
|---|---|---|
| Uni (kesto, laatu, rakenne) | 1–2 yötä | Oura / Apple Health |
| HRV (poikkeama henkilökohtaisesta baseline) | 24–48h | Oura (yön ka.) |
| Leposyke (trendi) | 24–72h | Apple Watch / Oura |
| Ateriarytmi (paastojakso, ateriamäärä) | 12–24h | Ruokakuvien aikaleimat |
| Ruoka-aineet (tunnetut triggerikategoriat) | 12–48h | Ruokakuva-AI |
| Kofeiini (oletus: aamukahvi) | 12–24h | Manuaalinen tai ruokakuva |
| Stressi / työkuorma | 24–72h (kumuloituva) | HRV + leposyke + kontekstimerkintä |
| Liikunta (intensiteetti, kesto) | 12–48h | Apple Health |
| Nesteytys | 12–24h | Ei luotettavaa automaattista mittausta – **jätetään pois MVP:stä** |
| Hormonikierto | Syklin vaihe | Manuaalinen kirjaus / Ouran lämpötiladata |
| Matkustus | 24–48h | Manuaalinen merkintä |
| Poikkeava päivärytmi | 24h | Unen ajoituksen vaihtelu |
| Alkoholi | 12–24h | Manuaalinen merkintä |

## Analyysin tasot

### Taso 1: Sääntöpohjainen riskinarviointi (MVP)

Yksinkertaiset säännöt, joiden pohjana on kliininen evidenssi ja käyttäjän oma data:

```
JOS yön_HRV < henkilökohtainen_baseline × 0.85
JA uni_kesto < 6h
→ "Kohonnut riski" (keltainen)

JOS yön_HRV < henkilökohtainen_baseline × 0.75
JA uni_kesto < 6h
JA edellispäivän_konteksti sisältää (alkoholi TAI matkustus TAI poikkeava_rytmi)
→ "Korkea riski" (punainen)
```

**Baseline:** Liukuva 14 päivän mediaani. Ensimmäisten 2 viikon aikana käytetään populaatiotason oletusarvoja ja kommunikoidaan selkeästi: "Opimme vielä normaalia tasoasi."

### Taso 2: Tilastollinen korrelaatioanalyysi (V2)

- Lasketaan jokaiselle tekijälle **ehdollinen todennäköisyys**: P(migreeni | tekijä poikkeava) vs. P(migreeni | tekijä normaali)
- Käytetään **Fisherin eksaktia testiä** tai **Bayesilaista päättelyä** pienten otoskokojen vuoksi
- Vaatii **vähintään 8–10 migreenikohtausta** ennen kuin analyysi aktivoituu
- Analysoidaan myös **yhdistelmätriggereitä** (esim. lyhyt uni + intensiivinen liikunta)

### Taso 3: ML-pohjainen ennustus (V3+)

- Aikasarja-analyysi (LSTM tai transformer-pohjainen)
- Mahdollista vasta kun dataa on 6+ kuukautta
- Ei välttämätön – tilastollinen analyysi kattaa suurimman osan arvosta

## Korrelaatio vs. hypoteesi vs. kohina

Appi luokittelee jokaisen havainnon kolmeen kategoriaan ja kommunikoi ne eri tavoin:

### Uskottava hypoteesi (näytetään käyttäjälle)
- Vähintään 5 migreenikohtausta datassa
- Tekijä poikkeava vähintään 60 %:ssa kohtauksista JA merkittävästi vähemmän poikkeava ei-migreenipäivinä
- p-arvo < 0.1 (huom: tietoisesti löysempi raja, koska n on pieni, ja kyseessä ei ole kliininen päätös)
- **Muotoilu:** "Havaintojesi perusteella lyhyt uni (< 6h) näyttää liittyvän kohonneeseen migreeniriskiisi. Tämä on havaittu 7/10 kohtausta edeltävässä yössä vs. 2/20 muina öinä."

### Kiinnostava korrelaatio (näytetään varovaisesti)
- 3–4 migreenikohtausta datassa TAI p-arvo 0.1–0.2
- **Muotoilu:** "Alustava havainto: prosessoidut lihat ovat esiintyneet usein ennen migreenipäiviäsi. Dataa ei ole vielä tarpeeksi varman johtopäätöksen tekemiseen. Jatketaan seuraamista."

### Liian heikko signaali (ei näytetä käyttäjälle)
- Alle 3 migreenikohtausta TAI ei tilastollisesti erottuvaa
- Tallennetaan sisäisesti jatkoseurantaa varten
- **Ei näytetä käyttäjälle**, koska se aiheuttaisi turhaa hätää tai harhaanjohtavia oletuksia

## Väärien johtopäätösten välttäminen

### Ongelma: Pienet otoskoot + paljon muuttujia = monitestauskorrelaatiot

**Vastatoimet:**

1. **Minimidata-vaatimukset:** Hypoteeseja ei muodosteta ennen 8–10 migreenikohtausta. Tämä kommunikoidaan käyttäjälle: "Tarvitsen vielä lisää dataa ennen luotettavia havaintoja."

2. **Bonferroni-tyylinen korjaus ei toimi** pienellä datalla – käytetään sen sijaan **Bayesilaista prioria**: tunnetuille migreenitriggereille (uni, stressi, HRV) annetaan korkeampi ennakko-todennäköisyys. Tuntemattomille tekijöille vaaditaan vahvempi signaali.

3. **Temporaalinen validointi:** Havaittu kuvio tarkistetaan uudella datalla. Ensimmäinen havainto → "seurataan" → vahvistuu tai heikentyy 4 viikon kuluessa.

4. **Satunnaisvaihtelun kommunikointi:** Appi ei koskaan sano "X aiheuttaa migreenisi". Sen sijaan: "X näyttää liittyvän kohonneeseen riskiin datasi perusteella."

5. **Negatiivisten tulosten näyttäminen:** Jos dataa on tarpeeksi ja tekijä EI näytä korreloivan, appi kertoo: "Juusto ei näytä liittyvän migreeneihisi 3 kuukauden datan perusteella." Tämä on arvokasta tietoa.

6. **Suojaavien tekijöiden tunnistaminen:** Sama logiikka toimii myös toiseen suuntaan – mitkä tekijät liittyvät migreenittömiin jaksoihin? (Esim. säännöllinen unirytmi, kohtuullinen liikunta, korkea HRV.)

---

# 7. Suositusmoottori

## Suunnitteluperiaatteet

1. **Konkreettisuus:** "Harkitse kävelylenkkiä klo 12–14" > "Liiku tänään"
2. **Ajoitus:** Suositus tulee silloin kun se on toiminnallisesti relevantti
3. **Epävarmuuden kommunikointi:** "Tämä on perustunut 3 viikon dataasi" – ei absoluuttisia väitteitä
4. **Ei ylikuormitusta:** Maksimi 2 suositusta/päivä normaalitilanteessa, 3 kohonneen riskin päivänä
5. **Vain toiminnalliset suositukset:** Jokaisen suosituksen pitää olla jotain, mitä käyttäjä voi oikeasti tehdä seuraavan tunnin sisällä

## Suositukset ajankohdan mukaan

### Aamusuositukset (klo 7–9)

Aktivoituvat aamunäkymän yhteydessä. Perustuvat yön dataan.

| Tilanne | Suositus | Perustelu |
|---|---|---|
| HRV matala + uni lyhyt | "Palautumisesi jäi vajaaksi. Harkitse kevyempää päivää ja vältä intensiivistä liikuntaa." | Kuormituksen minimoiminen kohonneen riskin päivänä |
| Uni ok mutta HRV matalalla trendillä 3+ pv | "HRV on laskenut 3 päivän ajan. Kuormitus saattaa kumuloitua – pidä huoli tauoista." | Kumulatiivisen ylikuormituksen ehkäisy |
| Kaikki normaalia | Ei suositusta | Ei turhia viestejä hyvinä päivinä |
| Poikkeavan hyvä yö | "Erinomainen palautuminen. Hyvä päivä vaativalle työlle tai liikunnalle." | Positiivinen vahvistus + toiminnan tuki |

### Päiväsuositukset (klo 11–15)

Proaktiivinen push-notifikaatio vain kohonneen riskin päivänä.

| Tilanne | Suositus | Perustelu |
|---|---|---|
| Kohonnut riski + ei ruokakuvaa klo 13 mennessä | "Muistutus: säännöllinen ateriarytmi voi auttaa kohonneen riskin päivänä." | Ateriarytmin poikkeamat ovat potentiaalinen triggeri |
| Edellisestä migreenikohtauksesta < 48h | "Olet toipumisvaiheessa. Anna itsellesi kevyempi päivä." | Postdrome-vaiheessa ylikuormitus voi laukaista uuden kohtauksen |
| Normaali päivä | Ei suositusta | — |

### Iltasuositukset (klo 20–22)

Tulevat päivän yhteenvedon yhteydessä.

| Tilanne | Suositus | Perustelu |
|---|---|---|
| Korkea kuormituspäivä (korkea syke, vähän taukoja) | "Aktiivinen päivä takana. Pyri nukkumaan ennen klo 23 palautumisen tueksi." | Uniajoituksen säännöllisyys on yksi vahvimmista suojaavista tekijöistä |
| Alkoholi merkitty kontekstiin | "Alkoholi voi heikentää unen laatua ja laskea HRV:tä. Huomenna voi olla kohonnut riski." | Ennakoiva tiedotus ilman syyllistämistä |
| Normaali ilta | Ei suositusta | — |

### Migreeniriskin noustessa

| Tilanne | Suositus | Perustelu |
|---|---|---|
| Riskitaso siirtyy kohonneesta korkeaan | "Riskitasosi on kohonnut. Mahdollisuuksien mukaan: kevennä aikataulua, vältä tunnettuja triggereitäsi [listaa käyttäjän tunnistetut], ja huolehdi nesteen­saannista." | Konkreettinen, personoitu toimenpidelista |
| Useita riskitekijöitä samanaikaisesti | "Useita riskitekijöitä havaittu: [listaus]. Harkitse ennaltaehkäisevää lääkitystä jos lääkärisi on sellaista suositellut." | Huom: ei suosittele lääkitystä, vaan viittaa lääkärin ohjeeseen |

### Palautumisen heikentyessä (3+ päivän trendi)

| Tilanne | Suositus | Perustelu |
|---|---|---|
| HRV laskeva trendi 3 pv | "Palautumisesi on heikentynyt 3 päivän ajan. Tämä voi lisätä migreeniriskiä. Priorisointi: uni ja tauot." | Kumuloitumisen ehkäisy |
| Readiness Score laskee 5 pv | "Oura Readiness on laskenut viikon ajan. Harkitse kalenterin keventämistä seuraaviksi 2 päiväksi." | Proaktiivinen ennakointi |

### Kuormituksen kasvaessa

| Tilanne | Suositus | Perustelu |
|---|---|---|
| Lyhyt uni + pitkä työpäivä + ei liikuntaa 3 pv | "Kuormitus on kasvanut ja palautuminen jäänyt vajaaksi. Tämä yhdistelmä on aiemmin edeltänyt migreenikohtauksiasi." | Personoitu varoitus perustuen käyttäjän omaan dataan |

## Mitä appi EI suosittele

- **Lääkitystä** (paitsi viittaus käyttäjän omaan lääkäriltä saatuun ohjeeseen)
- **Diagnooseja** ("sinulla on stressimigreeni")
- **Geneerisiä vinkkejä** ("juo vettä", "meditoiilu", "nuku tarpeeksi")
- **Tiukka sääntöjä** ("älä koskaan syö juustoa") – vaan todennäköisyyksiä

---

# 8. Käyttöliittymä

## Näkymä 1: Dashboard (etusivu)

### Mitä näkyy
- **Riskimittari:** Yksinkertainen värikoodi (vihreä / keltainen / punainen) + lyhyt selite
- **Yön avainluvut:** Uni (kesto + laatu-arvio), HRV (arvo + trendi-nuoli ↑↓→), Readiness Score
- **Mahdollinen suositus:** Max 1 suositus, napautettava lisätietoja varten
- **Viimeisin ruokakuva:** Pieni thumbnail + tunnistetut raaka-aineet
- **Migreenittömät päivät:** Yksinkertainen laskuri ("14 päivää edellisestä kohtauksesta")

### Mitä päätöstä auttaa tekemään
"Pitääkö minun muuttaa tämän päivän suunnitelmia?"

### Miksi tärkeä
Tämä on ainoa näkymä, jota käyttäjä katsoo joka aamu. Sen on oltava informatiivinen mutta ei ylikuormittava. 5 sekunnin vilkaisu riittää.

## Näkymä 2: Päivän riskinäkymä

### Mitä näkyy
- **Riskitason perustelu:** Mitkä tekijät nostavat / laskevat riskiä tänään
- **Aikajana:** 24h taaksepäin – uni, ateriat, aktiivisuus, HRV visuaalisena janana
- **Vertailu:** "Samankaltaisina päivinä aiemmin migreeniriski on ollut X%"
- **Suositukset:** 1–3 konkreettista toimenpidettä

### Mitä päätöstä auttaa tekemään
"Miksi riskini on koholla ja mitä voin tehdä?"

### Miksi tärkeä
Antaa käyttäjälle ymmärryksen ja hallinnan tunteen. Pelkkä "punainen valo" ei riitä – käyttäjä haluaa tietää miksi.

## Näkymä 3: Migreenihypoteesit

### Mitä näkyy
- **Vahvistuneet hypoteesit:** Lista tunnistetuista mahdollisista triggereistä ja suojaavista tekijöistä, luottamustasoineen
- **Seurannassa olevat:** Alustavat korrelaatiot, joita vielä validoidaan
- **Kumotut:** Tekijät joita data EI tue triggereinä (arvokas tieto!)
- **Jokaisen kohdalla:** Visualisointi (esim. "Lyhyt uni esiintyi 8/12 migreeniä edeltävänä yönä vs. 5/45 muina öinä")

### Mitä päätöstä auttaa tekemään
"Mitkä tekijät todennäköisesti vaikuttavat migreeneihini?"

### Miksi tärkeä
Tämä on appin ydinlupauksen täyttymys. Ilman tätä näkymää appi on vain toinen datan keruuväline.

## Näkymä 4: Ruokakuvan analyysi

### Mitä näkyy
- **Kameranäkymä** ruokakuvan ottamista varten
- **AI:n tunnistus:** Lista tunnistetuista raaka-aineista / ruoka-aineista, muokattavissa
- **Merkintä potentiaalisista triggereistä:** Jos tunnistettu aine on potentiaalinen triggeri (tyramiinipitoinen, histamiiinipitoinen), näytetään varovainen merkintä
- **Aikaleima** tallentuu automaattisesti

### Mitä päätöstä auttaa tekemään
"Onko tässä aterialla jotain, mitä kannattaa seurata?"

### Miksi tärkeä
Minimoi manuaalista työtä. Kuvan ottaminen on nopeaa (< 5s). Datan rikastus tapahtuu automaattisesti.

## Näkymä 5: Oirekirjaus

### Mitä näkyy
- **Iso nappi:** "Migreeni alkoi" (yksi napautus)
- **Intensiteetti:** 1–3 asteikko (lievä / kohtalainen / vaikea) (toinen napautus)
- **Valinnainen lisätieto:** Aura kyllä/ei, sijainti (toispuoleinen/molemminpuolinen), pahoinvointi
- **Kohtauksen lopetus:** "Migreeni ohi" -nappi

### Mitä päätöstä auttaa tekemään
"Haluan kirjata migreenikohtauksen mahdollisimman helposti."

### Miksi tärkeä
Tämä on koko analytiikan perusta. Jos migreenikirjaus on vaivalloista, koko appi menettää arvonsa. **2 napautusta on maksimi pakollinen interaktio.**

## Näkymä 6: Viikkokooste

### Mitä näkyy
- **Viikon yhteenveto:** Migreenikohtaukset, keskimääräinen riski, palautumis­trendi
- **Avainluvut:** HRV-trendi, unen kesto (keskiarvo + vaihtelu), ateriarytmin säännöllisyys
- **Viikon oivallukset:** 1–2 merkittävintä havaintoa ("Tällä viikolla migreenisi seurasivat lyhyitä unia" tai "Ei merkittäviä havaintoja tällä viikolla")
- **Vertailu edelliseen viikkoon:** Paraniko vai heikkenikö tilanne?

### Mitä päätöstä auttaa tekemään
"Meneekö suuntani oikeaan vai väärään suuntaan?"

### Miksi tärkeä
Viikkotason katsaus on oikea aikajänne kuvioiden havaitsemiseen. Päivätaso on liian kohinaista, kuukausitaso liian harvaa.

## Näkymä 7: Trendit ja löydökset

### Mitä näkyy
- **Pitkän aikavälin graafit:** HRV, leposyke, unen kesto, migreenifrekvenssi – 4vko / 3kk / 6kk
- **Migreenikohtausten merkinnät aikajanalle:** Klikattavissa → näyttää mitä edelsi
- **Korrelaatiomatriisi (V2+):** Visuaalinen esitys siitä, mitkä tekijät korreloivat migreenin kanssa
- **Suojaavien tekijöiden seuranta:** "Viikolla jolloin HRV oli yli basalinen + uni > 7h, migreenikohtauksia oli 0"

### Mitä päätöstä auttaa tekemään
"Mitkä pidemmän ajan trendit vaikuttavat terveydentilaani?"

### Miksi tärkeä
Tässä käyttäjä näkee kuukausien kertymän. Analyyttiselle käyttäjälle tämä on arvokkainta – mutta vasta kun dataa on tarpeeksi.

---

# 9. Tekninen toteutus

## Korkean tason arkkitehtuuri

```
┌─────────────────────────────────────────────┐
│                 iOS App (SwiftUI)            │
│  ┌──────────┐ ┌──────────┐ ┌──────────────┐ │
│  │Dashboard │ │Oirekirj. │ │Ruokakuva-UI  │ │
│  └────┬─────┘ └────┬─────┘ └──────┬───────┘ │
│       │             │              │         │
│  ┌────┴─────────────┴──────────────┴───────┐ │
│  │         Local Data Layer (Core Data)    │ │
│  │         + HealthKit Integration         │ │
│  └────┬────────────────────────────────────┘ │
└───────┼──────────────────────────────────────┘
        │ HTTPS/REST
┌───────┼──────────────────────────────────────┐
│       ▼                                      │
│  ┌──────────────────────────────────────┐    │
│  │           API Gateway (FastAPI)      │    │
│  └──┬───────────┬───────────┬───────────┘    │
│     │           │           │                │
│  ┌──▼──┐  ┌────▼────┐  ┌───▼──────────┐    │
│  │Oura │  │Ruokakuva│  │Hypoteesi-    │    │
│  │Sync │  │Analyysi │  │moottori      │    │
│  └─────┘  │(Vision  │  │(Sääntö +     │    │
│           │ API)    │  │ Tilasto)     │    │
│           └─────────┘  └──────────────┘    │
│                                              │
│  ┌──────────────────────────────────────┐    │
│  │     PostgreSQL + TimescaleDB         │    │
│  └──────────────────────────────────────┘    │
│              Backend (Cloud)                 │
└──────────────────────────────────────────────┘
```

## Teknologiavalinnat

### Frontend: iOS-natiivi (SwiftUI)

**Perustelu:**
- Apple HealthKit -integraatio vaatii natiivia
- Käyttäjä on Apple-ekosysteemissä (Apple Watch + Oura)
- SwiftUI on riittävän nopea kehittää yksin / pienellä tiimillä
- Cross-platform (Flutter/React Native) ei tuo tässä etua, koska HealthKit on iOS-only

**Ei cross-platformia koska:**
- Android ei tue HealthKitiä
- Oura-integraatio toimii API:n kautta kummallakin, mutta Watch-data on iOS-sidottu
- Parempi tehdä yksi hyvä iOS-appi kuin kaksi keskinkertaista

### Backend: Python (FastAPI)

**Perustelu:**
- Nopea prototyyppikieli
- Erinomainen data-analyysikirjasto-ekosysteemi (pandas, scipy, numpy)
- FastAPI on kevyt, nopea ja helppo testata
- Myöhemmin ML-laajennukset luontevasti samassa ekosysteemissä

### Tietokanta: PostgreSQL + TimescaleDB

**Perustelu:**
- Aikasarjadata (HRV, syke, uni) → TimescaleDB on optimoitu tähän
- PostgreSQL on vakaa, hyvin tuettu, JSONB tukee joustavaa skeemaa
- Ei tarvita NoSQL:ää – data on rakenteellista

### Apple HealthKit -integraatio

- **HKHealthStore** lukee: HRV, leposyke, univaiheet, askeleet, aktiivisuus
- **Background delivery** päivittää dataa automaattisesti
- Data tallennetaan ensin lokaalisti (Core Data), synkataan backendiin
- **HUOM:** HealthKit-data ei saa lähteä laitteelta ilman käyttäjän nimenomaista suostumusta

### Oura API -integraatio

- **OAuth 2.0** -autentikointi
- **REST API** palauttaa: sleep, readiness, activity, daily scores
- Pollaus kerran/päivä (yödata valmis aamulla)
- Oura API v2 tukee webhookeja → käytetään V2:ssa

### Ruokakuva-analyysi

**MVP:** OpenAI Vision API tai Claude Vision
- Kuva lähetetään backendiin → API-kutsu → raaka-ainelista palautetaan
- Riittävä tarkkuus pääraaka-aineille (liha, kala, juusto, vihannekset, viljatuotteet)
- **Ei yritä arvioida kaloreja** tai annoskokoa

**V2:** Fine-tuunattu malli migreenitriggereiden tunnistamiseen
- Koulutetaan tunnistamaan erityisesti: kypsytetyt juustot, prosessoidut lihat, punaviini, suklaa, sitrushedelmät

### Analytiikkakerros

**MVP (sääntöpohjainen):**
- Python-funktiot jotka laskevat riskiscoreja yksinkertaisilla säännöillä
- Henkilökohtainen baseline liukuvasta mediaanista
- Ei ML:ää – pelkkää tilastollista vertailua

**V2 (tilastollinen):**
- scipy.stats: Fisherin eksaktitesti, chi-square
- Bayesilainen päättely: pymc3 tai kevyempi oma toteutus
- Korrelaatioanalyysi aikaikkunoilla (12h, 24h, 48h viiveillä)

**V3+ (ML):**
- scikit-learn: logistinen regressio, random forest (baseline)
- Aikasarjamallit: Prophet tai LSTM
- Vasta kun dataa on 6+ kuukautta ja tilastollinen analyysi on validoitu

## Nopein uskottava tapa rakentaa MVP

1. **SwiftUI-appi** pelkällä lokaalilla datalla (Core Data)
2. **HealthKit-integraatio** (HRV, syke, uni)
3. **Oura API** (sleep, readiness)
4. **Yksinkertainen sääntöpohjainen riskiarvio** (toteutettavissa clientissä)
5. **Ruokakuva** → suora Vision API -kutsu clientista
6. **Ei backendia MVP:ssä** – kaikki lokaalia, paitsi ruokakuva-analyysi

**Aika-arvio:** 4–6 viikkoa yksin kehittäen

## Paras tapa rakentaa tuotantokelpoinen versio

- Backend (FastAPI + PostgreSQL + TimescaleDB)
- Synkronointi pilveen (end-to-end-salattu)
- Kunnollinen hypoteesimoottori serveripuolella
- CI/CD (TestFlight → App Store)
- Tietosuoja-auditointi
- **Aika-arvio:** 3–4 kuukautta, 1–2 kehittäjää

---

# 10. Tietosuoja, regulaatio ja riskit

## Wellness vs. lääkinnällinen ohjelmisto

### Milloin HealthHub on wellness-sovellus (ei reguloitu)

- Näyttää käyttäjän omaa dataa yhdistettynä
- Tarjoaa yleisiä hyvinvointisuosituksia ("harkitse kevyempää päivää")
- Esittää korrelaatioita ja hypoteeseja, ei diagnooseja
- Käyttäjä tekee itse päätökset
- Ei väitä ennustavansa, diagnosoivansa tai hoitavansa migreeniä

### Milloin raja ylittyy (MDR / FDA Class II)

- Jos appi väittää **ennustavansa** migreenikohtauksia ("saat migreenin 80% todennäköisyydellä")
- Jos appi **suosittelee lääkitystä** tai lääkeannoksia
- Jos appi väittää olevansa **diagnostinen työkalu**
- Jos markkinoinnissa käytetään ilmaisuja kuten "estää migreenin" tai "hoitaa migreeniä"

### HealthHubin linja

**HealthHub on wellness-työkalu joka auttaa käyttäjää ymmärtämään omaa dataansa.** Se ei diagnosoi, ennusta eikä hoida. Kaikki kommunikaatio muotoillaan hypoteeseina ja havaintoina, ei tosiasioina tai lääketieteellisinä neuvoina.

**Konkreettiset muotoilusäännöt:**
- ❌ "Saat todennäköisesti migreenin huomenna"
- ✅ "Useat riskitekijät ovat koholla – aiempien havaintojen perusteella tämä yhdistelmä on edeltänyt kohtauksiasi"
- ❌ "Ota triptaani nyt"
- ✅ "Jos lääkärisi on suositellut ennaltaehkäisevää lääkitystä, tämä saattaa olla hyvä hetki harkita sitä"
- ❌ "Juusto aiheuttaa migreenisi"
- ✅ "Kypsytetty juusto näyttää liittyvän kohonneeseen riskiin datasi perusteella"

## Tärkeimmät riskit

### Käyttäjälle

| Riski | Vakavuus | Mitigaatio |
|---|---|---|
| Väärä turvallisuudentunne ("appi sanoo matala riski → en varaudu") | Keskikorkea | Kommunikoi selkeästi: "Riskiarvio perustuu rajalliseen dataan. Se ei korvaa omaa tuntemustasi." |
| Ahdistuksen lisääntyminen datan jatkuvasta seuraamisesta | Keskikorkea | Minimoi notifikaatiot, ei pakollista päivittäistä interaktiota, mahdollisuus "hiljainen viikko" -tilaan |
| Väärät korrelaatiot johtavat tarpeettomiin ruokavaliorajoituksiin | Keskitaso | Minimidata-vaatimukset, epävarmuuden kommunikointi, negatiivisten tulosten näyttäminen |
| Tietojen vuoto (terveysdata on sensitiivistä) | Korkea | End-to-end-salaus, GDPR-yhteensopivuus, minimoitu datankeruu |

### Tuotetiimille

| Riski | Vakavuus | Mitigaatio |
|---|---|---|
| Regulaatioraja ylittyy huomaamatta | Korkea | Juridinen tarkistus ennen julkaisua, selkeät sisäiset muotoilusäännöt |
| Apple App Store hylkäys (terveysväittämät) | Keskikorkea | Noudatetaan Applen Health-kategoria-ohjeita tarkasti |
| Oura API -muutokset rikkovat integraation | Keskitaso | Abstraktiokerros API:n ja logiikan välillä, monitorointi |
| Käyttäjä lopettaa kirjaamisen → data loppuu | Korkea | Minimoi manuaalinen työ, varmista arvo myös ilman täydellistä dataa |

## GDPR ja tietosuoja

- **Data on käyttäjän.** Täysi vienti ja poisto milloin tahansa.
- **Minimoitu keruu:** Kerätään vain mitä analyysi tarvitsee
- **End-to-end-salaus** pilvisynkronoinnissa
- **Ei kolmannen osapuolen analytiikkaa** terveydatalle (ei Firebase Analytics, ei Mixpanel terveystiedoille)
- **Tietosuojaseloste** selkeällä kielellä, ei legalise

---

# 11. Oppimissuunnitelma

## Tärkeimmät hypoteesit testattavaksi

| # | Hypoteesi | Miten testataan | Minimidata |
|---|---|---|---|
| H1 | Käyttäjä kirjaa migreenikohtaukset luotettavasti 2 napautuksen UI:lla | MVP-testaus 2 viikkoa | 3–5 kohtausta kirjattuna |
| H2 | Sääntöpohjainen riskiarvio (HRV + uni) korreloi migreenikohtausten kanssa | 2 kuukauden data | 8+ kohtausta + päivittäinen HRV/uni |
| H3 | Ruokakuva-AI tunnistaa pääraaka-aineet riittävän tarkasti | 50 testikuvaa | 80%+ tarkkuus pääkategorioissa |
| H4 | Ateriarytmin poikkeamat korreloivat migreenin kanssa | 2–3 kuukauden data | 10+ kohtausta + johdonmukainen kuvien ottaminen |
| H5 | Käyttäjä kokee appin hyödylliseksi (ei kuormittavaksi) | Käyttöfrekvenssidatan seuranta | 4 viikon retention > 60% |

## Heikoin lenkki

**Käyttäjän sitoutuminen ruokakuvien ottamiseen.** Jos käyttäjä ei ota kuvia aterioistaan, merkittävä osa analyysistä (ateriarytmi, ruoka-ainetriggerit) jää pois. Tämä on suurempi riski kuin mikään tekninen komponentti.

Toiseksi heikoin: **Pienten otoskokojen ongelma.** 4–8 migreenikohtausta kuukaudessa tarkoittaa, että luotettavien hypoteesien muodostaminen kestää 2–3 kuukautta. Käyttäjän pitää kokea appi hyödylliseksi jo ennen kuin hypoteesit alkavat muodostua.

## Mikä minimitieto poistaisi suurimman epävarmuuden

**2 viikon testijakso, jossa käyttäjä (sinä) käyttää paperista/digitaalista prototyyppiä:**
- Kirjaa migreenikohtaukset
- Ottaa kuvia aterioista
- Katsoo aamuisin Ouran + Apple Watchin dataa

Jos tämän jälkeen:
- Kirjaukset ovat johdonmukaisia → H1 vahvistuu
- Ruokakuvia on > 70% aterioista → H3 on testaamisen arvoinen
- Käyttäjä kokee prosessin hyödylliseksi → jatkamisen arvoista

## Halvin nopea testi

**1 viikon manuaalinen prototyyppi:**
1. Käytä Oura-appia ja Apple Health -dataa sellaisenaan
2. Kirjaa migreenikohtaukset Apple Healthin kaikkien oireiden kirjaukseen tai yksinkertaiseen muistiinpanosovellukseen
3. Ota kuvia aterioista ja tallenna ne kansioon aikaleimoineen
4. Viikon lopussa: katso manuaalisesti, näkyykö mitään kuviota

**Kustannus:** 0 € + 15 min/päivä
**Mitä opitaan:** Onko kirjaaminen realistista? Näkyykö datassa mitään kiinnostavaa? Onko tarvetta oikeasti olemassa?

## Suositus

### ✅ JATKA – ehdollisesti

**Perustelu:**
- Ongelma on aito ja merkittävä (migreeni vaikuttaa suoraan toimintakykyyn)
- Data on saatavilla (Oura + Apple Watch + ruokakuvat)
- Teknisesti toteutettavissa MVP:nä 4–6 viikossa
- Käyttäjäprofiili on ihanteellinen (analyyttinen, motivoitunut, ymmärtää datan rajoitukset)

**Ehdot:**
1. **Tee ensin 1 viikon manuaalinen testi** (halvin nopea testi yllä). Jos kirjaaminen tuntuu raskaalta tai hyödyttömältä, älä rakenna appia.
2. **MVP ilman backendia.** Aloita puhtaasti lokaalilla iOS-appilla. Backend vasta kun perusarvo on validoitu.
3. **Älä rakenna hypoteesimoottoria MVP:hen.** Keskity datan keruuseen ja yksinkertaiseen riskiarvioon. Hypoteesit V2:ssa, kun dataa on tarpeeksi.

---

# 12. Konkreettinen lopputulos

## A. Executive Summary

**HealthHub** on iOS-mobiilisovellus, joka yhdistää Apple Watchin, Ouran ja ruokakuvadatan yhdeksi näkymäksi migreenin triggerien tunnistamiseksi ja arjen toimintakyvyn tueksi.

**Ydinongelma:** Migreenialtis käyttäjä startup-ympäristössä tarvitsee ymmärrystä siitä, mitkä tekijät altistavat hänet kohtauksille – mutta nykyiset sovellukset siiloittavat datan, vaativat liikaa manuaalista työtä ja eivät tee päätelmiä.

**Ratkaisu:** Automaattinen datan keruu (HealthKit + Oura API) + kevyt manuaalinen kirjaus (migreeni 2 napautuksella, ruoka kuvanotolla) + sääntöpohjainen riskiarvio → myöhemmin tilastollinen hypoteesimoottori.

**Kriittinen ero kilpailijoihin:** HealthHub ei ole dashboard-appi – se tekee päätelmiä, kommunikoi epävarmuuden ja antaa ajoitettuja, konkreettisia suosituksia.

**Suositus:** Jatka ehdollisesti. Tee ensin 1 viikon manuaalinen testijakso. Jos kirjaaminen on realistista, rakenna lokaali iOS-MVP 4–6 viikossa.

## B. Ominaisuuspriorisointi

| Ominaisuus | Vaihe | Prioriteetti | Vaiva | Arvo | Päätös |
|---|---|---|---|---|---|
| Apple Health -integraatio | MVP | P0 | Keskitaso | Kriittinen | ✅ Rakenna |
| Oura-integraatio | MVP | P0 | Keskitaso | Kriittinen | ✅ Rakenna |
| Migreenikirjaus (2 tap) | MVP | P0 | Matala | Kriittinen | ✅ Rakenna |
| Riskiarvio (sääntöpohjainen) | MVP | P0 | Keskitaso | Korkea | ✅ Rakenna |
| Ruokakuva + AI-tunnistus | MVP | P1 | Korkea | Keskikorkea | ✅ Rakenna |
| Dashboard | MVP | P0 | Keskitaso | Korkea | ✅ Rakenna |
| Migreenin jälkianalyysi | MVP | P1 | Keskitaso | Korkea | ✅ Rakenna |
| Viikkokooste | MVP | P1 | Matala | Keskikorkea | ✅ Rakenna |
| Hypoteesimoottori (tilastollinen) | V2 | P1 | Korkea | Erittäin korkea | ⏳ Odota |
| Kontekstimerkinnät | V2 | P2 | Matala | Keskitaso | ⏳ Odota |
| Suositusmoottori | V2 | P1 | Keskikorkea | Korkea | ⏳ Odota |
| Kuormitusvaroitus | V2 | P2 | Keskitaso | Keskikorkea | ⏳ Odota |
| Trendit (pitkä aikaväli) | V2 | P2 | Keskitaso | Keskikorkea | ⏳ Odota |
| ML-ennustus | V3+ | P3 | Erittäin korkea | Epävarma | 🔬 Tutki myöhemmin |
| Säädata | V3+ | P3 | Matala | Heikko evidenssi | ❓ Ehkä |
| Lääkekirjaus | V3+ | P2 | Keskitaso | Korkea mutta riskialtis | ❓ Ehkä |
| Chatbot | - | - | Korkea | Matala | ❌ Älä rakenna |
| Kalorilaskenta | - | - | Korkea | Ei relevantti | ❌ Älä rakenna |
| Yhteisö | - | - | Erittäin korkea | Matala | ❌ Älä rakenna |

## C. Tietomalli (ydinkäsitteet)

Katso erillinen `DATA_MODEL.md` täydellisestä mallista. Yhteenveto:

```
User
 ├── HealthMetric[]        (HRV, syke, uni, askeleet – automaattinen)
 │    ├── source: "apple_health" | "oura"
 │    ├── metric_type: "hrv" | "resting_hr" | "sleep_duration" | ...
 │    ├── value: Float
 │    ├── recorded_at: DateTime
 │    └── metadata: JSON
 │
 ├── MealEntry[]           (ruokakuvat)
 │    ├── image_url: String
 │    ├── recognized_items: [String]
 │    ├── potential_triggers: [String]
 │    ├── photographed_at: DateTime
 │    └── user_corrections: JSON?
 │
 ├── MigraineEvent[]       (kohtaukset)
 │    ├── started_at: DateTime
 │    ├── ended_at: DateTime?
 │    ├── intensity: 1-3
 │    ├── has_aura: Boolean?
 │    └── notes: String?
 │
 ├── ContextTag[]          (kontekstimerkinnät)
 │    ├── tag_type: "travel" | "alcohol" | "stress" | "hormone_phase" | ...
 │    ├── tagged_at: DateTime
 │    └── value: String?
 │
 ├── DailyRiskAssessment[] (päivittäinen riskiarvio)
 │    ├── date: Date
 │    ├── risk_level: "low" | "elevated" | "high"
 │    ├── contributing_factors: JSON
 │    └── recommendation: String?
 │
 ├── TriggerHypothesis[]   (hypoteesit – V2)
 │    ├── factor: String
 │    ├── direction: "trigger" | "protective"
 │    ├── confidence: "weak" | "moderate" | "strong"
 │    ├── evidence: JSON  (esiintymät, p-arvo, ...)
 │    ├── status: "monitoring" | "confirmed" | "refuted"
 │    └── updated_at: DateTime
 │
 └── Baseline              (henkilökohtaiset baseline-arvot)
      ├── hrv_14d_median: Float
      ├── resting_hr_14d_median: Float
      ├── sleep_duration_14d_median: Float
      └── updated_at: DateTime
```

## D. Käyttäjäpolku yhdelle päivälle

### Tiistai – kohonneen riskin päivä

**06:45 – Herätys**
- Oura synkannut yön datan: uni 5,5h (normaali 7,2h), HRV 28ms (normaali 42ms), Readiness 58
- Apple Watch: leposyke 68bpm (normaali 58bpm)

**07:00 – Avaa HealthHub**
- Dashboard näyttää: 🟡 **Kohonnut riski**
- Avainluvut: Uni 5,5h ↓ | HRV 28 ↓↓ | Leposyke 68 ↑
- Suositus: "Palautumisesi jäi vajaaksi. Harkitse kevyempää päivää. HRV ja leposyke viittaavat kuormituksen kumuloitumiseen."
- Käyttäjä nyökkää, sulkee appin. **Kesto: 15 sekuntia.**

**08:15 – Aamupala**
- Käyttäjä ottaa kuvan aamupalasta (puuroa, marjoja, kahvi)
- Appi tunnistaa: "puuroa, marjoja, kahvia"
- Aikaleima tallentuu. **Kesto: 5 sekuntia.**

**12:30 – Lounas**
- Kuva lounaasta (pasta, juusto, salaatti)
- Appi tunnistaa: "pasta, juusto, salaatti"
- Merkintä: "juusto – potentiaalinen triggeri seurannassa" (koska kypsytetty juusto on aiemmin havaittu korrelaatiossa)
- **Kesto: 5 sekuntia.**

**14:00 – Migreeni alkaa**
- Käyttäjä avaa appin → painaa "Migreeni alkoi" → valitsee intensiteetti 2 (kohtalainen)
- Appi tallentaa kohtauksen. **Kesto: 4 sekuntia.**

**17:30 – Migreeni helpottaa**
- Käyttäjä painaa "Migreeni ohi"
- Appi näyttää **jälkianalyysin**: 48h aikaikkunan
  - "Yön uni oli 2,3h lyhyempi kuin normaalisti"
  - "HRV oli 33% alle baseline-tasosi"
  - "Leposyke oli 17% yli normaalin"
  - "Kypsytettyä juustoa lounaalla (seurannassa oleva tekijä)"
  - Yhteenveto: "Useat kuormitustekijät olivat koholla. Lyhyt uni + matala HRV on aiemminkin edeltänyt kohtauksiasi."
- **Kesto: 30 sekuntia lukemiseen.**

**21:00 – Ilta**
- Päivän yhteenveto näkyy
- Valinnainen kysymys: "Oliko tänään jotain poikkeavaa?" → ei mitään erityistä
- **Kesto: 10 sekuntia.**

**Päivän kokonaisinteraktio: ~70 sekuntia aktiivista käyttöä.**

## E. Käyttöliittymän pääruudut

### Ruutu 1: Dashboard

```
┌─────────────────────────────┐
│  HealthHub          ⚙️      │
│                              │
│  ┌──────────────────────┐   │
│  │    🟡 KOHONNUT RISKI  │   │
│  │  "Palautuminen vajaa" │   │
│  └──────────────────────┘   │
│                              │
│  Uni          5,5h    ↓     │
│  HRV          28ms    ↓↓    │
│  Leposyke     68bpm   ↑     │
│  Readiness    58      ↓     │
│                              │
│  ┌──────────────────────┐   │
│  │ 💡 Harkitse kevyempää │   │
│  │    päivää tänään      │   │
│  └──────────────────────┘   │
│                              │
│  14 pv edellisestä          │
│  kohtauksesta               │
│                              │
│  ─── ─── ─── ─── ─── ───   │
│  📊   📸   ⚡   📋   📈    │
│ Koti Ruoka Oire Viikko Trend│
└─────────────────────────────┘
```

### Ruutu 2: Oirekirjaus

```
┌─────────────────────────────┐
│  ← Oirekirjaus              │
│                              │
│                              │
│                              │
│  ┌──────────────────────┐   │
│  │                      │   │
│  │   🔴 MIGREENI ALKOI   │   │
│  │                      │   │
│  │   (paina nappia)     │   │
│  │                      │   │
│  └──────────────────────┘   │
│                              │
│  Tai merkitse mennyt:       │
│  [Eilen] [Toissapäivänä]   │
│                              │
│                              │
│                              │
│  ─── ─── ─── ─── ─── ───   │
└─────────────────────────────┘
```

### Ruutu 3: Ruokakuva

```
┌─────────────────────────────┐
│  ← Ruokakirjaus             │
│                              │
│  ┌──────────────────────┐   │
│  │                      │   │
│  │   [Kameranäkymä]     │   │
│  │                      │   │
│  │        📷            │   │
│  │                      │   │
│  └──────────────────────┘   │
│                              │
│  Viimeisin:                 │
│  12:30 – pasta, juusto,     │
│          salaatti            │
│  ⚠️ juusto (seurannassa)    │
│                              │
│  08:15 – puuroa, marjoja,   │
│          kahvia              │
│                              │
│  ─── ─── ─── ─── ─── ───   │
└─────────────────────────────┘
```

### Ruutu 4: Migreenihypoteesit (V2)

```
┌─────────────────────────────┐
│  ← Hypoteesit               │
│                              │
│  VAHVISTUNEET                │
│  ┌──────────────────────┐   │
│  │ 🔴 Lyhyt uni (<6h)    │   │
│  │ 8/12 kohtausta edels. │   │
│  │ vs 5/45 muina öinä    │   │
│  │ Luottamus: Vahva      │   │
│  └──────────────────────┘   │
│                              │
│  SEURANNASSA                │
│  ┌──────────────────────┐   │
│  │ 🟡 Kypsytetty juusto  │   │
│  │ 4/12 kohtausta edels. │   │
│  │ Dataa kerätään...     │   │
│  └──────────────────────┘   │
│                              │
│  EI NÄYTTÖÄ                 │
│  ┌──────────────────────┐   │
│  │ ✅ Suklaa             │   │
│  │ Ei korrelaatiota      │   │
│  │ (3kk dataa)           │   │
│  └──────────────────────┘   │
│                              │
│  ─── ─── ─── ─── ─── ───   │
└─────────────────────────────┘
```

## F. 30 päivän MVP-rakennussuunnitelma

### Viikko 0 (ennen koodausta): Validointi
- [ ] 1 viikon manuaalinen testijakso (Oura + Apple Health + muistiinpanot + ruokakuvat)
- [ ] Arvioi: onko kirjaaminen realistista?
- [ ] Go/no-go -päätös

### Viikko 1: Perusta
- [ ] Xcode-projekti, SwiftUI-pohja, navigaatiorakenne
- [ ] Core Data -skeema (HealthMetric, MigraineEvent, MealEntry)
- [ ] HealthKit-integraatio: HRV, leposyke, unen kesto lukeminen
- [ ] Baseline-laskenta (14pv liukuva mediaani)

### Viikko 2: Oura + riskiarvio
- [ ] Oura OAuth 2.0 -autentikointi
- [ ] Oura API: sleep, readiness, HRV (yön ka.)
- [ ] Sääntöpohjainen riskiarvio-logiikka
- [ ] Dashboard-näkymä (riskimittari + avainluvut)

### Viikko 3: Kirjaukset
- [ ] Migreenikirjaus-UI (2 napautusta)
- [ ] Ruokakuva: kuvan ottaminen + tallennus
- [ ] Vision API -integraatio ruoka-aineiden tunnistamiseen
- [ ] Migreenin jälkianalyysi (48h aikaikkunan visualisointi)

### Viikko 4: Koosteet + viimeistely
- [ ] Viikkokooste-näkymä
- [ ] Iltakysymys (valinnainen kontekstimerkintä)
- [ ] Notifikaatiot (kohonneen riskin päivänä, max 1/pv)
- [ ] Testaus, bugifixaus, UI-viimeistely
- [ ] TestFlight-jakelu itseille testaukseen

## G. Esimerkki: Miten appi tunnistaisi mahdollisen migreenitriggerin

### Skenario: Kypsytetyn juuston yhteys migreeniin

**Datankeruu (kuukaudet 1–3):**

Käyttäjä käyttää appia 3 kuukautta. Tänä aikana:
- 14 migreenikohtausta kirjattu
- ~180 ruokakuvaa otettu (n. 2/päivä)
- HRV, uni ja leposyke päivittäin automaattisesti

**Hypoteesimoottorin analyysi (V2, aktivoituu 10+ kohtauksen jälkeen):**

Appi käy läpi jokaisen migreenikohtauksen ja tutkii 12–48h aikaikkunan ennen kohtausta.

```
Tekijä: Kypsytetty juusto (tunnistettu ruokakuvista)

Esiintyminen migreeniä edeltävinä päivinä:
  - 6 / 14 kohtausta (43%)

Esiintyminen ei-migreenipäivinä:
  - 8 / 76 päivää (11%)

Suhteellinen riski: 43% / 11% = 3.9x

Fisherin eksaktitesti:
  p-arvo = 0.007

Bayesilainen priori:
  Kypsytetty juusto on tunnettu potentiaalinen triggeri (tyramiini)
  → Priori: kohtuullinen (0.3)
  → Posteriori datan jälkeen: korkea (0.82)
```

**Päätös: Uskottava hypoteesi** (p < 0.1, tunnettu mekanismi, riittävä data)

**Mitä käyttäjä näkee:**

> **Havainto: Kypsytetty juusto ja migreeniriski**
>
> Kypsytetty juusto on esiintynyt aterioissasi 6/14 migreeniä edeltävänä päivänä (43%), verrattuna 8/76 muuhun päivään (11%).
>
> Tämä on tilastollisesti merkitsevä ero ja kypsytetty juusto on tunnettu potentiaalinen migreenitriggeri (sisältää tyramiinia).
>
> **Tämä ei tarkoita, että juusto varmasti aiheuttaa migreeniäsi.** Muut tekijät (kuten uni ja stressi) vaikuttavat samanaikaisesti. Mutta datasi perusteella kypsytettyä juustoa kannattaa seurata tarkemmin.
>
> **Ehdotus:** Kokeile 4 viikon jaksoa, jossa vältät kypsytettyä juustoa, ja seurataan muuttuuko kuvio.

**Mitä tapahtuu seuraavaksi:**

1. Jos käyttäjä kokeilee 4 viikon juustotonta jaksoa ja migreenikohtaukset vähenevät → hypoteesi vahvistuu
2. Jos kohtaukset eivät vähene → hypoteesi heikentyy, appi päivittää arvionsa
3. Kummassakin tapauksessa käyttäjä on saanut konkreettista, datapohjaista tietoa omasta tilanteestaan

**Miksi tämä on parempi kuin geneerinen neuvo "vältä juustoa":**
- Perustuu käyttäjän omaan dataan, ei yleistykseen
- Kertoo tarkan lukumäärän ja suhteellisen riskin
- Kommunikoi epävarmuuden
- Ehdottaa validoivaa testiä
- Päivittyy uuden datan myötä

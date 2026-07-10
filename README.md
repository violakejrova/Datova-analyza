# Analýza dat z útulku Austin Animal Center

Tento projekt se zabývá analýzou historických dat o příjmech a odchodech zvířat v texaském útulku Austin Animal Center. Cílem je analyzovat trendy, vyčistit anomálie v datech a vizualizovat klíčové ukazatele pro vedení útulku.

## Struktura projektu

* `data/` – vyexportované CSV/TXT tabulky ze SQL dotazů sloužící jako podklady pro Power BI
* `sql/` – skripty s čistými SQL dotazy z pgAdminu
* `powerbi/` – výsledný .pbix soubor s interaktivním reportem
* `grafy/` – složka s výslednými vizualizacemi a screenshoty z reportu
* `README.md` – dokumentace k projektu

---

## Datový přehled a logika datasetu

Před samotnou analýzou jsem ověřila konzistenci dat mezi tabulkami příjmů (`intakes`) a odchodů (`outcomes`).

* **Celkový počet příjmů:** 124 120 záznamů
* **Celkový počet odchodů:** 124 491 záznamů

Počet odchodů je mírně vyšší než počet příjmů. Tento jev pravděpodobně souvisí se zvířaty, která v útulku fyzicky žila ještě před spuštěním databázového systému.

---

## 1. Analýza příjmů zvířat (Intake)

V této části projektu jsem se zaměřila na to, co se v útulku děje při příjmu zvířat, jaká data chybí a jaká specifika má Texas.

### Chybějící data a jejich logika

V datech je velká skupina zvířat, která nemají jméno ani určené pohlaví (v databázi jako NULL nebo „Unknown“). Analýza ukázala, že to má jasné důvody:

* **Divoká zvěř (kategorie Other):** Přes 97 % těchto zvířat nemá jméno ani pohlaví. U netopýrů nebo mývalů to ošetřovatelé zkrátka nezjišťují.
* **Zdravotní stav:** Zvířata bez jména a pohlaví často přicházejí zraněná (Injured) nebo nemocná (Sick). Jde o urgentní příjmy z ulice, kde se prioritně řeší záchrana života, nikoliv papírování.

### Čištění dat (Breed)

U divokých (Other) a hospodářských zvířat (Livestock) byl v datech nepořádek způsobený softwarem útulku, který je určený hlavně pro psy a kočky. Duplikovaly se tam čisté názvy s přívlastkem „Mix“ (např. Bat vs. Bat Mix, Pig vs. Pig Mix).

Pomocí SQL funkce `TRIM(REPLACE(breed, ' Mix', ''))` jsem tyto duplicity vyčistila. U kategorie Other se tím počet skupin snížil ze 120 na 76, což umožnilo vytvořit přehledné grafy v Power BI.

---

### Použité SQL dotazy a zjištění

Všechny skripty jsem spouštěla v pgAdminu a vyčištěné výsledky uložila pro Power BI.

#### Zvířata bez jména – absolutní počty

Dotaz zjišťuje, kolik zvířat bez jména je v jednotlivých kategoriích a v jakém zdravotním stavu při příjmu přišla.

```sql
SELECT animal_type, intake_condition, COUNT(*) AS count_no_name
FROM intakes 
WHERE name IS NULL OR LOWER(name) = 'unknown' 
GROUP BY animal_type, intake_condition
ORDER BY animal_type;
```

#### Podíl zvířat bez jména podle druhů

Tento dotaz počítá procento zvířat bez jména v jednotlivých kategoriích.

```sql
SELECT 
    animal_type,
    ROUND(
        100.0 * COUNT(CASE WHEN name IS NULL THEN 1 END) / COUNT(*), 
        2
    ) AS procento_bez_jmena
FROM intakes
GROUP BY animal_type
ORDER BY animal_type;
```

#### Neznámé pohlaví – celkově

Přehled všech hodnot ve sloupci `sex_upon_intake`.

```sql
SELECT sex_upon_intake, COUNT(*)
FROM intakes 
GROUP BY sex_upon_intake;
```

#### Neznámé pohlaví podle druhu zvířete

```sql
SELECT animal_type, COUNT(animal_type)
FROM intakes 
WHERE sex_upon_intake IS NULL 
   OR LOWER(sex_upon_intake) = 'unknown'
   OR LOWER(sex_upon_intake) = 'null'
GROUP BY animal_type;
```

#### Neznámé pohlaví i jméno podle druhu a zdravotního stavu

Kombinace obou podmínek ukazuje, u kterých kategorií a zdravotních stavů se chybějící údaje překrývají nejčastěji.

```sql
SELECT animal_type, intake_condition, COUNT(intake_condition)
FROM intakes
WHERE (sex_upon_intake IS NULL 
   OR LOWER(sex_upon_intake) = 'unknown') 
   AND (name IS NULL OR LOWER(name) = 'unknown')
GROUP BY intake_condition, animal_type;
```

#### Co se skrývá v kategorii Other

Dotaz zároveň čistí duplicity v názvech plemen/druhů odstraněním přípony „Mix“.

```sql
SELECT 
    TRIM(REPLACE(breed, ' Mix', '')) AS druh, COUNT(*) AS pocet
FROM intakes
WHERE animal_type = 'Other'
GROUP BY TRIM(REPLACE(breed, ' Mix', ''))
ORDER BY pocet DESC;
```

#### Co se skrývá v kategorii Livestock

Stejná logika čištění aplikovaná na hospodářská zvířata.

```sql
SELECT 
    TRIM(REPLACE(breed, ' Mix', '')) AS druh, 
    COUNT(*) AS pocet
FROM intakes
WHERE animal_type = 'Livestock'
GROUP BY TRIM(REPLACE(breed, ' Mix', ''))
ORDER BY pocet DESC;
```

#### Zdravotní stav hospodářských zvířat podle druhu

```sql
SELECT intake_condition, TRIM(REPLACE(breed, ' Mix', '')) AS druh, COUNT(breed)
FROM intakes
WHERE animal_type = 'Livestock'
GROUP BY TRIM(REPLACE(breed, ' Mix', '')), intake_condition
ORDER BY COUNT(breed) DESC;
```

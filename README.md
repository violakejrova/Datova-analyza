# Analýza dat z útulku Austin Animal Center

Tento projekt se zabývá analýzou historických dat o příjmech a odchodech zvířat v texaském útulku Austin Animal Center. Cílem projektu je datová analýza trendů, čištění anomálií a vizualizace klíčových ukazatelů pro vedení útulku.

## Struktura projektu
* `grafy/` - složka obsahující výsledné vizualizace (Power BI report, PDF export a datové podklady)
* `README.md` - dokumentace k projektu

---

## Datový přehled a logika datasetu

Před samotnou analýzou byla ověřena konzistence dat mezi tabulkami příjmů (`intakes`) a odchodů (`outcomes`). 

* **Celkový počet příjmů:** 124 120 záznamů
* **Celkový počet odchodů:** 124 491 záznamů

*Počet odchodů je mírně vyšší než počet příjmů. Tento jev pravděpodobně ukazuje na zvířata, která v útulku fyzicky žila ještě před spuštěním databázového systému.*

---

## Analýza "No Name" zvířat (Nalezení bezjmenní tvorové)

První část projektu se zaměřila na zvířata, která byla do útulku přijata bez jména (v databázi vedená jako `NULL` nebo pod obecným označením `'Unknown'`). Zjišťovala jsem, které druhy zvířat tvoří největší podíl této skupiny.

Data byla agregována pomocí následujícího SQL dotazu:

```sql
SELECT 
    animal_type, 
    COUNT(*) AS count_no_name
FROM intakes
WHERE name IS NULL 
   OR LOWER(name) = 'unknown'
GROUP BY animal_type
ORDER BY count_no_name DESC;
```

---
 [dataset](https://www.kaggle.com/datasets/jackdaoud/animal-shelter-analytics)


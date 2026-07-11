SELECT * FROM outcomes
LIMIT 20;

-- jak odešli
SELECT animal_type, outcome_type, COUNT(outcome_type)
FROM outcomes
WHERE outcome_type IS NOT NULL
GROUP BY animal_type, outcome_type
ORDER BY COUNT(outcome_type) DESC;
-- nejvíc eutanázie
SELECT animal_type, count(animal_type)
FROM outcomes
WHERE outcome_type = 'Euthanasia'
GROUP BY animal_type
ORDER BY COUNT(animal_type) DESC;

-- nejvíc eutanázie u other a livestock
SELECT breed, COUNT(breed)
FROM outcomes
WHERE outcome_type = 'Euthanasia' AND (animal_type = 'Other' OR animal_type = 'Livestock')
GROUP BY breed
ORDER BY COUNT(breed) DESC;

-- duplicity v id?
SELECT *
FROM outcomes
WHERE animal_id IN (
    SELECT animal_id
	FROM outcomes
    GROUP BY animal_id
    HAVING COUNT(*) > 1
)
ORDER BY animal_id, datetime
LIMIT 7;

-- kolik jednotlivců tam bylo opakovaně?
SELECT 
    animal_id, 
    name, 
    animal_type, 
    COUNT(animal_id) AS pocet_odchodu
FROM outcomes
GROUP BY 
    animal_id, 
    name, 
    animal_type
HAVING COUNT(animal_id) > 1 
ORDER BY pocet_odchodu DESC;
-- informace o max
SELECT * FROM outcomes WHERE animal_id = 'A721033';
SELECT * FROM intakes WHERE animal_id = 'A721033';
-- kdo se nejvíc vracel (druh)
SELECT 
    animal_type,
    COUNT(DISTINCT animal_id) AS pocet_unikatnich_recidivistu,
    SUM(pocet_navstev) AS celkovy_pocet_vsech_jejich_navratu
FROM (
    SELECT 
        animal_id, 
        animal_type, 
        COUNT(*) AS pocet_navstev
    FROM intakes
    GROUP BY animal_id, animal_type
    HAVING COUNT(*) > 1
) AS subquery
GROUP BY animal_type
ORDER BY celkovy_pocet_vsech_jejich_navratu DESC;

-- proč zemřeli/byli usmrceni?
SELECT
	animal_type, outcome_type, outcome_subtype,
	COUNT(*) as pocet_pripadu
FROM outcomes
WHERE (outcome_type IN('Euthanasia')) AND outcome_subtype IS NOT NULL
GROUP BY animal_type, outcome_type, outcome_subtype
ORDER BY animal_type, pocet_pripadu DESC;
-- kdy nejvíc odhází
SELECT 
    EXTRACT(MONTH FROM datetime) AS mesic,
    COUNT(*) AS pocet_odchodu,
	animal_type
FROM outcomes
GROUP BY mesic, animal_type
ORDER BY mesic, pocet_odchodu DESC;

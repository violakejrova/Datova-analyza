-- noname animals absolute
SELECT animal_type, intake_condition,  COUNT(*) AS count_no_name
FROM intakes 
WHERE name IS NULL OR LOWER(name) = 'unknown' 
GROUP BY animal_type, intake_condition
ORDER BY animal_type
;

-- noname animals percent
SELECT 
    animal_type,
    ROUND(
        100.0 * COUNT(CASE WHEN name IS NULL THEN 1 END) / COUNT(*), 
        2
    ) AS procento_bez_jmena
FROM intakes
GROUP BY animal_type
ORDER BY animal_type;

-- unknown sex
SELECT sex_upon_intake, count(*)
FROM intakes 
GROUP BY sex_upon_intake
;
-- unknown sex by animal type
SELECT animal_type,count(animal_type)
FROM intakes 
WHERE sex_upon_intake IS NULL 
   OR LOWER(sex_upon_intake) = 'unknown'
   OR LOWER(sex_upon_intake) = 'null'
GROUP BY animal_type;

-- unknown sex and name by animal type and condition
SELECT animal_type, intake_condition, COUNT(intake_condition)
FROM intakes
WHERE (sex_upon_intake IS NULL 
   OR LOWER(sex_upon_intake) = 'unknown') 
   AND (name IS NULL OR LOWER(name) = 'unknown')
GROUP BY intake_condition, animal_type
;

-- who is type Other? 
SELECT 
TRIM(REPLACE(breed, ' Mix', '')) AS druh, COUNT(*) AS pocet
FROM intakes
WHERE animal_type = 'Other'
GROUP BY TRIM(REPLACE(breed, ' Mix', ''))
ORDER BY pocet DESC;

-- who is livestock? + clean 
SELECT 
    TRIM(REPLACE(breed, ' Mix', '')) AS druh, 
    COUNT(*) AS pocet
FROM intakes
WHERE animal_type = 'Livestock'
GROUP BY TRIM(REPLACE(breed, ' Mix', ''))
ORDER BY pocet DESC;
-- vymazat duplikáty typu racoon a racoon mix
UPDATE intakes
SET breed = REPLACE(REPLACE(breed, ' Mix', ''), ' mix', '')
WHERE animal_type IN ('Other', 'Livestock') 
  AND (breed ILIKE '% mix');

UPDATE outcomes
SET breed = REPLACE(REPLACE(breed, ' Mix', ''), ' mix', '')
WHERE animal_type IN ('Other', 'Livestock') 
  AND (breed ILIKE '% mix');

-- datum
ALTER TABLE outcomes 
ALTER COLUMN datetime TYPE TIMESTAMP 
USING TO_TIMESTAMP(datetime, 'MM/DD/YYYY HH12:MI:SS AM');

ALTER TABLE intakes 
ALTER COLUMN datetime TYPE TIMESTAMP 
USING TO_TIMESTAMP(datetime, 'MM/DD/YYYY HH12:MI:SS AM');
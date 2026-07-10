CREATE TABLE intakes (
    animal_id VARCHAR(64),
    name VARCHAR(128),
    datetime VARCHAR(128),
    monthyear VARCHAR(64),
    found_location VARCHAR(256),
    intake_type VARCHAR(128),
    intake_condition VARCHAR(128), 
    animal_type VARCHAR(64),
    sex_upon_intake VARCHAR(64),
    age_upon_intake VARCHAR(64),
    breed VARCHAR(128),
    color VARCHAR(128)
);

CREATE TABLE outcomes (
    animal_id VARCHAR(64),
    name VARCHAR(128),
    datetime VARCHAR(128),
    monthyear VARCHAR(64),
    date_of_birth VARCHAR(128),
    outcome_type VARCHAR(128),
    outcome_subtype VARCHAR(128),
    animal_type VARCHAR(64),
    sex_upon_outcome VARCHAR(64),
    age_upon_outcome VARCHAR(64),
    breed VARCHAR(128),
    color VARCHAR(128)
);
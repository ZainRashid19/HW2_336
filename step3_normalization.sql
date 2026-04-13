
ALTER TABLE Application RENAME TO Application_Step2;


CREATE TABLE Location (
    location_id SERIAL PRIMARY KEY,
    county_code TEXT,
    msamd TEXT,
    state_code TEXT,
    census_tract_number TEXT,
    population TEXT,
    minority_population TEXT,
    hud_median_family_income TEXT,
    tract_to_msamd_income TEXT,
    number_of_owner_occupied_units TEXT,
    number_of_1_to_4_family_units TEXT
);

INSERT INTO Location (
    county_code,
    msamd,
    state_code,
    census_tract_number,
    population,
    minority_population,
    hud_median_family_income,
    tract_to_msamd_income,
    number_of_owner_occupied_units,
    number_of_1_to_4_family_units
)
SELECT DISTINCT
    NULLIF(TRIM(county_code), ''),
    NULLIF(TRIM(msamd), ''),
    NULLIF(TRIM(state_code), ''),
    NULLIF(TRIM(census_tract_number), ''),
    NULLIF(TRIM(population), ''),
    NULLIF(TRIM(minority_population), ''),
    NULLIF(TRIM(hud_median_family_income), ''),
    NULLIF(TRIM(tract_to_msamd_income), ''),
    NULLIF(TRIM(number_of_owner_occupied_units), ''),
    NULLIF(TRIM(number_of_1_to_4_family_units), '')
FROM Preliminary;


CREATE TABLE Application (
    ID BIGINT PRIMARY KEY,
    as_of_year INT,
    respondent_id TEXT,
    agency_code INT,
    loan_type INT,
    property_type INT,
    loan_purpose INT,
    owner_occupancy INT,
    loan_amount_000s INT,
    preapproval INT,
    action_taken INT,
    applicant_ethnicity INT,
    co_applicant_ethnicity INT,
    applicant_sex INT,
    co_applicant_sex INT,
    applicant_income_000s INT,
    purchaser_type INT,
    rate_spread TEXT,
    hoepa_status INT,
    lien_status INT,
    sequence_number INT,
    application_date_indicator INT,
    location_id INT REFERENCES Location(location_id)
);

INSERT INTO Application (
    ID,
    as_of_year,
    respondent_id,
    agency_code,
    loan_type,
    property_type,
    loan_purpose,
    owner_occupancy,
    loan_amount_000s,
    preapproval,
    action_taken,
    applicant_ethnicity,
    co_applicant_ethnicity,
    applicant_sex,
    co_applicant_sex,
    applicant_income_000s,
    purchaser_type,
    rate_spread,
    hoepa_status,
    lien_status,
    sequence_number,
    application_date_indicator,
    location_id
)
SELECT
    p.ID,
    NULLIF(TRIM(p.as_of_year), '')::INT,
    NULLIF(TRIM(p.respondent_id), ''),
    NULLIF(TRIM(p.agency_code), '')::INT,
    NULLIF(TRIM(p.loan_type), '')::INT,
    NULLIF(TRIM(p.property_type), '')::INT,
    NULLIF(TRIM(p.loan_purpose), '')::INT,
    NULLIF(TRIM(p.owner_occupancy), '')::INT,
    NULLIF(TRIM(p.loan_amount_000s), '')::INT,
    NULLIF(TRIM(p.preapproval), '')::INT,
    NULLIF(TRIM(p.action_taken), '')::INT,
    NULLIF(TRIM(p.applicant_ethnicity), '')::INT,
    NULLIF(TRIM(p.co_applicant_ethnicity), '')::INT,
    NULLIF(TRIM(p.applicant_sex), '')::INT,
    NULLIF(TRIM(p.co_applicant_sex), '')::INT,
    NULLIF(TRIM(p.applicant_income_000s), '')::INT,
    NULLIF(TRIM(p.purchaser_type), '')::INT,
    NULLIF(TRIM(p.rate_spread), ''),
    NULLIF(TRIM(p.hoepa_status), '')::INT,
    NULLIF(TRIM(p.lien_status), '')::INT,
    NULLIF(TRIM(p.sequence_number), '')::INT,
    NULLIF(TRIM(p.application_date_indicator), '')::INT,
    l.location_id
FROM Preliminary p
JOIN Location l
  ON NULLIF(TRIM(p.county_code), '') IS NOT DISTINCT FROM l.county_code
 AND NULLIF(TRIM(p.msamd), '') IS NOT DISTINCT FROM l.msamd
 AND NULLIF(TRIM(p.state_code), '') IS NOT DISTINCT FROM l.state_code
 AND NULLIF(TRIM(p.census_tract_number), '') IS NOT DISTINCT FROM l.census_tract_number
 AND NULLIF(TRIM(p.population), '') IS NOT DISTINCT FROM l.population
 AND NULLIF(TRIM(p.minority_population), '') IS NOT DISTINCT FROM l.minority_population
 AND NULLIF(TRIM(p.hud_median_family_income), '') IS NOT DISTINCT FROM l.hud_median_family_income
 AND NULLIF(TRIM(p.tract_to_msamd_income), '') IS NOT DISTINCT FROM l.tract_to_msamd_income
 AND NULLIF(TRIM(p.number_of_owner_occupied_units), '') IS NOT DISTINCT FROM l.number_of_owner_occupied_units
 AND NULLIF(TRIM(p.number_of_1_to_4_family_units), '') IS NOT DISTINCT FROM l.number_of_1_to_4_family_units;

CREATE TABLE Applicant_Race (
    ID BIGINT,
    race INT,
    race_order INT,
    PRIMARY KEY (ID, race_order),
    FOREIGN KEY (ID) REFERENCES Application(ID)
);

INSERT INTO Applicant_Race
SELECT ID, NULLIF(TRIM(applicant_race_1), '')::INT, 1
FROM Preliminary
WHERE NULLIF(TRIM(applicant_race_1), '') IS NOT NULL;

INSERT INTO Applicant_Race
SELECT ID, NULLIF(TRIM(applicant_race_2), '')::INT, 2
FROM Preliminary
WHERE NULLIF(TRIM(applicant_race_2), '') IS NOT NULL;

INSERT INTO Applicant_Race
SELECT ID, NULLIF(TRIM(applicant_race_3), '')::INT, 3
FROM Preliminary
WHERE NULLIF(TRIM(applicant_race_3), '') IS NOT NULL;

INSERT INTO Applicant_Race
SELECT ID, NULLIF(TRIM(applicant_race_4), '')::INT, 4
FROM Preliminary
WHERE NULLIF(TRIM(applicant_race_4), '') IS NOT NULL;

INSERT INTO Applicant_Race
SELECT ID, NULLIF(TRIM(applicant_race_5), '')::INT, 5
FROM Preliminary
WHERE NULLIF(TRIM(applicant_race_5), '') IS NOT NULL;

CREATE TABLE CoApplicant_Race (
    ID BIGINT,
    race INT,
    race_order INT,
    PRIMARY KEY (ID, race_order),
    FOREIGN KEY (ID) REFERENCES Application(ID)
);

INSERT INTO CoApplicant_Race
SELECT ID, NULLIF(TRIM(co_applicant_race_1), '')::INT, 1
FROM Preliminary
WHERE NULLIF(TRIM(co_applicant_race_1), '') IS NOT NULL;

INSERT INTO CoApplicant_Race
SELECT ID, NULLIF(TRIM(co_applicant_race_2), '')::INT, 2
FROM Preliminary
WHERE NULLIF(TRIM(co_applicant_race_2), '') IS NOT NULL;

INSERT INTO CoApplicant_Race
SELECT ID, NULLIF(TRIM(co_applicant_race_3), '')::INT, 3
FROM Preliminary
WHERE NULLIF(TRIM(co_applicant_race_3), '') IS NOT NULL;

INSERT INTO CoApplicant_Race
SELECT ID, NULLIF(TRIM(co_applicant_race_4), '')::INT, 4
FROM Preliminary
WHERE NULLIF(TRIM(co_applicant_race_4), '') IS NOT NULL;

INSERT INTO CoApplicant_Race
SELECT ID, NULLIF(TRIM(co_applicant_race_5), '')::INT, 5
FROM Preliminary
WHERE NULLIF(TRIM(co_applicant_race_5), '') IS NOT NULL;

CREATE TABLE Denial_Reason (
    ID BIGINT,
    denial_reason INT,
    reason_order INT,
    PRIMARY KEY (ID, reason_order),
    FOREIGN KEY (ID) REFERENCES Application(ID)
);

INSERT INTO Denial_Reason
SELECT ID, NULLIF(TRIM(denial_reason_1), '')::INT, 1
FROM Preliminary
WHERE NULLIF(TRIM(denial_reason_1), '') IS NOT NULL;

INSERT INTO Denial_Reason
SELECT ID, NULLIF(TRIM(denial_reason_2), '')::INT, 2
FROM Preliminary
WHERE NULLIF(TRIM(denial_reason_2), '') IS NOT NULL;

INSERT INTO Denial_Reason
SELECT ID, NULLIF(TRIM(denial_reason_3), '')::INT, 3
FROM Preliminary
WHERE NULLIF(TRIM(denial_reason_3), '') IS NOT NULL;
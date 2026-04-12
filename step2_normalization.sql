CREATE TABLE Agency (
    agency_code INT PRIMARY KEY,
    agency_name TEXT NOT NULL,
    agency_abbr TEXT NOT NULL
);

CREATE TABLE Loan_Type (
    loan_type INT PRIMARY KEY,
    loan_type_name TEXT NOT NULL
);

CREATE TABLE Property_Type (
    property_type INT PRIMARY KEY,
    property_type_name TEXT NOT NULL
);

CREATE TABLE Loan_Purpose (
    loan_purpose INT PRIMARY KEY,
    loan_purpose_name TEXT NOT NULL
);

CREATE TABLE Owner_Occupancy (
    owner_occupancy INT PRIMARY KEY,
    owner_occupancy_name TEXT NOT NULL
);

CREATE TABLE Preapproval (
    preapproval INT PRIMARY KEY,
    preapproval_name TEXT NOT NULL
);

CREATE TABLE Action_Taken (
    action_taken INT PRIMARY KEY,
    action_taken_name TEXT NOT NULL
);

CREATE TABLE MSAMD (
    msamd INT PRIMARY KEY,
    msamd_name TEXT NOT NULL
);

CREATE TABLE State (
    state_code INT PRIMARY KEY,
    state_name TEXT NOT NULL,
    state_abbr TEXT NOT NULL
);

CREATE TABLE County (
    county_code INT PRIMARY KEY,
    county_name TEXT NOT NULL
);

CREATE TABLE Ethnicity (
    ethnicity_code INT PRIMARY KEY,
    ethnicity_name TEXT NOT NULL
);

CREATE TABLE Sex (
    sex_code INT PRIMARY KEY,
    sex_name TEXT NOT NULL
);

CREATE TABLE Purchaser_Type (
    purchaser_type INT PRIMARY KEY,
    purchaser_type_name TEXT NOT NULL
);

CREATE TABLE Hoepa_Status (
    hoepa_status INT PRIMARY KEY,
    hoepa_status_name TEXT NOT NULL
);

CREATE TABLE Lien_Status (
    lien_status INT PRIMARY KEY,
    lien_status_name TEXT NOT NULL
);

CREATE TABLE Edit_Status_Placeholder (
    edit_status_id INT PRIMARY KEY,
    edit_status_name TEXT,
    edit_status INT
);


CREATE TABLE Application (
    ID BIGINT PRIMARY KEY, -- Inherited from Project 0 [cite: 14, 15]
    as_of_year INT,
    respondent_id TEXT, 
    agency_code INT REFERENCES Agency(agency_code),
    loan_type INT REFERENCES Loan_Type(loan_type),
    property_type INT REFERENCES Property_Type(property_type),
    loan_purpose INT REFERENCES Loan_Purpose(loan_purpose),
    owner_occupancy INT REFERENCES Owner_Occupancy(owner_occupancy),
    loan_amount_000s INT,
    preapproval INT REFERENCES Preapproval(preapproval),
    action_taken INT REFERENCES Action_Taken(action_taken),
    msamd INT REFERENCES MSAMD(msamd),
    state_code INT REFERENCES State(state_code),
    county_code INT REFERENCES County(county_code),
    census_tract_number NUMERIC,
    applicant_ethnicity INT REFERENCES Ethnicity(ethnicity_code),
    co_applicant_ethnicity INT REFERENCES Ethnicity(ethnicity_code),
    applicant_sex INT REFERENCES Sex(sex_code),
    co_applicant_sex INT REFERENCES Sex(sex_code),
    applicant_income_000s INT,
    purchaser_type INT REFERENCES Purchaser_Type(purchaser_type),
    rate_spread NUMERIC,
    hoepa_status INT REFERENCES Hoepa_Status(hoepa_status),
    lien_status INT REFERENCES Lien_Status(lien_status),
    sequence_number INT,
    population INT,
    minority_population NUMERIC,
    hud_median_family_income INT,
    tract_to_msamd_income NUMERIC,
    number_of_owner_occupied_units INT,
    number_of_1_to_4_family_units INT,
    application_date_indicator INT
);


INSERT INTO Agency SELECT DISTINCT NULLIF(agency_code, '')::INT, agency_name, agency_abbr FROM Preliminary WHERE agency_code <> '';
INSERT INTO Loan_Type SELECT DISTINCT NULLIF(loan_type, '')::INT, loan_type_name FROM Preliminary WHERE loan_type <> '';
INSERT INTO Property_Type SELECT DISTINCT NULLIF(property_type, '')::INT, property_type_name FROM Preliminary WHERE property_type <> '';
INSERT INTO Loan_Purpose SELECT DISTINCT NULLIF(loan_purpose, '')::INT, loan_purpose_name FROM Preliminary WHERE loan_purpose <> '';
INSERT INTO Owner_Occupancy SELECT DISTINCT NULLIF(owner_occupancy, '')::INT, owner_occupancy_name FROM Preliminary WHERE owner_occupancy <> '';
INSERT INTO Preapproval SELECT DISTINCT NULLIF(preapproval, '')::INT, preapproval_name FROM Preliminary WHERE preapproval <> '';
INSERT INTO Action_Taken SELECT DISTINCT NULLIF(action_taken, '')::INT, action_taken_name FROM Preliminary WHERE action_taken <> '';
INSERT INTO MSAMD SELECT DISTINCT NULLIF(msamd, '')::INT, msamd_name FROM Preliminary WHERE msamd <> '';
INSERT INTO State SELECT DISTINCT NULLIF(state_code, '')::INT, state_name, state_abbr FROM Preliminary WHERE state_code <> '';
INSERT INTO County SELECT DISTINCT NULLIF(county_code, '')::INT, county_name FROM Preliminary WHERE county_code <> '';
INSERT INTO Ethnicity (ethnicity_code, ethnicity_name) SELECT DISTINCT NULLIF(applicant_ethnicity, '')::INT, applicant_ethnicity_name  FROM Preliminary WHERE applicant_ethnicity <> '' UNION SELECT DISTINCT NULLIF(co_applicant_ethnicity, '')::INT, co_applicant_ethnicity_name  FROM Preliminary WHERE co_applicant_ethnicity <> '';
INSERT INTO Sex (sex_code, sex_name) SELECT DISTINCT NULLIF(applicant_sex, '')::INT, applicant_sex_name FROM Preliminary WHERE applicant_sex <> '' UNION SELECT DISTINCT NULLIF(co_applicant_sex, '')::INT, co_applicant_sex_name  FROM Preliminary WHERE co_applicant_sex <> '';
INSERT INTO Purchaser_Type SELECT DISTINCT NULLIF(purchaser_type, '')::INT, purchaser_type_name FROM Preliminary WHERE purchaser_type <> '';
INSERT INTO Hoepa_Status SELECT DISTINCT NULLIF(hoepa_status, '')::INT, hoepa_status_name FROM Preliminary WHERE hoepa_status <> '';
INSERT INTO Lien_Status SELECT DISTINCT NULLIF(lien_status, '')::INT, lien_status_name FROM Preliminary WHERE lien_status <> '';


INSERT INTO Application (
    ID, as_of_year, respondent_id, agency_code, loan_type, property_type, 
    loan_purpose, owner_occupancy, loan_amount_000s, preapproval, 
    action_taken, msamd, state_code, county_code, census_tract_number, 
    applicant_ethnicity, co_applicant_ethnicity, applicant_sex, 
    co_applicant_sex, applicant_income_000s, purchaser_type, rate_spread, 
    hoepa_status, lien_status, sequence_number, population, 
    minority_population, hud_median_family_income, tract_to_msamd_income, 
    number_of_owner_occupied_units, number_of_1_to_4_family_units, 
    application_date_indicator
)
SELECT 
    ID,
    NULLIF(as_of_year, '')::INT,
    NULLIF(respondent_id, ''),
    NULLIF(agency_code, '')::INT,
    NULLIF(loan_type, '')::INT,
    NULLIF(property_type, '')::INT,
    NULLIF(loan_purpose, '')::INT,
    NULLIF(owner_occupancy, '')::INT,
    NULLIF(loan_amount_000s, '')::INT,
    NULLIF(preapproval, '')::INT,
    NULLIF(action_taken, '')::INT,
    NULLIF(msamd, '')::INT,
    NULLIF(state_code, '')::INT,
    NULLIF(county_code, '')::INT,
    NULLIF(census_tract_number, '')::NUMERIC,
    NULLIF(applicant_ethnicity, '')::INT,
    NULLIF(co_applicant_ethnicity, '')::INT,
    NULLIF(applicant_sex, '')::INT,
    NULLIF(co_applicant_sex, '')::INT,
    NULLIF(applicant_income_000s, '')::INT,
    NULLIF(purchaser_type, '')::INT,
    NULLIF(rate_spread, '')::NUMERIC,
    NULLIF(hoepa_status, '')::INT,
    NULLIF(lien_status, '')::INT,
    NULLIF(sequence_number, '')::INT,
    NULLIF(population, '')::INT,
    NULLIF(minority_population, '')::NUMERIC,
    NULLIF(hud_median_family_income, '')::INT,
    NULLIF(tract_to_msamd_income, '')::NUMERIC,
    NULLIF(number_of_owner_occupied_units, '')::INT,
    NULLIF(number_of_1_to_4_family_units, '')::INT,
    NULLIF(application_date_indicator, '')::INT
FROM Preliminary;

-- handle edit status
INSERT INTO Edit_Status_Placeholder (edit_status_id, edit_status_name, edit_status)
VALUES (1, NULL, NULL);
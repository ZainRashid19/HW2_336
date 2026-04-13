
ALTER TABLE Application
ADD CONSTRAINT fk_app_agency FOREIGN KEY (agency_code) REFERENCES Agency(agency_code);

ALTER TABLE Application
ADD CONSTRAINT fk_app_loan_type FOREIGN KEY (loan_type) REFERENCES Loan_Type(loan_type);

ALTER TABLE Application
ADD CONSTRAINT fk_app_property_type FOREIGN KEY (property_type) REFERENCES Property_Type(property_type);

ALTER TABLE Application
ADD CONSTRAINT fk_app_loan_purpose FOREIGN KEY (loan_purpose) REFERENCES Loan_Purpose(loan_purpose);

ALTER TABLE Application
ADD CONSTRAINT fk_app_owner_occupancy FOREIGN KEY (owner_occupancy) REFERENCES Owner_Occupancy(owner_occupancy);

ALTER TABLE Application
ADD CONSTRAINT fk_app_preapproval FOREIGN KEY (preapproval) REFERENCES Preapproval(preapproval);

ALTER TABLE Application
ADD CONSTRAINT fk_app_action_taken FOREIGN KEY (action_taken) REFERENCES Action_Taken(action_taken);

ALTER TABLE Application
ADD CONSTRAINT fk_app_ethnicity FOREIGN KEY (applicant_ethnicity) REFERENCES Ethnicity(ethnicity_code);

ALTER TABLE Application
ADD CONSTRAINT fk_coapp_ethnicity FOREIGN KEY (co_applicant_ethnicity) REFERENCES Ethnicity(ethnicity_code);

ALTER TABLE Application
ADD CONSTRAINT fk_app_sex FOREIGN KEY (applicant_sex) REFERENCES Sex(sex_code);

ALTER TABLE Application
ADD CONSTRAINT fk_coapp_sex FOREIGN KEY (co_applicant_sex) REFERENCES Sex(sex_code);

ALTER TABLE Application
ADD CONSTRAINT fk_app_purchaser FOREIGN KEY (purchaser_type) REFERENCES Purchaser_Type(purchaser_type);

ALTER TABLE Application
ADD CONSTRAINT fk_app_hoepa FOREIGN KEY (hoepa_status) REFERENCES Hoepa_Status(hoepa_status);

ALTER TABLE Application
ADD CONSTRAINT fk_app_lien FOREIGN KEY (lien_status) REFERENCES Lien_Status(lien_status);


ALTER TABLE Application ALTER COLUMN as_of_year SET NOT NULL;
ALTER TABLE Application ALTER COLUMN agency_code SET NOT NULL;
ALTER TABLE Application ALTER COLUMN loan_type SET NOT NULL;
ALTER TABLE Application ALTER COLUMN property_type SET NOT NULL;
ALTER TABLE Application ALTER COLUMN loan_purpose SET NOT NULL;
ALTER TABLE Application ALTER COLUMN owner_occupancy SET NOT NULL;
ALTER TABLE Application ALTER COLUMN action_taken SET NOT NULL;
ALTER TABLE Application ALTER COLUMN location_id SET NOT NULL;


ALTER TABLE Application
ADD CONSTRAINT chk_loan_amount CHECK (loan_amount_000s IS NULL OR loan_amount_000s >= 0);

ALTER TABLE Application
ADD CONSTRAINT chk_income CHECK (applicant_income_000s IS NULL OR applicant_income_000s >= 0);

ALTER TABLE Applicant_Race
ADD CONSTRAINT chk_app_race_order CHECK (race_order BETWEEN 1 AND 5);

ALTER TABLE CoApplicant_Race
ADD CONSTRAINT chk_coapp_race_order CHECK (race_order BETWEEN 1 AND 5);

ALTER TABLE Denial_Reason
ADD CONSTRAINT chk_denial_order CHECK (reason_order BETWEEN 1 AND 3);

\copy (SELECT a.as_of_year, a.respondent_id, ag.agency_name, ag.agency_abbr, a.agency_code, lt.loan_type_name, a.loan_type, pt.property_type_name, a.property_type, lp.loan_purpose_name, a.loan_purpose, oo.owner_occupancy_name, a.owner_occupancy, a.loan_amount_000s, pa.preapproval_name, a.preapproval, at.action_taken_name, a.action_taken, m.msamd_name, l.msamd, st.state_name, st.state_abbr, l.state_code, c.county_name, l.county_code, l.census_tract_number, e1.ethnicity_name AS applicant_ethnicity_name, a.applicant_ethnicity, e2.ethnicity_name AS co_applicant_ethnicity_name, a.co_applicant_ethnicity, ar.applicant_race_1, ar.applicant_race_2, ar.applicant_race_3, ar.applicant_race_4, ar.applicant_race_5, cr.co_applicant_race_1, cr.co_applicant_race_2, cr.co_applicant_race_3, cr.co_applicant_race_4, cr.co_applicant_race_5, sx1.sex_name AS applicant_sex_name, a.applicant_sex, sx2.sex_name AS co_applicant_sex_name, a.co_applicant_sex, a.applicant_income_000s, pu.purchaser_type_name, a.purchaser_type, d.denial_reason_1, d.denial_reason_2, d.denial_reason_3, a.rate_spread, hs.hoepa_status_name, a.hoepa_status, ls.lien_status_name, a.lien_status, '' AS edit_status_name, '' AS edit_status, a.sequence_number, l.population, l.minority_population, l.hud_median_family_income, l.tract_to_msamd_income, l.number_of_owner_occupied_units, l.number_of_1_to_4_family_units, a.application_date_indicator FROM Application a JOIN Location l ON a.location_id = l.location_id LEFT JOIN Agency ag ON a.agency_code = ag.agency_code LEFT JOIN Loan_Type lt ON a.loan_type = lt.loan_type LEFT JOIN Property_Type pt ON a.property_type = pt.property_type LEFT JOIN Loan_Purpose lp ON a.loan_purpose = lp.loan_purpose LEFT JOIN Owner_Occupancy oo ON a.owner_occupancy = oo.owner_occupancy LEFT JOIN Preapproval pa ON a.preapproval = pa.preapproval LEFT JOIN Action_Taken at ON a.action_taken = at.action_taken LEFT JOIN MSAMD m ON l.msamd = m.msamd::TEXT LEFT JOIN State st ON l.state_code = st.state_code::TEXT LEFT JOIN County c ON l.county_code = c.county_code::TEXT LEFT JOIN Ethnicity e1 ON a.applicant_ethnicity = e1.ethnicity_code LEFT JOIN Ethnicity e2 ON a.co_applicant_ethnicity = e2.ethnicity_code LEFT JOIN Sex sx1 ON a.applicant_sex = sx1.sex_code LEFT JOIN Sex sx2 ON a.co_applicant_sex = sx2.sex_code LEFT JOIN Purchaser_Type pu ON a.purchaser_type = pu.purchaser_type LEFT JOIN Hoepa_Status hs ON a.hoepa_status = hs.hoepa_status LEFT JOIN Lien_Status ls ON a.lien_status = ls.lien_status LEFT JOIN (SELECT id, MAX(CASE WHEN race_order = 1 THEN race END) AS applicant_race_1, MAX(CASE WHEN race_order = 2 THEN race END) AS applicant_race_2, MAX(CASE WHEN race_order = 3 THEN race END) AS applicant_race_3, MAX(CASE WHEN race_order = 4 THEN race END) AS applicant_race_4, MAX(CASE WHEN race_order = 5 THEN race END) AS applicant_race_5 FROM Applicant_Race GROUP BY id) ar ON a.id = ar.id LEFT JOIN (SELECT id, MAX(CASE WHEN race_order = 1 THEN race END) AS co_applicant_race_1, MAX(CASE WHEN race_order = 2 THEN race END) AS co_applicant_race_2, MAX(CASE WHEN race_order = 3 THEN race END) AS co_applicant_race_3, MAX(CASE WHEN race_order = 4 THEN race END) AS co_applicant_race_4, MAX(CASE WHEN race_order = 5 THEN race END) AS co_applicant_race_5 FROM CoApplicant_Race GROUP BY id) cr ON a.id = cr.id LEFT JOIN (SELECT id, MAX(CASE WHEN reason_order = 1 THEN denial_reason END) AS denial_reason_1, MAX(CASE WHEN reason_order = 2 THEN denial_reason END) AS denial_reason_2, MAX(CASE WHEN reason_order = 3 THEN denial_reason END) AS denial_reason_3 FROM Denial_Reason GROUP BY id) d ON a.id = d.id ORDER BY a.id) TO 'C:/Users/thaty/Downloads/HW2_336-main/HW2_336-main/reconstructed_hmda.csv' WITH CSV HEADER
SET search_path = s23_group3;


DROP TABLE IF EXISTS location, disease_study, stratification, disease_questions, disease_data, obese_study, obese_questions, obese_data CASCADE;

CREATE TABLE location AS
    (
        SELECT DISTINCT geolocation AS geo, locationabbr AS abbr, locationdesc AS description
        FROM nut_obese
    INTERSECT 
        SELECT DISTINCT geolocation AS geo, locationabbr AS abbr, locationdesc AS description
        FROM chronic_disease
    );

ALTER TABLE location 
ADD PRIMARY KEY (abbr);
ALTER TABLE s23_group3.location OWNER TO s23_group3;


CREATE TABLE disease_study AS (
    SELECT DISTINCT 
        locationabbr AS location_abbr, 
        YearStart AS year_start, 
        YearEnd AS year_end,
        datasource as source 
    FROM chronic_disease WHERE locationabbr IN (SELECT abbr FROM location)
);

ALTER TABLE disease_study ADD COLUMN id SERIAL NOT NULL;
ALTER TABLE disease_study ADD PRIMARY KEY (id);
ALTER TABLE disease_study ADD CONSTRAINT located_at FOREIGN KEY (location_abbr) REFERENCES location(abbr);
ALTER TABLE s23_group3.disease_study OWNER TO s23_group3;

CREATE TABLE disease_questions AS (
    SELECT DISTINCT 
        question, 
        topic
    FROM chronic_disease
);

ALTER TABLE disease_questions ADD COLUMN id SERIAL NOT NULL;
ALTER TABLE disease_questions ADD PRIMARY KEY (id);
ALTER TABLE s23_group3.disease_questions OWNER TO s23_group3;


CREATE TABLE disease_data AS (
    SELECT datavalueunit AS unit,
        datavaluetype AS type,
        datavalue AS value,
        datavaluealt AS alt,
        datavaluefootnote AS footnote,
        (
            SELECT id
            FROM disease_questions q 
            WHERE q.question = c.question 
            AND q.topic = c.topic
            LIMIT 1
        ) AS question_id,
        stratification1 AS stratification,
        (
            SELECT id
            FROM  disease_study WHERE 
                LocationAbbr = location_abbr 
                AND year_start = YearStart
                AND year_end = YearEnd
                AND datasource = source 
            LIMIT 1
        ) AS study_id 
            
    FROM chronic_disease c 
);

ALTER TABLE disease_data ADD PRIMARY KEY (study_id, stratification, question_id);
ALTER TABLE disease_data ADD CONSTRAINT from_study FOREIGN KEY (study_id) REFERENCES study(id);
ALTER TABLE disease_data ADD CONSTRAINT for_question FOREIGN KEY (question_id) REFERENCES question(id);
ALTER TABLE s23_group3.disease_data OWNER TO s23_group3;

CREATE table obese_study AS (
    SELECT DISTINCT 
        locationabbr AS location_abbr,
        YearStart AS year_start,
        YearEnd AS year_end,
        datasource AS source
    FROM nut_obese
    WHERE locationabbr IN (SELECT abbr FROM location)
);

ALTER TABLE obese_study ADD COLUMN id SERIAL NOT NULL;
ALTER TABLE obese_study ADD CONSTRAINT must_be_unique UNIQUE (location_abbr, year_start, year_end, source);
ALTER TABLE obese_study ADD PRIMARY KEY (id);
ALTER TABLE obese_study ADD CONSTRAINT located_ad FOREIGN KEY (location_abbr) REFERENCES location(abbr);
ALTER TABLE s23_group3.obese_study OWNER TO s23_group3;

CREATE TABLE obese_questions AS (
    SELECT DISTINCT 
        question,
        topic
    FROM nut_obese
);
ALTER TABLE obese_questions ADD COLUMN id SERIAL NOT NULL;
ALTER TABLE obese_questions ADD PRIMARY KEY (id);
ALTER TABLE s23_group3.obese_questions OWNER TO s23_group3;

CREATE TABLE obese_data AS (
    SELECT
        data_value_unit AS unit,
        data_value_type AS type,
        data_value AS value,
        data_value_alt AS alt,
        data_value_footnote AS footnote,
        (
            SELECT id
            FROM obese_questions q
            WHERE q.question = o.question
            AND q.topic = o.topic
        ) AS question_id, 
        stratification1 AS stratification,
        (
            SELECT id 
            FROM obese_study
            WHERE
                LocationAbbr = location_abbr
                AND year_start = YearStart
                AND year_end = YearEnd
                AND datasource = source 
        ) AS study_id
        FROM nut_obese o
);

ALTER TABLE obese_data ADD PRIMARY KEY (study_id, stratification, question_id);
ALTER TABLE obese_data ADD CONSTRAINT from_study FOREIGN KEY (study_id) REFERENCES obese_study(id);
ALTER TABLE obese_data ADD CONSTRAINT for_question FOREIGN KEY (question_id) REFERENCES obese_questions(id);
ALTER TABLE s23_group3.obese_data OWNER TO s23_group3;





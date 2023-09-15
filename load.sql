SET search_path = s23_group3;

DROP TABLE IF EXISTS chronic_disease CASCADE;
DROP TABLE IF EXISTS nut_obese CASCADE;
CREATE TABLE chronic_disease (
    YearStart                         INTEGER,
    YearEnd                           INTEGER,  
    LocationAbbr                      TEXT,
    LocationDesc                      TEXT,
    DataSource                        TEXT,
    Topic                             TEXT,
    Question                          TEXT,
    Response                          BOOLEAN,  
    DataValueUnit                     TEXT,
    DataValueType                     TEXT,
    DataValue                         TEXT,
    DataValueAlt                      NUMERIC(9,2),  
    DataValueFootnoteSymbol           TEXT,
    DatavalueFootnote                 TEXT,
    LowConfidenceLimit                NUMERIC(8,2),  
    HighConfidenceLimit               NUMERIC(8,2),  
    StratificationCategory1           TEXT,
    Stratification1                   TEXT,
    StratificationCategory2           BOOLEAN,  
    Stratification2                   BOOLEAN,  
    StratificationCategory3           BOOLEAN,  
    Stratification3                   BOOLEAN,  
    GeoLocation                       TEXT,
    ResponseID                        BOOLEAN,  
    LocationID                        INTEGER,  
    TopicID                           TEXT,
    QuestionID                        TEXT,
    DataValueTypeID                   TEXT,
    StratificationCategoryID1         TEXT,
    StratificationID1                 TEXT,
    StratificationCategoryID2         BOOLEAN,  
    StratificationID2                 BOOLEAN,  
    StratificationCategoryID3         BOOLEAN,  
    StratificationID3                 BOOLEAN 
);
\copy chronic_disease from 'chronic.csv' WITH (FORMAT 'csv', HEADER true);

ALTER TABLE s23_group3.chronic_disease OWNER TO s23_group3;
UPDATE chronic_disease 
SET geolocation = REGEXP_REPLACE(SUBSTRING(geolocation, 7), '([ ])', ',');

CREATE TABLE nut_obese(
    YearStart                          INTEGER,  
    YearEnd                            INTEGER,  
    LocationAbbr                       TEXT,
    LocationDesc                       TEXT,
    Datasource                         TEXT,
    Class                              TEXT,
    Topic                              TEXT,
    Question                           TEXT,
    Data_Value_Unit                    BOOLEAN,  
    Data_Value_Type                    TEXT,
    Data_Value                         NUMERIC(4,2),  
    Data_Value_Alt                     NUMERIC(4,2),  
    Data_Value_Footnote_Symbol         TEXT,
    Data_Value_Footnote                TEXT,
    Low_Confidence_Limit               NUMERIC(4,2),  
    High_Confidence_Limit              NUMERIC(4,2),  
    Sample_Size                        INTEGER,  
    Total                              TEXT,
    Age                                TEXT,
    Education                          TEXT,
    Gender                             TEXT,
    Income                             TEXT,
    Race_Ethnicity                     TEXT,
    GeoLocation                        TEXT,
    ClassID                            TEXT,
    TopicID                            TEXT,
    QuestionID                         TEXT,
    DataValueTypeID                    TEXT,
    LocationID                         INTEGER,  
    StratificationCategory1            TEXT,
    Stratification1                    TEXT,
    StratificationCategoryId1          TEXT,
    StratificationID1                  TEXT
);

\copy nut_obese FROM 'obese.csv' WITH (FORMAT 'csv', HEADER true);
ALTER TABLE s23_group3.nut_obese OWNER TO s23_group3;

UPDATE chronic_disease
SET geolocation = POINT(
        TRUNC(SPLIT_PART(REGEXP_REPLACE(geolocation, '([ \)\(])', '','g'),',', 2)::NUMERIC(15,3), 2),
        TRUNC(SPLIT_PART(REGEXP_REPLACE(geolocation, '([ \)\(])', '','g'),',', 1)::NUMERIC(15,3), 2)
    );

UPDATE nut_obese
SET geolocation = POINT(
        TRUNC(SPLIT_PART(REGEXP_REPLACE(geolocation, '([ \)\(])', '','g'),',', 1)::NUMERIC(15,3), 2),
        TRUNC(SPLIT_PART(REGEXP_REPLACE(geolocation, '([ \)\(])', '','g'),',', 2)::NUMERIC(15,3), 2)
    );

UPDATE nut_obese
SET Stratification1 = (
    CASE 
        WHEN Stratification1 = 'Non-Hispanic White' THEN 'White'
        WHEN Stratification1 = 'Non-Hispanic Black' THEN 'Black'
        WHEN Stratification1 = 'American Indian/Alaska Native' THEN 'Native American'
        WHEN Stratification1 = 'Hawaiian/Pacific Islander' THEN 'Pacific Islander'
        WHEN Stratification1 = '2 or more races' THEN 'Multiracial'
        WHEN Stratification1 = 'Total' THEN 'Overall'
        ELSE Stratification1
    END
     
);
UPDATE nut_obese
SET StratificationCategory1=(
    CASE
        WHEN StratificationCategory1='Total' THEN 'Overall'
    END
);
UPDATE chronic_disease
SET Stratification1 = (
    CASE 
        WHEN Stratification1 = 'White, non-Hispanic' THEN 'White'
        WHEN Stratification1 = 'Black, non-Hispanic' THEN 'Black'
        WHEN Stratification1 = 'American Indian or Alaska Native' THEN 'Native American'
        WHEN Stratification1 = 'Asian, non-Hispanic' THEN 'Asian'
        WHEN Stratification1 = 'Asian or Pacific Islander' THEN 'Pacific Islander'
        WHEN Stratification1 = 'Multiracial, non-Hispanic' THEN 'Multiracial'
        WHEN Stratification1 = 'Other, non-Hispanic' THEN 'Other'
        WHEN Stratification1 = 'Total' THEN 'Overall'
        ELSE Stratification1
    END
);

DELETE FROM chronic_disease 
WHERE datavalue IS NULL;
DELETE FROM nut_obese
WHERE data_value IS NULL;



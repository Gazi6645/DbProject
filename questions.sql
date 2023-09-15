--The Connection between Obesity and Chronic Illness

-- Does the 'Percent of adults aged 18 years and older who have obesity' have a correlation with 'Hospitalizations for asthma' and 'Emergency department visit rate for asthma' in a given state?
SELECT l.description, AVG(dd.value::DOUBLE PRECISION)
FROM location l JOIN disease_study ds ON l.abbr=ds.location_abbr
JOIN disease_data dd ON ds.id=dd.study_id JOIN 
disease_questions dq ON dd.question_id =dq.id
WHERE dq.question='Hospitalizations for asthma' AND dd.type='Age-adjusted Rate'
GROUP BY l.description
ORDER BY l.description;

---Does 'Poverty' have correlation with 'Percent of adults aged 18 years and older who have obesity'?
--poverty
SELECT l.description, AVG(dd.value::DOUBLE PRECISION)
FROM location l JOIN disease_study ds ON l.abbr=ds.location_abbr
JOIN disease_data dd ON ds.id=dd.study_id JOIN 
disease_questions dq ON dd.question_id =dq.id
WHERE dq.question='Poverty' AND dd.type='Crude Prevalence'
GROUP BY l.description
ORDER BY l.description;
--is there any correlation between 'Percent of adults who engage in muscle-strengthening activities on 2 or more days a week' and 'Percent of adults who engage in no leisure-time physical activity' with 'Percent of adults aged 18 years and older who have obesity'?
--Obesity
SELECT l.description, AVG(od.value)
FROM location l JOIN obese_study os ON l.abbr=os.location_abbr
JOIN obese_data od ON os.id=od.study_id JOIN 
obese_questions oq ON od.question_id =oq.id
WHERE oq.question='Percent of adults aged 18 years and older who have obesity'
GROUP BY l.description
ORDER BY l.description;

SELECT l.description, AVG(od.value)
FROM location l JOIN obese_study os ON l.abbr=os.location_abbr
JOIN obese_data od ON os.id=od.study_id JOIN 
obese_questions oq ON od.question_id =oq.id
WHERE oq.question='Percent of adults who engage in muscle-strengthening activities on 2 or more days a week'
GROUP BY l.abbr
ORDER BY l.description;

SELECT l.description, AVG(od.value)
FROM location l JOIN obese_study os ON l.abbr=os.location_abbr
JOIN obese_data od ON os.id=od.study_id JOIN 
obese_questions oq ON od.question_id =oq.id
WHERE oq.question='Percent of adults who engage in no leisure-time physical activity'
GROUP BY l.abbr
ORDER BY l.description;

--What state Has the Highest rate of Obesity
SELECT l.description, AVG(od.value)
FROM location l JOIN obese_study os ON l.abbr=os.location_abbr
JOIN obese_data od ON os.id=od.study_id JOIN 
obese_questions oq ON od.question_id =oq.id
WHERE oq.question='Percent of adults aged 18 years and older who have obesity'
GROUP BY l.abbr
ORDER BY l.description;

-- What is the correlation between obesisty and asthema
--Emergency department visit rate for asthma

SELECT CORR (od.obese_average, ad.asthma_average) AS corr_between_asthma_obeseity
FROM (
    SELECT l.description, AVG(od.value) AS obese_average
    FROM location l JOIN obese_study os ON l.abbr=os.location_abbr
    JOIN obese_data od ON os.id=od.study_id JOIN 
    obese_questions oq ON od.question_id =oq.id
    WHERE oq.question='Percent of adults aged 18 years and older who have obesity'
    GROUP BY l.abbr
    ORDER BY l.description
) od JOIN  (
    SELECT l.description, AVG(od.alt) AS asthma_average
    FROM location l JOIN obese_study os ON l.abbr=os.location_abbr
    JOIN disease_data od ON os.id=od.study_id JOIN 
    disease_questions oq ON od.question_id =oq.id
    WHERE oq.question='Asthma mortality rate'
    AND 
    od.type='Crude Rate' AND od.unit='cases per 1,000,000'
    GROUP BY l.abbr
    ORDER BY l.description
) ad ON od.description = ad.description;

-- -- 

-- SELECT CORR (od.obese_average, ad.stroke_average) AS corr_between_stroke_obeseity
-- FROM (
--     SELECT l.description, AVG(od.value) AS obese_average
--     FROM location l JOIN obese_study os ON l.abbr=os.location_abbr
--     JOIN obese_data od ON os.id=od.study_id JOIN 
--     obese_questions oq ON od.question_id =oq.id
--     WHERE oq.question='Percent of adults aged 18 years and older who have obesity'
--     GROUP BY l.abbr
--     ORDER BY l.description
-- ) od JOIN  (
--     SELECT l.description, AVG(od.alt) AS stroke_average
--     FROM location l JOIN obese_study os ON l.abbr=os.location_abbr
--     JOIN disease_data od ON os.id=od.study_id JOIN 
--     disease_questions oq ON od.question_id =oq.id
--     WHERE oq.question='Hospitalization for stroke'
--     AND 
--     od.type='Crude Rate'
--     GROUP BY l.abbr
--     ORDER BY l.description
-- ) ad ON od.description = ad.description;


-- SELECT CORR (od.obese_average, ad.heart_average) AS corr_between_heart_obeseity
-- FROM (
--     SELECT l.description, AVG(od.value) AS obese_average
--     FROM location l JOIN obese_study os ON l.abbr=os.location_abbr
--     JOIN obese_data od ON os.id=od.study_id JOIN 
--     obese_questions oq ON od.question_id =oq.id
--     WHERE oq.question='Percent of adults aged 18 years and older who have obesity'
--     GROUP BY l.abbr
--     ORDER BY l.description
-- ) od JOIN  (
--     SELECT l.description, AVG(od.alt) AS heart_average
--     FROM location l JOIN obese_study os ON l.abbr=os.location_abbr
--     JOIN disease_data od ON os.id=od.study_id JOIN 
--     disease_questions oq ON od.question_id =oq.id
--     WHERE oq.question='Mortality from coronary heart disease'
--     AND od.type='Crude Rate'
--     GROUP BY l.abbr
--     ORDER BY l.description
-- ) ad ON od.description = ad.description;

-- -- diabetes

-- SELECT CORR (od.obese_average, ad.heart_average) AS corr_between_heart_obeseity
-- FROM (
--     SELECT l.description, AVG(od.value) AS obese_average
--     FROM location l JOIN obese_study os ON l.abbr=os.location_abbr
--     JOIN obese_data od ON os.id=od.study_id JOIN 
--     obese_questions oq ON od.question_id =oq.id
--     WHERE oq.question='Percent of adults aged 18 years and older who have obesity'
--     GROUP BY l.abbr
--     ORDER BY l.description
-- ) od JOIN  (
--     SELECT l.description, AVG(od.alt) AS heart_average
--     FROM location l JOIN obese_study os ON l.abbr=os.location_abbr
--     JOIN disease_data od ON os.id=od.study_id JOIN 
--     disease_questions oq ON od.question_id =oq.id
--     WHERE oq.question='Mortality due to diabetes reported as any listed cause of death'
--     AND od.type='Crude Rate'
--     GROUP BY l.abbr
--     ORDER BY l.description
-- ) ad ON od.description = ad.description;


-- obesity 

SELECT ad.question AS disease_questions, CORR (od.obese_average, ad.average) AS obesity_and_disease_correlations
FROM (
    SELECT l.description, AVG(od.value) AS obese_average
    FROM location l JOIN obese_study os ON l.abbr=os.location_abbr
    JOIN obese_data od ON os.id=od.study_id JOIN 
    obese_questions oq ON od.question_id =oq.id
    WHERE oq.question='Percent of adults aged 18 years and older who have obesity'
    GROUP BY l.abbr
    ORDER BY l.description
) od JOIN  (
    SELECT l.description, dq.question, AVG(od.alt) AS average
    FROM location l JOIN obese_study os ON l.abbr=os.location_abbr
    JOIN disease_data od ON os.id=od.study_id JOIN 
    disease_questions dq ON od.question_id =dq.id
    WHERE od.type='Crude Rate'
    GROUP BY 
        l.description, 
        dq.question
    ORDER BY l.description
) ad ON od.description = ad.description
GROUP BY ad.question;



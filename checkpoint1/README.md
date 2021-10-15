# The-Hungry-Hornets
Data Science Group for MSAI 339 Fall 2021
By Lili Barsky, Vikram Kharvi, and Josh Cheema (Team
Hungry Hornets)

Relational Analytics:
Below, we list the questions we were interested in and the queries used to obtain them. We provide brief 
commentary on the findings. A full discussion of the findings is saved as a pdf titled findings. 

These queries can be run using the CPDB database and DataGrip as long as you have an active
connection to the public database. The sql document in the src directory can be directly
uploaded. 

1. What percentage of officers has at least one drug/alcohol abuse allegation?

--Pulls category ids under drug/alcohol abuse and 08J and 024 since these are drug/alcohol related
SELECT id
FROM data_allegationcategory
WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse'
OR data_allegationcategory.category_code IN ('08J', '024');

--Select distinct officer who have those category id complaints -> 1578
SELECT DISTINCT officer_id
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse'
    OR data_allegationcategory.category_code IN ('08J', '024'));

--Select distinct officers with complaints NOT categorized by drug/alcohol allegations -> 23,249
SELECT DISTINCT officer_id
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id NOT IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse'
    OR data_allegationcategory.category_code IN ('08J', '024'));

--All allegations from officers with drug/alcohol allegations (includes officers with multiple) -> 1900
SELECT officer_id
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse'
    OR data_allegationcategory.category_code IN ('08J', '024'));

--All allegations among officers NOT drug/alcohol related (including officers with multiple allegations) -> 246,421
SELECT officer_id
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id NOT IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse'
    OR data_allegationcategory.category_code IN ('08J', '024'));

--Officers with > 20 allegations and any number of drug/alcohol allegations -> 402
SELECT DISTINCT id
FROM data_officer
WHERE allegation_count > 20 AND id in (SELECT DISTINCT officer_id
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse'
    OR data_allegationcategory.category_code IN ('08J', '024')));

--Officers with > 20 allegations and NO drug/alcohol allegations -> 3,374
SELECT DISTINCT id
FROM data_officer
WHERE allegation_count > 20 AND id in (SELECT DISTINCT officer_id
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id NOT IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse'
    OR data_allegationcategory.category_code IN ('08J', '024')));

--Officers with > 50 allegations and drug/alcohol allegations -> 57
SELECT DISTINCT id
FROM data_officer
WHERE allegation_count > 50 AND id in (SELECT DISTINCT officer_id
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse'
    OR data_allegationcategory.category_code IN ('08J', '024')));

--Officers with > 50 allegations and NO drug/alcohol allegations -> 325
SELECT DISTINCT id
FROM data_officer
WHERE allegation_count > 50 AND id in (SELECT DISTINCT officer_id
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id NOT IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse'
    OR data_allegationcategory.category_code IN ('08J', '024')));

2. Are drug/alcohol abuse allegations more likely to be made against on or off duty
officers?

--1169 officers with these allegations while on duty (1578 total regardless of duty status)
SELECT DISTINCT officer_id
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE (data_allegationcategory.category = 'Drug / Alcohol Abuse'
    OR data_allegationcategory.category_code IN ('08J', '024'))
    AND data_allegationcategory.on_duty = True);

--1378 officers with drug and alcohol abuse allegations while on duty (includes )
SELECT officer_id
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE (data_allegationcategory.category = 'Drug / Alcohol Abuse'
    OR data_allegationcategory.category_code IN ('08J', '024'))
    AND data_allegationcategory.on_duty = True);

3. What percentage of officers are involved in medical policy violation allegations? These
are categorized differently than drug/alcohol abuse.

-- The additional category id's added fit our question
SELECT id
FROM data_allegationcategory
WHERE data_allegationcategory.category = 'Medical'
OR data_allegationcategory.category_code IN ('003', '003A', '003B', '003C', '003D', '003E');

--29 of these
SELECT DISTINCT officer_id
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Medical'
    OR data_allegationcategory.category_code IN ('003', '003A', '003B', '003C', '003D', '003E'));

4. Are there differences in officer salary (+$1012.55) and/or distribution of awards (1 less honorable mention) among police with and without drug/alcohol abuse allegations and other medical allegations?

--$1,012.55 higher pay among those with these allegations versus those without
SELECT
(SELECT avg(salary)
FROM data_salary
WHERE officer_id IN
    (SELECT DISTINCT officer_id
    FROM data_officerallegation
    WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
     FROM data_allegationcategory
     WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E'))))
     - (SELECT avg(salary) FROM data_salary WHERE officer_id IN (SELECT id from data_officer)) AS DIFFERENCE

--Those without these allegations
SELECT
(SELECT avg(honorable_mention_count)
FROM data_officer
WHERE id IN
    (SELECT DISTINCT officer_id
    FROM data_officerallegation
    WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical' OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E'))))
    - (SELECT avg(honorable_mention_count) FROM data_officer WHERE id IN (SELECT id from data_officer)) AS DIFFERENCE

5. Among officers with drug/alcohol abuse allegations, what is the average amount of time
they have been on the force?

--20.290 years for those with drug/alcohol abuse allegations 
SELECT AVG(EXTRACT(YEAR FROM resignation_date) - EXTRACT(YEAR FROM appointed_date))
FROM data_officer
WHERE id IN
    (SELECT DISTINCT officer_id
    FROM data_officerallegation
    WHERE data_officerallegation.allegation_category_id IN
        (SELECT id
        FROM data_allegationcategory
        WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse'
           OR data_allegationcategory.category_code
                  IN ('08J', '024')));

--Officers without drug/alcohol abuse allegations? = 24.931
SELECT AVG(EXTRACT(YEAR FROM resignation_date) - EXTRACT(YEAR FROM appointed_date))
FROM data_officer
WHERE id NOT IN
    (SELECT DISTINCT officer_id
    FROM data_officerallegation
    WHERE data_officerallegation.allegation_category_id IN
        (SELECT id
        FROM data_allegationcategory
        WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse'
           OR data_allegationcategory.category_code
                  IN ('08J', '024')));
--Question 1:

--D/A/M allegations and disciplined = 737
SELECT DISTINCT(officer_id)
FROM data_officerallegation
WHERE data_officerallegation.disciplined=True AND data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical'
    OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E'))

--D/A/M allegations and NOT disciplined = 880
SELECT DISTINCT(officer_id)
FROM data_officerallegation
WHERE data_officerallegation.disciplined=False AND data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical'
    OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E'))

--Allegations but NOT in D/A/M and disciplined = 9601
SELECT DISTINCT(officer_id)
FROM data_officerallegation
WHERE data_officerallegation.disciplined=True AND data_officerallegation.allegation_category_id NOT IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical'
    OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E'))

--Allegations but NOT in D/A/M and NOT disciplined = 21797
SELECT DISTINCT(officer_id)
FROM data_officerallegation
WHERE data_officerallegation.disciplined=False AND data_officerallegation.allegation_category_id NOT IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse' OR data_allegationcategory.category = 'Medical'
    OR data_allegationcategory.category_code IN ('08J', '024', '003', '003A', '003B', '003C', '003D', '003E'))

--Question 2:
-- All info on allegations with d/a/m = 1930
SELECT *
FROM data_officerallegation
WHERE data_officerallegation.allegation_category_id IN
    (SELECT id
    FROM data_allegationcategory
    WHERE data_allegationcategory.category = 'Drug / Alcohol Abuse'
    OR data_allegationcategory.category_code IN ('08J', '024')
    OR data_allegationcategory.category = 'Medical'
    OR data_allegationcategory.category_code IN ('003', '003A', '003B', '003C', '003D', '003E'));

-- Checking data types of columns
PRAGMA table_info(consumer_complaints_cleaned);

-- Creating first cleaned table
DROP TABLE IF EXISTS consumer_complaints_cleaned;

CREATE TABLE consumer_complaints_cleaned AS
SELECT
    complaint_id,
    -- Convert MM/DD/YYYY to YYYY-MM-DD
    DATE(SUBSTR(date_received, 7, 4) || '-' || SUBSTR(date_received, 1, 2) || '-' || SUBSTR(date_received, 4, 2)) AS formatted_date,
    -- Extract Year
    STRFTIME('%Y', DATE(SUBSTR(date_received, 7, 4) || '-' || SUBSTR(date_received, 1, 2) || '-' || SUBSTR(date_received, 4, 2))) AS year,
    -- Extract Month
    STRFTIME('%m', DATE(SUBSTR(date_received, 7, 4) || '-' || SUBSTR(date_received, 1, 2) || '-' || SUBSTR(date_received, 4, 2))) AS month,
    product, 
    COALESCE(sub_product, 'None') as sub_product,
    issue, 
    COALESCE(sub_issue, 'Not Provided') as sub_issue,
    company, 
    state, 
    zipcode,
    COALESCE(tags, 'None') as tags,
    submitted_via,
    date_sent_to_company,
    company_response_to_consumer,
    timely_response
FROM    
    consumer_complaints;

-- SELECT * QUERY
SELECT * FROM consumer_complaints_cleaned LIMIT 10;

-- Creating count of complaints by product
SELECT
    product,
    COUNT(complaint_id) as complaint_count
FROM
    consumer_complaints_cleaned
GROUP BY
    product
ORDER BY
    complaint_count DESC;

-- the top 20 issues for the product "Mortgage"
SELECT
    issue,
    COUNT(complaint_id) as complaint_count
FROM
    consumer_complaints_cleaned
WHERE
    product = "Mortgage"
GROUP BY
    issue
ORDER BY
    complaint_count DESC;


-- Checking unique values for issue column
SELECT
    DISTINCT issue
FROM
    consumer_complaints_cleaned;

-- Showing the top 20 issues
SELECT 
    issue, 
    COUNT(complaint_id) as complaint_count
FROM 
    consumer_complaints_cleaned
GROUP BY 
    issue
ORDER BY 
    complaint_count DESC
LIMIT 20;

-- Seeing count of complaints by company
SELECT
    company, 
    COUNT(complaint_id) as complaint_count
FROM 
    consumer_complaints_cleaned
GROUP BY
    company
ORDER BY
    complaint_count DESC;

-- Final table creation
DROP TABLE IF EXISTS consumer_complaints_cleaned_final;

CREATE TABLE consumer_complaints_cleaned_final AS
SELECT
    year,
    month, 
    product, 
    state, 
    zipcode,
    submitted_via,
    timely_response,
    COUNT(complaint_id) as complaint_count,
    AVG(CASE WHEN timely_response = 'Yes' THEN 1 ELSE 0 END) * 100 as timely_response_percentage
FROM   
    consumer_complaints_cleaned
WHERE 
    year IS NOT NULL AND
    month IS NOT NULL AND
    product IS NOT NULL AND
    state IS NOT NULL AND
    zipcode IS NOT NULL AND
    submitted_via IS NOT NULL AND
    timely_response IS NOT NULL
GROUP BY
    year,
    month, 
    product, 
    state, 
    zipcode,
    submitted_via,
    timely_response
ORDER BY
    complaint_count DESC;

-- SELECT * QUERY
SELECT * FROM consumer_complaints_cleaned_final
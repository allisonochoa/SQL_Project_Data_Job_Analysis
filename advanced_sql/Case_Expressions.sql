--Label a new column as follows:
    --‘Anywhere’ jobs as ‘Remote’.
    --‘New York, NY’ jobs as ‘Local’.
    --Otherwise ‘Onsite’

--Solution 1--
SELECT
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact;

--Solution 2--
    --Especially for the total number of Data Analyst jobs in each category.)--
SELECT
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category,
    COUNT(job_id) AS number_of_jobs
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;

--I want to categorize the salaries from each job posting. To see if it fits in my desired salary range. 
    --Put salary into different buckets (Low = 25K - 94k, Standard = 95k - 164k, High = 164k - 233k):
    --Why? It is easy to determine which job postings are worth looking at based on salary. Bucketing is a common practice in data analysis when viewing categories.
    --I only want to look at data analyst roles.
    --Order from highest to lowest.

--Solution 1--
    --Shows all job postings and their salaries (except from null values), adding them a tag (salary bucket)--

SELECT
    job_title_short,
    salary_year_avg,
    CASE
        WHEN salary_year_avg BETWEEN 0 AND 94000 THEN 'LOW'
        WHEN salary_year_avg BETWEEN 94001 AND 164999 THEN 'Standard'
        WHEN salary_year_avg >= 165000 THEN 'High'
        ELSE 'Error'
    END AS salary_buckets
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL  
ORDER BY
    salary_year_avg DESC;

--Solution2--
SELECT
    CASE
        WHEN salary_year_avg BETWEEN 0 AND 94000 THEN 'LOW'
        WHEN salary_year_avg BETWEEN 94001 AND 164999 THEN 'Standard'
        WHEN salary_year_avg >= 165000 THEN 'High'
        ELSE 'Error'
    END AS salary_buckets,
    COUNT(job_id) AS number_of_jobs    
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL 
GROUP BY
    salary_buckets
ORDER BY
    MIN(salary_year_avg) DESC; 
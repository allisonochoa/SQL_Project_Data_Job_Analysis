--Write a query to count the number of job postings for each month in 2023, adjust the job_posted_date to be in ‘America/New_York’ time zone before extracting (hint) the month. Assume the job_posted_date is stored in UTC. Group and order by the month.--
SELECT
    EXTRACT (MONTH FROM (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York'))
    AS posting_month,
    COUNT (job_id)
FROM
    job_postings_fact
WHERE
    job_posted_date >= '2023-01-01'
    AND job_posted_date < '2024-01-01'
GROUP BY
    posting_month
ORDER BY
    posting_month;

--Write a query to find companies (include company name) that have posted jobs offering health insurance, where these postings were made in the second quarter of 2023. Use date extraction to filter by quarter.--
SELECT
    companies.name AS company_name,
    EXTRACT (MONTH FROM job_postings.job_posted_date) AS month,
    job_postings.job_health_insurance AS health_insurance
FROM
    job_postings_fact AS job_postings
LEFT JOIN company_dim AS companies
    ON job_postings.company_id = companies.company_id
WHERE
    job_postings.job_health_insurance = TRUE  
    AND (EXTRACT(MONTH FROM job_postings.job_posted_date) = 4
        OR EXTRACT(MONTH FROM job_postings.job_posted_date) = 5
        OR EXTRACT(MONTH FROM job_postings.job_posted_date) = 6)
    AND EXTRACT(YEAR FROM job_postings.job_posted_date) = 2023;

--Create 3 tables (from other tables):
    --Jan 2023 jobs
    --Feb 2023 jobs
    --Mar 2023 jobs
--Foreshadowing: this will be used in another practice problem.
--Hints:Use CREATE TABLE table_name AS syntax to create your table. Look at a way to filter out only specific months (EXTRACT)--

--JANUARY--
CREATE TABLE january_jobs AS
    SELECT
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 1;


--FEBRUARY--
CREATE TABLE february_jobs AS
    SELECT
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 2;


--MARCH--
CREATE TABLE march_jobs AS
    SELECT
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 3;
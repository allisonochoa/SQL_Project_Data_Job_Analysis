--Convert a value to a date format by removing the time portion--
SELECT
    job_title_short,
    job_location,
    job_posted_date,
    job_posted_date ::DATE AS job_posted_date_only
FROM
    job_postings_fact;

--Convert a timestamp to a specified time zone--
SELECT
    job_title_short,
    job_location,
	job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM
    job_postings_fact;

--Get specific date parts (e.g., year, month, day)--
SELECT
	job_title_short,
	job_location,
	EXTRACT(MONTH FROM job_posted_date) AS job_posted_month,
	EXTRACT(YEAR FROM job_posted_date) AS job_posted_year
FROM
	job_postings_fact;

--Get the count of job postings by month--
SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS job_posted_month
FROM
	job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    job_posted_month
ORDER BY
    job_posted_count DESC;
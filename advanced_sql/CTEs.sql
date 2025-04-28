--Define a temporary result set that you can reference--
    --Can reference within a SELECT, INSERT, UPDATE, or DELETE statement
    --Defined with WITH

WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT (MONTH FROM job_posted_date) = 1
)

SELECT
    *
FROM
    january_jobs;

--Find the companies with the most job openings. Divide in 2:
    --Get the total number of job postings per company id (job_postings_fact).
    --Return the total number of jobs with the company name (company_dim).

WITH company_job_count AS (
    SELECT
        company_id,
        COUNT (*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM    
    company_dim
LEFT JOIN
    company_job_count
    ON company_job_count.company_id = company_dim.company_id
ORDER BY
    company_job_count.total_jobs DESC;

--Identify the top 5 skills that are the most frequently mentioned in job postings. Use a subquery to find the skill IDs with the highest counts in the skills_job_dim table and then join this result with the skills_dim table to get the skill names.--

WITH skill_id_count AS (
    SELECT
        skill_id,
        COUNT(*) AS number_of_skills
    FROM
        skills_job_dim
    GROUP BY
        skill_id
)


SELECT
    skills_dim.skills AS skill_name,
    COALESCE(skill_id_count.number_of_skills, 0) AS number_of_skills
FROM    
    skills_dim
LEFT JOIN
    skill_id_count
    ON skill_id_count.skill_id = skills_dim.skill_id
WHERE
    skill_id_count.number_of_skills IS NOT NULL
ORDER BY
    skill_id_count.number_of_skills DESC
LIMIT 5;

--The following problems include the use of both CTEs and a CASE expressions--

--Determine the size category (Small = Less than 10 job postings, Medium = Between 10 and 50 job postings, or Large = More than 50 job postings) for each company by first identifying the number of job postings they have. Use a subquery to calculate the total job postings per company. A company is considered Small if it has less than 10 job postings, Medium if the number of job postings is between 10 and 50, and Large if it has more than 50 job postings. Implement a subquery to aggregate job counts per company before classifying them based on size.--
WITH company_job_count AS (
    SELECT
        company_id,
        COUNT (*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs,
    CASE
        WHEN total_jobs BETWEEN 1 AND 9 THEN 'Small'
        WHEN total_jobs BETWEEN 10 AND 50 THEN 'Medium'
        WHEN total_jobs > 50 THEN 'Large'
        ELSE 'Error'
    END AS company_size
FROM    
    company_dim
LEFT JOIN
    company_job_count
    ON company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC;

--Find the count of the number of remote job postings per skill:
    --Display the top 5 skills by their demand in remote jobs.
    --Include skill ID, name, and count of postings requiring the skill.
    --Only for data analyst jobs
WITH remote_job_skills AS (
    SELECT
        skills_to_job.skill_id,
        COUNT (*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN
        job_postings_fact AS job_postings
        ON job_postings.job_id = skills_to_job.job_id
    WHERE  
        job_postings.job_work_from_home = TRUE
        AND job_postings.job_title = 'Data Analyst'
    GROUP BY    
        skills_to_job.skill_id
)

SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM
    remote_job_skills
INNER JOIN
    skills_dim AS skills
    ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT
    5;

--Identify the top 5 companies that post the most Data Analysts remote roles. Display the company name and the number of remote Data Analyst job postings:
    --Use a CTE to first filter job_postings_fact for jobs with job_title = 'Data Analyst' and job_work_from_home = TRUE.
    --Group by company_id and count job postings.
    --Join the result with company_dim to get company names.
    --Order by the job count and limit to 5 results.
WITH postings AS (
    SELECT  
        job_postings_fact.company_id,
        COUNT (*) AS postings_count
    FROM    
        job_postings_fact
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.job_work_from_home = TRUE
    GROUP BY    
        job_postings_fact.company_id
)

SELECT
    company_dim.company_id,
    company_dim.name AS company_name,
    postings.postings_count
FROM    
    postings
INNER JOIN
    company_dim
    ON company_dim.company_id = postings.company_id
ORDER BY    
    postings_count DESC
LIMIT
    5;
--Get the corresponding skill and skill type for each job posting in q1:
    --Include those without any skills, too.
    --Why? To look at the skills and the type for each job in the first quarter that has a salary >$70,000.

WITH q1 AS (
    SELECT
        job_id
    FROM    
        january_jobs
    WHERE
        salary_year_avg > 70000

UNION ALL

    SELECT
        job_id
    FROM    
        february_jobs
    WHERE
        salary_year_avg > 70000

UNION ALL

    SELECT
        job_id
    FROM    
        march_jobs
    WHERE
        salary_year_avg > 70000
)

SELECT
    q1.job_id,
    skills_dim.skills,
    skills_dim.type AS "skill type"
FROM
    q1
LEFT JOIN
    skills_job_dim
    ON skills_job_dim.job_id = q1.job_id
LEFT JOIN
    skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    q1.job_id ASC;

--Find job postings from the 1st quarter that have a salary greater than $70K:
    --Combine job postings tables from the 1st quarter of 2023 (Jan-Mar)
    --Get job postings with an average yearly salary > $70,000
SELECT
    quarter_1_job_postings.job_title_short,
    quarter_1_job_postings.job_location,
    quarter_1_job_postings.job_via,
    quarter_1_job_postings.job_posted_date :: DATE,
    quarter_1_job_postings.salary_year_avg
FROM(
    SELECT
        *
    FROM    
        january_jobs

UNION ALL

    SELECT
        *
    FROM    
        february_jobs

UNION ALL

    SELECT
        *
    FROM    
        march_jobs
) AS quarter_1_job_postings
WHERE
    quarter_1_job_postings.salary_year_avg > 70000
    AND quarter_1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    quarter_1_job_postings.salary_year_avg DESC
;
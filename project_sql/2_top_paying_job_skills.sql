/*
Question: What skills are required for the top-paying data analyst jobs?
    - Use the top 10 highest-paying Data Analyst jobs from first query
    - Add the specific skills required for these roles
    - Why? It provides a detailed look at which high-paying jobs demand certain skills,
      helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        company_dim.name AS company_name
    FROM    
        job_postings_fact
    LEFT JOIN
        company_dim
        ON company_dim.company_id = job_postings_fact.company_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT
        10
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills
FROM
    top_paying_jobs
INNER JOIN
    skills_job_dim
    ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN
    skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    top_paying_jobs.salary_year_avg DESC;
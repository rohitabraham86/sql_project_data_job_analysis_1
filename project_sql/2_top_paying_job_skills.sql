/* **Question: What are the top-paying data analyst jobs, and what skills are required?** 

- Identify the top 10 highest-paying Data Analyst jobs and the specific skills required for these roles.
- Filters for roles with specified salaries that are remote
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
     helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs AS (
    SELECT
        j.job_id,
        j.job_title,
        j.salary_year_avg,
        cd.name AS company_name
    FROM
        job_postings_fact AS j
    LEFT JOIN
        company_dim AS cd ON
        j.company_id = cd.company_id

    WHERE   
        j.job_title_short = 'Data Analyst' AND
        j.job_location = 'Anywhere' AND
        j.salary_year_avg IS NOT NULL
    ORDER BY
        j.salary_year_avg DESC
    LIMIT 10
)

SELECT 
    tpj.*, -- this will select all columns from tpj column
    sd.skills
FROM 
    top_paying_jobs AS tpj
INNER JOIN 
    skills_job_dim AS sjd ON
    tpj.job_id = sjd.job_id
INNER JOIN 
    skills_dim AS sd ON
    sjd.skill_id = sd.skill_id
ORDER BY
    tpj.salary_year_avg DESC;

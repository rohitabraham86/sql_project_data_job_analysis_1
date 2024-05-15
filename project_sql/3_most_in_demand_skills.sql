/* **Question: What are the most in-demand skills for data analysts?**

- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, providing insights into the most valuable skills for job seekers.
*/


SELECT
    sd.skills,
    COUNT(sjd.job_id) AS demand_count
FROM 
    job_postings_fact AS j
INNER JOIN 
    skills_job_dim AS sjd ON
    j.job_id = sjd.job_id
INNER JOIN 
    skills_dim AS sd ON
    sjd.skill_id = sd.skill_id
WHERE
    j.job_title_short = 'Data Analyst' AND
    j.job_country = 'India'
GROUP BY
    sd.skills
ORDER BY
    demand_count DESC
LIMIT 5;
# Introduction
📊 Explore the dynamic realm of tech jobs through my SQL project! 🖥️💼 Delve into insightful analyses of top-paying tech roles, in-demand skills, and high-demand jobs with lucrative salaries, with a special focus on data analyst positions. 💰📈

This repository is your gateway to uncovering trends, patterns, and valuable insights in the evolving world of data analytics careers. Join me on this data-driven journey as we navigate the intricacies of the tech job market! 🔍✨

🔍 Explore the SQL queries here in [project_sql](/sql_project_data_job_analysis_1/project_sql) folder.


# Background
This dataset was curated by [Luke Barousse](https://www.linkedin.com/in/luke-b/) and you can access it from the [SQL Course](https://lukebarousse.com/sql) he created along with [Kelly Adams](https://www.linkedin.com/in/kellyjianadams/).


From this dataset, I wanted to explore the **Data Analyst** job market in **India**, and the questions I wanted to explore are the following: 📊

- What are the top-paying data analyst jobs?
- What are the top-paying data analyst jobs, and what skills are required?
- What are the most in-demand skills for data analysts?
- What are the top skills based on salary?
-  What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst?
- What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst **worldwide**?

# Tools Used
These 🛠️ tools collectively empowered the development, analysis, and sharing of SQL queries, ensuring efficient project management and collaboration.

- **PostgreSQL:** Utilized PostgreSQL as the primary database management system for storing, querying, and analyzing data related to tech jobs.

- **Visual Studio Code (VS Code):** Leveraged VS Code as the integrated development environment (IDE) for writing, testing, and debugging SQL queries and scripts efficiently.

- **Git:** Employed Git for version control, allowing for collaborative development, tracking changes, and managing project iterations effectively.

- **GitHub:** Utilized GitHub as the platform for hosting the project repository, enabling seamless collaboration, code sharing, and version control management with the development community.
# The Analysis
### 1. Top Paying Data Analyst Jobs

This query retrieves information about Top Paying Data Analyst job postings in India. The query filters out job postings that have a ```NULL``` salary, matches the job title short to ```Data Analyst```, ensures the job is in ```India```, and then orders the results by ***average yearly salary*** in ***descending order***, showing the top 10 highest-paying Data Analyst jobs.

```sql
SELECT
    j.job_id,
    job_title_short,
    j.job_title,
    j.job_location,
    j.job_schedule_type,
    j.salary_year_avg,
    j.job_posted_date,
    cd.name AS company_name
FROM
    job_postings_fact AS j
LEFT JOIN
    company_dim AS cd ON
    j.company_id = cd.company_id

WHERE   
    j.job_title_short = 'Data Analyst' AND
    j.job_country = 'India' AND
    j.salary_year_avg IS NOT NULL
ORDER BY
    j.salary_year_avg DESC
LIMIT 10;    
```

### 2. Skills for Top Paying Data Analyst Jobs

This query employs a **Common Table Expression (CTE)** named ```top_paying_jobs``` to identify and gather details about the top 10 highest-paying Data Analyst jobs in India. It selects essential attributes such as job ID, title, salary, and company name from this CTE. Additionally, it leverages ```INNER JOIN``` operations to link the ```top_paying_jobs``` CTE with the ```skills_job_dim``` and ```skills_dim``` tables, enabling the retrieval of specific skills required for each job. This comprehensive approach provides a holistic view of the most lucrative Data Analyst positions in India, combining salary information with skill requirements. The final output is structured and sorted by salary, offering valuable insights into the job market landscape for Data Analysts in the region.

```sql
WITH top_paying_jobs AS (
    SELECT
        j.job_id,
        j.job_title_short,
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
        j.job_country = 'India' AND
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
    tpj.salary_year_avg DESC
LIMIT 10;
```


### 3. Most in demand skills

This query calculates the demand for different skills among ***Data Analyst*** jobs in ***India***. It achieves this by joining the ```job_postings_fact``` table with the ```skills_job_dim``` and ```skills_dim``` tables based on their respective IDs. The query then filters the data to consider only Data Analyst roles in India. It counts the number of job IDs associated with each skill, groups the results by skill, and orders them in descending order of demand. Finally, it limits the output to show the top 5 most in-demand skills for Data Analyst positions in India.

```sql
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
```

### 4. Top paid skills

This query calculates the ***average salary*** for Data Analyst jobs in India based on ***different skills***. It joins the ```job_postings_fact```, ```skills_job_dim```, and ```skills_dim``` tables to associate skills with job IDs and fetch corresponding salary data. The query filters the results to include only Data Analyst roles in India with non-null salary information. It then calculates the average salary for each skill group and presents the results in descending order of average salary. Finally, it limits the output to display the top 25 skills with the highest average salaries for Data Analyst positions in India.

```sql
SELECT
    sd.skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
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
    j.job_country = 'India' AND
    j.salary_year_avg IS NOT NULL 
GROUP BY
    sd.skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```
### 5. Most optimal skills

This complex query first calculates the demand for different skills among ***Data Analyst jobs in India*** and their average salary. It does so by using two ***Common Table Expressions (CTEs)***: ```skills_demand``` and ```average_salary```.

- ***skills_demand CTE:*** Counts the demand for each skill among Data Analyst jobs in India, considering factors like job title, location, and salary.
- ***average_salary CTE:*** Calculates the average salary for each skill group among Data Analyst jobs in India.

After calculating demand and average salary separately, the main query ***joins*** these two CTEs on the ```skill_id``` and retrieves columns such as skill ID, skill name, demand count, and average salary. The results are then ordered first by average salary in descending order and then by demand count in descending order, providing insights into both the most lucrative and most in-demand skills for Data Analyst positions in India.

```sql
WITH skills_demand AS(
    SELECT
        sd.skill_id,
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
        j.job_country = 'India' AND
        j.salary_year_avg IS NOT NULL
    GROUP BY
        sd.skill_id
),
average_salary AS(
    SELECT
        sd.skill_id,
        sd.skills,
        ROUND(AVG(salary_year_avg),0) AS avg_salary
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
        j.job_country = 'India' AND
        j.salary_year_avg IS NOT NULL
    GROUP BY
        sd.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN
    average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
    avg_salary DESC,
    demand_count DESC;
```

### 6. Most optimal skills - Worldwide

This complex query calculates the demand for different skills among ***Data Analyst jobs outside India (excluding India)*** and their average salary. It uses two ***Common Table Expressions (CTEs):*** ```skills_demand``` and ```average_salary```.

- ***skills_demand CTE:*** Counts the demand for each skill among Data Analyst jobs outside India, considering factors like job title, location (not India), and salary.
- ***average_salary CTE:*** Calculates the average salary for each skill group among Data Analyst jobs outside India.

After calculating demand and average salary separately, the main query ***joins*** these two CTEs on the ```skill_id``` and retrieves columns such as skill ID, skill name, demand count, and average salary. The results are then filtered to include only skills with a demand count greater than 10, ordered first by average salary in descending order and then by demand count in descending order. This provides insights into both the most lucrative and most in-demand skills for Data Analyst positions outside India.

```sql
WITH skills_demand AS(
    SELECT
        sd.skill_id,
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
        j.job_country != 'India' AND
        j.salary_year_avg IS NOT NULL
    GROUP BY
        sd.skill_id
),
average_salary AS(
    SELECT
        sd.skill_id,
        sd.skills,
        ROUND(AVG(salary_year_avg),0) AS avg_salary
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
        j.job_country != 'India' AND
        j.salary_year_avg IS NOT NULL
    GROUP BY
        sd.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN
    average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE  
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
# Conclusion
- ### The top paying Data Analyst jobs has an average annual salary of $650,000.
- ### The top paying skill is SQL along with Python, MongoDB with an average annual salary of $165,000 and the job which requires these skills is Data Architect 2023.
- ### Most in-demand skill is SQL.


# What I Learned

I've learned how to write SQL queries to analyze job data, particularly focusing on Data Analyst roles. Here's what I've covered:

### 1. Basic Job Analysis:

I can retrieve job information like job ID, title, location, schedule type, salary, posting date, and company name from a database using SQL SELECT queries.

### 2. Filtering and Sorting:

I can filter job data based on criteria such as job title, country, and salary using WHERE clauses in SQL queries.

I can also sort job data based on salary in ascending or descending order using ORDER BY clauses.

### 3. Joining Tables:

I've learned to join multiple tables using INNER JOIN and LEFT JOIN operations to fetch related data from different tables in a database.

### 4. Using Common Table Expressions (CTEs):

I understand how to use CTEs to break down complex queries into manageable parts, making it easier to analyze and understand the data.

### 5. Grouping and Aggregation:

I can group data using GROUP BY clauses and perform aggregation functions like COUNT and AVG to calculate demand counts and average salaries for different skills or job attributes.

### 6. Limiting Results:

I've learned to limit the number of rows returned in a query using the LIMIT clause, which is useful for displaying top results or controlling the output size.

Overall, I've gained a good understanding of how to extract meaningful insights from job data using SQL queries. This includes analyzing demand for skills, calculating average salaries, and identifying top-performing job roles based on various criteria.
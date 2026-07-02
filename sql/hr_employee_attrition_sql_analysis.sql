
--HR EMPLOYEE ATTRITION - SQL ANALYSIS TASKS

--TASK 1: Attrition rate per Department and Job Role
--Requirement: GROUP BY + conditional COUNT
  
  Use HR_attrition
  Go

SELECT
    department,
    job_role,
    COUNT(*) AS total_employees,

    COUNT(
        CASE 
            WHEN attrition = 1 THEN 1 
        END
    ) AS employees_left,

    COUNT(
        CASE 
            WHEN attrition = 0 THEN 1 
        END
    ) AS employees_stayed,

    CAST(
        COUNT(
            CASE 
                WHEN attrition = 1 THEN 1 
            END
        ) * 100.0 / COUNT(*)
        AS DECIMAL(5,2)
    ) AS attrition_rate_percent

FROM dbo.hr_employee_attrition_cleaned

GROUP BY
    department,
    job_role

ORDER BY
    attrition_rate_percent DESC,
    department,
    job_role;

--TASK 2: Compare average MonthlyIncome:employees who left vs employees who stayed. Requirement: subqueries

SELECT
    (
        SELECT AVG(CAST(monthly_income AS DECIMAL(12,2)))
        FROM dbo.hr_employee_attrition_cleaned
        WHERE attrition = 1
    ) AS average_monthly_income_employees_left,

    (
        SELECT AVG(CAST(monthly_income AS DECIMAL(12,2)))
        FROM dbo.hr_employee_attrition_cleaned
        WHERE attrition = 0
    ) AS average_monthly_income_employees_stayed;


--TASK 3: Rank Job Roles by average Years At Company Requirement: tenure patterns per role. 
--Uses DENSE_RANK so equal averages receive the same rank.
USE HR_attrition;
GO

SELECT
    job_role,
    CAST(
        AVG(CAST(years_at_company AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS average_years_at_company,

    DENSE_RANK() OVER (
        ORDER BY AVG(CAST(years_at_company AS DECIMAL(10,2))) DESC
    ) AS tenure_rank

FROM dbo.hr_employee_attrition_cleaned

GROUP BY
    job_role

ORDER BY
    tenure_rank,
    job_role;
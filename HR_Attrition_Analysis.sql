-- ============================================================
-- HR ATTRITION ANALYSIS
-- Author: Rishitha Gopagani
-- Tools: MySQL
-- Dataset: 628 employees across multiple departments
-- Goal: Identify key drivers of employee attrition
-- ============================================================
 
-- ============================================================
-- PHASE 1: DATA EXPLORATION
-- ============================================================
 
-- Total employees
SELECT COUNT(DISTINCT Employee_ID) AS Total_Employees 
FROM project.adviti_hr_data;
 
-- Age distribution
SELECT Age, COUNT(DISTINCT Employee_ID) AS Employees 
FROM project.adviti_hr_data 
GROUP BY Age 
ORDER BY Age ASC;
 
-- Gender distribution
SELECT Gender, COUNT(DISTINCT Employee_ID) AS Employees 
FROM project.adviti_hr_data 
GROUP BY Gender;
 
-- Department distribution
SELECT Department, COUNT(DISTINCT Employee_ID) AS Employees 
FROM project.adviti_hr_data 
GROUP BY Department;
 
-- Salary distribution
SELECT Salary, COUNT(DISTINCT Employee_ID) AS Employees 
FROM project.adviti_hr_data 
GROUP BY Salary;
 
-- Attrition overview
SELECT Attrition, COUNT(DISTINCT Employee_ID) AS Employees 
FROM project.adviti_hr_data 
GROUP BY Attrition;
 
-- Missing values check
SELECT 
    SUM(CASE WHEN Employee_ID IS NULL OR Employee_ID = '' THEN 1 ELSE 0 END) AS Employee_ID_Missing,
    SUM(CASE WHEN Employee_Name IS NULL OR Employee_Name = '' THEN 1 ELSE 0 END) AS Employee_Name_Missing,
    SUM(CASE WHEN Age IS NULL OR Age = '' THEN 1 ELSE 0 END) AS Age_Missing,
    SUM(CASE WHEN Years_of_Service IS NULL OR Years_of_Service = '' THEN 1 ELSE 0 END) AS Years_Missing,
    SUM(CASE WHEN Position IS NULL OR Position = '' THEN 1 ELSE 0 END) AS Position_Missing,
    SUM(CASE WHEN Gender IS NULL OR Gender = '' THEN 1 ELSE 0 END) AS Gender_Missing,
    SUM(CASE WHEN Department IS NULL OR Department = '' THEN 1 ELSE 0 END) AS Department_Missing
FROM project.adviti_hr_data;
 
 
-- ============================================================
-- PHASE 2: DATA CLEANING — CREATE ANALYSIS TABLE
-- ============================================================
 
DROP TABLE IF EXISTS project.adviti_hr_data_analysis;
 
CREATE TABLE project.adviti_hr_data_analysis AS
SELECT 
    Employee_ID,
    Employee_Name,
    Age,
    CASE
        WHEN Age BETWEEN 21 AND 25 THEN '21-25'
        WHEN Age BETWEEN 26 AND 30 THEN '26-30'
        WHEN Age BETWEEN 31 AND 35 THEN '31-35'
        WHEN Age BETWEEN 36 AND 40 THEN '36-40'
        WHEN Age BETWEEN 41 AND 45 THEN '41-45'
        WHEN Age BETWEEN 46 AND 50 THEN '46-50'
        ELSE '<=20'
    END AS AgeGroup,
    Years_of_Service,
    Position,
    CASE
        WHEN Position IN ('Account Exec.', 'Account Executive', 'AccountExec.', 'AccountExecutive') THEN 'Account Executive'
        WHEN Position IN ('Content Creator', 'Creator') THEN 'Content Creator'
        WHEN Position IN ('DataAnalyst', ' Data Analyst') THEN 'Data Analyst'
        WHEN Position IN (' Analytics Intern', 'Intern', 'SE Interns') THEN 'Interns'
        ELSE Position
    END AS Position_Updated,
    IF(Gender = 'M', 'Male', IF(Gender = 'F', 'Female', Gender)) AS Gender_Updated,
    CASE WHEN Department = '' THEN 'Management' ELSE Department END AS Department,
    Salary,
    CASE
        WHEN Salary >= 5000000 THEN '> 50L'
        WHEN Salary >= 4000000 THEN '40L - 50L'
        WHEN Salary >= 3000000 THEN '30L - 40L'
        WHEN Salary >= 2000000 THEN '20L - 30L'
        WHEN Salary >= 1000000 THEN '10L - 20L'
        ELSE '< 10L'
    END AS Salary_Buckets,
    Performance_Rating,
    Work_Hours,
    Attrition,
    Promotion,
    Training_Hours,
    CASE
        WHEN Training_Hours >= 40 THEN '40+ Hours'
        WHEN Training_Hours >= 30 THEN '30 - 40 Hours'
        WHEN Training_Hours >= 20 THEN '20 - 30 Hours'
        WHEN Training_Hours >= 10 THEN '10 - 20 Hours'
        ELSE '< 10 Hours'
    END AS Training_Hours_Buckets,
    Satisfaction_Score,
    Education_Level,
    Employee_Engagement_Score,
    Absenteeism,
    CASE
        WHEN Absenteeism = 0 THEN 'No Leaves'
        WHEN Absenteeism BETWEEN 1 AND 5 THEN '1-5 days'
        WHEN Absenteeism BETWEEN 6 AND 10 THEN '6-10 days'
        WHEN Absenteeism BETWEEN 11 AND 15 THEN '11-15 days'
        ELSE '15+ days'
    END AS Absenteeism_Buckets,
    Distance_from_Work,
    CASE
        WHEN Distance_from_Work >= 40 THEN '40+ Kms'
        WHEN Distance_from_Work >= 30 THEN '30 - 40 Kms'
        WHEN Distance_from_Work >= 20 THEN '20 - 30 Kms'
        WHEN Distance_from_Work >= 10 THEN '10 - 20 Kms'
        ELSE '< 10 Kms'
    END AS Distance_from_Work_Buckets,
    JobSatisfaction_PeerRelationship,
    JobSatisfaction_WorkLifeBalance,
    JobSatisfaction_Compensation,
    JobSatisfaction_Management,
    JobSatisfaction_JobSecurity,
    (JobSatisfaction_PeerRelationship +
     JobSatisfaction_WorkLifeBalance +
     JobSatisfaction_Compensation +
     JobSatisfaction_Management +
     JobSatisfaction_JobSecurity) / 5 * 100 AS JobSatisfaction_Rate,
    EmployeeBenefit_HealthInsurance,
    EmployeeBenefit_PaidLeave,
    EmployeeBenefit_RetirementPlan,
    EmployeeBenefit_GymMembership,
    EmployeeBenefit_ChildCare,
    (EmployeeBenefit_HealthInsurance +
     EmployeeBenefit_PaidLeave +
     EmployeeBenefit_RetirementPlan +
     EmployeeBenefit_GymMembership +
     EmployeeBenefit_ChildCare) / 5 * 100 AS EmployeeBenefit_Satisfaction_Rate
FROM project.adviti_hr_data;
 
 
-- ============================================================
-- PHASE 3: ATTRITION ANALYSIS
-- ============================================================
 
-- Overall attrition rate
SELECT
    COUNT(Employee_ID) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Yes,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Attrition_No,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns';
-- Finding: Overall attrition rate is 48% — alarmingly high
 
-- Attrition by gender
SELECT Gender_Updated,
    COUNT(Employee_ID) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY Gender_Updated;
-- Finding: Gender has no significant effect on attrition
 
-- Attrition by position
SELECT Position_Updated,
    COUNT(Employee_ID) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY Position_Updated
ORDER BY Attrition_Rate DESC;
 
-- Attrition by department
SELECT Department,
    COUNT(Employee_ID) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY Department
ORDER BY Attrition_Rate DESC;
 
-- Attrition by salary bucket
SELECT Salary_Buckets,
    COUNT(Employee_ID) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY Salary_Buckets
ORDER BY MIN(Salary);
-- Finding: Lowest salary band has highest attrition
 
-- Attrition by promotion
SELECT Promotion,
    COUNT(Employee_ID) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY Promotion
ORDER BY Attrition_Rate DESC;
 
-- Attrition by distance from work
SELECT Distance_from_Work_Buckets,
    COUNT(Employee_ID) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY Distance_from_Work_Buckets
ORDER BY Attrition_Rate DESC;
-- Finding: Employees living 40+ km away have highest attrition
 
-- Attrition by age group
SELECT AgeGroup,
    COUNT(Employee_ID) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY AgeGroup
ORDER BY Attrition_Rate DESC;
 
-- Attrition by years of service
SELECT Years_of_Service,
    COUNT(Employee_ID) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY Years_of_Service
ORDER BY Years_of_Service;
 
-- Attrition by satisfaction score
SELECT Satisfaction_Score,
    COUNT(Employee_ID) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY Satisfaction_Score
ORDER BY Satisfaction_Score;
 
-- Attrition by absenteeism
SELECT Absenteeism_Buckets,
    COUNT(Employee_ID) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY Absenteeism_Buckets
ORDER BY Attrition_Rate DESC;
 
-- Attrition by training hours
SELECT Training_Hours_Buckets,
    COUNT(Employee_ID) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY Training_Hours_Buckets
ORDER BY Attrition_Rate DESC;
-- Finding: Less than 10 training hours = highest attrition
 
-- Attrition by engagement score
SELECT Employee_Engagement_Score,
    COUNT(Employee_ID) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY Employee_Engagement_Score
ORDER BY Employee_Engagement_Score;
-- Finding: Low engagement score is the strongest predictor of attrition
 
 
-- ============================================================
-- PHASE 4: MULTI-FACTOR & ADVANCED ANALYSIS
-- ============================================================
 
-- Department + Engagement + Satisfaction + Attrition combined
SELECT Department,
    ROUND(AVG(Employee_Engagement_Score), 2) AS Avg_Engagement,
    ROUND(AVG(Satisfaction_Score), 2) AS Avg_Satisfaction,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY Department
ORDER BY Attrition_Rate DESC;
 
-- Training vs promotion and performance
SELECT Training_Hours_Buckets,
    ROUND(AVG(Performance_Rating), 2) AS Avg_Performance,
    ROUND(SUM(CASE WHEN Promotion = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Promotion_Rate
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY Training_Hours_Buckets;
 
-- Employees above their department average salary (CTE)
WITH dept_avg AS (
    SELECT Department,
        AVG(Salary) AS Avg_Salary
    FROM project.adviti_hr_data_analysis
    WHERE Position_Updated <> 'Interns'
    GROUP BY Department
)
SELECT 
    e.Employee_ID,
    e.Employee_Name,
    e.Department,
    e.Salary,
    ROUND(d.Avg_Salary, 0) AS Dept_Avg_Salary
FROM project.adviti_hr_data_analysis e
JOIN dept_avg d ON e.Department = d.Department
WHERE e.Salary > d.Avg_Salary
ORDER BY e.Department;
 
-- Top 2 earners per department (Window Function)
WITH ranked AS (
    SELECT 
        Employee_ID,
        Employee_Name,
        Department,
        Salary,
        DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS Salary_Rank
    FROM project.adviti_hr_data_analysis
    WHERE Position_Updated <> 'Interns'
)
SELECT * FROM ranked
WHERE Salary_Rank <= 2;
 
-- Departments where attrition rate is above company average (Subquery)
SELECT 
    Department,
    COUNT(Employee_ID) AS Total_Employees,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate,
    ROUND(AVG(Employee_Engagement_Score), 2) AS Avg_Engagement,
    ROUND(AVG(Satisfaction_Score), 2) AS Avg_Satisfaction
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY Department
HAVING Attrition_Rate > (
    SELECT ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2)
    FROM project.adviti_hr_data_analysis
    WHERE Position_Updated <> 'Interns'
)
ORDER BY Attrition_Rate DESC;
 
 
-- ============================================================
-- EXECUTIVE SUMMARY — Top attrition risk factors by department
-- ============================================================
SELECT 
    Department,
    COUNT(Employee_ID) AS Total_Employees,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(Employee_ID), 2) AS Attrition_Rate,
    ROUND(AVG(Employee_Engagement_Score), 2) AS Avg_Engagement,
    ROUND(AVG(Satisfaction_Score), 2) AS Avg_Satisfaction,
    ROUND(AVG(Salary), 0) AS Avg_Salary
FROM project.adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'
GROUP BY Department
ORDER BY Attrition_Rate DESC;
 
 
-- ============================================================
-- KEY FINDINGS
-- ============================================================
-- 1. Overall attrition rate: 48% — alarmingly high
-- 2. Low engagement score is the strongest predictor of attrition
-- 3. Employees with less than 10 training hours have highest attrition
-- 4. Employees living 40+ km away show higher attrition
-- 5. Low salary bucket (< 10L) has highest attrition rate
-- 6. Gender has no significant effect on attrition
--
-- RECOMMENDATIONS:
-- 1. Invest in engagement programmes in high-attrition departments
-- 2. Mandate minimum 20 training hours per employee per year
-- 3. Introduce remote work or transport allowance for 40+ km employees
-- 4. Review salary bands — low earners are leaving at the highest rate
-- 5. Tie promotion reviews to tenure milestones to reward loyalty
-- ============================================================
 
CREATE DATABASE hr_db;

USE hr_db;

SHOW TABLES;

DESC general_data;
DESC employee_survey_data;
DESC manager_survey_data;

# Retrieve the total number of employees in the dataset
SELECT COUNT(EmployeeID) AS Total_employees FROM employee_survey_data;

# List all unique job roles in the dataset
SELECT DISTINCT JobRole FROM general_data;

# Find the average age of employees
SELECT round(avg(Age),2) AS Avg_employee_age FROM general_data;

# Retrieve the names and ages of employees who have worked at the company for more than 5 years
SELECT EmpName, Age FROM general_data
WHERE YearsAtCompany > 5;

# Get a count of employees grouped by their department
SELECT Department, count(EmployeeID) AS No_of_Employees FROM general_data
GROUP BY Department;

# List employees who have 'High' Job Satisfaction
SELECT employee_survey_data.EmployeeID, general_data.EmpName FROM employee_survey_data
INNER JOIN general_data
ON employee_survey_data.EmployeeID = general_data.EmployeeID
WHERE JobSatisfaction = 4;


# Find the highest Monthly Income in the dataset
SELECT EmpName, MonthlyIncome FROM general_data
ORDER BY MonthlyIncome desc
Limit 1;


# List employees who have 'Travel_Rarely' as their BusinessTravel type
SELECT EmpName FROM general_data
WHERE BusinessTravel = "Travel_Rarely";


# Retrieve the distinct MaritalStatus categories in the dataset
SELECT DISTINCT MaritalStatus, count(EmployeeID) AS No_of_Employees FROM general_data
GROUP BY MaritalStatus;


# Get a list of employees with more than 2 years of work experience but less than 4 years in their current role
SELECT EmpName FROM general_data
WHERE TotalWorkingYears > 2 AND TotalWorkingYears < 4;


# Find the average distance from home for employees in each department
SELECT Department, round(avg(DistanceFromHome),3) AS Avg_DistanceFromHome FROM general_data
GROUP BY Department;


# Retrieve the top 5 employees with the highest MonthlyIncome
SELECT EmployeeID, EmpName, MonthlyIncome FROM general_data
ORDER BY MonthlyIncome DESC
LIMIT 5;


# Calculate the percentage of employees who have had a promotion in the last year
SELECT COUNT(*) FROM general_data;    #Total number of employees

SELECT COUNT(*) FROM general_data
WHERE YearsSinceLastPromotion = 0;    #no. of employees who have had a promotion in the last year

SELECT                                #This Outer SELECT statement is used to retrieve the calculated % and labeeled it as %PromotedLastYear
(SELECT COUNT(*) FROM general_data
WHERE YearsSinceLastPromotion = 0) * 100.0 / (SELECT COUNT(*) FROM general_data) AS PercentagePromotedLastYear;


# List the employees with the highest and lowest EnvironmentSatisfaction
SELECT g.EmpName, e.EnvironmentSatisfaction 
FROM general_data AS g
INNER JOIN employee_survey_data AS e
ON g.EmployeeID = e.EmployeeID
WHERE e.EnvironmentSatisfaction = (SELECT max(EnvironmentSatisfaction) FROM employee_survey_data)
OR 
e.EnvironmentSatisfaction = (SELECT min(EnvironmentSatisfaction) FROM employee_survey_data);


# Find the employees who have the same JobRole and MaritalStatus
SELECT e1.EmpName, e1.JobRole, e1.MaritalStatus 
FROM general_data e1, general_data e2
WHERE e1.JobRole = e2.JobRole 
AND e1.MaritalStatus = e2.MaritalStatus
AND e1.EmployeeID != e2.EmployeeID;


# List the employees with the highest TotalWorkingYears who also have a PerformanceRating of 4
SELECT g.EmpName, g.TotalWorkingYears, m.PerformanceRating 
FROM general_data AS g
INNER JOIN manager_survey_data AS m
ON g.EmployeeID = m.EmployeeID
WHERE m.PerformanceRating = 4
AND g.TotalWorkingYears = (
    SELECT MAX(g.TotalWorkingYears)
    FROM general_data AS g
    INNER JOIN manager_survey_data AS m
    ON g.EmployeeID = m.EmployeeID
    WHERE m.PerformanceRating = 4    #ensures that the maximum TotalWorkingYears is calculated only for employees with a PR of 4
);


# Calculate the average Age and JobSatisfaction for each BusinessTravel type.
SELECT g.BusinessTravel, round(avg(g.Age),2) AS Avg_age, round(avg(e.JobSatisfaction),2) AS AvgJobSatisfaction
FROM general_data AS g
INNER JOIN employee_survey_data AS e
ON g.EmployeeID = e.EmployeeID
GROUP BY BusinessTravel;


# Retrieve the most common EducationField among employees
SELECT EducationField, count(*) AS Count FROM general_data
GROUP BY EducationField
ORDER BY count(*) > 1 desc, EducationField;


# List the employees who have worked for the company the longest but haven't had a promotion
SELECT EmpName, TotalWorkingYears, YearsSinceLastPromotion
FROM general_data
WHERE YearsSinceLastPromotion = 0
AND TotalWorkingYears = (
    SELECT MAX(TotalWorkingYears)
    FROM general_data
    WHERE YearsSinceLastPromotion = 0    
);

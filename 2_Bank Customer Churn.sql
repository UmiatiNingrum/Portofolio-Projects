-- -------------------------------------- BANK CUSTOMER CHURN ----------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- ------------------------------------ Create Database dan Table ------------------------------------------
-- Create a Database
CREATE DATABASE project_portofolio;

-- Use a Database
USE project_portofolio;

-- Create a Table
CREATE TABLE bank_customer_churn
(
	RowNumber INT,
    CustomerId INT,
    Surname VARCHAR(50),
    CreditScore INT,
    Geography VARCHAR(20),
    Gender VARCHAR(10),
    Age INT,
    Tenure INT,
    Balance DECIMAL(10,2),
    NumOfProducts INT,
    HasCrCard INT,
    IsActiveMember INT,
    EstimatedSalary DECIMAL(10,2),
    Exited INT,
    Complain INT,
    SatisfactionScore INT,
    CardType VARCHAR(20),
    PointEarned INT
);

-- Insert data
SET GLOBAL LOCAL_INFILE = 1;

LOAD DATA LOCAL INFILE 'D:/BELAJAR DATAN/Portofolio/SQL + Power BI/Customer-Churn-Records.csv'
INTO TABLE bank_customer_churn
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


-- -------------------------------------------------------------------------------------------------------
-- --------------------------------------- Query Data ----------------------------------------------------
SELECT * FROM bank_customer_churn;

-- ----- Data Quality Check -----

-- Check for Duplicates
SELECT 	CustomerId, 
		COUNT(*) AS Total
FROM bank_customer_churn
GROUP BY CustomerId
HAVING Total > 1;

-- Check for Missing Values
SELECT	SUM(RowNumber IS NULL) AS Missing_RowNumber,
		SUM(CustomerId IS NULL) AS Missing_CustomerId,
		SUM(Surname IS NULL) AS Missing_Surname,
		SUM(CreditScore IS NULL) AS Missing_CreditScore,
		SUM(Geography IS NULL) AS Missing_Geography,
		SUM(Gender IS NULL) AS Missing_Gender,
		SUM(Age IS NULL) AS Missing_Age,
		SUM(Tenure IS NULL) AS Missing_Tenure,
		SUM(Balance IS NULL) AS Missing_Balance,
		SUM(NumOfProducts IS NULL) AS Missing_NumOfProducts,
		SUM(HasCrCard IS NULL) AS Missing_HasCrCard,
		SUM(IsActiveMember IS NULL) AS Missing_IsActiveMember,
		SUM(EstimatedSalary IS NULL) AS Missing_EstimatedSalary,
		SUM(Exited IS NULL) AS Missing_Exited,
		SUM(Complain IS NULL) AS Missing_Complain,
		SUM(SatisfactionScore IS NULL) AS Missing_SatisfactionScore,
		SUM(CardType IS NULL) AS Missing_CardType,
		SUM(PointEarned IS NULL) AS Missing_PointEarned
FROM bank_customer_churn;


-- ----- Exploratory Data Analysis (EDA) -----

-- 1. Customer Churn Overview
SELECT 	COUNT(*) AS Total_Customers,
		SUM(Exited) AS Churned_Customers,
		ROUND((SUM(Exited) / COUNT(*)) * 100, 2) AS Churn_Rate_Percent
FROM bank_customer_churn;

-- 2. Demographic & Financial Profile
-- 2.1 Customer Churn by Geography
SELECT	Geography,
		COUNT(*) AS Total_Customers,
		SUM(Exited) AS Churned_Customers,
		(SUM(Exited) / COUNT(*)) * 100 AS Churn_Rate_Percent
FROM bank_customer_churn
GROUP BY Geography
ORDER BY Churn_Rate_Percent DESC;

-- 2.2 Customer Churn by Gender
SELECT	Gender,
		COUNT(*) AS Total_Customers,
		SUM(Exited) AS Churned_Customers,
		(SUM(Exited) / COUNT(*)) * 100 AS Churn_Rate_Percent
FROM bank_customer_churn
GROUP BY Gender
ORDER BY Churn_Rate_Percent DESC;

-- 2.3 Customer Churn by Age
SELECT	(CASE
			WHEN Age BETWEEN 18 AND 29 THEN '18-29'
			WHEN Age BETWEEN 30 AND 39 THEN '30-39'
			WHEN Age BETWEEN 40 AND 49 THEN '40-49'
			WHEN Age BETWEEN 50 AND 59 THEN '50-59'
			WHEN Age BETWEEN 60 AND 69 THEN '60-69'
			WHEN Age BETWEEN 70 AND 79 THEN '70-79'
			ELSE '80-92'
		END) AS Age_Group,
		COUNT(*) AS Total_Customers,
		SUM(Exited) AS Churned_Customers,
		(SUM(Exited) / COUNT(*)) * 100 AS Churn_Rate_Percent
FROM bank_customer_churn
GROUP BY Age_Group
ORDER BY Churn_Rate_Percent DESC;

-- 2.4 Customer Churn by Credit Score
SELECT	(CASE 
			WHEN CreditScore < 580 THEN 'Poor (300-579)'
			WHEN CreditScore BETWEEN 580 AND 669 THEN 'Fair(580-669)'
			WHEN CreditScore BETWEEN 670 AND 739 THEN 'Good (670-739)'
			WHEN CreditScore BETWEEN 740 AND 799 THEN 'Very Good (740-799)'
			ELSE 'Exceptional (800-850)'
		END) AS CreditScore_Group,
		COUNT(*) AS Total_Customers,
		SUM(Exited) AS Churned_Customers,
		(SUM(Exited) / COUNT(*)) * 100 AS Churn_Rate_Percent
FROM bank_customer_churn
GROUP BY CreditScore_Group
ORDER BY Churn_Rate_Percent DESC;

-- 2.5 Customer Churn by Estimated Salary
SELECT	(CASE
			WHEN EstimatedSalary <= 50000 THEN '<=50K'
			WHEN EstimatedSalary BETWEEN 50001 AND 100000 THEN '50K–100K'
			WHEN EstimatedSalary BETWEEN 100001 AND 150000 THEN '100K–150K'
			ELSE '150K+'
		END) AS EstimatedSalary_Group,
		COUNT(*) AS Total_Customers,
		SUM(Exited) AS Churned_Customers,
		(SUM(Exited) / COUNT(*)) * 100 AS Churn_Rate_Percent
FROM bank_customer_churn
GROUP BY EstimatedSalary_Group
ORDER BY Churn_Rate_Percent DESC;

-- 3. Product & Account Usage
-- 3.1 Customer Churn by Num Of Products
SELECT	NumOfProducts,
		COUNT(*) AS Total_Customers,
		SUM(Exited) AS Churned_Customers,
        (SUM(Exited) / COUNT(*)) * 100 AS Churn_Rate_Percent
FROM bank_customer_churn
GROUP BY NumOfProducts
ORDER BY Churn_Rate_Percent DESC;

-- 3.2 Customer Churn by Balance
SELECT	(CASE
			WHEN Balance = 0 THEN 'No Balance (0)'
			WHEN Balance BETWEEN 1 AND 50000 THEN '<=50K'
			WHEN Balance BETWEEN 50001 AND 100000 THEN '50K–100K'
			WHEN Balance BETWEEN 100001 AND 150000 THEN '100K–150K'
			WHEN Balance BETWEEN 150001 AND 200000 THEN '150K–200K'
			ELSE '200K+'
		END) AS Balance_Group,
		COUNT(*) AS Total_Customers,
		SUM(Exited) AS Churned_Customers,
		(SUM(Exited) / COUNT(*)) * 100 AS Churn_Rate_Percent
FROM bank_customer_churn
GROUP BY Balance_Group
ORDER BY Churn_Rate_Percent DESC;

-- 5.3 Customer Churn by Has Cr Card
SELECT 	HasCrCard, 
		COUNT(*) AS Total_Customers,
		SUM(Exited) AS Churned_Customers,
        (SUM(Exited) / COUNT(*)) * 100 AS Churn_Rate_Percent
FROM bank_customer_churn
GROUP BY HasCrCard
ORDER BY Churn_Rate_Percent DESC;

-- 5.4 Customer Churn by Card Type 
SELECT 	CardType, 
		COUNT(*) AS Total_Customers,
		SUM(Exited) AS Churned_Customers,
        (SUM(Exited) / COUNT(*)) * 100 AS Churn_Rate_Percent
FROM bank_customer_churn
GROUP BY CardType
ORDER BY Churn_Rate_Percent DESC;

-- 4. Customer Engagement & Feedback
-- 4.1 Customer Churn by Is Active Member
SELECT 	IsActiveMember, 
		COUNT(*) AS Total_Customers,
		SUM(Exited) AS Churned_Customers,
        (SUM(Exited) / COUNT(*)) * 100 AS Churn_Rate_Percent
FROM bank_customer_churn
GROUP BY IsActiveMember
ORDER BY Churn_Rate_Percent DESC;

-- 4.2 Customer Churn by Tenure
SELECT	Tenure,
		COUNT(*) AS Total_Customers,
		SUM(Exited) AS Churned_Customers,
        (SUM(Exited) / COUNT(*)) * 100 AS Churn_Rate_Percent
FROM bank_customer_churn
GROUP BY Tenure
ORDER BY Churn_Rate_Percent DESC;

-- 4.3 Customer Churn by Complain
SELECT 	Complain, 
		COUNT(*) AS Total_Customers,
		SUM(Exited) AS Churned_Customers,
        (SUM(Exited) / COUNT(*)) * 100 AS Churn_Rate_Percent
FROM bank_customer_churn
GROUP BY Complain
ORDER BY Churn_Rate_Percent DESC;

-- 4.4 Customer Churn by SatisfactionScore 
SELECT 	SatisfactionScore,
		COUNT(*) AS Total_Customers, 
		SUM(Exited) AS Churned_Customers,
        (SUM(Exited) / COUNT(*)) * 100 AS Churn_Rate_Percent
FROM bank_customer_churn
GROUP BY SatisfactionScore
ORDER BY Churn_Rate_Percent DESC;

-- 4.5 Customer Churn by PointEarned
SELECT	(CASE 
			WHEN PointEarned <= 200 THEN '<=200'
			WHEN PointEarned BETWEEN 201 AND 400 THEN '200–400'
			WHEN PointEarned BETWEEN 401 AND 600 THEN '400–600'
			WHEN PointEarned BETWEEN 601 AND 800 THEN '600–800'
			ELSE '800-1000'
		END) AS PointEarned_Group,
		COUNT(*) AS Total_Customers,
		SUM(Exited) AS Churned_Customers,
		(SUM(Exited) / COUNT(*)) * 100 AS Churn_Rate_Percent
FROM bank_customer_churn
GROUP BY PointEarned_Group
ORDER BY Churn_Rate_Percent DESC;






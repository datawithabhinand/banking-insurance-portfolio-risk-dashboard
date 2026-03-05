
Project: Banking & Insurance Portfolio Risk Analysis
Author: Abhinand P P
Tools Used: PostgreSQL, Power BI
Dataset: Simulated dataset of 500 customer financial profiles

Description:
This SQL script contains the analysis queries used to explore customer financial profiles,
insurance portfolio behaviour, credit risk exposure, and churn risk patterns.

The insights from these queries were later visualized in a Power BI dashboard.




SELECT current_database();


CREATE TABLE customer_financial_profile (
  customer_id INT,
  age INT,
  gender TEXT,
  annual_income TEXT,
  credit_score INT,
  account_tenure_years NUMERIC(4,1),
  avg_monthly_balance TEXT,
  missed_payments INT,
  loan_type TEXT,
  loan_amount TEXT,
  insurance_type TEXT,
  annual_premium TEXT,
  policy_tenure_years NUMERIC(4,1),
  claims_count INT,
  total_claim_amount TEXT,
  customer_risk_score INT,
  churn_risk TEXT,
  customer_segment TEXT
);


SELECT COUNT(*) 
FROM customer_financial_profile;


SELECT *
FROM customer_financial_profile
LIMIT 5;


SELECT 
COUNT(*) AS TOTAL_CUSTOMERS,
AVG(AGE) AS AVERAGE_AGE
FROM CUSTOMER_FINANCIAL_PROFILE;

-- (THIS QUERY GIVES US A HIGH-LEVEL OVERVIEW OF 
THE CUSTOMER BASE BY CALCULATING THE TOTAL NUMBER OF CUSTOMERS AND THE AVERAGE AGE ACROSS THE ENTIRE PORTFOLIO)


SELECT 
COUNT(*) AS TOTAL_CUSTOMERS,
AVG(AGE) AS AVERAGE_AGE,
AVG(CREDIT_SCORE) AS AVERAGE_CREDIT_SCORE
FROM CUSTOMER_FINANCIAL_PROFILE;

-- This query provides a high-level demographic and financial snapshot of the customer portfolio by 
summarizing the total number of customers, their average age and their average credit score. 


SELECT 
CUSTOMER_SEGMENT,
COUNT(*) AS CUSTOMER_COUNT
FROM CUSTOMER_FINANCIAL_PROFILE
GROUP BY CUSTOMER_SEGMENT;

--- This query breaks down the customer portfolio by customer segment and shows how many customers fall into each segment.

SELECT
  CUSTOMER_SEGMENT,
  ROUND(AVG(REPLACE(REPLACE(AVG_MONTHLY_BALANCE, '$', ''), ',', '')::NUMERIC), 2) AS AVG_BALANCE
FROM CUSTOMER_FINANCIAL_PROFILE
GROUP BY CUSTOMER_SEGMENT
ORDER BY AVG_BALANCE DESC;

----This query calculates the average monthly balance for each customer segment (High/Medium/Low Value) to understand 
whether higher-value segments actually hold higher balances.

SELECT INSURANCE_TYPE,
ROUND(AVG(REPLACE(REPLACE(ANNUAL_PREMIUM,'$', ''), ',', '')::NUMERIC),2) AS AVG_ANNUAL_PREMIUM
FROM CUSTOMER_FINANCIAL_PROFILE
GROUP BY INSURANCE_TYPE
ORDER BY AVG_ANNUAL_PREMIUM DESC;

---- This query calculates the average annual insurance premium for each insurance product type.


SELECT 
INSURANCE_TYPE, 
COUNT(*) AS TOTAL_CUSTOMERS,
SUM(CASE WHEN CLAIMS_COUNT>0 THEN 1 ELSE 0 END)AS CUSTOMER_WITH_CLAIMS, 
ROUND(AVG(CLAIMS_COUNT),2) AS AVG_CLAIMS_COUNT,
ROUND(AVG(REPLACE(REPLACE(TOTAL_CLAIM_AMOUNT,'$', ''), ',', '')::NUMERIC),2) AS AVG_TOTAL_CLAIM_AMOUNT
FROM CUSTOMER_FINANCIAL_PROFILE
GROUP BY INSURANCE_TYPE
ORDER BY AVG_TOTAL_CLAIM_AMOUNT DESC;

----This query summarizes claims behaviour by insurance type. It counts total customers, 
counts how many have at least one claim, calculates average claim frequency, and calculates the average claim amount


SELECT 
CHURN_RISK, 
COUNT(*) AS CUSTOMERS,
ROUND(AVG(CUSTOMER_RISK_SCORE),1) AS AVG_RISK_SCORE
FROM CUSTOMER_FINANCIAL_PROFILE
GROUP BY CHURN_RISK
ORDER BY AVG_RISK_SCORE DESC;

-----This query analyzes customer churn risk levels and shows how they relate to the average customer risk score, 
helping identify whether higher-risk customers are more likely to churn.


SELECT 
CUSTOMER_SEGMENT,
COUNT(*) AS CUSTOMERS,
ROUND(AVG(CUSTOMER_RISK_SCORE),1) AS AVG_RISK_SCORE
FROM CUSTOMER_FINANCIAL_PROFILE
GROUP BY CUSTOMER_SEGMENT
ORDER BY AVG_RISK_SCORE;


----This query analyzes customer risk scores across different customer value segments to understand 
whether higher-value customers also carry higher or lower risk.

----High Risk %

SELECT
  ROUND(100.0 * SUM(CASE WHEN customer_risk_score >= 70 THEN 1 ELSE 0 END) / COUNT(*), 1) AS high_risk_pct
FROM customer_financial_profile;


-----High churn % by customer segment

SELECT
  customer_segment,
  ROUND(100.0 * SUM(CASE WHEN churn_risk = 'High' THEN 1 ELSE 0 END) / COUNT(*), 1) AS high_churn_pct
FROM customer_financial_profile
GROUP BY customer_segment
ORDER BY high_churn_pct DESC;


----Correlation-style insight: missed payments vs churn

SELECT
  churn_risk,
  ROUND(AVG(missed_payments), 2) AS avg_missed_payments
FROM customer_financial_profile
GROUP BY churn_risk
ORDER BY avg_missed_payments DESC;




USE banking_analytics;


-- 1. Calculate Banking KPIs
SELECT
    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,

    SUM(CASE WHEN IsActiveMember = 1 THEN 1 ELSE 0 END)
        AS active_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage,

    ROUND(SUM(Balance), 2)
        AS total_customer_balance

FROM customer_churn;

-- Business insight: Approximately 1 in 5 customers in this dataset have left the bank. This makes customer retention an important area for our dashboard.


-- 2. Analyze customer churn by country
SELECT
    Geography AS country,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage
FROM customer_churn
GROUP BY Geography
ORDER BY churn_rate_percentage DESC;

-- Business insight
-- Germany has the highest customer churn rate at 32.44%, approximately twice the rate of France and Spain.
-- This suggests that the bank should investigate customer retention in Germany. However, the dataset alone doesn't establish why those customers left.


-- 3. Analyze customer churn by gender
SELECT
    Gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage
FROM customer_churn
GROUP BY Gender
ORDER BY churn_rate_percentage DESC;

-- Business insight: Female customers have an 8.60 percentage-point higher churn rate than male customers in this dataset.
-- This difference is worth investigating, but it doesn't establish the cause.


-- 4. Analyze customer churn by age group
SELECT
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 40 THEN '31-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        WHEN Age BETWEEN 51 AND 60 THEN '51-60'
        ELSE '61+'
    END AS age_group,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage

FROM customer_churn

GROUP BY age_group

ORDER BY churn_rate_percentage DESC;

-- Business insight: Customers aged 51–60 have the highest churn rate at 56.21%.
-- This group deserves closer investigation to understand possible retention issues. Age alone does not explain the cause.


-- 5. Analyze churn by credit score
SELECT
    CASE
        WHEN CreditScore < 500 THEN 'Below 500'
        WHEN CreditScore < 600 THEN '500-599'
        WHEN CreditScore < 700 THEN '600-699'
        WHEN CreditScore < 800 THEN '700-799'
        ELSE '800+'
    END AS credit_score_group,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage

FROM customer_churn
GROUP BY credit_score_group
ORDER BY churn_rate_percentage DESC;

-- Business insight: Customers with credit scores below 500 have the highest churn rate (23.73%).
-- However, differences across credit score groups are relatively modest compared with those across age groups.


-- 6. Analyze churn by account balance
SELECT
    CASE
        WHEN Balance = 0 THEN 'Zero Balance'
        WHEN Balance < 50000 THEN 'Below 50K'
        WHEN Balance < 100000 THEN '50K-100K'
        WHEN Balance < 150000 THEN '100K-150K'
        ELSE '150K+'
    END AS balance_group,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage

FROM customer_churn
GROUP BY balance_group
ORDER BY churn_rate_percentage DESC;

-- Business insight: Customers with nonzero balances below 50K have the highest observed churn rate (34.67%), but this group contains only 75 customers.
-- The 100K–150K group is a larger segment with a relatively high churn rate of 25.77%, making it worth investigating.


-- 7. Analyze churn by banking products
SELECT
    NumOfProducts AS number_of_products,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage

FROM customer_churn
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

-- Business insight: Customers holding two products have the lowest churn rate (7.60%). Customers holding three or four products show unusually high churn,
-- which deserves further investigation. These results show an association, not proof that having more products causes churn.


-- 8. Customer Activity vs Churn
SELECT
    CASE
        WHEN IsActiveMember = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS activity_status,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage

FROM customer_churn
GROUP BY IsActiveMember
ORDER BY churn_rate_percentage DESC;

-- Business insight: Inactive customers have approximately 1.88 times the churn rate of active customers.
-- This suggests customer engagement is an important factor to investigate when developing retention strategies.


-- 9. Credit Card Ownership vs Customer Churn
SELECT
    CASE
        WHEN HasCrCard = 1 THEN 'Has Credit Card'
        ELSE 'No Credit Card'
    END AS credit_card_status,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage

FROM banking_analytics.customer_churn
GROUP BY HasCrCard
ORDER BY churn_rate_percentage DESC;

-- Business insight: The churn rates differ by only 0.61 percentage points.
-- Credit card ownership alone does not appear to be a strong indicator of customer churn in this dataset.


-- 10. Customer Tenure vs Churn
SELECT
    CASE
        WHEN Tenure BETWEEN 0 AND 2 THEN '0-2 Years'
        WHEN Tenure BETWEEN 3 AND 5 THEN '3-5 Years'
        WHEN Tenure BETWEEN 6 AND 8 THEN '6-8 Years'
        ELSE '9-10 Years'
    END AS tenure_group,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage

FROM banking_analytics.customer_churn

GROUP BY tenure_group
ORDER BY churn_rate_percentage DESC;

-- Business insight: Customer churn rates remain relatively similar across tenure groups (18.87%–21.37%).
-- This suggests tenure alone is not a strong indicator of churn in this dataset.


-- 11. Estimated Salary vs Customer Churn
SELECT
    CASE
        WHEN EstimatedSalary < 50000 THEN 'Below 50K'
        WHEN EstimatedSalary < 100000 THEN '50K-100K'
        WHEN EstimatedSalary < 150000 THEN '100K-150K'
        ELSE '150K+'
    END AS salary_group,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage

FROM banking_analytics.customer_churn

GROUP BY salary_group
ORDER BY churn_rate_percentage DESC;

-- Business insight: Churn rates are fairly similar across salary groups, ranging from 19.87% to 21.51%.
-- Estimated salary alone appears to have limited value for identifying customers at risk of leaving.


-- 12. Customer Complaints vs Churn
SELECT
    CASE
        WHEN Complain = 1 THEN 'Has Complaint'
        ELSE 'No Complaint'
    END AS complaint_status,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage

FROM banking_analytics.customer_churn

GROUP BY Complain
ORDER BY churn_rate_percentage DESC;

-- Business insight: Complaint status is almost perfectly associated with customer churn in this dataset.


-- 13. Customer Satisfaction vs Churn
SELECT
    `Satisfaction Score` AS satisfaction_score,
    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage

FROM banking_analytics.customer_churn

GROUP BY `Satisfaction Score`
ORDER BY `Satisfaction Score`; 

-- Business insight: Churn rates are relatively similar across satisfaction scores, ranging from 19.64% to 21.80%.
-- This suggests satisfaction score alone is not a strong indicator of churn in this dataset.


-- 14. Customer Churn by Complaints and Activity
SELECT
    CASE
        WHEN Complain = 1 THEN 'Has Complaint'
        ELSE 'No Complaint'
    END AS complaint_status,

    CASE
        WHEN IsActiveMember = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS activity_status,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage

FROM banking_analytics.customer_churn

GROUP BY Complain, IsActiveMember

ORDER BY churn_rate_percentage DESC;

-- Business insight: Complaint status is extremely strongly associated with churn in this dataset. 
-- Activity status makes relatively little difference within the complaint groups.
-- This unusually strong relationship should be checked for possible data leakage before using complaints to predict churn.


-- 15. Churn by Customer Geography and Gender
SELECT
    Geography AS country,
    Gender AS gender,
    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage

FROM banking_analytics.customer_churn

GROUP BY Geography, Gender

ORDER BY churn_rate_percentage DESC;

-- Business insight: Female customers in Germany have the highest churn rate (37.55%), while male customers in France have the lowest (12.75%).
-- The bank could prioritize investigating retention challenges in Germany, especially among female customers.


-- 16. Customer Churn by Age and Activity Status
SELECT
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 40 THEN '31-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        WHEN Age BETWEEN 51 AND 60 THEN '51-60'
        ELSE '61+'
    END AS age_group,

    CASE
        WHEN IsActiveMember = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS activity_status,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage

FROM banking_analytics.customer_churn

GROUP BY age_group, activity_status

ORDER BY churn_rate_percentage DESC;

-- Business insight: Inactive customers aged 51–60 have the highest churn rate (85.71%).
-- Customer inactivity appears particularly important among older age groups.


-- 17. Identify High-Risk Customer Segments
SELECT
    CASE
        WHEN Age < 40 THEN 'Below 40'
        WHEN Age BETWEEN 40 AND 50 THEN '40-50'
        ELSE 'Above 50'
    END AS age_segment,

    CASE
        WHEN IsActiveMember = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS activity_status,

    CASE
        WHEN Complain = 1 THEN 'Complaint'
        ELSE 'No Complaint'
    END AS complaint_status,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage

FROM banking_analytics.customer_churn

GROUP BY age_segment, activity_status, complaint_status

ORDER BY churn_rate_percentage DESC;

-- Business insight: Customers with complaints have exceptionally high churn rates across all age and activity groups.
-- However, the near-perfect relationship suggests the Complain field may contain information recorded after churn.
-- We should investigate this before treating it as a predictive feature.


-- 18. Check for Possible Data Leakage

-- 18. Check Complaint Status vs Actual Churn
SELECT
    Complain,
    Exited,
    COUNT(*) AS total_customers
FROM banking_analytics.customer_churn
GROUP BY Complain, Exited
ORDER BY Complain, Exited;

-- Key finding: Complaint status matches churn status for 9,986 out of 10,000 customers — 99.86% agreement.
-- This is a major warning sign for potential data leakage. We cannot prove leakage without knowing when complaints were recorded,
-- but we should exclude Complain from any future predictive model until that is verified.


-- 19. Customer Churn Risk Without Complaint Status
SELECT
    Geography AS country,

    CASE
        WHEN Age < 40 THEN 'Below 40'
        WHEN Age BETWEEN 40 AND 50 THEN '40-50'
        ELSE 'Above 50'
    END AS age_segment,

    CASE
        WHEN IsActiveMember = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS activity_status,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        AS churned_customers,
	
     ROUND(
        100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS churn_rate_percentage

FROM banking_analytics.customer_churn

GROUP BY Geography, age_segment, activity_status

ORDER BY churn_rate_percentage DESC;

-- Key finding:- Your highest-risk segment is:
-- Germany → Above 50 → Inactive customers
-- 1. Total customers: 162
-- 2. Churned customers: 141
-- 3.  Churn rate: 87.04%

SELECT *
FROM banking_analytics.customer_churn;

SELECT *
FROM banking_analytics.customer_churn;
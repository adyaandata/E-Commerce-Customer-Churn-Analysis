SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM transactions;
SELECT * FROM cust_support;
SELECT * FROM churn_status;

-- Overall Customer Churn Rate
SELECT COUNT(*) AS tot_customer,SUM(flag) AS churned_members,
	   Round(SUM(flag)*100.0/COUNT(customer_id),2) AS overall_churn_rate
FROM churn_status;

-- Revenue loss due to churning
SELECT cs.status,SUM(t.amount) AS tot_revenue
FROM transactions t
JOIN churn_status cs
ON cs.customer_id = t.customer_id
GROUP BY cs.status;

-- Customer Segment who churn the most 
-- Membership type
SELECT membership_type,COUNT(*) AS tot_customers,SUM(flag) AS churned_customers,
	   SUM(flag)*100.0/ COUNT(*) AS churn_rate
FROM customers c
JOIN churn_status cs
ON cs.customer_id = c.customer_id
GROUP BY membership_type;

-- City
SELECT city,COUNT(*) AS tot_customers,SUM(flag) AS churned_customers,
	   SUM(flag)*100.0/ COUNT(*) AS churn_rate
FROM customers c
JOIN churn_status cs
ON cs.customer_id = c.customer_id
GROUP BY city
ORDER BY churn_rate DESC;

-- Age Group
SELECT age_group,COUNT(*) AS tot_customers,SUM(flag) AS churned_customers,
	   SUM(flag)*100.0/COUNT(*) AS churn_rate
FROM(
	SELECT *,
	CASE
	    WHEN age <=25 THEN '<=25'
		WHEN age BETWEEN 26 AND 35 THEN '26-35'
		WHEN age BETWEEN 36 AND 45 THEN '36-45'
		WHEN age BETWEEN 46 AND 55 THEN '46-55'
		WHEN age BETWEEN 56 AND 65 THEN '56-55'
		ELSE '>65'
	END AS age_group
	FROM customers c
	JOIN churn_status cs
	ON cs.customer_id = c.customer_id
)
GROUP BY age_group
ORDER BY churn_rate DESC;

-- City with highest churn rate
SELECT c.city,SUM(cs.flag)*100.0/COUNT(cs.customer_id)
FROM customers c
JOIN churn_status cs
ON cs.customer_id = c.customer_id
GROUP BY city;

-- Who churn more low speding customer or high spending customer
SELECT 
    spending_group,
    COUNT(*) AS total_customers,
    SUM(flag) AS churned_customers,
    AVG(CAST(flag AS FLOAT)) * 100 AS churn_rate
FROM (
    SELECT 
        c.customer_id,
        COALESCE(SUM(amount),0) AS total_spending,
        flag,
        CASE 
            WHEN COALESCE(SUM(amount),0) < 50000 THEN 'Low Spending Customer'
            WHEN COALESCE(SUM(amount),0) BETWEEN 50000 AND 150000 THEN 'Medium Spending Customer'
            ELSE 'High Spending Customer'
        END AS spending_group
    FROM customers c
    LEFT JOIN transactions t
    ON t.customer_id = c.customer_id
    JOIN churn_status cs
    ON cs.customer_id = c.customer_id
    GROUP BY c.customer_id, flag
	ORDER BY c.customer_id
) t1

GROUP BY spending_group;

-- Product category associated with highest churn
WITH category_customers AS(
SELECT DISTINCT p.category,t.customer_id,cs.flag
FROM transactions t
JOIN products p
ON p.product_id = t.product_id
JOIN churn_status cs
ON cs.customer_id = t.customer_id
) 
SELECT category,COUNT(customer_id) AS tot_customers,
	   SUM(flag) AS churned_customers,
	   AVG(CAST(flag AS FLOAT)) * 100 AS churn_rate
FROM category_customers
GROUP BY category
ORDER BY churn_rate;

--Product categories with revenue
SELECT p.category,ROUND(SUM(t.amount)::numeric,2) AS tot_revenue
FROM products p
JOIN transactions t
ON p.product_id = t.product_id
GROUP BY p.category
ORDER BY tot_revenue DESC;

-- Does complaint frequency increases churn
WITH complaint_count AS(
	SELECT c.customer_id,COUNT(csp.ticket_id) AS tot_complaints
	FROM customers c
	LEFT JOIN cust_support csp
	ON c.customer_id = csp.customer_id
	GROUP BY c.customer_id
),

complaint_group AS(
	SELECT customer_id,
	CASE 
		WHEN tot_complaints = 0 THEN 'No Complaints'
		WHEN tot_complaints <= 1 THEN 'Low Complaints'
		WHEN tot_complaints BETWEEN 2 AND 3 THEN 'Medium Complaints'
		ELSE 'High Complaints'
	END AS complaint_segment
	FROM complaint_count
)

SELECT cg.complaint_segment,COUNT(*) AS tot_customers,
	   SUM(cs.flag) AS churned_customers,
	   AVG(CAST(cs.flag AS FLOAT))*100 AS churn_rate
FROM churn_status cs
JOIN complaint_group cg
ON cs.customer_id = cg.customer_id
GROUP BY cg.complaint_segment
ORDER BY churn_rate DESC;

-- Does slower issue resolution increase churn
WITH resolution_data AS(
	SELECT 
		c.customer_id,AVG(csp.resolution_time_hours) AS avg_resolution
		FROM customers c
		LEFT JOIN cust_support csp
		ON c.customer_id = csp.customer_id
		GROUP BY c.customer_id
),

resolution_group AS(
	SELECT customer_id,
	CASE 
		WHEN avg_resolution <24 THEN 'Fast Resolution'
		WHEN avg_resolution <=72 THEN 'Moderate Resolution'
		ELSE 'Slow Resolution'
	END AS resolution_segment 
    FROM resolution_data
)

SELECT rg.resolution_segment,COUNT(*) AS tot_customer,
	   SUM(cs.flag) AS churned_customers,
	   AVG(CAST(flag AS FLOAT))*100 AS churn_rate
FROM churn_status cs 
JOIN resolution_group rg
ON rg.customer_id = cs.customer_id
GROUP BY rg.resolution_segment
ORDER BY churn_rate DESC;

-- Do low satisfaction score increases churn
WITH satisfaction_data AS (
	SELECT 
		c.customer_id,AVG(csp.satisfaction_score) AS avg_satisfaction
		FROM customers c
		LEFT JOIN cust_support csp
		ON c.customer_id = csp.customer_id
		GROUP BY c.customer_id
),

satisfaction_group AS (
	SELECT customer_id,
	CASE
		WHEN avg_satisfaction <= 2 THEN 'Low Satisfaction'
		WHEN avg_satisfaction <= 3.5 THEN 'Neutral'
		ELSE 'High Satisfaction'
	END AS satisfaction_segment
	FROM satisfaction_data
)

SELECT sg.satisfaction_segment,COUNT(*) AS tot_customer,
	   SUM(cs.flag) AS churned_customers,
	   AVG(CAST(flag AS FLOAT))*100 AS churn_rate
FROM churn_status cs 
JOIN satisfaction_group sg
ON sg.customer_id = cs.customer_id
GROUP BY sg.satisfaction_segment
ORDER BY churn_rate DESC;

-- New customers leaving faster or loyal customers
SELECT
	CASE
	    WHEN tenure_months BETWEEN 0 AND 12 THEN 'New Customers'
		WHEN tenure_months BETWEEN 13 AND 36 THEN 'Regular Customers'
		ELSE 'Loyal Customers'
	END AS tenure_group,
	COUNT(*) tot_customers,SUM(cs.flag) AS churned_customers,
	AVG(CAST(flag AS FLOAT))*100 AS churn_rate
FROM customers c
JOIN churn_status cs
ON cs.customer_id = c.customer_id
GROUP BY tenure_group
ORDER BY churn_rate DESC;  

-- Most Valuable Customers (Top 10)
WITH revenue AS (
    SELECT customer_id,
           ROUND(SUM(amount)::NUMERIC,2) AS tot_revenue
    FROM transactions
    GROUP BY customer_id
)

SELECT 
    r.customer_id,
    r.tot_revenue,
    cs.flag,
    CASE
        WHEN cs.flag = 1 THEN 'Churned'
        ELSE 'Active'
    END AS churn_status
FROM revenue r
JOIN churn_status cs
ON r.customer_id = cs.customer_id
ORDER BY r.tot_revenue DESC
LIMIT 10;

-- Customers at highest risk of churn
SELECT csu.customer_id,
	   COUNT(csu.ticket_id) AS complaints,
	   ROUND(AVG(csu.resolution_time_hours),2) AS avg_resolution_time,
	   ROUND(AVG(csu.satisfaction_score),2) AS avg_satisfaction_score,
	   cs.status
FROM cust_support csu
JOIN churn_status cs
ON cs.customer_id = csu.customer_id
GROUP BY csu.customer_id,cs.status
ORDER BY complaints DESC,
		 avg_resolution_time DESC,
		 avg_satisfaction_score ASC
LIMIT 20;

-- Yearly Revenue
SELECT EXTRACT(YEAR FROM order_date) AS year,
	   ROUND(SUM(amount)::NUMERIC,2) AS tot_revenue
FROM transactions
GROUP BY year
ORDER BY year;

-- Monthly Revenue
SELECT DATE_TRUNC('MONTH',order_date) AS month,
	   ROUND(SUM(amount)::NUMERIC,2) AS tot_revenue
FROM transactions
GROUP BY month
ORDER BY month;

-- Is Churn increasing over time
SELECT DATE_TRUNC('MONTH',c.signup_date) AS month,
	   COUNT(*) AS tot_customers,
	   SUM(cs.flag) AS churned_customers,
	   ROUND(AVG(CAST(cs.flag AS FLOAT))::NUMERIC,2)*100 AS churn_rate
FROM customers c
JOIN churn_status cs
ON cs.customer_id = c.customer_id
GROUP BY month
ORDER BY month;
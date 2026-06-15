-- Customer Spending View
DROP VIEW vw_customer_spending;
CREATE VIEW vw_customer_spending AS 
SELECT c.customer_id,COALESCE(SUM(t.amount),0) AS total_spending,
CASE 
	WHEN COALESCE(SUM(t.amount),0) < 50000 THEN 'Low Spender'
	WHEN COALESCE(SUM(t.amount),0) <= 150000 THEN 'Medium Spender'
	ELSE 'High Spender'
END AS spending_group
FROM customers c
LEFT JOIN transactions t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id;

-- Complaint Summary View
DROP VIEW vw_customer_complaints;
CREATE VIEW vw_customer_complaints AS
SELECT c.customer_id,COUNT(csp.ticket_id) AS complaint_count,
CASE
	WHEN COUNT(csp.ticket_id) = 0 THEN 'No Complaints'
	WHEN COUNT(csp.ticket_id) <= 1 THEN 'Low Complaints'
	WHEN COUNT(csp.ticket_id) <= 3 THEN 'Medium Complaints'
	ELSE 'High Complaints'
	END AS complaint_group,
	
AVG(csp.satisfaction_score) AS avg_satisfaction,
AVG(csp.resolution_time_hours) AS avg_resolution_time,

CASE 
	WHEN AVG(csp.satisfaction_score) <= 2 THEN 'Low Satisfaction'
	WHEN AVG(csp.satisfaction_score) <= 3.5 THEN 'Neutral'
	ELSE 'High Satisfaction'
END AS satisfaction_group,

CASE 
	WHEN AVG(csp.resolution_time_hours) < 24 THEN 'Fast Resolution'
	WHEN AVG(csp.resolution_time_hours) <= 72 THEN 'Moderate Resolution'
	ELSE 'Slow Resolution'
END AS resolution_group

FROM customers c
LEFT JOIN cust_support csp
ON c.customer_id = csp.customer_id
GROUP BY c.customer_id;

-- Churn Summary View
CREATE VIEW vw_customer_churn AS 
SELECT c.customer_id,c.city,c.membership_type,cs.flag
FROM customers c
JOIN churn_status cs
ON c.customer_id = cs.customer_id;

-- Order Frequency Group
DROP VIEW vw_customers_orders;
CREATE VIEW vw_customer_orders AS
SELECT c.customer_id,COUNT(t.transaction_id) AS total_orders,
CASE
	WHEN COUNT(t.transaction_id) <= 5 THEN 'Low Activity'
	WHEN COUNT(t.transaction_id) <= 15 THEN 'Medium Activity'
	ELSE 'High Activity'
END AS order_frequency_group
FROM customers c
LEFT JOIN transactions t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id;
DROP TABLE IF EXISTS customers;
CREATE TABLE customers(
	customer_id VARCHAR(15) PRIMARY KEY,
	gender VARCHAR(10),	
	age INT,
	city VARCHAR(15),
	tenure_months INT,
	income INT,
	membership_type VARCHAR(10),
	signup_date DATE
);

DROP TABLE IF EXISTS products;
CREATE TABLE products(
	product_id VARCHAR(15) PRIMARY KEY,
	category VARCHAR(15),
	brand VARCHAR(40),
	price FLOAT
);

DROP TABLE IF EXISTS transactions
CREATE TABLE transactions(
	transaction_id VARCHAR(15) PRIMARY KEY,
	customer_id VARCHAR(15),
	product_id VARCHAR(15),
	quantity INT,
	payment_method VARCHAR(15),
	order_date DATE,
	amount FLOAT
);

DROP TABLE IF EXISTS cust_support
 CREATE TABLE cust_support(
	ticket_id VARCHAR(15) PRIMARY KEY,
	customer_id	VARCHAR(15),
	issue_type VARCHAR(20),
	resolution_time_hours INT,
	satisfaction_score INT
 );

DROP TABLE IF EXISTS churn_status;
CREATE TABLE churn_status(
	customer_id VARCHAR(15),
	status VARCHAR(5),
	flag INT
 );

ALTER TABLE transactions
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE transactions
ADD CONSTRAINT fk_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE cust_support
ADD CONSTRAINT fk_support_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE churn_status
ADD CONSTRAINT fk_churn_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE churn_status
ADD PRIMARY KEY(customer_id);

-- Checking Row Counts 
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM transactions;
SELECT COUNT(*) FROM cust_support;
SELECT COUNT(*) FROM churn_status;

-- Checking Null Values
SELECT *
FROM customers
WHERE customer_id IS NULL;

-- Checking Duplicate Values
SELECT COUNT(customer_id) 
FROM customers
GROUP BY customer_id
HAVING COUNT(customer_id) > 1;

-- Checking Foreign Key Isuues
SELECT customer_id
FROM transactions
WHERE customer_id NOT IN (
	  SELECT customer_id FROM customers
);
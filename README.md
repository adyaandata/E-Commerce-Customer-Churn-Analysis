# E-Commerce Customer Churn Analysis

## Overview

This project focuses on analyzing customer churn in an e-commerce business using **PostgreSQL**, **SQL**, **Power BI**, and **DAX**. The analysis uncovers churn drivers, customer behavior patterns, and revenue impact through a relational database and interactive dashboard.

---

## Project Goal

The primary goal of this project is to identify the factors contributing to customer churn and generate actionable insights that can help businesses improve customer retention and reduce revenue loss.

### Key Questions Explored

- What is the overall customer churn rate?
- How much revenue is lost due to customer churn?
- Which customer segments are more likely to churn?
- Does customer spending behavior influence churn?
- Which product categories are associated with higher churn rates?
- How do customer complaints, resolution times, and satisfaction scores impact retention?
- Are new customers more likely to churn than loyal customers?
- Is customer churn increasing over time?

---

## Dataset Overview

The dataset was obtained from Kaggle and contains multiple interconnected tables representing different aspects of an e-commerce business.

### Tables Used

| Table | Description |
|---------|------------|
| Customers | Customer demographics and membership details |
| Transactions | Customer purchase history and order values |
| Products | Product information and categories |
| Churn Status | Customer churn indicators |
| Customer Support | Complaints, resolution times, and satisfaction scores |

---

## Database Design

A relational database was built in PostgreSQL to efficiently store and analyze the data.

### Tasks Performed

- Created tables for all datasets
- Defined Primary Keys
- Established Foreign Key relationships
- Maintained Referential Integrity
- Created SQL Views for reporting and analysis
- Performed multi-table joins for business insights

### Database Relationships

- Customers → Transactions
- Customers → Churn Status
- Customers → Customer Support
- Products → Transactions

---

## SQL Analysis

Using SQL, I performed extensive business analysis to uncover patterns and trends related to customer churn.

### Customer Churn Analysis

- Overall Customer Churn Rate
- Revenue Loss Due to Churn
- Churn by Membership Type
- Churn by City
- Churn by Age Group
- Churn Trends Over Time

### Customer Behavior Analysis

- Spending-Based Customer Segmentation
- Low, Medium, and High Spending Customer Churn Comparison
- Most Valuable Customers
- High-Risk Customer Identification

### Product Analysis

- Product Categories with Highest Churn
- Product Category Revenue Contribution
- Product Performance Analysis

### Customer Support Analysis

- Complaint Frequency vs Churn
- Resolution Time vs Churn
- Satisfaction Score vs Churn
- Customer Support Performance Analysis

### Revenue Analysis

- Monthly Revenue Trends
- Yearly Revenue Trends
- Revenue Loss Analysis

---

## SQL Concepts Used

- Joins
- Group By
- Aggregate Functions
- CASE Statements
- Common Table Expressions (CTEs)
- SQL Views
- Date Functions
- Multi-Table Analysis
- Customer Segmentation
- Business KPI Analysis

---

## Power BI Dashboard

The analyzed data was visualized in Power BI through an interactive dashboard designed to monitor customer churn and business performance.

### Dashboard Features

- Interactive Slicers and Filters
- KPI Cards
- Churn Analysis
- Revenue Analysis
- Customer Segmentation
- Product Performance Analysis
- Customer Support Insights
- Trend Analysis
- Dynamic Reporting

### DAX Measures Used

To create business-focused KPIs, DAX measures were developed for:

- Total Customers
- Active Customers
- Churned Customers
- Churn Rate
- Total Revenue
- Revenue Loss
- Average Satisfaction Score
- Average Resolution Time
- Dynamic KPI Calculations

---

## Key Insights

- Customer churn varies significantly across different customer segments.
- Certain membership types exhibit higher churn tendencies.
- Customer support quality has a direct impact on retention.
- Increased complaint frequency is associated with higher churn rates.
- Longer issue resolution times contribute to customer attrition.
- Lower satisfaction scores indicate a greater risk of churn.
- Customer spending behavior influences loyalty and retention.
- Revenue loss from churned customers represents a significant business challenge.
- Churn trend analysis helps identify periods requiring targeted retention strategies.

---

## Business Recommendations

- Improve customer support response and resolution times.
- Focus retention efforts on high-risk customer segments.
- Monitor customer satisfaction scores regularly.
- Develop loyalty programs for valuable customers.
- Identify churn indicators early through continuous monitoring.
- Leverage dashboard insights for proactive decision-making.

---

## Skills Demonstrated

### SQL & Database Management
- PostgreSQL
- Database Design
- Data Modeling
- Foreign Key Relationships
- SQL Views
- Advanced Querying

### Business Intelligence
- Power BI
- DAX
- KPI Development
- Dashboard Design
- Interactive Reporting

### Analytics
- Customer Churn Analysis
- Revenue Analysis
- Customer Segmentation
- Customer Support Analytics
- Business Insights Generation

---

## Project Structure

```text
E-Commerce-Customer-Churn-Analysis
│
├── Dataset
│   ├── customers.csv
│   ├── products.csv
│   ├── transactions.csv
│   ├── churn_status.csv
│   └── customer_support.csv
│
├── SQL
│   ├── Table_Creation.sql
│   ├── Foreign_Key_Constraints.sql
│   ├── Views.sql
│   └── Analysis_Queries.sql
│
├── PowerBI
│   └── E_Commerce_Customer_Churn_Dashboard.pbix
│
├── Images
│   └── Dashboard.png
│
└── README.md

# Brazilian Retail Analysis
## SQL · Power BI · Python

## Project Overview

- This project analyzes Olist, a Brazilian e-commerce marketplace, with the goal of understanding how customer behavior, product performance, seller activity, and delivery operations impact revenue and customer satisfaction.

- The analysis focuses on the period 2017–2018 and combines SQL, Power BI, and Python to provide a complete, end-to-end analytical workflow: from data preparation and KPI calculation to visualization and exploratory data analysis.

- The project is descriptive and business-oriented, prioritizing insights and decision-making over predictive modeling.

## Business Questions Addressed

- How did revenue, orders, and active customers evolve over time?

- Which customers, products, and sellers generate most of the value?

- How concentrated is revenue across customers and categories?

- How does delivery performance affect customer satisfaction?

- Did operational improvements translate into business growth?

## Tools & Technologies

**SQL**: Data cleaning, transformations, and KPI calculations

**Power BI**: Interactive dashboards and DAX measures

**Python**: Exploratory Data Analysis (Pandas, Matplotlib, Seaborn)

## Repository Structure
/sql
  └── olist_analysis.sql        # SQL queries and KPI calculations

/powerbi
  └── olist_dashboard.pbix     # Interactive Power BI report

/python
  └── olist_eda.ipynb          # Exploratory Data Analysis notebook

/docs
  └── Olist_Conclusions.pdf # Written conclusions and business insights

## Key Insights 

- Customer satisfaction is strongly linked to delivery performance. Orders delivered on time receive significantly higher review scores than late deliveries.

- Revenue is highly concentrated: a small group of customers and product categories accounts for a large share of total sales.

- After strong growth in 2017, revenue, orders, and active customers stabilized during 2018.

- Average revenue per customer and average seller productivity both declined slightly in 2018.

- Logistics performance improved in 2018 (faster deliveries and fewer late orders), but these operational gains did not fully translate into revenue growth.

- A more detailed explanation of findings and business implications can be found in the PDF conclusions document included in this repository.
Dashboards

## The Power BI report includes three main dashboards:

- **General View**
Monthly evolution of revenue, orders, and active customers, with KPIs and filters by year and order status.

- **Customers & Products**
Revenue concentration, top customers, category performance, and average revenue per customer.

- **Sellers & Logistics**
Seller revenue and order volume, delivery performance, late delivery rate, and operational KPIs.

## Data Source

The data used in this project comes from the public Olist Brazilian E-Commerce Dataset (https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce )

## Notes

- The project focuses on descriptive analysis and business understanding.

- Results from SQL, Power BI, and Python are directionally consistent, with minor differences due to aggregation levels and filtering logic.

- The project is designed as a portfolio case, simulating how a junior BI / Data Analyst would approach a real marketplace dataset.

## Author

Agustín

Business Intelligence / Data Analytics

Portfolio:  

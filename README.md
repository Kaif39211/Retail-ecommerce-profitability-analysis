# 🛒 E-Commerce Sales Performance & Margin Optimization

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)]()
[![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)]()
[![Microsoft Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white)]()

## 📌 Executive Summary
An end-to-end data analytics pipeline designed to identify profit bleeding and optimize sales performance across [Number, e.g., 4] major retail channels. By analyzing over [Number, e.g., 35,000+] transactional records, this project transitions raw e-commerce data into a dynamic executive dashboard, pinpointing exactly where the business is losing margin.

**📊 [View Interactive Power BI Dashboard Here](Insert-NovyPro-or-Web-Link-Here)**

---

## 📖 Business Case (S.T.A.R. Framework)
- **Situation:** Despite high gross merchandise value (GMV) and order volumes, net profit margins were stagnating, suggesting unaccounted margin leakage in shipping, discounting, or dead stock.
- **Task:** Build an automated, scalable reporting solution to audit historical sales, segment customer profitability, and isolate the specific product categories driving revenue loss.
- **Action:** 
  - Extracted and sanitized raw transactional datasets using **Advanced Excel (Power Query)**.
  - Architected a relational database in **PostgreSQL** to execute complex aggregations and cohort analyses.
  - Developed a Star Schema data model and custom DAX measures in **Power BI** to visualize actual vs. target profitability.
- **Result:** Identified **$[X,XXX]** in margin leakage caused by excessive discounting and recommended supply chain adjustments to recover **[X]%** of lost net profit.

---

## 🔄 The Data Pipeline

### Phase 1: Data Preprocessing (Excel)
Raw e-commerce exports are notoriously messy. I utilized Excel to establish a clean foundation:
- Handled missing dimensions and null values via `XLOOKUP` and logical operators.
- Standardized date formatting and currency conversions.
- *Artifact:* `📁 data/cleaned_retail_data.xlsx`

### Phase 2: Exploratory Data Analysis (SQL)
Loaded the sanitized data into PostgreSQL for high-performance querying.
- **Key Analyses:** Month-over-Month (MoM) growth rates, customer lifetime value (CLV) segmentation, and moving averages.
- **Highlight Query:**
  ```sql
  -- Example snippet: Identifying top bleeding categories
  SELECT Product_Category, 
         SUM(Total_Revenue) as Gross_Sales,
         SUM(Discount_Amount + Shipping_Cost) as Total_Leakage
  FROM Fact_Sales
  GROUP BY Product_Category
  ORDER BY Total_Leakage DESC;

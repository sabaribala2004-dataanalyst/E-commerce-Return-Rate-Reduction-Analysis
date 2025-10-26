# 📦 E-commerce Return Analysis & Prediction

## 🧩 Introduction
Product returns are one of the biggest challenges in the E-commerce industry, directly affecting profitability and customer trust.  
This project focuses on identifying the key factors influencing product returns, analyzing category and supplier performance, and predicting return risk using a logistic regression model.  
By integrating SQL, Power BI, and Python, the project provides a complete analytical workflow — from raw data cleaning to predictive modeling and dashboard visualization.

---

## 🧠 Abstract
The goal of this project is to perform a comprehensive analysis of return patterns and predict the probability of future returns.  
The dataset includes customer demographics, product details, suppliers, marketing channels, payment types, and delivery timelines.  

**Project workflow includes:**
1. **SQL (PostgreSQL):** Cleaning, transforming, and aggregating data to find return percentages by category, supplier, region, and marketing channel.  
2. **Power BI Dashboard:** Creating an interactive, drill-through-enabled visualization to explore overall return performance.  
3. **Python (Logistic Regression):** Building a predictive model to estimate the probability of returns and exporting a CSV of high-risk products.

The combined approach provides actionable insights for optimizing supplier quality, shipping performance, and marketing strategies.

---

## 🛠️ Tools Used
| Tool | Purpose |
|------|----------|
| **PostgreSQL** | Data cleaning, transformation, and SQL-based return rate analysis |
| **Python (Colab)** | Logistic Regression model for predicting return probability |
| **Power BI** | Interactive dashboard visualization with filters & drill-through features |
| **Pandas & Scikit-learn** | Data manipulation and machine learning model building |
| **Matplotlib / Seaborn** | Trend and feature visualization |
| **CSV Dataset** | Input and output data for model and visualization |

---

## 🚀 Deliverables
- ✅ **Interactive Power BI Dashboard** with drill-through filters for detailed insights  
- ✅ **Python Codebase** to train and test logistic regression model for return prediction  
- ✅ **CSV Output File** containing high-risk products with predicted return probability scores  

---

## 🔍 Steps Involved in Building the Project

### 1️⃣ Data Cleaning & Preparation (SQL)
- Created a PostgreSQL table `ecommerce_returns` and loaded the dataset.  
- Removed duplicate records, standardized text fields (like `Delivery_Issue`), and fixed missing values.  
- Added helpful indexes for faster SQL query performance.

### 2️⃣ Data Analysis (SQL)
- Calculated **return % by category, supplier, region, and marketing channel**.  
- Identified **top return reasons** (e.g., wrong size, damaged, not as described).  
- Created **SQL views** for Power BI integration:
  - `vw_return_overall`
  - `vw_return_by_category`
  - `vw_high_risk_products`

### 3️⃣ Visualization (Power BI)
- Developed two detailed dashboards:
  - **Page 1 – Return Insights Overview:** Overall KPIs, category & supplier performance, top return reasons, and return % by region.  
  - **Page 2 – Return Rate Drivers & Customer Behavior:** Payment method vs return rate, delivery issues, return rate over time, and top 10 high-risk products.  
- Added navigation buttons, dynamic slicers, and drill-through filters for interactive exploration.

### 4️⃣ Prediction Model (Python)
- Imported SQL-cleaned dataset into Colab using Pandas.  
- Encoded categorical variables, handled missing data, and split into train-test sets.  
- Trained a **Logistic Regression model** to predict `return_flag`.  
- Calculated **Return Risk Score = Probability of Return × 100**.  
- Exported high-risk product data (with >70% return chance) to a CSV file for Power BI usage.

### 5️⃣ Integration & Reporting
- Merged Python model output into Power BI as a new table.  
- Displayed high-risk products with return rates, regions, and marketing channels.  
- Enabled business users to monitor suppliers and categories that require intervention.

---

## 🎯 Conclusion
The **E-commerce Return Analysis & Prediction Project** delivers a data-driven framework to understand and reduce product returns.  

**Key Results:**
- Categories like **Fashion (16.3%)** and **Electronics (13.6%)** show the highest return rates.  
- Suppliers such as **StylishCo** and **FabricHub** report above-average return percentages.  
- **India** and **Canada** regions experience higher return volumes compared to others.  
- Logistic regression successfully identifies **high-risk products** before returns occur.  
- Power BI dashboard provides a 360° view of operational inefficiencies and customer patterns.  

**Business Impact:**
- Improves supplier accountability  
- Reduces return costs and delivery delays  
- Enhances forecasting and customer satisfaction  

---

## 👤 Author
**Sabari Bala**  
📧 [sabaribala2004-dataanalyst@gmail.com](mailto:sabaribala2004-dataanalyst@gmail.com)  
💼 *Data Analyst | SQL | Power BI | Python | Excel*

---



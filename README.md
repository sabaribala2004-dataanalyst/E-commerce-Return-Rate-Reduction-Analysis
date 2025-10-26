# 📦 E-commerce Return Analysis & Prediction

## 🧩 Introduction
The E-commerce industry faces a major challenge in managing product returns that impact both profitability and customer satisfaction. This project focuses on analyzing customer return behavior, identifying high-risk products, and predicting the probability of returns using a data-driven approach.  
Through SQL, Power BI, and Python, the analysis provides actionable insights to improve inventory management, supplier quality, and customer experience.

---

## 🧠 Abstract
This project aims to analyze an E-commerce return dataset containing details such as category, supplier, region, payment type, and shipping days.  
The workflow includes:
- **SQL Analysis (PostgreSQL):** Extracting and cleaning data, computing return percentages by category, supplier, region, and marketing channel.  
- **Power BI Visualization:** Creating an interactive dashboard to display key metrics such as return rate, reasons for return, and supplier performance.  
- **Python Logistic Regression Model:** Building a predictive model to calculate the probability of product returns and assign a “return risk score.”  

The outcome enables businesses to proactively manage returns and identify risky categories, suppliers, and customers.

---

## 🛠️ Tools Used
| Tool | Purpose |
|------|----------|
| **PostgreSQL** | Data cleaning, transformation, and SQL-based return rate analysis |
| **Python (Colab)** | Logistic Regression model to predict return probability |
| **Power BI** | Interactive dashboard for data visualization and reporting |
| **Pandas & Scikit-learn** | Data manipulation and model building |
| **Matplotlib / Seaborn** | Visual exploration of trends |
| **CSV Dataset** | E-commerce sales and returns data |

---

## 🔍 Steps Involved in Building the Project
### 1️⃣ Data Cleaning and Preparation
- Created PostgreSQL table `ecommerce_returns` and loaded the CSV dataset.  
- Removed duplicates and standardized fields such as `Delivery_Issue`.  
- Added indexes for faster query execution.  

### 2️⃣ Exploratory Data Analysis (SQL)
- Computed **return rates** by *Category*, *Supplier*, *Region*, *Marketing Channel*, and *Payment Type*.  
- Identified **Top Return Reasons** (e.g., wrong size, not as described, late delivery).  
- Created **SQL views** for Power BI:  
  - `vw_return_overall`  
  - `vw_return_by_category`  
  - `vw_high_risk_products`

### 3️⃣ Power BI Dashboard Development
- Built two interactive dashboards:
  - **Page 1: Return Insights Overview** – Visualized return % by category, region, supplier, and marketing channel.
  - **Page 2: Return Rate Drivers & Customer Behavior** – Displayed delivery issues, payment method impact, return rate over time, and top 10 high-risk products.  
- Added slicers, navigation buttons, and drill-through features for detailed analysis.

### 4️⃣ Predictive Modeling (Python)
- Imported cleaned dataset using Pandas.  
- Encoded categorical variables and handled missing values.  
- Split data into **training and testing sets (70:30)**.  
- Trained a **Logistic Regression Model** to predict return probability (`return_flag`).  
- Calculated and exported a **Return Risk Score** for each product into a CSV file for Power BI integration.  

### 5️⃣ Insights Integration
- Linked Python-generated “High-Risk Products” CSV into Power BI.  
- Created combined views for delivery issues, customer age, and payment method vs. return rate.  
- Enabled managers to track which products or suppliers require intervention.

---

## 🎯 Conclusion
The E-commerce Return Analysis project successfully combined **SQL**, **Power BI**, and **Python** to deliver an end-to-end data solution.  
Key outcomes include:
- Identification of **high-return categories** such as *Fashion* and *Electronics*.  
- Detection of **suppliers** with consistently high return rates (*StylishCo*, *FabricHub*).  
- Insights showing that **delivery delays and wrong sizes** are major return drivers.  
- A **predictive model** that enables proactive mitigation by highlighting products with >70% return probability.  

This integrated analytical workflow empowers decision-makers to reduce operational costs, enhance product quality, and improve customer retention.

---

## 👤 Author
**Sabari Bala**  
📧 [sabaribala2004-dataanalyst@gmail.com](mailto:sabaribala2004-dataanalyst@gmail.com)  
💼 *Data Analyst | SQL | Power BI | Python | Excel*

---

### 📝 Repository Description (350 Characters)
End-to-end E-commerce return analysis project using PostgreSQL, Power BI, and Python. Includes SQL queries, logistic regression model, and interactive dashboard to identify high-return products, analyze customer behavior, and predict return risk scores for business optimization.


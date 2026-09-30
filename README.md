# Enterprise Banking & Credit Risk Analytics Platform

An end-to-end data analytics and business intelligence system evaluating credit risk exposure, delinquency forecasting, and branch-level liquidity surveillance across 165,000+ financial records using Python, MySQL 8.0, and Tableau Public[cite: 7].

---

## 📌 Executive Summary

Institutional retail banks require rigorous data-driven systems to monitor multi-million dollar credit portfolios while preserving operational liquidity across branch networks[cite: 7]. This project provides a production-grade analytics pipeline that ingests, cleans, analyzes, and visualizes retail loan performance and high-volume cash transactions[cite: 7].

### Core Project Metrics
- **Total Records Analyzed**: 165,535 records (65,535 Loan Originations | 100,000 Banking Transactions)[cite: 7]
- **Funded Capital Evaluated**: $350M+ across standardized credit risk tiers (Grades A through G)[cite: 7]
- **Operational Scope**: 6 retail branch locations evaluated for cash inflow/outflow liquidity and AML risk surveillance[cite: 7]
- **Tech Stack**: Python 3.12 (Pandas, NumPy, SQLAlchemy, PyMySQL), MySQL 8.0, Tableau Public[cite: 5, 7]

---

## 📁 Repository Structure

```text
├── Code_File.ipynb                 # Python ETL & automated database ingestion pipeline
├── banking_analytics_master.sql     # Production MySQL schema DDL & analytical queries
├── requirements.txt                # Pinned Python dependencies
├── Project_Report.docx             # Detailed executive business intelligence report
├── credit_risk_by_grade.csv        # Query output: Graded credit risk & delinquency matrix
├── branch_liquidity_rankings.csv   # Query output: Branch liquidity & cash flow rankings
└── README.md                       # Project documentation and architecture guide
```[cite: 7]

---

## ⚙️ Data Architecture & Pipeline

```text
[Raw Datasets (.xlsx)]
   ├── Bank Data Analystics.xlsx (65,535 rows)
   └── Debit and Credit banking_data.xlsx (100,000 rows)
              │
              ▼
[Python Data Engineering Pipeline (Code_File.ipynb)]
   ├── Whitespace normalization & duplicate header elimination
   ├── ISO timestamp conversion (pd.to_datetime)
   └── Automated AML flag: Is_High_Risk_Txn (Debit > $4,500)
              │
              ▼
[MySQL 8.0 Relational Database (citi_bank_analytics)]
   ├── Table: loan_portfolio (65,535 records)
   └── Table: banking_transactions (100,000 records)
              │
              ├──► [Analytical SQL: CTEs, Grouping, DENSE_RANK() OVER]
              │
              ▼
[Tableau Public Executive BI Dashboards]
   ├── Dual-axis credit exposure vs. delinquency curves
   ├── State-level geographic exposure map
   └── Multi-dimensional underwriting density heatmap
```[cite: 7]

---

## 🔍 Key SQL Queries & Analytics

### 1. Credit Risk Segregation & Delinquency Benchmarking by Grade
```sql
USE citi_bank_analytics;

SELECT 
    `Grrade` AS Credit_Grade,
    COUNT(`Account ID`) AS Total_Accounts,
    ROUND(SUM(`Funded Amount`), 2) AS Total_Funded_Exposure,
    SUM(CASE WHEN UPPER(`Is Default Loan`) = 'Y' THEN 1 ELSE 0 END) AS Default_Count,
    ROUND(SUM(CASE WHEN UPPER(`Is Default Loan`) = 'Y' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Default_Rate_Pct,
    SUM(CASE WHEN UPPER(`Is Delinquent Loan`) = 'Y' THEN 1 ELSE 0 END) AS Delinquent_Count,
    ROUND(SUM(CASE WHEN UPPER(`Is Delinquent Loan`) = 'Y' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Delinquency_Rate_Pct
FROM loan_portfolio
WHERE `Grrade` IS NOT NULL AND TRIM(`Grrade`) != ''
GROUP BY `Grrade`
ORDER BY `Grrade`;
```[cite: 7]

#### Findings:
| Credit Grade | Total Accounts | Funded Exposure ($) | Default Count | Default Rate (%) | Delinquent Count | Delinquency Rate (%) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **A** | 10,085 | $84,738,425.00 | 271 | 2.69% | 395 | 3.92% |
| **B** | 12,020 | $130,553,250.00 | 291 | 2.42% | 1,097 | 9.13% |
| **C** | 8,098 | $87,290,475.00 | 193 | 2.38% | 1,103 | 13.62% |
| **D** | 5,307 | $64,054,375.00 | 145 | 2.73% | 920 | 17.34% |
| **E** | 2,842 | $43,352,800.00 | 84 | 2.96% | 485 | 17.07% |
| **F** | 1,049 | $18,555,150.00 | 28 | 2.67% | 230 | 21.93% |
| **G** | 316 | $6,265,850.00 | 8 | 2.53% | 82 | 25.95% |[cite: 7]

- **Exposure Concentration**: Grade B constitutes peak asset allocation ($130.55M across 12,020 accounts) with a controlled 2.42% default rate[cite: 4, 7].
- **Risk Escalation**: Delinquency rates increase monotonically from 3.92% (Grade A) to 25.95% (Grade G), validating the credit rating segmentation[cite: 4, 7].

---

### 2. Branch Liquidity & Operational Cash Flow Rankings
```sql
USE citi_bank_analytics;

WITH BranchSummary AS (
    SELECT 
        Branch,
        ROUND(SUM(CASE WHEN LOWER(`Transaction Type`) = 'credit' THEN `Amount` ELSE 0 END), 2) AS Total_Credit_Inflow,
        ROUND(SUM(CASE WHEN LOWER(`Transaction Type`) = 'debit' THEN `Amount` ELSE 0 END), 2) AS Total_Debit_Outflow,
        ROUND(
            SUM(CASE WHEN LOWER(`Transaction Type`) = 'credit' THEN `Amount` ELSE 0 END) - 
            SUM(CASE WHEN LOWER(`Transaction Type`) = 'debit' THEN `Amount` ELSE 0 END), 2
        ) AS Net_Cash_Flow,
        SUM(`Is_High_Risk_Txn`) AS Total_High_Risk_Transactions,
        COUNT(*) AS Total_Txn_Volume
    FROM banking_transactions
    WHERE Branch IS NOT NULL AND TRIM(Branch) != ''
    GROUP BY Branch
)
SELECT 
    Branch,
    Total_Txn_Volume,
    Total_Credit_Inflow,
    Total_Debit_Outflow,
    Net_Cash_Flow,
    Total_High_Risk_Transactions,
    ROUND(Total_Credit_Inflow / NULLIF(Total_Debit_Outflow, 0), 3) AS Credit_to_Debit_Ratio,
    DENSE_RANK() OVER (ORDER BY Net_Cash_Flow DESC) AS Liquidity_Rank
FROM BranchSummary
ORDER BY Liquidity_Rank ASC;
```[cite: 7]

#### Findings:
| Branch | Txn Volume | Total Credit Inflow ($) | Total Debit Outflow ($) | Net Cash Flow ($) | High-Risk Txns | Liquidity Rank |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **East Branch** | 16,727 | $21,526,010.93 | $21,171,100.24 | **+$354,910.69** | 850 | **1** |
| **Suburban Branch** | 16,645 | $21,178,327.45 | $20,997,948.90 | **+$180,378.55** | 859 | **2** |
| **North Branch** | 16,500 | $20,920,840.21 | $20,756,291.51 | **+$164,548.70** | 854 | **3** |
| **Downtown Branch** | 16,627 | $21,263,152.26 | $21,324,063.93 | **-$60,911.67** | 901 | **4** |
| **City Center Branch** | 16,719 | $21,418,348.49 | $21,493,121.30 | **-$74,772.81** | 886 | **5** |
| **Main Branch** | 16,782 | $21,296,707.07 | $21,542,743.34 | **-$246,036.27** | 902 | **6** |[cite: 7]

- **Liquidity Imbalance**: East Branch leads the network with a +$354,910.69 cash surplus, while Main Branch runs the largest deficit at -$246,036.27[cite: 4, 7].
- **AML Surveillance**: High-risk transactions (debit withdrawals > $4,500) peak in high-velocity commercial centers (Main Branch: 902; Downtown: 901)[cite: 4, 7].

---

## 📊 Business Intelligence & Tableau Dashboards

The Tableau workbook incorporates three analytical views[cite: 4, 7]:
1. **Dual-Axis Portfolio Benchmarking**: Combines funded loan volume bar charts with synchronized delinquency percentage trend lines[cite: 4, 7].
2. **Geospatial Exposure Choropleth**: Evaluates state-level funded capital distribution across India and tracks geographical default concentrations[cite: 4, 7].
3. **Underwriting Matrix Heatmap**: Cross-analyzes loan purpose categories against borrower verification statuses to identify elevated risk sectors[cite: 4, 7].

---

## 🚀 Setup & Execution Guide

### 1. Clone the Repository
```bash
git clone [https://github.com/](https://github.com/)<your-username>/banking-analytics-platform.git
cd banking-analytics-platform
```[cite: 7]

### 2. Environment Setup
```bash
python -m venv venv
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

pip install -r requirements.txt
```[cite: 7]

### 3. Run the Data Pipeline
Open and execute `Code_File.ipynb` to clean the raw Excel files and ingest the data into MySQL[cite: 7]:
```bash
jupyter notebook Code_File.ipynb

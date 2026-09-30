# 🏛️ Banking & Credit Risk Analytics Platform

[![Python](https://img.shields.io/badge/Python-3.10%20%7C%203.11%20%7C%203.12-blue?logo=python&logoColor=white)](https://www.python.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0%20(Port%203307)-orange?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Tableau](https://img.shields.io/badge/Tableau%20Public-Interactive%20Dashboard-E97627?logo=tableau&logoColor=white)](https://public.tableau.com/)
[![Pandas](https://img.shields.io/badge/Pandas-2.0%2B-150458?logo=pandas&logoColor=white)](https://pandas.pydata.org/)
[![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-2.0%2B-D71F00?logo=sqlalchemy&logoColor=white)](https://www.sqlalchemy.org/)
[![Status](https://img.shields.io/badge/Deployment-Production%20Verified-success)](#relational-sql-analytics--verified-results)

An enterprise-grade Banking Decision Management & Credit Risk Analytics repository built to ingest, clean, standardize, model, and visualize **165,535 records** spanning **$434.81M+** in funded lending exposure and **$254.89M** in retail cash flows across six regional bank branches.

---

## 📑 Table of Contents
1. [Executive Summary & Scope](#-executive-summary--scope)
2. [Platform Architecture & Data Pipeline](#-platform-architecture--data-pipeline)
3. [Relational SQL Analytics & Verified Results](#-relational-sql-analytics--verified-results)
   - [Credit Risk Matrix by Grade (A–G)](#1-credit-risk-segregation--delinquency-rates-by-grade)
   - [Branch Liquidity Window Rankings (1–6)](#2-branch-liquidity-net-cash-flow--inflowoutflow-surveillance)
4. [Production SQL Scripts](#-production-sql-scripts)
5. [Tableau Business Intelligence Architecture](#-tableau-business-intelligence-architecture)
6. [Strategic Recommendations & Risk Directives](#-strategic-recommendations--risk-directives)
7. [Repository File Structure](#-repository-file-structure)
8. [Step-by-Step Reproduction Instructions](#-step-by-step-reproduction-instructions)

---

## 🎯 Executive Summary & Scope

Modern commercial banking risk frameworks (Basel III, Dodd-Frank, FinCEN) demand real-time surveillance of credit exposure, capital adequacy, and intraday branch liquidity. This platform models:
- **Capital Exposure:** Over **$434,810,325.00** across **65,535** loan accounts (52 attributes).
- **Branch Transaction Surveillance:** **100,000** transactions totaling **$254,888,655.63** across 6 regional branches.
- **Key Risk Multiplier:** Demonstrates that while baseline default rates remain stable between 2.38% and 2.96%, **delinquency rates experience an escalating 6.6x surge** from Grade A (3.92%) to Grade G (25.95%).
- **Liquidity Bifurcation:** Identifies severe branch liquidity asymmetry where East Branch maintains **+$354,910.69** in idle surplus while Main Branch suffers a **-$246,036.27** operational deficit.
- **AML Compliance:** Detects and flags **5,252 high-risk outbound debit transfers** exceeding the $4,500 threshold.

---

## ⚙️ Platform Architecture & Data Pipeline

┌─────────────────────────────────┐        ┌──────────────────────────────────────┐│    RAW EXCEL DATASETS (42.4 MB) │        │      CITI DECISION MANAGEMENT RULE   ││ • Bank Data Analystics.xlsx     │        │ • High-Risk AML Flagging:            ││ • Debit & Credit banking.xlsx   │        │   np.where(Debit & Amount > 4500)    │└────────────────┬────────────────┘        └──────────────────┬───────────────────┘│                                            │▼                                            ▼┌────────────────────────────────────────────────────────────────────────────────┐│                        PYTHON / PANDAS ETL ENGINE                              ││ • Regex whitespace stripping & duplicate header pruning (~df.duplicated())     ││ • ISO-8601 timestamp coercion: pd.to_datetime(errors='coerce')                 ││ • Standardized schemas exported to cleaned CSV files (41.3 MB)                 │└────────────────────────────────┬───────────────────────────────────────────────┘│▼┌────────────────────────────────────────────────────────────────────────────────┐│                 SQLALCHEMY 2.0 ORM BATCH LOADER                                ││ • PyMySQL engine connection pool -> localhost:3307                             ││ • Schema: 'citi_bank_analytics'                                                ││ • Tables: loan_portfolio (65.5k) & banking_transactions (100k)                 │└─────────────────┬──────────────────────────────────────────────┬───────────────┘│                                              │▼                                              ▼┌─────────────────────────────────┐        ┌──────────────────────────────────────┐│      MYSQL 8.0 RELATIONAL DB    │        │          TABLEAU PUBLIC / BI         ││ • Aggregation & Grouping Queries│        │ • Dual-Axis Synchronized Risk Marks  ││ • CTEs & DENSE_RANK() Analytics │        │ • State Geographic Choropleth Map    ││ • Delinquency & AML Metrics     │        │ • Underwriting Heat Matrices         │└─────────────────────────────────┘        └──────────────────────────────────────┘
1. **Extraction & Memory Optimization:** Dual workbook ingest using `openpyxl` with zero schema truncation.
2. **Data Sanitization:** Header regex normalization, elimination of duplicated columns, and NaN handling.
3. **Temporal Standardization:** All transaction and disbursement timestamps converted into standard `YYYY-MM-DD` ISO-8601 strings.
4. **Decision Management Risk Rule:** Vectorized condition isolating high-velocity debit capital outflows:
   ```python
   trans_df['Is_High_Risk_Txn'] = np.where(
       (trans_df['Transaction Type'] == 'Debit') & (trans_df['Amount'] > 4500), 1, 0
   )
Persistence Engine: Streamed directly into MySQL 8.0 running on dedicated port 3307 via SQLAlchemy connection pooling.📊 Relational SQL Analytics & Verified Results1. Credit Risk Segregation & Delinquency Rates by GradeThe portfolio was evaluated by borrowing grade (A through G). While default rates show minor variance (2.38% – 2.96%), delinquency serves as the primary leading indicator of systemic credit deterioration, jumping sharply in Grade D (17.34%) and peaking in Grade G (25.95%).Credit GradeTotal AccountsTotal Funded Exposure ($)Default CountDefault Rate (%)Delinquent CountDelinquency Rate (%)Risk LevelA10,085$84,738,425.002712.69%3953.92%Prime Low RiskB12,020$130,553,250.002912.42%1,0979.13%Prime ModerateC8,098$87,290,475.001932.38%1,10313.62%Near PrimeD5,307$64,054,375.001452.73%92017.34%Subprime HighE2,842$43,352,800.00842.96%48517.07%Subprime ElevatedF1,049$18,555,150.00282.67%23021.93%Deep SubprimeG316$6,265,850.0082.53%8225.95%Critical DistressTotal39,717$434,810,325.001,0202.57%4,31210.86%Portfolio Total2. Branch Liquidity, Net Cash Flow & Inflow/Outflow SurveillanceRanked via SQL analytic window function DENSE_RANK() OVER (ORDER BY Net_Cash_Flow DESC). Demonstrates extreme liquidity disparity between surplus branches (East, Suburban, North: +$699.8k) and deficit branches (Downtown, City Center, Main: -$381.7k).Liquidity RankBranch NameTotal Txn VolumeTotal Credit Inflow ($)Total Debit Outflow ($)Net Cash Flow ($)High-Risk AML TxnsCredit-to-Debit RatioTreasury Status1East Branch16,727$21,526,010.93$21,171,100.24+$354,910.698501.017Heavy Surplus2Suburban Branch16,645$21,178,327.45$20,997,948.90+$180,378.558591.009Stable Surplus3North Branch16,500$20,920,840.21$20,756,291.51+$164,548.708541.008Moderate Surplus4Downtown Branch16,627$21,263,152.26$21,324,063.93-$60,911.679010.997Deficit (AML Alert)5City Center Branch16,719$21,418,348.49$21,493,121.30-$74,772.818860.997Deficit6Main Branch16,782$21,296,707.07$21,542,743.34-$246,036.279020.989Critical DeficitSystemConsolidated Total100,000$127,603,386.41$127,285,269.22+$318,117.195,2521.002Solvent Net📜 Production SQL ScriptsThe exact production queries stored in banking_analytics_production.sql:Query 1: Credit Risk Segregation & Delinquency MatrixSQLUSE citi_bank_analytics;

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
Query 2: Branch Liquidity Rankings via CTE and Window FunctionSQLUSE citi_bank_analytics;

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
📈 Tableau Business Intelligence ArchitectureThe packaged workbook Bank Decision Management - Credit Risk Dashboard.twb is built with:Dual-Axis Synchronized Marks: Visualizes Total Funded Exposure bar volumes paired with dual-synchronized delinquency and default rate lines.Geographic Choropleth Map: Maps state-level underwriting density, showing concentration risk and regional delinquency heat across the United States.Underwriting Risk Matrices: Matrix analyzing Loan Purpose (Debt Consolidation, Credit Card, Small Business) against Sub-Grades and Verification Status.Dynamic Cross-Filtering: Interactive controls for Disbursement Year, Credit Grade selection, and Branch Treasury slicing.💡 Strategic Recommendations & Risk DirectivesCredit Grade Re-benchmarking & Underwriting Overhaul:Immediately curtail 60-month loan tenors for Grades E–G.Enforce mandatory 3rd-party income verification for Grades C & D over $15,000.Adjust risk pricing upwards by +175 to +250 bps for Grades D–F to cover expected credit loss (ECL).Automated Branch Treasury Cash Sweeps:Establish automated End-of-Day (EoD) Zero-Balance Account (ZBA) sweeps.Channel the +$699,837.94 cumulative surplus from East, Suburban, and North branches to fund the -$381,720.75 combined deficit at Main, City Center, and Downtown branches, eliminating overnight interbank borrowing fees.Real-Time AML Alert Surveillance Engine (> $4,500 Debit Cutoff):Main Branch (902 flags) and Downtown Branch (901 flags) account for 34.3% of all high-value debit transfers.Implement real-time compliance holds and mandatory FinCEN Suspicious Activity Report (SAR) reviews on rapid repetitive debits approaching $5,000.📂 Repository File StructureBanking_Analytics_Project/
├── 01_Banking_Analytics_Data_.ipynb        # Interactive Jupyter ETL & Analytics Pipeline
├── banking_analytics_production.sql        # Validated Production MySQL Queries & Schema DDL
├── Bank Decision Management - ... .twb      # Tableau Public BI Workbook
├── Project_Report.docx                     # Professional Executive Project Report (1" margins, #102C57)
├── requirements.txt                        # Production Pinned Dependencies
├── README.md                               # Comprehensive Project Documentation
├── MySQL RESULT/
│   ├── Credit Risk Segregation ...csv      # Exported Verified Credit Risk Results
│   └── Branch Liquidity ...csv             # Exported Verified Branch Liquidity Rankings
└── RAW DATASET/
    ├── Bank Data Analystics.xlsx           # Raw Loan Portfolio Data (65,535 rows)
    └── Debit and Credit banking_data.xlsx  # Raw Retail Transactions Data (100,000 rows)
🚀 Step-by-Step Reproduction Instructions1. PrerequisitesPython: 3.10, 3.11, or 3.12MySQL Server: 8.0 (configured on port 3307, or modify connection string to 3306)Tableau: Desktop or Tableau Public Reader2. Environment SetupBash# Clone the repository
git clone [https://github.com/Sanjay-Balan/Citi_Banking_Analytics_Project.git](https://github.com/Sanjay-Balan/Citi_Banking_Analytics_Project.git)
cd Citi_Banking_Analytics_Project

# Create and activate virtual environment
python -m venv venv

# Windows PowerShell:
.\venv\Scripts\Activate.ps1
# Linux / macOS:
# source venv/bin/activate

# Install production dependencies
pip install -r requirements.txt
3. Database Initialization & Pipeline ExecutionBash# Open and run the ETL notebook:
jupyter lab 01_Banking_Analytics_Data_.ipynb
Alternatively, run Python script to clean and stream data into MySQL:Pythonfrom sqlalchemy import create_engine
import pandas as pd

# Connect to MySQL on port 3307
db_url = 'mysql+pymysql://root:root123@localhost:3307/'
engine = create_engine(db_url)

# Execute ETL and upload to database
# (Tables 'loan_portfolio' and 'banking_transactions' are populated)
4. Execute Relational SQL QueriesExecute the validated SQL queries in MySQL Workbench or CLI:Bashmysql -u root -p -P 3307 < banking_analytics_production.sql
5. Generate the Executive Word ReportBashpython build_project_report.py
This generates the formatted executive deliverable Project_Report.docx.6. Launch Tableau Business Intelligence DashboardOpen Bank Decision Management - Credit Risk Dashboard.twb in Tableau Public / Tableau Desktop to interact with the visual analytics suite.

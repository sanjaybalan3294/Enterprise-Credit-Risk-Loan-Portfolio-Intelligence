-- 1. Create and use database
CREATE DATABASE IF NOT EXISTS citi_bank_analytics;
USE citi_bank_analytics;


-- 2. Create Loan Portfolio table structure
CREATE TABLE loan_portfolio (
    Account_ID VARCHAR(50),
    Client_id VARCHAR(50),
    Client_Name VARCHAR(100),
    Bank_Name VARCHAR(100),
    Branch_Name VARCHAR(100),
    City VARCHAR(100),
    State_Name VARCHAR(100),
    State_Abbr VARCHAR(10),
    Grrade VARCHAR(5),
    Sub_Grade VARCHAR(10),
    Loan_Amount DECIMAL(15, 2),
    Funded_Amount DECIMAL(15, 2),
    Int_Rate VARCHAR(20),
    Term VARCHAR(20),
    Loan_Status VARCHAR(50),
    Is_Delinquent_Loan VARCHAR(5),
    Is_Default_Loan VARCHAR(5),
    Disbursement_Date VARCHAR(50),
    Disbursement_Date_Years VARCHAR(10),
    Verification_Status VARCHAR(50),
    Home_Ownership VARCHAR(50),
    Purpose_Category VARCHAR(100),
    Total_Pymnt DECIMAL(15, 2),
    Recoveries DECIMAL(15, 2)
);

-- 3. Create Banking Transactions table structure
CREATE TABLE banking_transactions (
    Customer_ID VARCHAR(50),
    Customer_Name VARCHAR(100),
    Account_Number VARCHAR(50),
    Transaction_Date VARCHAR(50),
    Transaction_Type VARCHAR(20),
    Amount DECIMAL(15, 2),
    Balance DECIMAL(15, 2),
    Description VARCHAR(255),
    Branch VARCHAR(100),
    Transaction_Method VARCHAR(50),
    Currency VARCHAR(10),
    Bank_Name VARCHAR(100),
    Is_High_Risk_Txn INT
);

  -- Credit Risk Segregation & Delinquency Rates by Grade

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



-- Branch Liquidity, Net Cash Flow & Inflow/Outflow Surveillance
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


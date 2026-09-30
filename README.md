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

# 🌍 International Debt Analysis System (Python, MySQL & Power BI)

An end-to-end Finance & Global Economic Data Analytics pipeline built on **World Bank International Debt Statistics (2000–2024)**. This project transforms raw, multi-file wide-format CSV data into a normalized MySQL relational database, answers 30 business-driven SQL analytical questions, and delivers an interactive 3-page Power BI dashboard.

---

## 📌 Problem Statement
Global financial institutions like the World Bank publish international debt data across multiple raw CSV files with wide year columns, inconsistent codes, and missing values. Extracting country-wise borrowing trends, regional concentrations, and indicator-level insights requires a structured ETL pipeline, relational storage, and interactive visual reporting.

---

## 🛠️ Tech Stack
* **Python:** Pandas, NumPy, Regular Expressions (`re`), Matplotlib, Seaborn, SQLAlchemy, PyMySQL
* **Database:** MySQL (Normalized Star/Relational Schema with Primary & Foreign Keys, Indexes, Views, CTEs, Window Functions)
* **BI & Visualization:** Power BI Desktop (DAX Measures, Interactive Slicers, Geo Maps, Treemaps)

---

## 🔄 End-to-End Pipeline Architecture
1. **Data Collection:** Loaded 5 World Bank IDS datasets (`Country-Series`, `ALLCountries_Data`, `CountryMetaData`, `FootNoteMetaData`, `SeriesMetaData`).
2. **Data Cleaning & Preprocessing (Python):**
   * Reshaped 25 year columns (`2000–2024`) from wide to long format using `pd.melt()` (**1,574,450 records**).
   * Extracted standardized Country, Series, and Year codes using Regex and stripped trailing whitespace that caused merge mismatches.
   * Imputed time-series gaps via group-wise forward/backward fill (`ffill().bfill()`) and tagged aggregate groups accurately while preserving individual countries.
   * Verified referential integrity across tables before export.
3. **Database Design & SQL Analytics (MySQL):**
   * Built a normalized `debt_analysis` schema with `countries` (134 rows), `indicators` (577 rows), and `debt_data` (1,574,450 rows).
   * Automated bulk data ingestion from Python to MySQL using `SQLAlchemy` + `PyMySQL`.
   * Solved **30 analytical SQL queries** (Basic, Intermediate, and Advanced) covering rankings, percentage shares, `CASE` debt tiers, cumulative window sums, and SQL Views.
4. **Exploratory Data Analysis & Dashboarding (Python & Power BI):**
   * Generated 8 EDA charts in Python (global trends, top/bottom countries, income-group share, and Region vs. Income Group heatmap).
   * Built a 3-page interactive Power BI dashboard featuring KPI cards, regional trends, treemaps, and global debt maps.

---

## 📂 Repository Structure
- `InternationalDebtAnalysis.ipynb` — Data cleaning, preprocessing, and 8 EDA visualizations
- `load_to_mysql.py` — Automated Python-to-MySQL bulk data loader (SQLAlchemy + PyMySQL)
- `international_debt_analysis.sql` — Normalized MySQL schema + 30 analytical SQL queries
- `Global Debt Analysis Dashboard.pbix` — 3-page interactive Power BI dashboard
- `screenshots/` — Power BI dashboard page screenshots
- `README.md` — Project documentation

---

## 🚀 How to Run This Project
1. **Python Cleaning & EDA:** Open `Project2.ipynb` in Jupyter Notebook or Google Colab with the 5 World Bank IDS CSV files and run all cells to generate the cleaned CSVs.
2. **MySQL Setup:** Run the schema section of `international_debt_analysis.sql` in MySQL Workbench to create the `debt_analysis` database and tables.
3. **Load Data:** Update your MySQL password in `load_to_mysql.py` and run `python load_to_mysql.py` in your terminal.
4. **Run Analytics:** Execute the 30 queries in `international_debt_analysis.sql` inside MySQL Workbench.
5. **View Dashboard:** Open `Global Debt Analysis Dashboard.pbix` in Power BI Desktop.
## 📊 Key Insights
* **Steady 25-Year Growth:** Global external debt climbed consistently from 2000 to 2024, with a sharp acceleration after 2010.
* **Country Concentration:** **China** leads global external borrowing by a wide margin, followed by **India, Mexico, Brazil, and Indonesia**.
* **Regional & Income Dominance:** **East Asia & Pacific** and **Latin America & Caribbean** hold the largest regional shares, driven primarily by **Upper Middle Income** economies (~70.8% of total share).

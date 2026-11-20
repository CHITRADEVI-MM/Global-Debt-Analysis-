# Global-Debt-Analysis-
Global Debt Analysis Dashboard
An end-to-end data analysis project that explores global debt patterns across countries, regions, income groups, and years (2000–2024). The project uses Python for data preparation and Power BI Desktop for interactive visualisation.
Project Overview
The dashboard helps users explore:
- Global debt trends over time
- Countries with the highest recorded debt values
- Debt distribution across regions
- Debt distribution by income group
- Debt indicators and their contribution to total debt
- Country coverage across the selected years
Tools and Technologies
- Python — data cleaning and preparation
- Pandas — data manipulation
- NumPy — numerical operations
- MySQL — data storage/querying, if used in the Python workflow
- Power BI Desktop — data modelling and interactive dashboards
- Visual Studio Code / Jupyter Notebook — Python development
Dataset
The analysis uses global debt data with fields such as:
- Country_Name
- Country_Code
- Series_Name
- Series_Code
- Year
- Debt_Value
The dataset covers the years 2000–2024. The exact number of countries and indicators can vary depending on the filters and records included in the source dataset.

Dashboard Pages
Page 1 — Global Debt Overview
- Global debt KPI
- Total countries
- Total indicators
- Top 10 countries by debt
- Debt by region
- Debt by income group
- Global debt trend (2000–2024)
- Interactive filters
Page 2 — Debt Distribution
- Treemap showing debt distribution by country
- Debt value by year and income group
- Donut chart showing debt by income group
Page 3 — Global Debt Growth and Country Coverage
- Global debt growth compared with country coverage
- Debt share of the top 10 countries
- Regional debt comparison by income group
- Global debt distribution map (when map visuals are enabled in Power BI)
Python Workflow
The Python part of the project is intended for preparing the source data before it is analysed in Power BI.

Typical steps:
1. Load the source dataset.
2. Inspect column names, data types, missing values, and duplicates.
3. Clean and transform the data.
4. Prepare the required tables or files for analysis.
5. Load or connect the prepared data to MySQL, if that step is part of your implementation.
6. Connect the prepared data to Power BI and build the report.

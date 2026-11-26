import pandas as pd
from urllib.parse import quote_plus
from sqlalchemy import create_engine

# 1. Connect to local MySQL database
password = quote_plus("12345")  # Put your real MySQL Workbench password here
engine = create_engine(f"mysql+pymysql://root:{password}@localhost:3306/debt_analysis")
path = r"C:\Users\LENOVO\Downloads\\"

# 2. Load Countries (df3_clean.csv)
df_countries = pd.read_csv(path + "df3_clean.csv")
df_countries = df_countries[['Code', 'Short_Name', 'Region', 'Income_Group', 'Lending_category', 'Currency_Unit']]
df_countries.columns = ['country_code', 'country_name', 'region', 'income_group', 'lending_category', 'currency_unit']

df_countries.to_sql('countries', con=engine, if_exists='append', index=False)
print(f"Loaded {len(df_countries)} rows into countries.")

# 3. Load Indicators (df5_clean.csv + 3 extra IMF codes)
df_ind = pd.read_csv(path + "df5_clean.csv")
df_ind = df_ind[['Code', 'Indicator_Name', 'Topic', 'Periodicity']]
df_ind.columns = ['series_code', 'indicator_name', 'topic', 'periodicity']

extra_ind = pd.DataFrame([
    ('DT.DOD.DIMF.US.CD', 'Use of IMF credit (DOD, current US$)', 'Unknown', 'Annual'),
    ('DT.INT.DIMF.US.CD', 'IMF credit, charges (INT, current US$)', 'Unknown', 'Annual'),
    ('DT.INT.DSDR.CD', 'IMF SDR allocations, charges (INT, current US$)', 'Unknown', 'Annual')
], columns=['series_code', 'indicator_name', 'topic', 'periodicity'])

df_ind = pd.concat([df_ind, extra_ind], ignore_index=True).drop_duplicates(subset=['series_code'])
df_ind.to_sql('indicators', con=engine, if_exists='append', index=False)
print(f"Loaded {len(df_ind)} rows into indicators.")

# 4. Load Debt Data (df2_clean.csv) in chunks so memory stays safe
df_debt = pd.read_csv(path + "df2_clean.csv")
df_debt = df_debt[['Country_Code', 'Series_Code', 'Year', 'Debt_Value']]
df_debt.columns = ['country_code', 'series_code', 'year', 'debt_value']

df_debt.to_sql('debt_data', con=engine, if_exists='append', index=False, chunksize=10000, method='multi')
print(f"Loaded {len(df_debt)} rows into debt_data!")
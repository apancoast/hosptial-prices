# Hospital Standard Charge List Analysis
This project explores the public Standard Charge lists from two hospitals in Charlotte, NC. The goal of this project is to provide insights into the pricing strategies of these hospitals and to compare the cost of common medical procedures between the two hospitals.

# Tools Used
This project utilizes SQL, Python, and Power BI to analyze and visualize the hospital charge data. Python is used to parse the JSON files obtained and convert them into a format suitable for loading into the SQL database. SQL is then used to extract, transform, and load the data from the various data sources into a centralized database. Finally, Power BI is used to create interactive visualizations and reports to explore the data.

# Project Structure
- sql: Contains the SQL scripts used to engineer the database, preprocess the data, and perform exploratory data analysis (EDA) with Power BI. The SQL scripts are organized into the following subfolders:
    - database: Contains files used to create the database schema and tables.
    - preprocessing: Contains files used to clean and process the raw data and load it into the database. Admittedly, some scripts here may be better suited for the database folder. This ended up being a sort of database within a database. I'm not a data enginnering, and my goal was to make it succinct for Power Bi as quickly as possible. (The numbers in file names indicate order of excution because, uh, it's a mess.)
    - eda: Contains files used to perform exploratory data analysis (EDA) in conjunction with Power BI.
    - er: Contains the ER diagram for the database.
- notebooks: Contains the Jupyter Notebook used to parse JSON files obtained and convert them into a format suitable for loading into the SQL database.
- reports: 
    - power_bi: Contains the Power BI report files used to visualize and explore the hospital charge data, though they won't work without the attached database.
    - pdfs: Contains PDFs of Power BI reports for easier viewing.

# Data Sources
Due to file size and license restrictions, the source data files are not included in this repository, but can be accessed at the above data source links. The data for this project was obtained from the following sources:
- [OHDSI Athena](https://athena.ohdsi.org/search-terms/start) - a public database of healthcare data
Files used:
    - HCPCS and CPT4 Vocabularies, version 5
- [Novant Health Standard Charges](https://www.novanthealth.org/home/patients--visitors/your-healthcare-costs/cost-estimates/medical-center-standard-charges.aspx) - a public list of standard charges for medical procedures at Novant Health hospitals
Files used:
    - Presbyterian Medical Center standard charges
- [Atrium Health Pricing](https://atriumhealth.org/for-patients-visitors/financial-assistance/pricing) - a public list of standard charges for medical procedures at Atrium Health hospitals
Files used:
    -Carolinas Medical Center and Levine Children’s Hospital Standard Charges

# Results
The results of this project can be found in the Power BI report files located in the reports folder. The report provides insights into the pricing strategies of Novant Health and Atrium Health, and compares the cost of common medical procedures between the two hospitals. Additionally, SQL scripts are included in the data folder that can be used to reproduce the database and perform further analysis.

Please note that this project is on-going, so results are currently limited. It is my goal to provide actionable business insights as the project develops, which will be documented in the following Change Log.

# Change Log
## March 8, 2023
- Inital upload include database enginnering SQL scripts and report of the Gross Charges report exploring the difference in gross charges of codes shared by both hospitals.

## Future plans
- Analyze the cost differences of medical procedures shared by both hospitals for cash and insurance payments.
- Investigate whether there are any patterns in the types of patients or services offered by each hospital based on the CPT codes used and the charges associated with them (focusing on unshared codes).
- Incorporate additional data sources, such as sentiment analysis of publicly available reviews and Google search data, to gain a more comprehensive understanding of the factors that influence hospital charges.
- Explore the impact of demographic and location factors on hospital charges, such as age, gender, income, and geographic location.
- Continuously update and refine the Power BI reports to provide more insights into the hospital charge data.

# Contact
For any questions or feedback about this project, please to contact me via [LinkedIn](https://www.linkedin.com/in/pancoastashley/).

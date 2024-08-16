# Amazon Sales Data Anylysis
## Project Overview
This project aims to analyze sales data from Amazon using a robust ETL pipeline built with dbt (Data Build Tool) and Snowflake as the data warehouse. The analysis focuses on various aspects of sales performance, including product performance, promotions, seasonal trends, and geographical insights. The project is designed to provide actionable insights to help improve business strategies.

## Tech Stack
- dbt: For data transformation and modeling.
- Snowflake: As the data warehouse solution.
- Fivetran: For automated data ingestion.
- Git: Version control.
  
## Data Pipeline Overview
![image](https://github.com/user-attachments/assets/ceff70b5-b244-4f30-bd3d-723bdb109ca3)
The data pipeline starts with ingesting sales data from Google Sheets into Snowflake using Fivetran. The data is then transformed using dbt, where it goes through multiple stages, including staging, intermediate transformations, and finally, the creation of fact and dimension tables (data marts).

## Project DAG
![Screenshot 2024-08-15 at 10 32 57 PM](https://github.com/user-attachments/assets/939e87db-33b7-4ff1-abfb-1c2993b7d2e9)

The DAG represents the flow of data from raw ingestion to final analysis models. Each node in the DAG represents a transformation step, from cleaning the data in staging models to aggregating key metrics in data marts.

## Data Sources
- Google Sheets: Contains the raw sales data from Amazon.
- Fivetran: Used to automatically sync data from Google Sheets to Snowflake.
- 
## Models Breakdown
### Staging Models
The staging models clean and prepare the raw data for further transformations. Key transformations include:

- Handling null values in critical columns like Amount.
- Standardizing the Status field to ensure consistency across the dataset.
- Filtering out irrelevant or erroneous data, such as canceled or damaged shipments.
### Intermediate Models
Intermediate models aggregate and organize the data to answer specific business questions. These models include:

- int_sales_summary: Aggregates sales data by SKU, category, and state.
- int_seasonal_trends: Summarizes sales trends by month and product category.
### Data Marts (Fact & Dimension Tables)
The final data marts are structured to support detailed business intelligence analysis:

Fact Tables:
- fct_product_performance: Tracks product performance, including revenue, returns, and cancellations.
- fct_promotion_impact: Measures the impact of promotions on sales performance.
- fct_seasonal_trends: Analyzes sales trends across different seasons.
- fct_geography_performance: Provides insights into sales performance across different states.
## Analysis and Insights
### Key Business Questions Answered
![Screenshot 2024-08-15 at 10 37 26 PM](https://github.com/user-attachments/assets/6469229f-481a-4c00-9819-89fd665bfbfb)
![Screenshot 2024-08-15 at 10 37 59 PM](https://github.com/user-attachments/assets/af92fb77-cb2c-4952-8472-76176c6639b3)
![Screenshot 2024-08-15 at 10 39 00 PM](https://github.com/user-attachments/assets/0e5ae0ad-5ce4-488c-82e9-5b4f24b4ff82)
![Screenshot 2024-08-15 at 10 39 51 PM](https://github.com/user-attachments/assets/4fc69a9c-7cae-4766-945b-6e3aa4bdcc4a)



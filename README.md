# Walmart_Data Analysis

## Table of Contents

1. [Introduction](#introduction)
2. [Database and Table Schema](#database-and-table-schema)
3. [Data Cleaning and Preparation](#data-cleaning-and-preparation)
4. [Feature Engineering](#feature-engineering)
5. [Generic Questions](#generic-questions)
6. [Product Analysis](#product-analysis)
7. [Sales Analysis](#sales-analysis)
8. [Customer Analysis](#customer-analysis)
9. [How to Run the Project](#how-to-run-the-project)
10. [License](#license)

## Introduction

This project involves the analysis of Walmart sales data to gain insights into various aspects of the business, such as product sales, customer behavior, and overall performance. The analysis is performed using SQL queries on a MySQL database.

## Database and Table Schema
The dataset was obtained from the Kaggle Walmart Sales Forecasting Competition(https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting/data).
The project begins by creating a database named `walmart_db` and using it to store the sales data in a table named `walmart_data`. The table includes fields such as `Unit price`, `Total`, `Time`, `Tax 5%`, `Rating`, `Quantity`, `Product line`, `Payment`, and more, each with its respective data type and constraints.

## Data Cleaning and Preparation

To ensure the data's integrity and usability, several data cleaning steps are performed:

1. **Time Field Modification:** The `Time` field is modified to use the `TIME` data type.
2. **Null Count View:** A view named `NULL_COUNT` is created to count the number of null or empty values in each column.
3. **Feature Engineering:** Additional columns such as `time_of_day`, `day_name`, and `month_name` are added and populated based on existing data.

## Feature Engineering

New features are engineered to enrich the data and provide more meaningful insights:

- **Time of Day:** Categorizes each sale based on the time of the day (Morning, Afternoon, Evening, Night).
- **Day Name:** Adds the name of the day for each date.
- **Month Name:** Adds the name of the month for each date.
- **VAT Calculation:** Computes the VAT based on the `Tax 5%` and `cogs` fields.
- **Product Line Type:** Categorizes product lines as 'Good' or 'Bad' based on the average gross income.

## Generic Questions

This section addresses basic queries to understand the dataset better:

1. Count of unique cities.
2. Distinct cities and their respective branches.

## Product Analysis

Detailed analysis of products, including:

1. Number of unique product lines.
2. Most common payment method.
3. Most selling product line.
4. Total revenue by month.
5. Month with the largest cost of goods sold (COGS).
6. Product line with the largest revenue.
7. City with the largest revenue.
8. Product line with the highest VAT.
9. Categorization of product lines based on gross income.
10. Branches with sales exceeding the average product sold.
11. Most common product line by gender.
12. Average rating of each product line.

## Sales Analysis

Insights into sales patterns:

1. Number of sales made during different times of the day on weekdays.
2. Customer types contributing the most revenue.
3. City with the largest tax percentage/VAT.
4. Customer type paying the most in VAT.

## Customer Analysis

Understanding customer behavior:

1. Unique customer types.
2. Unique payment methods.
3. Most common customer type.
4. Customer type with the highest purchases.
5. Gender distribution among customers.
6. Gender distribution across branches.
7. Time of the day when customers give the most ratings.
8. Time of the day when customers give the most ratings per branch.
9. Day of the week with the best average ratings.
10. Day of the week with the best average ratings per branch.

## How to Run the Project

1. Set up a MySQL database and import the provided SQL scripts.
2. Execute the SQL queries to perform the data analysis.
3. Review the results of each query to gain insights into the Walmart sales data.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.


CREATE DATABASE IF NOT EXISTS walmart_db;
USE walmart_db;

SELECT * FROM walmart_data;
DESCRIBE walmart_data;
ALTER TABLE walmart_data MODIFY `Time` TIME;

-- NULL COUNT
CREATE OR REPLACE VIEW NULL_COUNT AS 
SELECT 'Invoice ID' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `Invoice ID` IS NULL OR `Invoice ID` = '' OR 0

UNION ALL

SELECT 'Branch' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `Branch` IS NULL OR `Branch` = '' OR 0

UNION ALL

SELECT 'City' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `City` IS NULL OR `City` = '' OR 0

UNION ALL

SELECT 'Customer type' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `Customer type` IS NULL OR `Customer type` = '' OR 0

UNION ALL

SELECT 'Gender' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `Gender` IS NULL OR `Gender` = '' OR 0

UNION ALL

SELECT 'Product line' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `Product line` IS NULL OR `Product line` = '' OR 0

UNION ALL

SELECT 'Unit price' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `Unit price` IS NULL OR `Unit price` = '' OR 0

UNION ALL

SELECT 'Quantity' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `Quantity` IS NULL OR `Quantity` = '' OR 0

UNION ALL

SELECT 'Tax 5%' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `Tax 5%` IS NULL OR `Tax 5%` = '' OR 0

UNION ALL

SELECT 'Total' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `Total` IS NULL OR `Total` = '' OR 0

UNION ALL

SELECT 'Date' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `Date` IS NULL OR `Date` = '' OR 0

UNION ALL

SELECT 'Time' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `Time` IS NULL OR `Time` = '' OR 0

UNION ALL

SELECT 'Payment' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `Payment` IS NULL OR `Payment` = '' OR 0

UNION ALL

SELECT 'cogs' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `cogs` IS NULL OR `cogs` = '' OR 0

UNION ALL

SELECT 'gross margin percentage' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `gross margin percentage` IS NULL OR `gross margin percentage` = '' OR 0

UNION ALL

SELECT 'gross income' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `gross income` IS NULL OR `gross income` = '' OR 0

UNION ALL

SELECT 'Rating' as column_name, COUNT(*) as null_count 
FROM walmart_data 
WHERE `Rating` IS NULL OR `Rating` = '' OR 0;

-- To query the view
SELECT * FROM NULL_COUNT;

-- ------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------ Feature Engineering----------------------------------------------------------------

SELECT * FROM walmart_data;
SET sql_safe_updates = 0;
ALTER TABLE walmart_data
ADD COLUMN `time_of_day` TEXT NOT NULL;

UPDATE walmart_data 
SET `time_of_day`= CASE
	WHEN `TIME` between '00:00:00' and '11:59:59' THEN 'Morning'
    WHEN `TIME` between '12:00:00' and '15:59:59' THEN 'Afternoon'
    WHEN `TIME` between '16:00:00' and '19:59:59' THEN 'Evening'
    ELSE 'Night'
END;
SELECT `time_of_day`,COUNT(`time_of_day`) FROM walmart_data GROUP BY `time_of_day`;


ALTER TABLE walmart_data ADD COLUMN day_name TEXT NOT NULL;
UPDATE walmart_data SET day_name= DAYNAME(`DATE`);

ALTER TABLE walmart_data
ADD COLUMN `month_name` TEXT NOT NULL;
UPDATE walmart_data
SET `month_name`= MONTHNAME(`DATE`);


ALTER TABLE walmart_data ADD COLUMN vat DOUBLE NOT NULL;
UPDATE walmart_data SET vat =( `Tax 5%`* `cogs`




-- ------------------------------------------------------------------------------------------------------------------------------
 # GENERIC QUESTIONS
 -- ------------------------------------------------------------------------------------------------------------------------------
 
 -- 1
SELECT COUNT(DISTINCT(City)) as Unique_city_count FROM walmart_data;
 
 -- 2
 SELECT distinct(city), branch from walmart_data;
 
 -- ------------------------------------------------------------------------------------------------------------------------------
 
 ## Product 
 
 -- ------------------------------------------------------------------------------------------------------------------------------
 -- 1 How many unique product lines does the data have?
 SELECT DISTINCT(`Product line`) FROM walamrt_data;
 
 -- 2 What is the most common payment method?
 SELECT PAYMENT Most_common_payment_mode, COUNT(Payment) FROM walmart_data 
 GROUP BY Payment ORDER BY COUNT(Payment) DESC LIMIT 1;
 
 -- 3 MOST SELLING PRODUCT LINE
 SELECT `Product line` Most_Selling_Product_Line FROM walmart_data 
 GROUP BY `Product line` ORDER BY COUNT(`Product line`) DESC LIMIT 1;
 
-- 4 TOTAL REVENUE BY MONTH
SELECT `month_name` , SUM(`Total`) `Total Revenue`
FROM walmart_data 
GROUP BY `month_name`,MONTH(`DATE`) ORDER BY MONTH(`DATE`) ASC;

-- 5 MONTH HAVING LARGEST COGS
SELECT `month_name` Max_cogs_Month FROM walmart_data  
GROUP BY `month_name` ORDER BY SUM(`cogs`) DESC LIMIT 1;


-- 6 PRODUCT LINE HAVING LARGEST REVENUE
SELECT `Product line` FROM walmart_data 
GROUP BY `Product line` ORDER BY SUM(`Total`) DESC LIMIT 1;


-- 7 CITY HAVING LARGEST REVENUE
SELECT `City` FROM walmart_data 
GROUP BY`City` ORDER BY SUM(`Total`) DESC LIMIT 1;


-- 8 Product having largesrt vat
SELECT `Product line`, SUM(`Tax 5%`)  FROM walmart_data
GROUP BY `Product line` ORDER BY  SUM(`Tax 5%`) DESC;


-- 9
ALTER  TABLE walmart_data ADD COLUMN P_line_type TEXT NOT NULL;
SET @AVG_INCOME= (SELECT AVG(`gross income`) FROM walmart_data);   -- USING TEMP VARIABLE TO HOLD AVG INCOME
UPDATE walmart_data 
SET P_line_type=CASE
	WHEN `gross income` > @AVG_INCOME THEN 'Good'
    ELSE 'BAD'
END;
SELECT `Product line`,`P_line_type` FROM walmart_data;

-- 10 Branches having sales> avg product sold
SELECT `Branch`
FROM walmart_data GROUP BY `Branch` 
HAVING SUM(`Quantity`)>AVG(`Quantity`);
 


-- 11 MOST COMMON PRODUCT LINE BY GENDER
SELECT DISTINCT(`Product line`),`Gender` 
FROM walmart_data GROUP BY `Product line`,`Gender`
ORDER BY (SELECT COUNT(`Gender`) FROM walmart_data) DESC;

-- 12 AVG RATING OD EACH PRODUCT LINE
SELECT `Product line`, AVG(`Rating`) 
FROM walmart_data GROUP BY `Product line`;

-- - - - - - - - - -
SELECT * FROM walmart_data;

-- ------------------------------------------------------------------------------------------------------------------------------

## SALES

-- ------------------------------------------------------------------------------------------------------------------------------
-- 1 Number of sales made in each time of the day per weekday
SELECT COUNT(`Invoice ID`) No_of_Sales,time_of_day ,day_name FROM walmart_data
WHERE  day_name NOT IN ('Saturday','Sunday')
GROUP BY time_of_day, day_name ORDER BY COUNT(`Invoice ID`) DESC;

-- 2 customer types bringing the most revenue
SELECT `Customer type`, SUM(`Total`) as Revenue
FROM walmart_data GROUP BY `Customer type`;

-- 3 city having the largest tax percent/ VAT (Value Added Tax)
SELECT `city`, SUM(`Tax 5%`) FROM walmart_data 
GROUP BY `city` ORDER BY SUM(`Tax 5%`) DESC LIMIT 1;

-- 4 customer type paying the most in VAT
SELECT `Customer type`, SUM(`Tax 5%`) FROM walmart_data 
GROUP BY `Customer type` 
ORDER BY SUM(`Tax 5%`) DESC LIMIT 1 ; 

-- ------------------------------------------------------------------------------------------------------------------------------

## CUSTOMER

-- ------------------------------------------------------------------------------------------------------------------------------
-- 1  unique customer types
SELECT DISTINCT(`Customer type`) unique_cust_type FROM walmart_data;
-- 2 unique payment methods 
SELECT DISTINCT(`Payment`) Unique_Payment_Methods FROM walmart_data;

-- 3 most common customer type
SELECT `Customer type` most_common_customer 
FROM walmart_data GROUP BY `Customer type` 
ORDER BY COUNT(`Customer type`) DESC LIMIT 1;

-- 4 customer type buys the most
SELECT `Customer type` FROM walmart_data 
GROUP BY `Customer type` 
ORDER BY SUM(`TOTAL`) DESC;

-- 5 Gender of most of the customers
SELECT `Gender` as max_freq_cust ,COUNT(`Gender`) number_of_cust FROM walmart_data 
GROUP BY `Gender` ORDER BY COUNT(`Gender`) DESC LIMIT 1;

-- 6 OVER ALL GENDER DISTRIBUTTION BRANCH 
SELECT `Branch`,`Gender`,
CONCAT(ROUND((COUNT(*)/(Select COUNT(`Gender`) FROM walmart_data)*100)),'%') as Percent_Dist
FROM walmart_data GROUP BY `Branch`,`Gender`;

# using windows function

SELECT `Branch`,`gender`, 
CONCAT(ROUND(COUNT(`Gender`)*100/SUM(COUNT(`Gender`)) OVER (PARTITION BY `Branch`),2),'%')
AS PERCENT_DISTRIBUTION FROM walmart_data GROUP BY `Branch`, `Gender`;



-- 7 time of the day when customers give most ratings
SELECT `time_of_day` as Most_Rating_Time FROM walmart_data 
GROUP BY `time_of_day` ORDER BY count(`Rating`) DESC LIMIT 1;

-- 8 time of the day do customers give most ratings per branch
SELECT `time_of_day` as Most_Rating_Time, `Branch` FROM walmart_data 
GROUP BY `time_of_day` ORDER BY count(`Rating`) DESC LIMIT 1;

-- 9 day fo the week having the best avg ratings
SELECT DAYNAME(`Date`) Dayname, AVG(`Rating`) max_average
FROM walmart_data GROUP BY DAYNAME(`Date`)
ORDER BY AVG(`Rating`)DESC LIMIT 1;

-- 10 day of the week has the best average ratings per branch
SELECT DAYNAME(`Date`) Day_of_week,`Branch`, AVG(`Rating`) max_average
FROM walmart_data GROUP BY `Branch`,DAYNAME(`Date`)
ORDER BY AVG(`Rating`)DESC;

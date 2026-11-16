
DROP TABLE IF EXISTS "SALES_DATASET";

CREATE TABLE SALES_DATASET (
    "Order_ID" VARCHAR(50) PRIMARY KEY,
    "Order_Date" DATE,
    "Ship_Date" DATE,    
    "Ship_Mode" VARCHAR(50),
    "Customer_ID" VARCHAR(50),
    "Customer_Name" VARCHAR(100),
    "Segment" VARCHAR(50),
    "Region" VARCHAR(50),
    "State" VARCHAR(50),
    "City" VARCHAR(50),
    "Product_ID" VARCHAR(50),
    "Product_Name" VARCHAR(255),
    "Category" VARCHAR(50),
    "Sub_Category" VARCHAR(50),
    "Quantity" INTEGER,
    "Unit_Price" NUMERIC(10, 2),
    "Unit_Cost" NUMERIC(10, 2),
    "Unit_Pofit" NUMERIC(10, 2),
    "Discount" VARCHAR(10),
    "Discount_Band" VARCHAR(50),
    "Total_Discount" NUMERIC(10, 4),
    "After_disc_price" NUMERIC(10, 2),
    "Shipping_Cost" NUMERIC(10, 2),
    "Sales" NUMERIC(10, 2),
    "Final_Profit_on_Sale" NUMERIC(10, 2),
    "Profit_Margin" NUMERIC(10, 4),
    "Sales_Channel" VARCHAR(50),
    "Payment_Method" VARCHAR(50),
    "Order_Priority" VARCHAR(50)
);

COPY "SALES_DATASET"
FROM 'C:\'
DELIMITER ','
CSV HEADER;

select * from "SALES_DATASET";



--                             T-1
-------------------------------------------------------------------------------
--We need to find products that are generating sales but losing money overall.
-------------------------------------------------------------------------------
SELECT
	"Product_Name",
	SUM("Sales") AS TOTAL_SALES,
	SUM("Final_Profit_on_Sale") AS FINAL_PROFIT,
	SUM("Final_Profit_on_Sale" + "Sales") AS TOTAL_LOSS
FROM
	"SALES_DATASET"
GROUP BY
	"Product_Name"
HAVING
	SUM("Final_Profit_on_Sale") < 0
	and sum("Sales")>0
ORDER BY
	TOTAL_SALES desc;



----Finding Total Bleeding_Profits

WITH Unprofitable_Products as
( SELECT
	"Product_Name",
	SUM("Sales") AS TOTAL_SALES,
	SUM("Final_Profit_on_Sale") AS TOTAL_PROFIT
FROM
	"SALES_DATASET"
GROUP BY
	"Product_Name"
HAVING
	SUM("Final_Profit_on_Sale") < 0
	and sum("Sales")>0 )
	
select sum(TOTAL_SALES) as Bleeding_Products_Total_Sales,
       sum(TOTAL_PROFIT) as Bleeding_Profit
	   
	   from Unprofitable_Products;



----Finding loss_margin_percentage

WITH Unprofitable_Products as
( SELECT
	"Product_Name",
	SUM("Sales") AS TOTAL_SALES,
	SUM("Final_Profit_on_Sale") AS TOTAL_PROFIT
FROM
	"SALES_DATASET"
GROUP BY
	"Product_Name"
HAVING
	SUM("Final_Profit_on_Sale") < 0
	and sum("Sales")>0 )
	
select sum(TOTAL_SALES) as Bleeding_Products_Total_Sales,
       sum(TOTAL_PROFIT) as Bleeding_Profit,
	   round((sum(TOTAL_PROFIT) / sum(TOTAL_SALES)) * 100,2) as loss_margin_percentage
	   
	   from Unprofitable_Products;





--                                 T-2
--------------------------------------------------------------
--Shipping Efficiency
--------------------------------------------------------------
SELECT 
    "Ship_Mode",
    round(avg("Ship_Date"::date - "Order_Date"::date),2) AS Total_Days_To_Ship
FROM 
    "SALES_DATASET"
GROUP BY 
    "Ship_Mode"
ORDER BY 
    Total_Days_To_Ship DESC;




--                                 T-3        
---------------------------------------------------------------------
--Identify VIP Customers
---------------------------------------------------------------------


SELECT
	"Customer_Name","Segment",
	ROUND(SUM("Sales"),0) AS SALES,
	ROUND(SUM("Final_Profit_on_Sale"),0) AS GIVE_US_PROFIT,
	ROUND(AVG("Profit_Margin"),2) AS Avg_Profit_Margin
FROM
	"SALES_DATASET"
GROUP BY
	"Customer_Name","Segment"
ORDER BY	
	SALES DESC
LIMIT
	10;

select * from "SALES_DATASET";
		

---------------------------------------------------------
--Monthly Sales Trends (Time-Series) 
---------------------------------------------------------

SELECT 
    DATE_TRUNC('month', "Order_Date"::date)::date AS Order_Month,
    ROUND(SUM("Sales"), 2) AS Total_Sales,
    ROUND(SUM("Final_Profit_on_Sale"), 2) AS Total_Profit
FROM 
    "SALES_DATASET"
GROUP BY 
    DATE_TRUNC('month', "Order_Date"::date)
ORDER BY 
    Order_Month asc;


----------------------------------------------------------------
--Regional Discount vs Profit Analysis Business Objective
----------------------------------------------------------------

ALTER TABLE "SALES_DATASET"
ALTER COLUMN "Discount" TYPE INT USING "Discount"::INT;



SELECT
	"Region",
	ROUND(SUM("Sales"), 0) AS TOTAL_SALES,
	ROUND(AVG("Discount"), 2) AS AVG_DISCOUNT_BY_REGION,
	ROUND(SUM("Final_Profit_on_Sale"), 0) AS FINAL_PROFIT
FROM
	"SALES_DATASET"
GROUP BY
	"Region"
ORDER BY
	TOTAL_SALES DESC;


SELECT
	*
FROM
	"SALES_DATASET";



---------------------------------------
--Loyal High-Frequency Buyers
---------------------------------------

SELECT
	"Customer_Name",
	COUNT(DISTINCT "Order_ID") AS TOTAL_ORDERS
FROM
	"SALES_DATASET"
GROUP BY
	"Customer_Name"
HAVING
	COUNT(DISTINCT "Order_ID") > 5
	order by TOTAL_ORDERS desc;
























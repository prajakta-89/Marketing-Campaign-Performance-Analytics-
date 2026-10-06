CREATE DATABASE Marketing_Analytics;
USE Marketing_Analytics;

SELECT COUNT(*) FROM Campaigns;

SELECT COUNT(*) FROM Customers;

SELECT COUNT(*) FROM Campaign_Performance;

SELECT COUNT(*) FROM Customer_Conversions;

SELECT * FROM Campaigns LIMIT 10;

SELECT * FROM Customers LIMIT 10;

SELECT * FROM Campaign_Performance LIMIT 10;

SELECT * FROM Customer_Conversions LIMIT 10;


#Data Quality Checks
#Check for NULL values
SELECT *
FROM Campaign_Performance
WHERE Campaign_ID IS NULL
   OR Revenue IS NULL
   OR Spend IS NULL;


#Check for duplicate Campaign IDs
SELECT
Campaign_ID,
COUNT(*)
FROM Campaigns
GROUP BY Campaign_ID
HAVING COUNT(*) > 1;
#Campaign Distribution
SELECT
Channel,
COUNT(*) Total_Campaigns
FROM Campaigns
GROUP BY Channel;


#Customer Segment Distribution
SELECT
Segment,
COUNT(*) Customers
FROM Customers
GROUP BY Segment;


#Customer Location Distribution
SELECT
Location,
COUNT(*) Customers
FROM Customers
GROUP BY Location
ORDER BY Customers DESC;


#KPI Calculations
#These KPIs will become Power BI Cards


#KPI 1 Total Spend
SELECT
ROUND(SUM(Spend),2) AS Total_Spend
FROM Campaign_Performance;


#KPI 2 Total Revenue
SELECT
ROUND(SUM(Revenue),2) AS Revenue
FROM Campaign_Performance;


#KPI 3 Total Impressions
SELECT
SUM(Impressions) Total_Impressions
FROM Campaign_Performance;


#KPI 4 Total Clicks
SELECT
SUM(Clicks) Total_Clicks
FROM Campaign_Performance;


#KPI 5 Total Conversions
SELECT
SUM(Conversions) Total_Conversions
FROM Campaign_Performance;


#KPI 6 CTR
SELECT
ROUND(
SUM(Clicks)*100/
SUM(Impressions),2
) CTR;


#KPI 7 Conversion Rate
SELECT
ROUND(
SUM(Conversions)*100/
SUM(Clicks),2
) Conversion_Rate
FROM Campaign_Performance;


#KPI 8 CAC
SELECT
ROUND(
SUM(Spend)/SUM(Conversions),2
) CAC
FROM Campaign_Performance;


#KPI 9 ROI
SELECT
ROUND(
((SUM(Revenue)-SUM(Spend))
/
SUM(Spend))*100,2
) ROI
FROM Campaign_Performance;


#KPI 10 ROAS
SELECT
ROUND(
SUM(Revenue)/SUM(Spend),2
) ROAS
FROM Campaign_Performance;


#Campaign Analysis
#Top Revenue Campaigns
SELECT
c.Campaign_Name,
SUM(cp.Revenue) Revenue
FROM Campaigns c
JOIN Campaign_Performance cp
ON c.Campaign_ID=cp.Campaign_ID
GROUP BY c.Campaign_Name
ORDER BY Revenue DESC
LIMIT 10;


#Top Conversion Campaigns
SELECT
c.Campaign_Name,
SUM(cp.Conversions) Conversions
FROM Campaigns c
JOIN Campaign_Performance cp
ON c.Campaign_ID=cp.Campaign_ID
GROUP BY c.Campaign_Name
ORDER BY Conversions DESC;


#Campaign ROI
SELECT
c.Campaign_Name,

ROUND(
((SUM(cp.Revenue)-SUM(cp.Spend))
/
SUM(cp.Spend))*100,2
) ROI


FROM Campaigns c
JOIN Campaign_Performance cp
ON c.Campaign_ID=cp.Campaign_ID

GROUP BY c.Campaign_Name
ORDER BY ROI DESC;


#Channel Performance
#Revenue by Channel
SELECT
c.Channel,
SUM(cp.Revenue) Revenue
FROM Campaigns c
JOIN Campaign_Performance cp
ON c.Campaign_ID=cp.Campaign_ID
GROUP BY c.Channel
ORDER BY Revenue DESC;


#ROI by Channel
SELECT
c.Channel,

ROUND(
((SUM(cp.Revenue)-SUM(cp.Spend))
/
SUM(cp.Spend))*100,2
) ROI

FROM Campaigns c
JOIN Campaign_Performance cp
ON c.Campaign_ID=cp.Campaign_ID

GROUP BY c.Channel
ORDER BY ROI DESC;


#Conversion Rate by Channel
SELECT
c.Channel,

ROUND(
SUM(cp.Conversions)*100/
SUM(cp.Clicks),2
) Conversion_Rate

FROM Campaigns c
JOIN Campaign_Performance cp
ON c.Campaign_ID=cp.Campaign_ID

GROUP BY c.Channel;



#Customer Analysis
#Best Customer Segments
SELECT
cu.Segment,

COUNT(*) Total_Conversions,

SUM(cc.Revenue) Revenue

FROM Customers cu
JOIN Customer_Conversions cc
ON cu.Customer_ID=cc.Customer_ID

GROUP BY cu.Segment
ORDER BY Revenue DESC;



#Revenue by Gender
SELECT
Gender,
SUM(cc.Revenue) Revenue

FROM Customers c
JOIN Customer_Conversions cc
ON c.Customer_ID=cc.Customer_ID

GROUP BY Gender;



#Revenue by Location
SELECT
Location,
SUM(cc.Revenue) Revenue

FROM Customers c
JOIN Customer_Conversions cc
ON c.Customer_ID=cc.Customer_ID

GROUP BY Location
ORDER BY Revenue DESC;



#Time Series Analysis
#Monthly Revenue Trend
SELECT

DATE_FORMAT(Date,'%Y-%m') Month,

SUM(Revenue) Revenue

FROM Campaign_Performance

GROUP BY Month

ORDER BY Month;


#Monthly Conversions
SELECT

DATE_FORMAT(Date,'%Y-%m') Month,

SUM(Conversions) Conversions

FROM Campaign_Performance

GROUP BY Month

ORDER BY Month;



#Monthly Spend
SELECT

DATE_FORMAT(Date,'%Y-%m') Month,

SUM(Spend) Spend

FROM Campaign_Performance

GROUP BY Month

ORDER BY Month;



#Advanced SQL
#Running Revenue
SELECT
Date,

SUM(Revenue)
OVER(
ORDER BY Date
) Running_Revenue

FROM Campaign_Performance;



#Campaign Ranking
SELECT

Campaign_ID,

SUM(Revenue) Revenue,

RANK() OVER(
ORDER BY SUM(Revenue) DESC
) Revenue_Rank

FROM Campaign_Performance

GROUP BY Campaign_ID;



#Top Campaign Per Channel
WITH campaign_rank AS
(
SELECT

c.Channel,

c.Campaign_Name,

SUM(cp.Revenue) Revenue,

RANK() OVER(
PARTITION BY c.Channel
ORDER BY SUM(cp.Revenue) DESC
) rnk

FROM Campaigns c

JOIN Campaign_Performance cp
ON c.Campaign_ID=cp.Campaign_ID

GROUP BY
c.Channel,
c.Campaign_Name
)

SELECT *
FROM campaign_rank
WHERE rnk=1;




#Create SQL Views
#Executive KPI View
CREATE VIEW Executive_KPI AS

SELECT

SUM(Spend) Total_Spend,

SUM(Revenue) Revenue,

SUM(Impressions) Impressions,

SUM(Clicks) Clicks,

SUM(Conversions) Conversions

FROM Campaign_Performance;



#Channel Performance View
CREATE VIEW Channel_Performance AS

SELECT

c.Channel,

SUM(cp.Revenue) Revenue,

SUM(cp.Spend) Spend,

SUM(cp.Conversions) Conversions

FROM Campaigns c

JOIN Campaign_Performance cp
ON c.Campaign_ID=cp.Campaign_ID

GROUP BY c.Channel;

DESCRIBE Campaign_Performance;
SELECT
ROUND(
    SUM(Clicks) * 100.0 / SUM(Impressions),
    2
) AS CTR
FROM Campaign_Performance;


#Campaign Optimization & Budget Strategy

#Revenue Breakdown by Channel
#Shows total revenue generated by each marketing channel.
SELECT
    c.Channel,
    ROUND(SUM(cp.Revenue), 2) AS Total_Revenue
FROM Campaigns c
JOIN Campaign_Performance cp
    ON c.Campaign_ID = cp.Campaign_ID
GROUP BY c.Channel
ORDER BY Total_Revenue DESC;

#Budget Utilization by Channel
#Compares the allocated campaign budget with the actual marketing spend.
SELECT
    c.Channel,
    ROUND(SUM(c.Budget), 2) AS Total_Budget,
    ROUND(SUM(cp.Spend), 2) AS Total_Spend,
    ROUND(
        SUM(cp.Spend) * 100.0 /
        NULLIF(SUM(c.Budget), 0),
        2
    ) AS Budget_Utilization_Percentage
FROM Campaigns c
JOIN Campaign_Performance cp
    ON c.Campaign_ID = cp.Campaign_ID
GROUP BY c.Channel
ORDER BY Budget_Utilization_Percentage DESC;

#Spend Efficiency by ROI
#Shows how much each campaign spends and the return generated from that spending.
SELECT
    c.Campaign_ID,
    c.Campaign_Name,
    c.Channel,
    ROUND(SUM(cp.Spend), 2) AS Total_Spend,
    ROUND(SUM(cp.Revenue), 2) AS Total_Revenue,
    ROUND(
        (SUM(cp.Revenue) - SUM(cp.Spend)) * 100.0 /
        NULLIF(SUM(cp.Spend), 0),
        2
    ) AS ROI
FROM Campaigns c
JOIN Campaign_Performance cp
    ON c.Campaign_ID = cp.Campaign_ID
GROUP BY
    c.Campaign_ID,
    c.Campaign_Name,
    c.Channel
ORDER BY ROI DESC;

#Underperforming Campaigns
#This is the most important query for your Underperforming Campaigns Table.
SELECT
    c.Campaign_Name,
    c.Channel,
    ROUND(SUM(cp.Spend), 2) AS Total_Spend,
    ROUND(SUM(cp.Revenue), 2) AS Total_Revenue,
    SUM(cp.Conversions) AS Total_Conversions,
    ROUND(
        (SUM(cp.Revenue) - SUM(cp.Spend)) * 100.0 /
        NULLIF(SUM(cp.Spend), 0),
        2
    ) AS ROI
FROM Campaigns c
JOIN Campaign_Performance cp
    ON c.Campaign_ID = cp.Campaign_ID
GROUP BY
    c.Campaign_Name,
    c.Channel
HAVING
    SUM(cp.Spend) > 0
    AND
    (
        (SUM(cp.Revenue) - SUM(cp.Spend)) * 100.0 /
        NULLIF(SUM(cp.Spend), 0)
    ) < 100
ORDER BY ROI ASC;

#Campaign Performance Summary
#This is useful for your Campaign Performance Matrix.
SELECT
    c.Campaign_ID,
    c.Campaign_Name,
    c.Channel,
    ROUND(SUM(cp.Spend), 2) AS Total_Spend,
    ROUND(SUM(cp.Revenue), 2) AS Total_Revenue,
    SUM(cp.Impressions) AS Impressions,
    SUM(cp.Clicks) AS Clicks,
    SUM(cp.Conversions) AS Conversions,

    ROUND(
        SUM(cp.Clicks) * 100.0 /
        NULLIF(SUM(cp.Impressions), 0),
        2
    ) AS CTR,

    ROUND(
        SUM(cp.Conversions) * 100.0 /
        NULLIF(SUM(cp.Clicks), 0),
        2
    ) AS Conversion_Rate,

    ROUND(
        (SUM(cp.Revenue) - SUM(cp.Spend)) * 100.0 /
        NULLIF(SUM(cp.Spend), 0),
        2
    ) AS ROI

FROM Campaigns c
JOIN Campaign_Performance cp
    ON c.Campaign_ID = cp.Campaign_ID

GROUP BY
    c.Campaign_ID,
    c.Campaign_Name,
    c.Channel

ORDER BY ROI DESC;

#ROI vs Conversion Rate
#Useful for your ROI vs Conversion Rate visual.
SELECT
    c.Campaign_Name,
    c.Channel,

    ROUND(
        (SUM(cp.Revenue) - SUM(cp.Spend)) * 100.0 /
        NULLIF(SUM(cp.Spend), 0),
        2
    ) AS ROI,

    ROUND(
        SUM(cp.Conversions) * 100.0 /
        NULLIF(SUM(cp.Clicks), 0),
        2
    ) AS Conversion_Rate,

    SUM(cp.Conversions) AS Total_Conversions,
    ROUND(SUM(cp.Revenue), 2) AS Total_Revenue

FROM Campaigns c
JOIN Campaign_Performance cp
    ON c.Campaign_ID = cp.Campaign_ID

GROUP BY
    c.Campaign_Name,
    c.Channel

ORDER BY ROI DESC;

#Budget vs Actual Spend by Campaign
#This is useful if you want a more detailed Budget Utilization visual.

#Top Revenue-Generating Campaigns
#Useful for identifying campaigns that are contributing most to revenue.

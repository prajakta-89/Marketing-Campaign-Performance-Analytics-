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
SUM(Spend)/SUM(Conversions)
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


#11. Total Marketing Budget
#Shows the total budget allocated to all campaigns.
SELECT
    ROUND(SUM(Budget), 2) AS Total_Budget
FROM Campaigns;

#12. Total Marketing Spend
SELECT
    ROUND(SUM(Spend), 2) AS Total_Spend
FROM Campaign_Performance;

#13Budget Utilization %
SELECT
    ROUND(
        SUM(cp.Spend) * 100.0 /
        NULLIF(SUM(c.Budget), 0),
        2
    ) AS Budget_Utilization_Percentage
FROM Campaigns c
JOIN Campaign_Performance cp
    ON c.Campaign_ID = cp.Campaign_ID;
    
#14Remaining Budget
SELECT
    ROUND(
        SUM(c.Budget) - SUM(cp.Spend),
        2
    ) AS Remaining_Budget
FROM Campaigns c
JOIN Campaign_Performance cp
    ON c.Campaign_ID = cp.Campaign_ID;
    
# 15 Overall ROI
SELECT
    ROUND(
        (SUM(Revenue) - SUM(Spend)) * 100.0 /
        NULLIF(SUM(Spend), 0),
        2
    ) AS ROI
FROM Campaign_Performance;

# 16 ROAS
SELECT
    ROUND(
        SUM(Revenue) /
        NULLIF(SUM(Spend), 0),
        2
    ) AS ROAS
FROM Campaign_Performance;

# 17 Total Conversions
SELECT
    SUM(Conversions) AS Total_Conversions
FROM Campaign_Performance;

# 18 Average Conversion Rate
SELECT
    ROUND(
        SUM(Conversions) * 100.0 /
        NULLIF(SUM(Clicks), 0),
        2
    ) AS Conversion_Rate
FROM Campaign_Performance;

# 20 Campaigns Requiring Review
SELECT
    COUNT(*) AS Campaigns_Requiring_Review
FROM
(
    SELECT
        c.Campaign_ID,
        ROUND(
            (SUM(cp.Revenue) - SUM(cp.Spend)) * 100.0 /
            NULLIF(SUM(cp.Spend), 0),
            2
        ) AS ROI
    FROM Campaigns c
    JOIN Campaign_Performance cp
        ON c.Campaign_ID = cp.Campaign_ID
    GROUP BY c.Campaign_ID
    HAVING SUM(cp.Spend) > 0
) AS Campaign_ROI
WHERE ROI < 100;


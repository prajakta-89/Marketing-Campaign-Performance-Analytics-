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
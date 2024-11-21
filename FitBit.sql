/* For this project I found some data on Kaggle about FitBit marketing campaings.  The original CSV was a single CSV
I created two files to demonstate joins keeping the CustomerID as the primary key in both.  I do wish that there was data on 
the amount that was spent so we could calculate ROI. */

-- Break down of count of Ages, Gender

SELECT AgeGroup, Gender, COUNT(*) AS Count
FROM fitbit_demo
GROUP BY 1, 2
ORDER BY 1,2;


--Caclculate Country Count
SELECT Country, COUNT(*) AS Country_Count
FROM fitbit_demo
GROUP BY 1
ORDER BY 2 DESC;

--Highest Converting Category

SELECT ProductCategory, SUM(Conversions) AS Device_Conversion_Count
FROM fitbit_marketing
GROUP BY 1
ORDER BY  2 DESC;

--Highest Converting Campaign
SELECT CampaignID, SUM(Conversions) AS CampaignID_Conversion_Count
FROM fitbit_marketing
GROUP BY 1
ORDER BY  2 DESC
LIMIT 10;


-- Platform Performance by ConversionValue
SELECT AdPlatform, SUM(ConversionValue) AS Platform_Value
FROM fitbit_marketing
GROUP BY 1
ORDER BY 2 DESC;

--Gender Conversion Value
SELECT d.Gender, SUM(m.ConversionValue) AS Gender_Conv_Value
FROM fitbit_demo d
LEFT JOIN fitbit_marketing m
ON d.CustomerID = m.CustomerID
GROUP BY Gender
ORDER BY 2;

--What Country Requirres the most impressions before conversting.
SELECT d.Country, SUM(m.Impressions) AS Impressions_Count
FROM fitbit_demo d
LEFT JOIN fitbit_marketing m
ON d.CustomerID = m.CustomerID
WHERE m.Conversions = 1
GROUP BY d.Country
ORDER BY 2 DESC;

-- Country Conversion Rate
SELECT     d.Country,  
CASE 
        WHEN SUM(m.Clicks ) > 0 THEN ROUND((SUM(m.Conversions) * 100 / CAST(SUM(m.Clicks) AS FLOAT)), 2)
        ELSE 0 
    END AS Conversion_Rate
FROM     fitbit_demo d
LEFT JOIN     fitbit_marketing m
ON     d.CustomerID = m.CustomerID
GROUP BY     1
ORDER BY     2 DESC;

-- Month over Month Campaign Performance

SELECT      substr(DateTime, 4, 2) AS Month,     SUM(Conversions) AS Total_Conversions,   SUM(SUM(Conversions)) 
OVER (ORDER BY substr(DateTime, 4, 2)) AS Cumulative_Conversions,  SUM(Conversions) - LAG(SUM(Conversions)) OVER (ORDER BY substr(DateTime, 4, 2)) AS MoM_Change
FROM     fitbit_marketing 
GROUP BY     substr(DateTime, 4, 2)
ORDER BY     Month;
	

--  Country Campaign Value

SELECT     substr(m.DateTime, 4, 2) AS Month, d.Country,  
    SUM(m.ConversionValue) OVER (PARTITION BY d.Country ORDER BY substr(m.DateTime, 4, 2)) AS Rolling_Conversion_Value
FROM   fitbit_demo d
LEFT JOIN   fitbit_marketing m
ON   d.CustomerID = m.CustomerID
GROUP BY   substr(m.DateTime, 4, 2), d.Country
ORDER BY   Month;

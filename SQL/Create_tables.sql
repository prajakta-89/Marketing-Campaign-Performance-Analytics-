CREATE DATABASE Marketing_Analytics;
USE Marketing_Analytics;



CREATE TABLE Campaigns (
    Campaign_ID INT PRIMARY KEY,
    Campaign_Name VARCHAR(100) NOT NULL,
    Channel VARCHAR(50) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Budget DECIMAL(12,2) NOT NULL
);



CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Age INT,
    Gender VARCHAR(20),
    Location VARCHAR(100),
    Segment VARCHAR(50)
);


CREATE TABLE Campaign_Performance (
    Performance_ID INT PRIMARY KEY,
    Campaign_ID INT NOT NULL,
    Date DATE NOT NULL,
    Impressions INT DEFAULT 0,
    Clicks INT DEFAULT 0,
    Conversions INT DEFAULT 0,
    Revenue DECIMAL(12,2) DEFAULT 0,
    Spend DECIMAL(12,2) DEFAULT 0,

    CONSTRAINT fk_campaign_performance
    FOREIGN KEY (Campaign_ID)
    REFERENCES Campaigns(Campaign_ID)
);


CREATE TABLE Customer_Conversions (
    Conversion_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Campaign_ID INT NOT NULL,
    Conversion_Date DATE NOT NULL,
    Revenue DECIMAL(10,2) DEFAULT 0,

    CONSTRAINT fk_customer
    FOREIGN KEY (Customer_ID)
    REFERENCES Customers(Customer_ID),

    CONSTRAINT fk_campaign_conversion
    FOREIGN KEY (Campaign_ID)
    REFERENCES Campaigns(Campaign_ID)
);


#Verify Tables

SELECT COUNT(*) FROM Campaigns;

SELECT COUNT(*) FROM Customers;

SELECT COUNT(*) FROM Campaign_Performance;

SELECT COUNT(*) FROM Customer_Conversions;

SELECT * FROM Campaigns LIMIT 10;

SELECT * FROM Customers LIMIT 10;

SELECT * FROM Campaign_Performance LIMIT 10;

SELECT * FROM Customer_Conversions LIMIT 10;


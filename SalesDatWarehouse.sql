-- create database
CREATE DATABASE SalesDW;

USE SalesDW;


-- create dimension table DimCity
CREATE TABLE DimCity (
    CityKey INT PRIMARY KEY,
    City NVARCHAR(100) NOT NULL,
    StateProvince NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL,
    SalesTerritory NVARCHAR(100) NOT NULL,
    Location NVARCHAR(200) NULL,
    LatestRecordedPopulation INT NULL
);

-- create dimension table DimCustomer
CREATE TABLE DimCustomer (
    CustomerKey INT PRIMARY KEY,
    WWICustomerID INT NOT NULL,
    Customer NVARCHAR(200) NOT NULL,
    BillToCustomer NVARCHAR(200) NOT NULL,
    Category NVARCHAR(100) NULL,
    BuyingGroup NVARCHAR(200) NULL,
    PrimaryContact NVARCHAR(200) NULL,
    PostalCode NVARCHAR(20) NULL,
    CreditLimit DECIMAL(18,2) NULL,
    LineageKey INT NULL
);

-- create dimension table DimDate
CREATE TABLE DimDate (
    DateKey DATE PRIMARY KEY,
    DayNumber INT NOT NULL,
    DayOfMonth INT NOT NULL,
    MonthName NVARCHAR(20) NOT NULL,
    ShortMonthName NVARCHAR(3) NOT NULL,
    CalendarMonthNumber INT NOT NULL,
    CalendarMonthLabel NVARCHAR(20) NOT NULL,
    CalendarYear INT NOT NULL,
    CalendarYearLabel NVARCHAR(20) NOT NULL,
    FiscalMonthNumber INT NOT NULL,
    FiscalMonthLabel NVARCHAR(20) NOT NULL,
    FiscalYear INT NOT NULL,
    FiscalYearLabel NVARCHAR(20) NOT NULL,
    ISOWeekNumber INT NOT NULL
);


-- create dimension table DimEmployee
CREATE TABLE DimEmployee (
    EmployeeKey INT PRIMARY KEY,
    WWIEmployeeID INT NOT NULL,
    Employee NVARCHAR(200) NOT NULL,
    PreferredName NVARCHAR(100) NULL,
    IsSalesperson BIT NOT NULL,
    Photo VARBINARY(MAX) NULL,
    LineageKey INT NULL
);

-- create dimension table DimStockItem

CREATE TABLE DimStockItem (
    StockItemKey INT PRIMARY KEY,
    WWIStockItemID INT NOT NULL,
    StockItem NVARCHAR(255) NOT NULL,
    Color NVARCHAR(100) NULL,
    SellingPackage NVARCHAR(100) NULL,
    BuyingPackage NVARCHAR(100) NULL,
    Brand NVARCHAR(100) NULL,
    Size NVARCHAR(50) NULL,
    LeadTimeDays INT NULL,
    QuantityPerOuter INT NULL,
    IsChillerStock BIT NULL,
    Barcode NVARCHAR(100) NULL,
    TaxRate DECIMAL(18,2) NULL,
    UnitPrice DECIMAL(18,2) NULL,
    RecommendedRetailPrice DECIMAL(18,3) NULL,
    TypicalWeightPerUnit DECIMAL(18,2) NULL,
    Photo NVARCHAR(MAX) NULL,
    Discount DECIMAL(18,2) NULL,
    ValidFrom DATE NULL,
    ValidTo DATE NULL,
    LineageKey INT NULL
);

-- create fact table FactSales

CREATE TABLE FactSales (
    SaleKey BIGINT NOT NULL,

    CityKey INT NOT NULL,
    CustomerKey INT NOT NULL,
    BillToCustomerKey INT NOT NULL,
    StockItemKey INT NOT NULL,

    InvoiceDateKey DATE NOT NULL,
    DeliveryDateKey DATE NULL,
    SalespersonKey INT NOT NULL,

    WWIInvoiceID INT NOT NULL,
    Description NVARCHAR(500) NULL,
    Package NVARCHAR(50) NULL,

    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    TaxRate DECIMAL(5,2) NOT NULL,

    TotalExcludingTax DECIMAL(18,2) NOT NULL,
    TaxAmount DECIMAL(18,2) NOT NULL,
    Profit DECIMAL(18,2) NOT NULL,
    TotalIncludingTax DECIMAL(18,2) NOT NULL,

    TotalDryItems INT NOT NULL,
    TotalChillerItems INT NOT NULL,

    LineageKey INT NULL,

    CONSTRAINT PK_FactSales PRIMARY KEY (SaleKey),

    CONSTRAINT FK_FactSales_City
        FOREIGN KEY (CityKey)
        REFERENCES DimCity (CityKey),

    CONSTRAINT FK_FactSales_Customer
        FOREIGN KEY (CustomerKey)
        REFERENCES DimCustomer (CustomerKey),

    CONSTRAINT FK_FactSales_BillToCustomer
        FOREIGN KEY (BillToCustomerKey)
        REFERENCES DimCustomer (CustomerKey),

    CONSTRAINT FK_FactSales_StockItem
        FOREIGN KEY (StockItemKey)
        REFERENCES DimStockItem (StockItemKey),

    CONSTRAINT FK_FactSales_Employee
        FOREIGN KEY (SalespersonKey)
        REFERENCES DimEmployee (EmployeeKey),

    CONSTRAINT FK_FactSales_InvoiceDate
        FOREIGN KEY (InvoiceDateKey)
        REFERENCES DimDate (DateKey)
);

-- Data insertion in each table directly from csv file

BULK INSERT DimCity
FROM 'D:\Downloads\DataModelling\process_data\DimCity.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = '|', ROWTERMINATOR = '\n');

BULK INSERT DimCustomer
FROM 'D:\Downloads\DataModelling\process_data\DimCustomer.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = '|', ROWTERMINATOR = '\n');

BULK INSERT DimEmployee
FROM 'D:\Downloads\DataModelling\process_data\DimEmployee.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = '|', ROWTERMINATOR = '\n');

BULK INSERT DimDate
FROM 'D:\Downloads\DataModelling\process_data\DimDate.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = '|', ROWTERMINATOR = '\n');

BULK INSERT DimStockItem
FROM 'D:\Downloads\DataModelling\process_data\DimStockItem.csv'
WITH (FIRSTROW = 3, FIELDTERMINATOR = '|', ROWTERMINATOR = '\n');

BULK INSERT FactSales
FROM 'D:\Downloads\DataModelling\process_data\FactSale.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = '|', ROWTERMINATOR = '\n');

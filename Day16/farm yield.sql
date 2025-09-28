create database FarmYield_Analysis;
use FarmYield_Analysis;

-- Create the farmers table 
CREATE TABLE farmers(
farmer_id INT PRIMARY KEY, 
first_name VARCHAR(50) NOT NULL, 
last_name VARCHAR(50) NOT NULL, 
email VARCHAR(100) UNIQUE, 
hire_date DATE ); 

-- Create the plots table 
CREATE TABLE plots ( 
plot_id INT PRIMARY KEY, 
plot_name VARCHAR(100) NOT NULL, 
farmer_id INT, 
crop_type VARCHAR(50) NOT NULL, 
soil_type VARCHAR(50), 
FOREIGN KEY (farmer_id) REFERENCES farmers(farmer_id) ); 

-- Create the yields table 
CREATE TABLE yields ( 
yield_id INT PRIMARY KEY, 
plot_id INT, 
harvest_date DATE, 
yield_kg DECIMAL(10, 2), 
weather_condition VARCHAR(50), 
FOREIGN KEY (plot_id) REFERENCES plots(plot_id) ); 

-- Create the irrigation_logs table 
CREATE TABLE irrigation_logs ( 
log_id INT PRIMARY KEY, 
plot_id INT, 
irrigation_date DATE, 
water_amount_liters DECIMAL(10, 2), 
FOREIGN KEY (plot_id) REFERENCES plots(plot_id) ); 

-- Insert data into farmers table (5 records)
INSERT INTO farmers (farmer_id, first_name, last_name, email, hire_date) VALUES
(1, 'John', 'Doe', 'john.doe@agri-innovate.com', '2020-05-15'),
(2, 'Jane', 'Smith', 'jane.smith@agri-innovate.com', '2021-02-20'),
(3, 'Peter', 'Jones', 'peter.jones@agri-innovate.com', '2020-11-10'),
(4, 'Maria', 'Garcia', 'maria.garcia@agri-innovate.com', '2022-08-01'),
(5, 'Alex', 'Chen', 'alex.chen@agri-innovate.com', '2023-03-25');

-- Insert data into plots table (8 records)
INSERT INTO plots (plot_id, plot_name, farmer_id, crop_type, soil_type) VALUES
(101, 'West Field', 1, 'Wheat', 'Loam'),
(102, 'North Pasture', 2, 'Corn', 'Clay'),
(103, 'South Farm', 1, 'Soybeans', 'Sand'),
(104, 'East Meadow', 3, 'Wheat', 'Loam'),
(105, 'Plot A', 4, 'Corn', 'Clay'),
(106, 'Plot B', 5, 'Soybeans', 'Sand'),
(107, 'High Plains', 3, 'Corn', 'Loam'),
(108, 'Valley View', 2, 'Wheat', 'Clay');

-- Insert data into yields table (20 records) 
INSERT INTO yields (yield_id, plot_id, harvest_date, yield_kg, weather_condition) 
VALUES (1, 101, '2024-07-20', 1500.50, 'Sunny'), 
(2, 102, '2024-09-15', 2100.75, 'Rainy'), 
(3, 103, '2024-10-01', 950.20, 'Mild'), 
(4, 104, '2024-07-25', 1650.30, 'Sunny'), 
(5, 105, '2024-09-18', 2200.10, 'Rainy'), 
(6, 106, '2024-10-05', 880.90, 'Mild'), 
(7, 107, '2024-09-20', 2350.40, 'Sunny'), 
(8, 108, '2024-08-01', 1450.60, 'Mild'), 
(9, 101, '2023-07-19', 1400.00, 'Rainy'), 
(10, 102, '2023-09-14', 2050.00, 'Sunny'), 
(11, 103, '2023-10-02', 900.00, 'Mild'), 
(12, 104, '2023-07-24', 1550.00, 'Rainy'), 
(13, 105, '2023-09-17', 2150.00, 'Sunny'), 
(14, 106, '2023-10-04', 850.00, 'Mild'), 
(15, 107, '2023-09-19', 2250.00, 'Rainy'), 
(16, 108, '2023-07-31', 1350.00, 'Mild'), 
(17, 101, '2022-07-21', 1300.00, 'Sunny'), 
(18, 102, '2022-09-16', 2000.00, 'Rainy'), 
(19, 103, '2022-10-03', 800.00, 'Mild'), 
(20, 104, '2022-07-26', 1500.00, 'Sunny'); 

-- Insert data into irrigation_logs table (15 records) 
INSERT INTO irrigation_logs (log_id, plot_id, irrigation_date, water_amount_liters) 
VALUES (1, 101, '2024-05-10', 50000.00), 
(2, 102, '2024-06-12', 75000.00), 
(3, 103, '2024-07-15', 30000.00), 
(4, 104, '2024-05-12', 45000.00), 
(5, 105, '2024-06-15', 80000.00), 
(6, 106, '2024-07-18', 25000.00), 
(7, 107, '2024-06-20', 70000.00), 
(8, 108, '2024-05-25', 55000.00), 
(9, 101, '2023-05-11', 48000.00), 
(10, 102, '2023-06-13', 72000.00), 
(11, 103, '2023-07-16', 28000.00), 
(12, 104, '2023-05-13', 43000.00), 
(13, 105, '2023-06-16', 78000.00), 
(14, 106, '2023-07-19', 23000.00), 
(15, 107, '2023-06-21', 68000.00);

-- ===========================
-- 3. Analytical Queries
-- ===========================
#1. Productivity & Performance

-- Task 1a: Top 3 most productive plots
SELECT p.plot_name, p.crop_type,
       ROUND(AVG(y.yield_kg), 2) AS average_yield_kg
FROM plots p
JOIN yields y ON p.plot_id = y.plot_id
GROUP BY p.plot_name, p.crop_type
ORDER BY average_yield_kg DESC
LIMIT 3;

-- Task 1b: Total water consumption per plot
SELECT p.plot_name,
       ROUND(SUM(i.water_amount_liters), 2) AS total_water_liters
FROM plots p
JOIN irrigation_logs i ON p.plot_id = i.plot_id
GROUP BY p.plot_name
ORDER BY total_water_liters DESC;

#2. Yield & Environmental Analysis

-- Task 2a: Average yield by crop & weather
SELECT p.crop_type, y.weather_condition,
       ROUND(AVG(y.yield_kg), 2) AS average_yield_kg
FROM plots p
JOIN yields y ON p.plot_id = y.plot_id
GROUP BY p.crop_type, y.weather_condition
ORDER BY p.crop_type, y.weather_condition;

-- Task 2b: Highest-yielding plot by soil type
SELECT soil_type, plot_name, highest_yield_kg
FROM (
  SELECT p.soil_type, p.plot_name, MAX(y.yield_kg) AS highest_yield_kg,
         ROW_NUMBER() OVER (PARTITION BY p.soil_type ORDER BY MAX(y.yield_kg) DESC) AS rn
  FROM plots p
  JOIN yields y ON p.plot_id = y.plot_id
  GROUP BY p.soil_type, p.plot_name
) ranked
WHERE rn = 1;

#3. Farmer & Resource Management

-- Task 3a: Farmer with lowest avg water consumption
SELECT f.first_name, f.last_name,
       ROUND(AVG(plot_water.total_water_liters), 2) AS average_water_liters_per_plot
FROM farmers f
JOIN plots p ON f.farmer_id = p.farmer_id
JOIN (
   SELECT plot_id, SUM(water_amount_liters) AS total_water_liters
   FROM irrigation_logs
   GROUP BY plot_id
) plot_water ON p.plot_id = plot_water.plot_id
GROUP BY f.first_name, f.last_name
ORDER BY average_water_liters_per_plot ASC
LIMIT 1;

-- Task 3b: Number of harvests per month (last 12 months)
WITH RECURSIVE months AS (
  SELECT DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL DAY(CURDATE())-1 DAY), '%Y-%m-01') AS month_start, 1 AS n
  UNION ALL
  SELECT DATE_FORMAT(DATE_SUB(month_start, INTERVAL 1 MONTH), '%Y-%m-01'), n+1
  FROM months
  WHERE n < 12
)
SELECT DATE_FORMAT(m.month_start, '%Y-%m') AS month,
       COALESCE(h.harvest_count, 0) AS harvest_count
FROM months m
LEFT JOIN (
   SELECT DATE_FORMAT(harvest_date, '%Y-%m-01') AS month_start,
          COUNT(*) AS harvest_count
   FROM yields
   WHERE harvest_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
   GROUP BY DATE_FORMAT(harvest_date, '%Y-%m-01')
) h ON m.month_start = h.month_start
ORDER BY m.month_start;

#4. Advanced Analysis (Bonus)

-- Task 4 (Bonus): Below-avg yield but above-avg water (per crop type)
SELECT p.plot_name, p.crop_type,
       ROUND(AVG(y.yield_kg), 2) AS avg_yield,
       ROUND(SUM(i.water_amount_liters), 2) AS total_water
FROM plots p
JOIN yields y ON p.plot_id = y.plot_id
JOIN irrigation_logs i ON p.plot_id = i.plot_id
GROUP BY p.plot_name, p.crop_type
HAVING AVG(y.yield_kg) < (
         SELECT AVG(y2.yield_kg)
         FROM plots p2
         JOIN yields y2 ON p2.plot_id = y2.plot_id
         WHERE p2.crop_type = p.crop_type
       )
   AND SUM(i.water_amount_liters) > (
         SELECT AVG(total_water)
         FROM (
            SELECT p2.plot_id, SUM(i2.water_amount_liters) AS total_water
            FROM plots p2
            JOIN irrigation_logs i2 ON p2.plot_id = i2.plot_id
            WHERE p2.crop_type = p.crop_type
            GROUP BY p2.plot_id
         ) t
       );
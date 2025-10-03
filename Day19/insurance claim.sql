create database InsuranceClaims;
use InsuranceClaims;

-- Customers Table
CREATE TABLE Customers (customer_id INT PRIMARY KEY,name VARCHAR(50),age INT,gender CHAR(1),city VARCHAR(50),state VARCHAR(50));

-- Policies Table
CREATE TABLE Policies (policy_id INT PRIMARY KEY,customer_id INT,policy_type VARCHAR(20),premium_amount DECIMAL(10,2),start_date DATE,end_date DATE,
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id));

-- Claims Table
CREATE TABLE Claims (claim_id INT PRIMARY KEY,policy_id INT,claim_date DATE,claim_amount DECIMAL(10,2),claim_status VARCHAR(20),
FOREIGN KEY (policy_id) REFERENCES Policies(policy_id));

-- Insert Customers
INSERT INTO Customers (customer_id, name, age, gender, city, state) VALUES
(101, 'Ramesh', 35, 'M', 'Hyderabad', 'Telangana'),
(102, 'Priya', 42, 'F', 'Bangalore', 'Karnataka'),
(103, 'Arjun', 29, 'M', 'Chennai', 'Tamil Nadu'),
(104, 'Divya', 51, 'F', 'Mumbai', 'Maharashtra');

-- Insert Policies
INSERT INTO Policies (policy_id, customer_id, policy_type, premium_amount, start_date,end_date) VALUES
(201, 101, 'Health', 12000, '2022-01-01', '2023-01-01'),
(202, 102, 'Vehicle', 18000, '2022-06-15', '2023-06-14'),
(203, 103, 'Life', 25000, '2022-03-10', '2023-03-09'),
(204, 104, 'Health', 20000, '2022-09-01', '2023-08-31');

-- Insert Claims
INSERT INTO Claims (claim_id, policy_id, claim_date, claim_amount, claim_status) VALUES
(301, 201, '2022-05-10', 5000, 'Approved'),
(302, 202, '2022-08-01', 15000, 'Rejected'),
(303, 203, '2022-12-20', 20000, 'Approved'),
(304, 204, '2023-02-15', 7000, 'Pending');

-- Basic Queries
-- o List all customers who purchased a Health insurance policy.
SELECT c.customer_id, c.name, p.policy_type
FROM Customers c
JOIN Policies p ON c.customer_id = p.customer_id
WHERE p.policy_type = 'Health';

-- o Find customers who are above 40 years and have Vehicle insurance.
SELECT c.customer_id, c.name, c.age, p.policy_type
FROM Customers c
JOIN Policies p ON c.customer_id = p.customer_id
WHERE c.age > 40 AND p.policy_type = 'Vehicle';

-- 2. Joins & Aggregations
-- o Display customer name, policy type, and claim status for all claims.
SELECT c.name, p.policy_type, cl.claim_status
FROM Claims cl
JOIN Policies p ON cl.policy_id = p.policy_id
JOIN Customers c ON p.customer_id = c.customer_id;

-- o Find the total premium collected by policy type.
SELECT policy_type, SUM(premium_amount) AS total_premium
FROM Policies
GROUP BY policy_type;

-- o Calculate the average claim amount for approved claims.
SELECT AVG(claim_amount) AS avg_approved_claim
FROM Claims
WHERE claim_status = 'Approved';

-- 3. Advanced Queries
-- o Identify the customer who has paid the highest premium.
SELECT c.name, p.premium_amount
FROM Policies p
JOIN Customers c ON p.customer_id = c.customer_id
ORDER BY p.premium_amount DESC
LIMIT 1;

-- o Find customers who made a claim but it was rejected.
SELECT DISTINCT c.name, cl.claim_amount
FROM Claims cl
JOIN Policies p ON cl.policy_id = p.policy_id
JOIN Customers c ON p.customer_id = c.customer_id
WHERE cl.claim_status = 'Rejected';

-- o Show the policy renewal due in the next 30 days (based on end_date).
SELECT p.policy_id, c.name, p.end_date
FROM Policies p
JOIN Customers c ON p.customer_id = c.customer_id
WHERE p.end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY);

-- 4. Analytical Queries
-- o Calculate claim ratio = (Approved Claims / Total Claims) * 100 for each policy type.
SELECT p.policy_type,
       (SUM(CASE WHEN cl.claim_status = 'Approved' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS claim_ratio
FROM Claims cl
JOIN Policies p ON cl.policy_id = p.policy_id
GROUP BY p.policy_type;

-- o Rank customers by their total premium paid (use window functions if MySQL8+).
SELECT c.name, SUM(p.premium_amount) AS total_premium,
       RANK() OVER (ORDER BY SUM(p.premium_amount) DESC) AS rank_position
FROM Policies p
JOIN Customers c ON p.customer_id = c.customer_id
GROUP BY c.name;

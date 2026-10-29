SELECT ChurnStatus, COUNT(*) AS TotalCustomers
FROM customer_churn
GROUP BY ChurnStatus;

-- 2. Average tenure and total cashback amount of customers who churned
SELECT 
    AVG(Tenure) AS AvgTenure,
    SUM(CashbackAmount) AS TotalCashback
FROM customer_churn
WHERE ChurnStatus = 'Churned';

-- 3. Percentage of churned customers who complained
SELECT 
    (COUNT(CASE WHEN ComplaintReceived = 'Yes' THEN 1 END) * 100.0 / COUNT(*)) AS PctChurnedWithComplaint
FROM customer_churn
WHERE ChurnStatus = 'Churned';

-- 4. City tier with the highest number of churned customers whose preferred order category is Laptop & Accessory
SELECT CityTier, COUNT(*) AS ChurnedCount
FROM customer_churn
WHERE ChurnStatus = 'Churned' AND PreferredOrderCat = 'Laptop & Accessory'
GROUP BY CityTier
ORDER BY ChurnedCount DESC
LIMIT 1;

-- 5. Most preferred payment mode among active customers
SELECT PreferredPaymentMode, COUNT(*) AS UserCount
FROM customer_churn
WHERE ChurnStatus = 'Active'
GROUP BY PreferredPaymentMode
ORDER BY UserCount DESC
LIMIT 1;

-- 6. Total order amount hike from last year for single customers preferring mobile phones
SELECT SUM(OrderAmountHikeFromlastYear) AS TotalHikeAmount
FROM customer_churn
WHERE MaritalStatus = 'Single' AND PreferredOrderCat = 'Mobile Phone';

-- 7. Average number of devices registered among customers who used UPI
SELECT AVG(NumberOfDeviceRegistered) AS AvgDevices
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI';

-- 8. City tier with the highest number of customers
SELECT CityTier, COUNT(*) AS TotalCustomers
FROM customer_churn
GROUP BY CityTier
ORDER BY TotalCustomers DESC
LIMIT 1;

-- 9. Gender that utilized the highest number of coupons
SELECT Gender, SUM(CouponUsed) AS TotalCoupons
FROM customer_churn
GROUP BY Gender
ORDER BY TotalCoupons DESC
LIMIT 1;

-- 10. Number of customers and max hours spent on app per order category
SELECT 
    PreferredOrderCat,
    COUNT(*) AS TotalCustomers,
    MAX(HoursSpentOnApp) AS MaxHoursSpent
FROM customer_churn
GROUP BY PreferredOrderCat;

-- 11. Total order count for credit card users with maximum satisfaction score
SELECT SUM(OrderCount) AS TotalOrders
FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card'
  AND SatisfactionScore = (SELECT MAX(SatisfactionScore) FROM customer_churn);

-- 12. Average satisfaction score of customers who complained
SELECT AVG(SatisfactionScore) AS AvgSatisfactionScore
FROM customer_churn
WHERE ComplaintReceived = 'Yes';

-- 13. Preferred order categories among customers who used > 5 coupons
SELECT DISTINCT PreferredOrderCat
FROM customer_churn
WHERE CouponUsed > 5;

-- 14. Top 3 preferred order categories with highest average cashback
SELECT PreferredOrderCat, AVG(CashbackAmount) AS AvgCashback
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY AvgCashback DESC
LIMIT 3;

-- 15. Preferred payment modes of customers with tenure of 10 and > 500 orders
SELECT DISTINCT PreferredPaymentMode
FROM customer_churn
WHERE Tenure = 10 AND OrderCount > 500;

-- 16. Distance categorization and churn status breakdown
SELECT 
    CASE 
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END AS DistanceCategory,
    ChurnStatus,
    COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY DistanceCategory, ChurnStatus
ORDER BY FIELD(DistanceCategory, 'Very Close Distance', 'Close Distance', 'Moderate Distance', 'Far Distance'), ChurnStatus;

-- 17. Orders of married customers in City Tier-1 with order count > average
SELECT *
FROM customer_churn
WHERE MaritalStatus = 'Married'
  AND CityTier = 1
  AND OrderCount > (SELECT AVG(OrderCount) FROM customer_churn);

-- 18. Return details along with customer details for churned customers who complained
SELECT 
    cr.ReturnID,
    cr.ReturnDate,
    cr.RefundAmount,
    c.*
FROM customer_returns cr
JOIN customer_churn c ON cr.CustomerID = c.CustomerID
WHERE c.ChurnStatus = 'Churned'
  AND c.ComplaintReceived = 'Yes';
USE sakila;

#Get number of monthly active customers.

SELECT DATE_FORMAT(rental_date, '%Y-%m') AS month,
       COUNT(DISTINCT customer_id) AS active_customers
FROM rental
GROUP BY month
ORDER BY month;


#Active users in the previous month.

SELECT DATE_FORMAT(DATE_SUB('2023-06-01', INTERVAL 1 MONTH), '%Y-%m') AS previous_month,
       COUNT(DISTINCT customer_id) AS active_customers
FROM rental
WHERE rental_date >= '2023-05-01' AND rental_date < '2023-06-01';


#Percentage change in the number of active customers.

WITH monthly_active_customers AS (
    SELECT DATE_FORMAT(rental_date, '%Y-%m') AS month,
           COUNT(DISTINCT customer_id) AS active_customers
    FROM rental
    GROUP BY month
),
monthly_change AS (
    SELECT current_month.month AS current_month,
           previous_month.month AS previous_month,
           current_month.active_customers AS current_active_customers,
           previous_month.active_customers AS previous_active_customers,
           (current_month.active_customers - previous_month.active_customers) AS customer_change
    FROM monthly_active_customers current_month
    JOIN monthly_active_customers previous_month ON current_month.month = DATE_ADD(previous_month.month, INTERVAL 1 MONTH)
)
SELECT current_month,
       previous_month,
       current_active_customers,
       previous_active_customers,
       customer_change,
       ROUND((customer_change / previous_active_customers) * 100, 2) AS percentage_change
FROM monthly_change
ORDER BY current_month;


WITH monthly_active_customers AS (
    SELECT DATE_FORMAT(rental_date, '%Y-%m') AS month,
           COUNT(DISTINCT customer_id) AS active_customers
    FROM rental
    GROUP BY month
),
retained_customers AS (
    SELECT current_month.month AS current_month,
           previous_month.month AS previous_month,
           current_month.active_customers AS current_active_customers,
           previous_month.active_customers AS previous_active_customers,
           (current_month.active_customers - previous_month.active_customers) AS customer_change
    FROM monthly_active_customers current_month
    JOIN monthly_active_customers previous_month ON current_month.month = DATE_ADD(previous_month.month, INTERVAL 1 MONTH)
)
SELECT current_month,
       previous_month,
       current_active_customers,
       previous_active_customers,
       customer_change,
       ROUND((customer_change / previous_active_customers) * 100, 2) AS percentage_change,
       (current_active_customers - customer_change) AS retained_customers
FROM retained_customers
ORDER BY current_month;


#Take in account im making this lab at 09/08/2023.




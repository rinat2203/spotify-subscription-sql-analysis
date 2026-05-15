-- Spotify Subscription SQL Analysis
-- Author: Rinat Zhanakhmetov
-- Tools: MySQL

-- Tables used:
-- users(user_id, name, registration_date)
-- subscriptions(subscription_id, user_id, plan_type, price, start_date, end_date)
-- payments(payment_id, user_id, amount, payment_date)

# DAU
SELECT payment_date, COUNT(DISTINCT user_id) AS DAU
FROM payments
GROUP BY payment_date
ORDER BY payment_date;

# WAU
SELECT YEAR(payment_date) AS year,
       WEEK(payment_date, 1) AS week,
       COUNT(DISTINCT user_id) AS WAU
FROM payments
GROUP BY YEAR(payment_date), WEEK(payment_date, 1)
ORDER BY year, week;

# MAU
SELECT YEAR(payment_date) AS year,
       MONTH(payment_date) AS month,
       COUNT(DISTINCT user_id) AS mau
FROM payments
GROUP BY YEAR(payment_date), MONTH(payment_date)
ORDER BY year, month;

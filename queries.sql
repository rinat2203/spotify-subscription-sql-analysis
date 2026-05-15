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

# AOV
SELECT u.user_id, u.name,
    ROUND(AVG(p.amount), 2) AS aov
FROM users u
LEFT JOIN payments p
    ON u.user_id = p.user_id
GROUP BY u.user_id, u.name
ORDER BY aov DESC;

# LTV
SELECT u.user_id, u.name,
    COALESCE(SUM(p.amount), 0) AS ltv
FROM users u
LEFT JOIN payments p
    ON u.user_id = p.user_id
GROUP BY u.user_id, u.name
ORDER BY ltv DESC;

# Top 5 Customers by LTV
SELECT u.user_id, u.name,
    COALESCE(SUM(p.amount), 0) AS ltv
FROM users u
LEFT JOIN payments p
    ON u.user_id = p.user_id
GROUP BY u.user_id, u.name
ORDER BY ltv DESC
LIMIT 5;

# Retention Rate
WITH monthly_users AS (
    SELECT DISTINCT
        user_id,
        DATE_FORMAT(payment_date, '%Y-%m-01') AS month
    FROM payments
)
SELECT
    m1.month,
    COUNT(DISTINCT m1.user_id) AS users_current_month,
    COUNT(DISTINCT m2.user_id) AS retained_users,
    COUNT(DISTINCT m2.user_id) * 100.0 / COUNT(DISTINCT m1.user_id) AS retention_rate
FROM monthly_users m1
LEFT JOIN monthly_users m2
    ON m1.user_id = m2.user_id
   AND m2.month = DATE_ADD(m1.month, INTERVAL 1 MONTH)
GROUP BY m1.month
ORDER BY m1.month;

# Churn Rate
WITH monthly_users AS (
    SELECT DISTINCT
        user_id,
        DATE_FORMAT(payment_date, '%Y-%m-01') AS month
    FROM payments
)
SELECT
    m1.month,
    COUNT(DISTINCT m1.user_id) AS users_current_month,
    COUNT(DISTINCT m2.user_id) AS retained_users,
    COUNT(DISTINCT m2.user_id) * 100.0 / COUNT(DISTINCT m1.user_id) AS retention_rate
FROM monthly_users m1
LEFT JOIN monthly_users m2
    ON m1.user_id = m2.user_id
   AND m2.month = DATE_ADD(m1.month, INTERVAL 1 MONTH)
GROUP BY m1.month
ORDER BY m1.month;

/* 2. USER ACTIVITY METRICS */
/* Daily Active Addresses (Line Chart) */
SELECT
  DATE_TRUNC('day', block_time) AS date,
  COUNT(DISTINCT "from") AS daily_active_addresses,
  COUNT(DISTINCT "to") AS daily_active_contracts
FROM viction.transactions
GROUP BY
  1
ORDER BY
  date DESC


/* Weekly Active Addresses (Bar Chart) */
SELECT
  DATE_TRUNC('week', block_time) AS week,
  COUNT(DISTINCT "from") AS weekly_active_addresses,
  COUNT(DISTINCT "to") AS weekly_active_contracts
FROM viction.transactions
GROUP BY
  1
ORDER BY
  week DESC

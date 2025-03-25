/* 1. HIGH-LEVEL NETWORK HEALTH METRICS */
/* Daily Transaction Count (Line Chart) */
SELECT
  DATE_TRUNC('day', block_time) AS date,
  COUNT(*) AS daily_transactions,
  AVG(gas_used) AS avg_gas_per_tx,
  COUNT(CASE WHEN success = TRUE THEN 1 END) * 100.0 / COUNT(*) AS success_rate
FROM viction.transactions
GROUP BY
  1
ORDER BY
  date DESC

/* Weekly Transaction Count (Bar Chart) */
SELECT
  DATE_TRUNC('week', block_time) AS week,
  COUNT(*) AS weekly_transactions,
  AVG(gas_used) AS avg_gas_per_tx,
  COUNT(CASE WHEN success = TRUE THEN 1 END) * 100.0 / COUNT(*) AS success_rate
FROM viction.transactions
GROUP BY
  1
ORDER BY
  week DESC

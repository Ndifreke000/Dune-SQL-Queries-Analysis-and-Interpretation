/* 7. HOURLY ACTIVITY PATTERNS */
/* Hourly Transaction Distribution (Heat Map) */
SELECT
  DATE_TRUNC('hour', block_time) AS hour,
  EXTRACT(DOW FROM block_time) AS day_of_week,
  COUNT(*) AS transaction_count
FROM viction.transactions
GROUP BY
  1,
  2
ORDER BY
  hour,
  day_of_week

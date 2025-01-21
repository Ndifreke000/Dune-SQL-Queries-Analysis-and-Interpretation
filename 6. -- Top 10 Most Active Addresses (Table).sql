/* 6. TOP ACTIVE ADDRESSES */
/* Top 10 Most Active Addresses (Table) */
SELECT
  "from" AS from_address,
  COUNT(*) AS total_transactions,
  COUNT(DISTINCT DATE_TRUNC('day', block_time)) AS active_days,
  SUM(value) AS total_value_transferred
FROM viction.transactions
GROUP BY
  "from"
ORDER BY
  total_transactions DESC
LIMIT 10

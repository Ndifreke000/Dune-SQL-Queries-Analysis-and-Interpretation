/* 3. NEW USER ACQUISITION */
/* New Addresses per Week (Bar Chart) */
WITH first_tx AS (
  SELECT
    "from" AS from_address,
    MIN(block_time) AS first_tx_time
  FROM viction.transactions
  GROUP BY
    "from"
)
SELECT
  DATE_TRUNC('week', first_tx_time) AS week,
  COUNT(*) AS new_addresses
FROM first_tx
GROUP BY
  1
ORDER BY
  week DESC

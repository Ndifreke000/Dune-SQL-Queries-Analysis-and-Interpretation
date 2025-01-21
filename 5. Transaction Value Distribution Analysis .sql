WITH transaction_values AS (
  SELECT
    CAST(value / POWER(10, 18) AS DOUBLE) AS value_in_vic,
    block_time
  FROM viction.transactions
  WHERE block_time >= CURRENT_DATE - INTERVAL '30' day
)
SELECT
  value_in_vic,
  block_time
FROM transaction_values
ORDER BY block_time ASC, value_in_vic ASC

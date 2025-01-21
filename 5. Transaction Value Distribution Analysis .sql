/* Transaction Value Distribution Analysis (Pie Chart) */
WITH transaction_categories AS (
  SELECT
    CASE
      WHEN value < 1 * POWER(10, 18)
      THEN 'Micro (<1 VIC)'
      WHEN value < 10 * POWER(10, 18)
      THEN 'Small (1-10 VIC)'
      WHEN value < 100 * POWER(10, 18)
      THEN 'Medium (10-100 VIC)'
      WHEN value < 1000 * POWER(10, 18)
      THEN 'Large (100-1000 VIC)'
      ELSE 'Whale (>1000 VIC)'
    END AS transaction_category,
    COUNT(*) AS transaction_count,
    SUM(value) AS total_value
  FROM viction.transactions
  WHERE
    block_time >= CURRENT_DATE - INTERVAL '30' day
  GROUP BY
    CASE
      WHEN value < 1 * POWER(10, 18)
      THEN 'Micro (<1 VIC)'
      WHEN value < 10 * POWER(10, 18)
      THEN 'Small (1-10 VIC)'
      WHEN value < 100 * POWER(10, 18)
      THEN 'Medium (10-100 VIC)'
      WHEN value < 1000 * POWER(10, 18)
      THEN 'Large (100-1000 VIC)'
      ELSE 'Whale (>1000 VIC)'
    END
)
SELECT
  transaction_category,
  transaction_count,
  ROUND((
    transaction_count * 100.0 / SUM(transaction_count) OVER ()
  ), 2) AS percentage_of_transactions,
  total_value / POWER(10, 18) AS total_value_in_vic,
  ROUND((
    total_value * 100.0 / SUM(total_value) OVER ()
  ), 2) AS percentage_of_value
FROM transaction_categories
ORDER BY
  total_value DESC

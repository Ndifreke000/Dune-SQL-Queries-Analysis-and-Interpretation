/* Transaction Value Analysis with Distribution Metrics (Line/Box Plot) */
WITH daily_stats AS (
  SELECT
    DATE_TRUNC('day', block_time) AS date,
    COUNT(*) AS num_transactions,
    AVG(value) AS avg_transaction_value,
    APPROX_PERCENTILE(value, 0.10) AS p10_value,
    APPROX_PERCENTILE(value, 0.25) AS p25_value,
    APPROX_PERCENTILE(value, 0.50) AS p50_value,
    APPROX_PERCENTILE(value, 0.75) AS p75_value,
    APPROX_PERCENTILE(value, 0.90) AS p90_value,
    COUNT(CASE WHEN value < 1 THEN 1 END) AS micro_tx_count,
    COUNT(CASE WHEN value >= 1 AND value < 10 THEN 1 END) AS small_tx_count,
    COUNT(CASE WHEN value >= 10 AND value < 100 THEN 1 END) AS medium_tx_count,
    COUNT(CASE WHEN value >= 100 AND value < 1000 THEN 1 END) AS large_tx_count,
    COUNT(CASE WHEN value >= 1000 THEN 1 END) AS whale_tx_count,
    SUM(value) AS total_daily_value,
    MAX(value) AS max_transaction_value
  FROM viction.transactions
  WHERE
    value > 0 /* Exclude zero-value transactions */
  GROUP BY
    1
)
SELECT
  date,
  num_transactions,
  avg_transaction_value,
  p10_value,
  p25_value,
  p50_value,
  p75_value,
  p90_value,
  (
    micro_tx_count * 100.0 / num_transactions
  ) /* Calculate percentage distribution of transaction sizes */ AS micro_tx_percentage,
  (
    small_tx_count * 100.0 / num_transactions
  ) AS small_tx_percentage,
  (
    medium_tx_count * 100.0 / num_transactions
  ) AS medium_tx_percentage,
  (
    large_tx_count * 100.0 / num_transactions
  ) AS large_tx_percentage,
  (
    whale_tx_count * 100.0 / num_transactions
  ) AS whale_tx_percentage,
  total_daily_value, /* Calculate value concentration */
  (
    p75_value - p25_value
  ) AS interquartile_range,
  max_transaction_value,
  (
    p75_value - p25_value
  ) /* Transaction value volatility indicator */ / p50_value AS value_dispersion_ratio
FROM daily_stats
ORDER BY
  date DESC

/* Hourly Activity Analysis with Time Window */
WITH date_bounds AS (
  SELECT
    MIN(block_time) AS min_date,
    MAX(block_time) AS max_date
  FROM viction.transactions
), hourly_patterns AS (
  SELECT
    DATE_TRUNC('hour', block_time) AS hour_timestamp,
    EXTRACT(DOW FROM block_time) AS day_of_week,
    EXTRACT(HOUR FROM block_time) AS hour_of_day,
    COUNT(*) AS transaction_count,
    AVG(COUNT(*)) OVER (PARTITION BY EXTRACT(DOW FROM block_time), EXTRACT(HOUR FROM block_time)) AS avg_transactions_this_hour
  FROM viction.transactions
  GROUP BY
    DATE_TRUNC('hour', block_time),
    EXTRACT(DOW FROM block_time),
    EXTRACT(HOUR FROM block_time)
)
SELECT
  hour_timestamp,
  CASE day_of_week
    WHEN 0
    THEN 'Sunday'
    WHEN 1
    THEN 'Monday'
    WHEN 2
    THEN 'Tuesday'
    WHEN 3
    THEN 'Wednesday'
    WHEN 4
    THEN 'Thursday'
    WHEN 5
    THEN 'Friday'
    WHEN 6
    THEN 'Saturday'
  END AS day_name,
  hour_of_day,
  transaction_count,
  avg_transactions_this_hour,
  transaction_count - avg_transactions_this_hour AS deviation_from_average,
  ROUND(
    (
      transaction_count - avg_transactions_this_hour
    ) / NULLIF(avg_transactions_this_hour, 0) * 100,
    2
  ) AS percentage_deviation
FROM hourly_patterns
ORDER BY
  hour_timestamp DESC

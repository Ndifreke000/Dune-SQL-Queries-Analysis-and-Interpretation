WITH daily_activity AS (
  SELECT
    DATE(block_time) AS day,
    t.from_address AS address,
    COUNT(*) AS daily_transactions
  FROM starknet.transactions
  CROSS JOIN UNNEST(messages_sent) AS t(from_address, payload, to_address)
  WHERE
    block_time >= CURRENT_DATE - INTERVAL '30' DAY
  GROUP BY
    1,
    2
), total_activity AS (
  SELECT
    day,
    SUM(daily_transactions) AS total_daily_transactions
  FROM daily_activity
  GROUP BY
    day
)
SELECT
  da.day,
  da.address,
  da.daily_transactions,
  da.daily_transactions * 100.0 / ta.total_daily_transactions AS percentage_of_daily_transactions
FROM daily_activity AS da
JOIN total_activity AS ta
  ON da.day = ta.day
ORDER BY
  da.day,
  da.daily_transactions DESC

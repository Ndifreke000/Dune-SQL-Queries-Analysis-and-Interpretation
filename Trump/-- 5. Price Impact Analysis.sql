/* 5. Price Impact Analysis */
WITH trade_impacts AS (
  SELECT
    tx_hash,
    block_time,
    amount_usd,
    amount_usd / token_sold_amount AS execution_price,
    LAG(amount_usd / token_sold_amount) OVER (ORDER BY block_time) AS previous_price
  FROM dex.trades
  WHERE
    (
      LOWER(token_bought_symbol) LIKE '%trump%' OR LOWER(token_sold_symbol) LIKE '%trump%'
    )
    AND block_time >= CURRENT_TIMESTAMP - INTERVAL '7' day
)
SELECT
  DATE_TRUNC('hour', block_time) AS hour,
  AVG(ABS(execution_price - previous_price) / NULLIF(previous_price, 0) * 100) AS avg_price_impact_pct,
  MAX(ABS(execution_price - previous_price) / NULLIF(previous_price, 0) * 100) AS max_price_impact_pct,
  COUNT(*) AS number_of_trades
FROM trade_impacts
WHERE
  NOT previous_price IS NULL
GROUP BY
  1
ORDER BY
  1

/* 3. Launch Momentum Analysis */
SELECT
  DATE_TRUNC('minute', block_time) AS minute,
  COUNT(DISTINCT tx_hash) AS trades_per_minute,
  COUNT(DISTINCT taker) AS unique_buyers,
  SUM(amount_usd) AS minute_volume_usd,
  AVG(amount_usd / token_bought_amount) AS avg_price_usd
FROM dex.trades
WHERE
  (
    LOWER(token_bought_symbol) LIKE '%trump%' OR LOWER(token_sold_symbol) LIKE '%trump%'
  )
  AND block_time >= CURRENT_TIMESTAMP - INTERVAL '24' hour
GROUP BY
  1
ORDER BY
  1

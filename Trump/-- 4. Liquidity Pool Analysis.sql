/* 4. Liquidity Pool Analysis */
SELECT
  DATE_TRUNC('hour', block_time) AS hour,
  project AS exchange_name,
  token_pair,
  SUM(amount_usd) AS pool_volume_usd,
  COUNT(DISTINCT tx_hash) AS swap_count,
  AVG(amount_usd / token_bought_amount) AS avg_price_usd,
  SUM(CASE WHEN amount_usd > 1000 THEN 1 ELSE 0 END) AS large_trades_count
FROM dex.trades
WHERE
  LOWER(token_bought_symbol) LIKE '%trump%'
  AND block_time >= CURRENT_TIMESTAMP - INTERVAL '7' day
GROUP BY
  1,
  2,
  3
ORDER BY
  hour DESC,
  pool_volume_usd DESC

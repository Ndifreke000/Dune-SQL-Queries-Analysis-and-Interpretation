-- 1. Initial Trading Analysis and Price Discovery
WITH initial_trading AS (
  SELECT 
    date_trunc('hour', block_time) as time_bucket,
    symbol,
    COUNT(DISTINCT tx_hash) as trades_count,
    SUM(amount_usd) as volume_usd,
    AVG(amount_usd/amount) as price_usd,
    MIN(amount_usd/amount) as min_price_usd,
    MAX(amount_usd/amount) as max_price_usd
  FROM dex.trades
  WHERE symbol ILIKE '%TRUMP%'  -- Case insensitive match for TRUMP token
  AND block_time >= NOW() - INTERVAL '7 days'  -- Adjust based on token launch date
  GROUP BY 1, 2
  ORDER BY time_bucket
)
SELECT 
  time_bucket,
  symbol,
  trades_count,
  volume_usd,
  price_usd,
  min_price_usd,
  max_price_usd,
  100 * (price_usd - LAG(price_usd) OVER (ORDER BY time_bucket)) / 
    NULLIF(LAG(price_usd) OVER (ORDER BY time_bucket), 0) as price_change_pct
FROM initial_trading;

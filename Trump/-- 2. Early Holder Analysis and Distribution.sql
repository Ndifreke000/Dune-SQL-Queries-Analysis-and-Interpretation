WITH holder_analysis AS (
  SELECT
    taker AS wallet_address,
    COUNT(DISTINCT tx_hash) AS transaction_count,
    SUM(
      CASE
        WHEN token_bought_amount_raw > 0
        THEN token_bought_amount_raw
        ELSE token_sold_amount_raw
      END
    ) AS total_token_amount,
    SUM(amount_usd) AS total_value_usd
  FROM dex.trades
  WHERE
    LOWER(token_bought_symbol) LIKE '%trump%'
    AND block_time >= CURRENT_TIMESTAMP - INTERVAL '7' day
  GROUP BY
    1
)
SELECT
  wallet_address,
  transaction_count,
  total_token_amount,
  total_value_usd,
  NTILE(100) OVER (ORDER BY total_token_amount DESC) AS percentile
FROM holder_analysis
WHERE
  total_token_amount > 0
ORDER BY
  total_token_amount DESC

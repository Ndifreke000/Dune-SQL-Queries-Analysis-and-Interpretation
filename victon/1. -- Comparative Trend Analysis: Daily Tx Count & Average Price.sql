WITH eth AS (
  SELECT
    DATE_TRUNC('day', block_time) AS day,
    COUNT(*) AS tx_count,
    AVG(value) AS avg_price
  FROM ethereum.transactions
  GROUP BY 1
), stark AS (
  SELECT
    DATE_TRUNC('day', block_time) AS day,
    COUNT(*) AS tx_count,
    NULL AS avg_price
  FROM starknet.transactions
  GROUP BY 1
), btc AS (
  SELECT
    DATE_TRUNC('day', block_time) AS day,
    COUNT(*) AS tx_count,
    NULL AS avg_price
  FROM bitcoin.transactions
  GROUP BY 1
)
SELECT
  day,
  chain,
  tx_count,
  avg_price
FROM (
  SELECT day, 'Ethereum' AS chain, tx_count, avg_price FROM eth
  UNION ALL
  SELECT day, 'Starknet' AS chain, tx_count, avg_price FROM stark
  UNION ALL
  SELECT day, 'Bitcoin' AS chain, tx_count, avg_price FROM btc
) AS combined
ORDER BY day, chain

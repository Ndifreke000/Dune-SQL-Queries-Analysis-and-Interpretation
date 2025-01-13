WITH daily_stats AS (
    SELECT 
        DATE_TRUNC('day', time) AS block_date,
        COUNT(*) AS blocks_per_day,
        AVG(tx_count) AS avg_tx_per_block,
        MAX(tx_count) AS max_tx_in_block,
        MIN(tx_count) AS min_tx_in_block,
        STDDEV(tx_count) AS tx_volatility
    FROM starknet.blocks 
    WHERE time >= CURRENT_DATE - INTERVAL '7' DAY
    GROUP BY DATE_TRUNC('day', time)
),
moving_averages AS (
    SELECT 
        block_date,
        avg_tx_per_block,
        AVG(avg_tx_per_block) OVER (
            ORDER BY block_date 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS three_day_ma
    FROM daily_stats
)
SELECT 
    ds.block_date,
    ROUND(ds.avg_tx_per_block, 2) AS avg_transactions,
    ROUND(ds.tx_volatility, 2) AS transaction_volatility,
    ds.max_tx_in_block,
    ds.min_tx_in_block,
    ds.blocks_per_day,
    ROUND(ma.three_day_ma, 2) AS three_day_moving_avg,
    ROUND(((ds.avg_tx_per_block - LAG(ds.avg_tx_per_block) OVER (ORDER BY ds.block_date)) / 
        LAG(ds.avg_tx_per_block) OVER (ORDER BY ds.block_date) * 100), 2) AS daily_growth_rate
FROM daily_stats ds
JOIN moving_averages ma ON ds.block_date = ma.block_date
ORDER BY ds.block_date DESC;

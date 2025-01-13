WITH daily_calls AS (
  SELECT
    DATE_TRUNC('day', block_time) AS call_date,
    entry_point_type AS function_name, /* Corrected alias */
    COUNT(*) AS daily_count,
    COUNT(DISTINCT caller_address) AS unique_callers, /* Corrected alias */
    COUNT(DISTINCT contract_address) AS unique_contracts /* Corrected alias */
  FROM starknet.calls
  WHERE
    block_time >= CURRENT_DATE - INTERVAL '30' DAY
  GROUP BY
    1,
    2
), function_stats AS (
  SELECT
    function_name,
    SUM(daily_count) AS total_calls,
    AVG(daily_count) AS avg_daily_calls,
    MAX(daily_count) AS peak_daily_calls,
    MIN(daily_count) AS min_daily_calls,
    SUM(unique_callers) AS total_unique_callers,
    SUM(unique_contracts) AS total_unique_contracts,
    COUNT(DISTINCT call_date) AS active_days
  FROM daily_calls
  GROUP BY
    function_name
), ranked_functions AS (
  SELECT
    function_name,
    total_calls,
    ROUND(avg_daily_calls, 2) AS avg_daily_calls,
    peak_daily_calls,
    min_daily_calls,
    total_unique_callers,
    total_unique_contracts,
    active_days,
    ROUND((
      total_calls * 100.0 / SUM(total_calls) OVER ()
    ), 2) AS percentage_of_total_calls,
    ROUND(
      (
        (
          total_calls - LAG(total_calls) OVER (ORDER BY total_calls DESC)
        ) / NULLIF(LAG(total_calls) OVER (ORDER BY total_calls DESC), 0) * 100
      ),
      2
    ) AS call_drop_to_next
  FROM function_stats
)
SELECT
  function_name,
  total_calls,
  avg_daily_calls,
  peak_daily_calls,
  min_daily_calls,
  total_unique_callers,
  total_unique_contracts,
  active_days,
  ROUND((
    active_days * 100.0 / 30
  ), 2) AS activity_rate_percentage,
  percentage_of_total_calls,
  call_drop_to_next AS percentage_drop_to_next_function
FROM ranked_functions
WHERE
  total_calls > 0
ORDER BY
  total_calls DESC
LIMIT 5

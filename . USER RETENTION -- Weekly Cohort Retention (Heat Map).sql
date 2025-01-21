/* 4. USER RETENTION */
/* Weekly Cohort Retention (Heat Map) */
WITH first_week AS (
  SELECT
    "from" AS from_address,
    DATE_TRUNC('week', MIN(block_time)) AS cohort_week
  FROM viction.transactions
  GROUP BY
    "from"
), activity AS (
  SELECT
    "from" AS from_address,
    DATE_TRUNC('week', block_time) AS activity_week
  FROM viction.transactions
)
SELECT
  cohort_week,
  activity_week,
  COUNT(DISTINCT activity.from_address) AS retained_users,
  COUNT(DISTINCT activity.from_address) * 100.0 / (
    SELECT
      COUNT(DISTINCT from_address)
    FROM first_week AS fw2
    WHERE
      fw2.cohort_week = first_week.cohort_week
  ) AS retention_rate
FROM first_week
JOIN activity
  ON first_week.from_address = activity.from_address
WHERE
  activity_week >= cohort_week
GROUP BY
  cohort_week,
  activity_week
ORDER BY
  cohort_week DESC,
  activity_week

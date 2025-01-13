SELECT
  from_address AS contract_address,
  CASE
    WHEN NOT ARRAY_POSITION(keys, TRY_CAST('[UpgradeInitiated]' AS VARBINARY)) IS NULL
    THEN 'UpgradeInitiated'
    WHEN NOT ARRAY_POSITION(keys, TRY_CAST('[ImplementationChanged]' AS VARBINARY)) IS NULL
    THEN 'ImplementationChanged'
    ELSE NULL
  END AS event_name,
  COUNT(*) AS upgrade_count,
  MAX(block_time) AS last_upgrade
FROM starknet.events
WHERE
  NOT ARRAY_POSITION(keys, TRY_CAST('[UpgradeInitiated]' AS VARBINARY)) IS NULL
  OR NOT ARRAY_POSITION(keys, TRY_CAST('[ImplementationChanged]' AS VARBINARY)) IS NULL
GROUP BY
  from_address,
  2
ORDER BY
  upgrade_count DESC

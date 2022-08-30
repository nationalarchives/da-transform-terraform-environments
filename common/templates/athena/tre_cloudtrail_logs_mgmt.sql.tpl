SELECT *
FROM ${database_name}."tre_cloudtrail_logs_mgmt"
WHERE
  eventsource = 'lambda.amazonaws.com' AND
  eventtime >= '2022-08-15' AND
  eventtime <= '2022-08-31'
ORDER BY sourceipaddress
LIMIT 20;
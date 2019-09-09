SELECT 
  x.Email
, x.Status
, x.Date
FROM 
(
	SELECT DISTINCT EmailAddress as Email, Status, CAST(CASE 
		WHEN DateUnsubscribed IS NOT NULL THEN DateUnsubscribed
		WHEN DateUndeliverable IS NOT NULL THEN DateUndeliverable
		ELSE DateJoined
		END as Date) as Date,
    ROW_NUMBER() OVER (PARTITION BY EmailAddress ORDER BY EmailAddress DESC) AS rank 
	FROM _Subscribers
) x
WHERE x.rank = 1

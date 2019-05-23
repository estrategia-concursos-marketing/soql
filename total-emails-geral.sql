SELECT DISTINCT EmailAddress as Email
FROM _Subscribers
WHERE EmailAddress IS NOT NULL
AND EmailAddress LIKE '%_@__%.__%'

UNION

SELECT DISTINCT Email
FROM [Leads-Newsletter-Organico]
WHERE Email IS NOT NULL
AND Email LIKE '%_@__%.__%'
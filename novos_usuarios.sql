SELECT DISTINCT SubscriberKey AS email
FROM _ListSubscribers l
WHERE CreatedDate >= convert(date, getDate()-30)
AND CreatedDate < convert(date, getDate())
GROUP BY SubscriberKey

UNION

SELECT DISTINCT Email
FROM [Leads-Gerais-6] g
LEFT JOIN _Subscribers s
ON g.Email = s.EmailAddress
WHERE g.Email LIKE '%_@__%.__%'
AND s.SubscriberKey IS NULL
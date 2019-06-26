SELECT DISTINCT SubscriberKey AS email
FROM  _Open
WHERE eventdate >= convert(date, getDate()-1)
AND eventdate < convert(date, getDate())
AND isunique = 1
GROUP BY SubscriberKey

UNION

SELECT email
FROM Novos_Usuarios
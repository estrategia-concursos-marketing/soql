SELECT SubscriberKey as [Subscriber Key], EmailAddress as [Email Address]
FROM _Subscribers s
LEFT JOIN (
    SELECT SubscriberKey as email_desengajado
    FROM _Click
    WHERE eventdate >= DATEADD(DAY, -30, GETDATE())
) x
ON s.EmailAddress = x.email_desengajado
WHERE x.email_desengajado IS NULL

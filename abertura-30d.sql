SELECT 
  x.Email
, x.[Interesse - Evento]
, x.Nome_do_email
FROM 
(
    SELECT DISTINCT
       s.EmailAddress as Email,
      j.EmailSubject as [Interesse - Evento],
      j.EmailName as Nome_do_email,
      ROW_NUMBER() OVER (PARTITION BY s.EmailAddress, j.EmailSubject 
                         ORDER BY s.EmailAddress, j.EmailSubject DESC) AS rank 
    FROM _Open o
    INNER JOIN _Job j 
    ON o.JobID = j.JobID
    INNER JOIN _Subscribers s
    ON o.SubscriberKey = s.SubscriberKey
    WHERE o.IsUnique = 1
    AND j.DeliveredTime >= DATEADD(DAY, -30, GETDATE())
    AND j.EmailSubject IS NOT NULL
    AND j.EmailName IS NOT NULL
    AND s.EmailAddress LIKE '%_@__%.__%'
) x
WHERE x.rank = 1
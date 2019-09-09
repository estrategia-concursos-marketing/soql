SELECT 
  x.Email
, x.[Interesse - Evento]
, x.Nome_do_email
FROM 
(
    SELECT 
       s.EmailAddress as Email
    ,  j.EmailSubject as [Interesse - Evento]
    ,  j.EmailName as Nome_do_email
    , ROW_NUMBER() OVER (PARTITION BY s.EmailAddress, j.EmailSubject 
                         ORDER BY s.EmailAddress, j.EmailSubject DESC) AS rank 
    FROM _Click c
    INNER JOIN _Job j 
    ON c.JobID = j.JobID
    INNER JOIN _Subscribers s
    ON c.SubscriberKey = s.SubscriberKey
    WHERE c.IsUnique = 1
    AND j.DeliveredTime >= DATEADD(DAY, -30, GETDATE())
    AND (c.URL like '%sucess%' or j.EmailName LIKE '%convit%') 
    AND s.EmailAddress LIKE '%_@__%.__%'
    AND s.SubscriberKey LIKE '%_@__%.__%'
) x
WHERE x.rank = 1

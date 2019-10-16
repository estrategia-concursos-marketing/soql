/*
    Por solicitação do diretor de vestibulares, 
    as leads são filtradas diretamente por query de Leads-Gerais-5. 
    Não passando por um filtro de "engajados_30d' etc.
*/

/* Leads dos Formulários */
SELECT 
  x.*
FROM 
(
    SELECT 
      l.[Primeiro Nome]
    , l.Sobrenome
    , l.Email
    , l.Telefone
    , l.[Origem do lead]
    , l.[Modo de entrada]
    , l.[Interesse - Área]
    , l.[Interesse - Concurso]
    , l.[Interesse - Evento]
    , l.[Estado de Origem do IP]
    , l.[Cidade de Origem do IP]
    , l.[Data de criação]
    , ROW_NUMBER() OVER (PARTITION BY l.Email, l.[Interesse - Evento] ORDER BY l.Email, l.[Interesse - Evento] DESC) AS rank 
    FROM [Leads-Gerais-6] l
    INNER JOIN engajados_30d e
    ON e.email = l.Email
    WHERE l.Email LIKE '%_@__%.__%'
    AND e.email IS NOT NULL
    AND l.[Interesse - Área] LIKE '%vestibular%'
) x
WHERE x.rank = 1

UNION

/* Leads das Importações */
SELECT 
    l.[ID principal], 
    l.Nome, 
    l.Sobrenome, 
    l.Email, 
    l.Telefone, 
    l.[Origem do lead], 
    l.[Interesse - Área], 
    l.[Interesse - Concurso], 
    l.[Interesse - Evento], 
    l.[Estado de Origem do IP], 
    l.[Cidade de Origem do IP], 
    l.[Data de criação], 
    l.[Hora de Criação], 
    l.Nome_do_email, 
    l.Genero, 
    l.Aniversario, 
    l.Nome_Emails_Abertos, 
    l.[Modo de entrada]
FROM Leads_Base_Importacao l
INNER JOIN engajados_30d e
ON l.Email = e.email
WHERE l.Email LIKE '%_@__%.__%'
AND e.email IS NOT NULL
OR (
    l.Nome_do_email LIKE '%vestibular%'
    OR l.[Interesse - Área] LIKE '%vestibular%' 
)

UNION

/* Leads das pessoas que clicam nos próprios emails. */
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
    AND j.EmailName LIKE '%vestibular%'
) x
WHERE x.rank = 1

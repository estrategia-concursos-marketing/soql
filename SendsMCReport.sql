SELECT     
    j.JobID, 
    j.AccountUserID as UserID, 
    j.FromName as Remetente,
    j.EmailName as Nome_do_Email,
    j.EmailSubject as Assunto_do_Email,
    j.DeliveredTime as Data_Hora_de_Envio,
    s.Envios_Totais,
    b.Bounces_Unicos,
    a.Aberturas_Unicas,
    c.Clicks_Unicos,
    r.Reclamacoes_Unicas,
    u.Opt_Out_Unicos
FROM _Job j
INNER JOIN SentEnviosTotais s
ON j.JobID = s.JobID
INNER JOIN BounceEntrega b
ON j.JobID = b.JobID
INNER JOIN OpenTaxaDeAbertura a
ON j.JobID = a.JobID
INNER JOIN ClickTaxaDeClicks c
ON j.JobID = c.JobID
INNER JOIN ComplaintReclamacoes r
ON j.JobID = r.JobID
INNER JOIN UnsubscribeOpt_Out_Unicos u
ON j.JobID = u.JobID

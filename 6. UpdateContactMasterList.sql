
--select tag from tblContacts where  tag is not null

--update tblContacts set Tag='' where tag  is not null

UPDATE C SET C.Tag= CASE WHEN ISNULL(S.[Country (Optional)],'')='' THEN ISNULL(C.Tag,'') ELSE ISNULL(C.Tag,'') +','+S.[Country (Optional)] END 
from tblContacts c inner join
TblSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
where S.[Country (Optional)] !='' 

UPDATE C SET C.Tag= CASE WHEN ISNULL(S.[State],'')='' THEN ISNULL(C.Tag,'') ELSE ISNULL(C.Tag,'') +','+S.[State] END 
from tblContacts c inner join
TblSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
where S.[State] !='' 

UPDATE C SET C.Tag= CASE WHEN ISNULL(S.City,'')='' THEN ISNULL(C.Tag,'') ELSE ISNULL(C.Tag,'') +','+S.City END 
from tblContacts c inner join
TblSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
where S.City !='' 

UPDATE C SET C.Tag= CASE WHEN ISNULL(S.[Tell us more about your interests],'')='' THEN ISNULL(C.Tag,'') ELSE ISNULL(C.Tag,'') +','+S.[Tell us more about your interests] END 
from tblContacts c inner join
TblSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
where S.[Tell us more about your interests] !='' 

UPDATE C SET C.Tag= CASE WHEN ISNULL(S.[Your field (Optional)],'')='' THEN ISNULL(C.Tag,'') ELSE ISNULL(C.Tag,'') +','+S.[Your field (Optional)] END 
from tblContacts c inner join
TblSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
where S.[Your field (Optional)] !='' 

--Grantees by Regions
UPDATE C SET C.Tag= CASE WHEN ISNULL(S.[Grantees by Regions],'')='' THEN ISNULL(C.Tag,'') ELSE ISNULL(C.Tag,'') +','+S.[Grantees by Regions] END 
from tblContacts c inner join
TblSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
where S.[Grantees by Regions] !='' 

--Grantees by Program
UPDATE C SET C.Tag= CASE WHEN ISNULL(S.[Grantees by Program],'')='' THEN ISNULL(C.Tag,'') ELSE ISNULL(C.Tag,'') +','+S.[Grantees by Program] END 
from tblContacts c inner join
TblSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
where S.[Grantees by Program] !='' 


UPDATE CM SET CM.FordfoundationContactPoint = K.FFContact FROM(
SELECT S.EMailAddress,
CASE WHEN ISNULL(S.RPO,'') ='' THEN CASE  ISNULL(S.[Grant Manager],'') WHEN '' THEN '' ELSE S.[Grant Manager]  END
ELSE S.RPO+S.[Grant Manager] END FFContact FROM 
tblContacts c 
inner join TblSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail) K 
INNER JOIN TblContacts CM ON CM.PrimaryEmail=K.EmailAddress where K.FFContact !=''

UPDATE C SET C.JobTitle = S.[Job Title]  FROM TblContacts c 
inner join TblSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
where S.[Job Title] !=''






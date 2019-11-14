
SELECT distinct  T.[First Name]FirstName,T.[Last Name]LastName,t.[Email Address]Email,t.Organization,
SlNo=Row_number() over(PARTITION BY T.[First Name],T.[Last Name],t.Organization ORDER BY T.[First Name],T.[Last Name],t.Organization,C.ContactId)
Into #TempContacts
FROM TblSubscribedContacts  T 
inner join Dim_ContactsMaster_New C on C.PrimaryEmail=T.[Email Address] Inner join (
select [First Name],[Last Name],Organization from TblSubscribedContacts
group by [First Name],[Last Name],Organization having count(*)>1 ) D
on Isnull(D.[First Name],'')=isnull(T.[First Name],'') 
and isnull(d.[Last Name],'')=isnull(t.[Last Name],'') and d.Organization=t.Organization
where Isnull(T.[First Name],'') !='' and Isnull(T.[Last Name],'')!=''
and ISnull(t.organization,'')!=''
order by t.[First Name],t.[Last Name], SlNo


SELECT Firstname,Lastname,[1] as PrimaryEmail,[2] as SecondaryEmail,ISNULL([3],'') as ThirdEmail,
Organization,0 As SecContactId,0 as ThirdContactId INTO #Second_thirdMail 
FROM (
SELECT firstname,lastname,SlNo,Email,Organization from #TempContacts
) t
Pivot(
max(email)
for SlNo in([1],[2],[3],[4]) 
) as L


select * from #Second_thirdMail 

			

Update C Set C.secondaryEmail=s.secondaryEmail,
c.ThirdEmail=s.ThirdEmail
from #Second_thirdMail S 
inner join Dim_ContactsMaster C 
On S.PrimaryEmail=C.PrimaryEmail

---Dim_ContactMaster

--SELECT distinct  T.[FirstName]FirstName,T.[LastName]LastName,t.PrimaryEmail,t.Organization,
--SlNo=Row_number() over(PARTITION BY T.[FirstName],T.[LastName],t.Organization ORDER BY T.[FirstName],T.[LastName],t.Organization,C.ContactId)
--Into #TempContacts
--FROM Dim_ContactsMaster_New  T 
--inner join Dim_ContactsMaster_New C on C.PrimaryEmail=T.PrimaryEmail Inner join (
--select [FirstName],[LastName],Organization from Dim_ContactsMaster_New
--group by [FirstName],[LastName],Organization having count(*)>1 ) D
--on Isnull(D.[FirstName],'')=isnull(T.[FirstName],'') 
--and isnull(d.[LastName],'')=isnull(t.[LastName],'') and d.Organization=t.Organization
--where Isnull(T.[FirstName],'') !='' and Isnull(T.[LastName],'')!=''
--and ISnull(t.organization,'')!=''
--order by t.[FirstName],t.[LastName], SlNo

--SELECT Firstname,Lastname,[1] as PrimaryEmail,[2] as SecondaryEmail,ISNULL([3],'') as ThirdEmail,
--Organization,0 As SecContactId,0 as ThirdContactId INTO #Second_thirdMail 
--FROM (
--SELECT firstname,lastname,SlNo,PrimaryEmail,Organization from #TempContacts
--) t
--Pivot(
--max(PrimaryEmail)
--for SlNo in([1],[2],[3],[4]) 
--) as L

--UPDATE C SET C.SecondaryEmail=T.SecondaryEmail,C.ThirdEmail=T.ThirdEmail 
--FROM #Second_thirdMail T Inner join Dim_ContactsMaster_New C on C.PrimaryEmail=T.PrimaryEmail





 --Splitting Events from tags

 UPDATE TblSubscribedContacts Set TAGS=replace(replace(tags,'&amp;','&'),';','|') where CHARINDEX(';',Tags)>0
 UPDATE TblSubscribedContacts Set TAGS=replace(tags,',','|') where CHARINDEX(',',Tags)>0
 update TblSubscribedContacts set TAGS=rtrim(replace(TAGS,''+CHAR(13)+'','')) where TAGS like '%' + CHAR(13)+'%'

truncate table TblMailChimpEventContacts
INSERT INTO TblMailChimpEventContacts(Firstname,Lastname,Emailaddress,Eventname)
SELECT DISTINCT S.[First Name],S.[Last Name], S.EmailAddress, Rtrim(Ltrim(Replace(B.item,'"',''))) EventName --INTO #TempContactEvents
FROM TblSubscribedContacts S
CROSS APPLY dbo.SplitString(S.tags, '|') B WHERE B.item !='' AND S.Tags IS NOT NULL
and len(Rtrim(Ltrim(Replace(B.item,'"',''))))>1

INSERT INTO TblMailChimpEventContacts(Firstname,Lastname,Emailaddress,Eventname)
SELECT distinct EB.[First Name],EB.[Last Name],EB.EmailAddress, isnull(campaign,'') EventName FROM TblSubscribedContacts EB
WHERE not exists(select 1 from TblMailChimpEventContacts E WHERE E.EventName=Isnull(EB.campaign,''))
and Campaign is not null

Select distinct Eventname,NewEventName into #TempContactEvents from TblMailChimpEventContacts

--Alter table #TempContactEvents add NewEventName varchar(200)
update #TempContactEvents set NewEventName=Eventname

update #TempContactEvents set 
NewEventName=ltrim(rtrim(SUBSTRING(NewEventName,0,Charindex('- Send',NewEventName,0))))
where Charindex('- Send',NewEventName,0) > 1


update #TempContactEvents set 
NewEventName=ltrim(rtrim(SUBSTRING(NewEventName,0,Charindex('(Send',NewEventName,0))))
where Charindex('(Send',NewEventName,0) > 1

update #TempContactEvents set 
NewEventName=ltrim(rtrim(SUBSTRING(NewEventName,0,Charindex('-Send',NewEventName,0))))
where Charindex('-Send',NewEventName,0) > 1

update #TempContactEvents set 
NewEventName=ltrim(rtrim(SUBSTRING(NewEventName,0,Charindex('(Reminder',NewEventName,0))))
where Charindex('(Reminder',NewEventName,0) > 1

update #TempContactEvents set 
NewEventName=ltrim(rtrim(SUBSTRING(NewEventName,0,Charindex('(Batch',NewEventName,0))))
where Charindex('(Batch',NewEventName,0) > 1

update #TempContactEvents set 
NewEventName=ltrim(rtrim(SUBSTRING(NewEventName,0,Charindex('send 0',NewEventName,0))))
where Charindex('send 0',NewEventName,0) > 1

update #TempContactEvents set 
NewEventName=ltrim(rtrim(SUBSTRING(NewEventName,0,Charindex('- batch 0',NewEventName,0))))
where Charindex('- batch 0',NewEventName,0) > 1

update #TempContactEvents set 
NewEventName='Why Cities Matter'
where Charindex('Why Cities Matter',NewEventName,0) = 1 
--in('Why Cities Matter1 - 6-12-18','Why Cities Matter2 - 6-12-18','Why Cities Matter3 - 6-12-18','Why Cities Matter4 - 6-12-18')

update #TempContactEvents set 
NewEventName='2017 Mozilla Web Fellows'
where Charindex('2017 Mozilla Web Fellows',NewEventName,0) = 1 

update #TempContactEvents set 
NewEventName=ltrim(rtrim(SUBSTRING(NewEventName,0,Charindex(' send0',NewEventName,0))))
where Charindex(' send0',NewEventName,0) > 1

update #TempContactEvents set 
NewEventName='9-26-18_Girls_Not_Brides_Reception'
where Charindex('9-26-18_Girls_Not_Brides_Reception',NewEventName,0) = 1 


update #TempContactEvents set 
NewEventName='Racial Equity in Philanthropy Fund'
where NewEventName 
in('Racial Equity in Philanthropy Fund1_7-11-18','Racial Equity in Philanthropy Fund2_7-11-18',
'Racial Equity in Philanthropy Fund3_7-11-18')

update #TempContactEvents set 
NewEventName='9-5-18 Click Here to Kill Everybody'
where Charindex('9-5-18 Click Here to Kill Everybody',NewEventName,0) = 1 

update #TempContactEvents set 
NewEventName='Emerging Media Summit'
where Charindex('Emerging Media Summit',NewEventName,0) = 1 

update #TempContactEvents set 
NewEventName='Future_of_Work_webinar'
where Charindex('Future_of_Work_webinar',NewEventName,0) > 0

update #TempContactEvents set 
NewEventName='GW_Webinar'
where Charindex('GW_Webinar',NewEventName,0) > 0

update #TempContactEvents set 
NewEventName='Make Trouble'
where Charindex('Make Trouble',NewEventName,0) > 0

update #TempContactEvents set 
NewEventName='MCA Inauguration'
where Charindex('MCA Inauguration',NewEventName,0) > 0

update #TempContactEvents set 
NewEventName=replace(NewEventName,'#','')
where Charindex('#',NewEventName,0)=1


update #TempContactEvents set 
NewEventName='Storytelling& - A day of conversation, engagement, and new alliances'
where Charindex('2-13-19 Storytelling&',NewEventName,0) =1

update #TempContactEvents set 
NewEventName='GW_Webinar'
where Charindex('CEG Webinar',NewEventName,0) = 1

update #TempContactEvents set 
NewEventName='6-12-19 Advancing Foundation Archives'
where Charindex('6-12-19 Advancing Foundation Archives',NewEventName,0) > 0

update #TempContactEvents set 
NewEventName='Democracy Against Domination'
where Charindex('Democracy Against Domination',NewEventName,0) >1

update #TempContactEvents set 
NewEventName='Just Cities & Regions webinar'
where Charindex('Just Cities & Regions webinar',NewEventName,0) =1

update #TempContactEvents set 
NewEventName='Democracy Against Domination'
where Charindex('Democracy Against Domination',NewEventName,0) =1

update #TempContactEvents set 
NewEventName='2019 Worldwide Meeting List'
where CHARINDEX('2019 Worldwide Meeting List',NeweventName,0)>0

update #TempContactEvents set 
NewEventName='4-22-19 Raj Chetty - save the date'
where CHARINDEX('4-22-19 Raj Chetty - save the date',NeweventName,0)>0

update #TempContactEvents set 
NewEventName=rtrim(replace(NewEventName,''+CHAR(13)+'','')) 
where NewEventName like '%' + CHAR(13)+'%'

update #TempContactEvents set 
NewEventName='Center for Social Justice Announcement'
where CHARINDEX('Center for Social Justice Announcement',NeweventName,0)>0

update #TempContactEvents set 
NewEventName='Cities and States Director Don Chen Announcement'
where CHARINDEX('Cities and States Director Don Chen Announcement',NeweventName,0)>0

update #TempContactEvents set 
NewEventName='7-9-19 A conversation with Valerie Jarrett'
where CHARINDEX('7-9-19 A conversation with Valerie Jarrett',NeweventName,0)>0

update #TempContactEvents set 
NewEventName='Emerging Media Summit'
where CHARINDEX('Emerging Media Summit',NeweventName,0)>0

update #TempContactEvents set 
NewEventName='4-29-19 Future of Workers'
where CHARINDEX('Future of Workers',NeweventName,0)>0

update #TempContactEvents set 
NewEventName='STORYTELLING& - A day of conversation, engagement, and new alliances'
where CHARINDEX('Storytelling& - A day of conversation| engagement| and new alliances',NeweventName,0)>0


update #TempContactEvents set 
NewEventName='STORYTELLING& - A day of conversation, engagement, and new alliances'
where CHARINDEX('Storytelling&',NeweventName,0)>0

update TblMailChimpEventContacts set NewEventName=rtrim(LTRIM(neweventName))
, Eventname=rtrim(LTRIM(Eventname))



Select distinct EventName into #TempEventBrite from TblEventBriteBulkImportCsv

select distinct M.NewEventName As MailChimpEventName,E.EventName EventBriteEventName from #TempContactEvents M
Inner join #TempEventBrite E on M.NewEventName like Concat('%',E.EventName,'%')



Update T set NewEventName=E.eventName From #TempEventBrite E
Inner Join #TempContactEvents T on T.NewEventName like Concat('%',E.EventName,'%')


Update T set NewEventName=E.NewEventName From #TempContactEvents E
Inner Join TblMailChimpEventContacts T on T.EventName =E.EventName

update TblMailChimpEventContacts set NewEventName=rtrim(ltrim(neweventname))
--remove invalid event
delete from TblMailChimpEventContacts where NewEventName in('5/2 5:40PM','5/2 5:40PM','Cities ')
or CHARINDEX('5/2 5:40PM',NeweventName,0)>0

INSERT INTO TblEvents(EventName)
SELECT distinct NewEventName FROM TblMailChimpEventContacts EB
WHERE not exists(select 1 from TblEvents E WHERE E.EventName=EB.NewEventName)



















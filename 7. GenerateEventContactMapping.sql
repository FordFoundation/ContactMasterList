

----Insert contacts which are available in Mail chimp campaign, tag and tags column

--Insert into TblContactEventMap(ContactId,EventId,SegmentNo,IsInvited,RSVPStatus)
--Select distinct C.ContactId,E.EventId, 0 SegNo,1,'Invited' IsInvited FROM TblContacts C
--Inner Join TblMailChimpEventContacts S On S.Emailaddress=C.PrimaryEmail
--Inner join TblEvents E on E.EventName=S.NewEventName
--Where NOT EXISTS(select 1 from TblContactEventMap M WHERE M.ContactId=C.ContactId AND M.EventId=E.EventId)
--order by EventId


SELECT DISTINCT EMAIL,EventName,SUM(Tickets)Tickets INTO #TempEBContacts FROM (
SELECT DISTINCT Firstname,Lastname,Eventname,email,Sum(CAst(Quantity as INT))Tickets,[Attendee Status] 
from TblEventBriteBulkImportCsv
where Email is not null and [Attendee Status] in('Checked In','Attending')
group by Firstname,Lastname,eventname,Email,[Attendee Status] --having count(*) >1
) K Group by Email,EventName 

INSERT INTO TblContactEventMap(ContactId,EventId,Tickets,SegmentNo,RSVPStatus)
SELECT distinct Contactid,Eventid,Tickets,0 SegmentNo,'RSVPed' from (
SELECT distinct C.Contactid,E.EventId, ISNULL(EB.Tickets,0)Tickets FROM TblContacts C
Inner Join #TempEBContacts EB ON EB.Email=C.PrimaryEmail 
INNER JOIN TblEvents E  ON E.EventName=EB.EventName
UNION
SELECT distinct C.Contactid,E.EventId, ISNULL(EB.Tickets,0)Tickets FROM TblContacts C
Inner Join #TempEBContacts EB ON EB.Email=ISNULL(C.SecondaryEmail,'')
INNER JOIN TblEvents E  ON E.EventName=EB.EventName
union
SELECT distinct C.Contactid,E.EventId, ISNULL(EB.Tickets,0)Tickets FROM TblContacts C
Inner Join #TempEBContacts EB ON EB.Email=ISNULL(C.ThirdEmail,'')
INNER JOIN TblEvents E  ON E.EventName=EB.EventName
) D
WHERE NOT Exists(SELECT 1 from TblContactEventMap M where M.ContactId=D.ContactId and M.EventId=D.EventId)





--Update the RSVP status if contact exists attendee status is attending, checked in
UPDATE MAP SET MAP.RSVPStatus='RSVPed' FROM (
SELECT DISTINCT C.ContactId,E.EventId  FROM TblContacts C
INNER JOIN TblEventBriteBulkImportCsv S On S.Email=C.PrimaryEmail
INNER JOIN TblEvents E on E.EventName=S.EventName
Where EXISTS(select 1 from TblContactEventMap M Where M.ContactId=C.ContactId AND M.EventId=E.EventId)
AND [Attendee Status] in('Attending','Checked In')) K
INNER JOIN TblContactEventMap MAP ON MAP.ContactId=K.ContactId AND K.EventId=MAP.EventId


--Update the RSVP status if contact exists attendee status is not attending
UPDATE MAP SET MAP.RSVPStatus='Declined' FROM (
SELECT DISTINCT C.ContactId,E.EventId  FROM TblContacts C
INNER JOIN TblEventBriteBulkImportCsv S On S.Email=C.PrimaryEmail
INNER JOIN TblEvents E on E.EventName=S.EventName
Where EXISTS(select 1 from TblContactEventMap M Where M.ContactId=C.ContactId AND M.EventId=E.EventId)
AND [Attendee Status] not in('Attending','Checked In')) K
INNER JOIN TblContactEventMap MAP ON MAP.ContactId=K.ContactId AND K.EventId=MAP.EventId
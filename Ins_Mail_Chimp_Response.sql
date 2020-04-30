
GO

/****** Object:  StoredProcedure [dbo].[Ins_Mail_Chimp_Response]    Script Date: 4/30/2020 12:03:21 PM ******/
DROP PROCEDURE [dbo].[Ins_Mail_Chimp_Response]
GO

/****** Object:  StoredProcedure [dbo].[Ins_Mail_Chimp_Response]    Script Date: 4/30/2020 12:03:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Ins_Mail_Chimp_Response] 
  @MailChimpRespXml XML, -- XML Variable 
  @UserType varchar(100)
                                            
                               
AS
BEGIN

declare @returnVal varchar(250)
SET @returnVal='';
--declare @Contactxml as xml
/*
EXEC [Ins_Mail_Chimp_Response] '<?xml version="1.0" standalone="yes"?>
<DocumentElement>
  <MailChimp>
    <EmailAddress>lcdlemurs@msn.com</EmailAddress>
    <Prefix />
    <First_Name>Lesley</First_Name>
    <Middle_Initial />
    <Last_Name>Davies</Last_Name>
	</MailChimp>
  <MailChimp>
    <EmailAddress>ralstyles1@gmail.com</EmailAddress>
    <Prefix />
    <First_Name>Robin</First_Name>
    <Middle_Initial />
    <Last_Name>Lacey</Last_Name>
 </MailChimp>
</DocumentElement>'


*/

BEGIN TRY 
--CREATE TABLE #TempMailResp(
--    ROWID int identity(1,1) primary key,
--	[EmailAddress] [nvarchar](250) NULL,
--	[Prefix] [nvarchar](20) NULL,
--	[First_Name] [nvarchar](150) NULL,
--	[Middle_Initial] [nvarchar](max) NULL	,
--	[Last_Name] [nvarchar](max) NULL	
--)  

 CREATE TABLE #TempTblContacts(EmailAddress nvarchar(200) NULL)

 	  INSERT INTO #TempTblContacts
   			SELECT  EmailAddress   FROM(
			SELECT DISTINCT EmailAddress FROM(					
					SELECT primaryEmail EmailAddress from TblContacts
					UNION 
					SELECT ISNULL(SecondaryEmail,'') EmailAddress from TblContacts where SecondaryEmail is not null
					union
					SElect Isnull(ThirdEmail,'') EmailAddress from TblContacts where ThirdEmail is not null
			) T	) K
 
if @UserType ='UnSubscribed'-----------------------------------------------------------UNSUBSCRIBED------------------------------------------
   Begin
   TRUNCATE TABLE Stg_TblContacts	
   TRUNCATE TABLE TblMailChimpUnSubscribedContacts

   INSERT INTO TblMailChimpUnSubscribedContacts
SELECT                                               
	 C.M.query('.//EmailAddress').value('(.)[1]', 'varchar(500)') [EmailAddress]
	,C.M.query('.//Prefix').value('(.)[1]', 'varchar(200)') [Prefix]
	,C.M.query('.//First_Name').value('(.)[1]', 'varchar(200)') [First_Name]
	,C.M.query('.//Middle_Initial').value('(.)[1]', 'varchar(200)') [Middle_Initial]
	,C.M.query('.//Last_Name').value('(.)[1]', 'varchar(500)') [Last_Name]
	,C.M.query('.//Full_name').value('(.)[1]', 'varchar(200)') [Full_name]
	,C.M.query('.//Job_Title').value('(.)[1]', 'varchar(500)') [Job_Title]
	,C.M.query('.//Organization').value('(.)[1]', 'varchar(500)') [Organization]
	,C.M.query('.//Your_field').value('(.)[1]', 'varchar(500)') [Your_field]
	,C.M.query('.//Position_Type').value('(.)[1]', 'varchar(500)') [Position_Type]
	,C.M.query('.//Region').value('(.)[1]', 'varchar(500)') [Region]
	,C.M.query('.//Country').value('(.)[1]', 'varchar(500)') [Country]
	,C.M.query('.//State').value('(.)[1]', 'varchar(500)') [State]
	,C.M.query('.//Twitter_username').value('(.)[1]', 'varchar(500)') [Twitter_username]
	,C.M.query('.//Grantee_Status').value('(.)[1]', 'varchar(500)') [Grantee_Status]
	,C.M.query('.//Telephone').value('(.)[1]', 'varchar(500)') [Telephone]
	,C.M.query('.//Ford_Staff_Category').value('(.)[1]', 'varchar(500)') [Ford_Staff_Category]
	,C.M.query('.//Sources').value('(.)[1]', 'varchar(500)') [Sources]
	,C.M.query('.//Grantee_Organization').value('(.)[1]', 'varchar(500)') [Grantee_Organization]
	,C.M.query('.//RPO_Office').value('(.)[1]', 'varchar(500)') [RPO_Office]
	,C.M.query('.//Grant_Type').value('(.)[1]', 'varchar(500)') [Grant_Type]
	,C.M.query('.//City').value('(.)[1]', 'varchar(500)') [City]
	,C.M.query('.//GPP_Announcement').value('(.)[1]', 'varchar(500)') [GPP_Announcement]
	,C.M.query('.//Domain_country').value('(.)[1]', 'varchar(500)') [Domain_country]
	,C.M.query('.//Source_List').value('(.)[1]', 'varchar(500)') [Source_List]
	,C.M.query('.//FF_Management_Level').value('(.)[1]', 'varchar(500)') [FF_Management_Level]
	,C.M.query('.//Cell_Phone').value('(.)[1]', 'varchar(500)') [Cell_Phone]
	,C.M.query('.//FF_Department').value('(.)[1]', 'varchar(500)') [FF_Department]
	,C.M.query('.//FF_Division').value('(.)[1]', 'varchar(500)') [FF_Division]
	,C.M.query('.//SalesForce_ID').value('(.)[1]', 'varchar(500)') [SalesForce_ID]
	,C.M.query('.//GDPR_Compliant').value('(.)[1]', 'varchar(500)') [GDPR_Compliant]
	,C.M.query('.//Domain_from_EU').value('(.)[1]', 'varchar(500)') [Domain_from_EU]
	,C.M.query('.//Opt-in_date').value('(.)[1]', 'varchar(500)') [Opt-in_date]
	,C.M.query('.//Campaign').value('(.)[1]', 'varchar(500)') [Campaign]
	,C.M.query('.//GDPR_Compliant_Signup_Form').value('(.)[1]', 'varchar(500)') [GDPR_Compliant_Signup_Form]
	,C.M.query('.//May_18_Status').value('(.)[1]', 'varchar(500)') [May_18_Status]
	,C.M.query('.//Fiscal_Year').value('(.)[1]', 'varchar(500)') [Fiscal_Year]
	,C.M.query('.//RPO').value('(.)[1]', 'varchar(500)') [RPO]
	,C.M.query('.//Grant_Manager').value('(.)[1]', 'varchar(500)') [Grant_Manager]
	,C.M.query('.//Tag').value('(.)[1]', 'varchar(500)') [Tag]
	,C.M.query('.//CfSJ_Campaign_Version').value('(.)[1]', 'varchar(500)') [CfSJ_Campaign_Version]
	,C.M.query('.//Mailing_Address').value('(.)[1]', 'varchar(500)') [Mailing_Address]
	,C.M.query('.//Zip_Country_Code').value('(.)[1]', 'varchar(100)') [Zip_Country_Code]
	,C.M.query('.//C/O').value('(.)[1]', 'varchar(100)') [C/O]
	,C.M.query('.//Nominees_YES_Full_Name').value('(.)[1]', 'varchar(250)') [Nominees_YES_Full_Name]
	,C.M.query('.//Nominess_NO_Full_Name').value('(.)[1]', 'varchar(250)') [Nominess_NO_Full_Name]
	,C.M.query('.//Nominess_ALL_Full_Name').value('(.)[1]', 'varchar(250)') [Nominess_ALL_Full_Name]
	,C.M.query('.//Candidate_Full_Name').value('(.)[1]', 'varchar(500)') [Candidate_Full_Name]
	,C.M.query('.//Subscribe_to').value('(.)[1]', 'varchar(500)') [Subscribe_to]
	,C.M.query('.//Tell_us_more_about_your_interests').value('(.)[1]', 'varchar(500)') [Tell_us_more_about_your_interests]
	,C.M.query('.//Ford_Foundation').value('(.)[1]', 'varchar(500)') [Ford_Foundation]
	,C.M.query('.//Grantees_by_Regions').value('(.)[1]', 'varchar(500)') [Grantees_by_Regions]
	,C.M.query('.//Grantees_by_Program').value('(.)[1]', 'varchar(500)') [Grantees_by_Program]
	,C.M.query('.//Int155b14559d').value('(.)[1]', 'varchar(500)') [Int155b14559d]
	,C.M.query('.//MEMBER_RATING').value('(.)[1]', 'varchar(500)') [MEMBER_RATING]
	,C.M.query('.//OPTIN_TIME').value('(.)[1]', 'varchar(500)') [OPTIN_TIME]
	,C.M.query('.//OPTIN_IP').value('(.)[1]', 'varchar(500)') [OPTIN_IP]
	,C.M.query('.//CONFIRM_TIME').value('(.)[1]', 'varchar(500)') [CONFIRM_TIME]
	,C.M.query('.//CONFIRM_IP').value('(.)[1]', 'varchar(500)') [CONFIRM_IP]
	,C.M.query('.//LATITUDE').value('(.)[1]', 'varchar(500)') [LATITUDE]
	,C.M.query('.//LONGITUDE').value('(.)[1]', 'varchar(500)') [LONGITUDE]
	,C.M.query('.//GMTOFF').value('(.)[1]', 'varchar(500)') [GMTOFF]
	,C.M.query('.//DSTOFF').value('(.)[1]', 'varchar(500)') [DSTOFF]
	,C.M.query('.//TIMEZONE').value('(.)[1]', 'varchar(500)') [TIMEZONE]
	,C.M.query('.//CC').value('(.)[1]', 'varchar(500)') [CC]
	,C.M.query('.//REGION1').value('(.)[1]', 'varchar(500)') [REGION1]
	,C.M.query('.//UNSUB_TIME').value('(.)[1]', 'varchar(500)') [UNSUB_TIME]
	,C.M.query('.//UNSUB_CAMPAIGN_TITLE').value('(.)[1]', 'varchar(100)') [UNSUB_CAMPAIGN_TITLE]
	,C.M.query('.//UNSUB_CAMPAIGN_ID').value('(.)[1]', 'varchar(100)') [UNSUB_CAMPAIGN_ID]
	,C.M.query('.//UNSUB_REASON').value('(.)[1]', 'varchar(500)') [UNSUB_REASON]
	,C.M.query('.//UNSUB_REASON_OTHER').value('(.)[1]', 'varchar(500)') [UNSUB_REASON_OTHER]
	,C.M.query('.//LEID').value('(.)[1]', 'varchar(500)') [LEID]
	,C.M.query('.//EUID').value('(.)[1]', 'varchar(2000)') [EUID]
	,C.M.query('.//NOTES').value('(.)[1]', 'varchar(4000)') [NOTES]
	,C.M.query('.//TAGS').value('(.)[1]', 'varchar(8000)') [TAGS]

   FROM @MailChimpRespXml.nodes('/EventResponse/MailChimp') C(M)

   
		INSERT INTO Stg_TblContacts(
		Firstname,Lastname,PrimaryEmail,JobTitle,Organization,Notes,[Source],Tag,IsActive,TwitterUsername,Telephone,Cellphone,Prefix,MiddleInitial)
		SELECT distinct [First Name],[Last Name],[EmailAddress],[Job Title],Organization,NOTES,[Sources],[TAGS],1,[Twitterusername(Optional)]
		,[Telephone],[CellPhone],LEFT([Prefix],20),[Middle Initial] FROM TblMailChimpUnSubscribedContacts T

		UPDATE C SET C.Unsubscribe =1--,
			   --C.IsActive=0
		FROM Stg_TblUnSubscribedContacts U
		INNER JOIN Stg_TblContacts C ON C.PrimaryEmail=U.EmailAddress

		INSERT INTO TblContacts(Prefix,Firstname,Lastname,VIP,PrimaryEmail,SecondaryEmail,ThirdEmail,AssistantEmail,Telephone,Cellphone,JobTitle
			,Organization,FordfoundationOwnerEmail,Notes,Source,Tag,IsActive,Delete_at,Unsubscribe,GDPRCompliant,TwitterUsername)
SELECT DISTINCT Prefix,Firstname,Lastname,VIP,PrimaryEmail,SecondaryEmail,ThirdEmail,AssistantEmail,Telephone,Cellphone,JobTitle
			,Organization,FordfoundationOwnerEmail,Notes,Source,Tag,IsActive,Delete_at,Unsubscribe,GDPRCompliant,TwitterUsername from Stg_TblContacts T
			WHERE ISNULL(IsDelete,0)=0
			AND NOT EXISTS (SELECT 1 from #TempTblContacts C where c.EmailAddress=T.PrimaryEmail)		
			AND PrimaryEmail NOT IN  ('event@fordfoundation.org', 'events@fordfoundation.org', 'rsvp@fordfoundation.org', 'fordevent@fordfoundation.org', 'fordevents@fordfoundation.org', 'c.caronan@fordfoundation.org', 'k.hughes@fordfoundation.org')
		
		UPDATE C SET C.Unsubscribe =1--,
			   --C.IsActive=0
		FROM Stg_TblContacts U
		INNER JOIN TblContacts C ON C.PrimaryEmail=U.PrimaryEmail

   End

ELSE IF @UserType = 'Cleaned' -----------------------------------------------------------CLEAED------------------------------------------
Begin
truncate table Stg_TblContacts
Truncate table  TblMailChimpCleanedContacts

INSERT INTO TblMailChimpCleanedContacts
SELECT                                               
	 C.M.query('.//EmailAddress').value('(.)[1]', 'varchar(500)') [EmailAddress]
	,C.M.query('.//Prefix').value('(.)[1]', 'varchar(200)') [Prefix]
	,C.M.query('.//First_Name').value('(.)[1]', 'varchar(200)') [First_Name]
	,C.M.query('.//Middle_Initial').value('(.)[1]', 'varchar(200)') [Middle_Initial]
	,C.M.query('.//Last_Name').value('(.)[1]', 'varchar(500)') [Last_Name]
	,C.M.query('.//Full_name').value('(.)[1]', 'varchar(200)') [Full_name]
	,C.M.query('.//Job_Title').value('(.)[1]', 'varchar(500)') [Job_Title]
	,C.M.query('.//Organization').value('(.)[1]', 'varchar(500)') [Organization]
	,C.M.query('.//Your_field').value('(.)[1]', 'varchar(500)') [Your_field]
	,C.M.query('.//Position_Type').value('(.)[1]', 'varchar(500)') [Position_Type]
	,C.M.query('.//Region').value('(.)[1]', 'varchar(500)') [Region]
	,C.M.query('.//Country').value('(.)[1]', 'varchar(500)') [Country]
	,C.M.query('.//State').value('(.)[1]', 'varchar(500)') [State]
	,C.M.query('.//Twitter_username').value('(.)[1]', 'varchar(500)') [Twitter_username]
	,C.M.query('.//Grantee_Status').value('(.)[1]', 'varchar(500)') [Grantee_Status]
	,C.M.query('.//Telephone').value('(.)[1]', 'varchar(500)') [Telephone]
	,C.M.query('.//Ford_Staff_Category').value('(.)[1]', 'varchar(500)') [Ford_Staff_Category]
	,C.M.query('.//Sources').value('(.)[1]', 'varchar(500)') [Sources]
	,C.M.query('.//Grantee_Organization').value('(.)[1]', 'varchar(500)') [Grantee_Organization]
	,C.M.query('.//RPO_Office').value('(.)[1]', 'varchar(500)') [RPO_Office]
	,C.M.query('.//Grant_Type').value('(.)[1]', 'varchar(500)') [Grant_Type]
	,C.M.query('.//City').value('(.)[1]', 'varchar(500)') [City]
	,C.M.query('.//GPP_Announcement').value('(.)[1]', 'varchar(500)') [GPP_Announcement]
	,C.M.query('.//Domain_country').value('(.)[1]', 'varchar(500)') [Domain_country]
	,C.M.query('.//Source_List').value('(.)[1]', 'varchar(500)') [Source_List]
	,C.M.query('.//FF_Management_Level').value('(.)[1]', 'varchar(500)') [FF_Management_Level]
	,C.M.query('.//Cell_Phone').value('(.)[1]', 'varchar(500)') [Cell_Phone]
	,C.M.query('.//FF_Department').value('(.)[1]', 'varchar(500)') [FF_Department]
	,C.M.query('.//FF_Division').value('(.)[1]', 'varchar(500)') [FF_Division]
	,C.M.query('.//SalesForce_ID').value('(.)[1]', 'varchar(500)') [SalesForce_ID]
	,C.M.query('.//GDPR_Compliant').value('(.)[1]', 'varchar(500)') [GDPR_Compliant]
	,C.M.query('.//Domain_from_EU').value('(.)[1]', 'varchar(500)') [Domain_from_EU]
	,C.M.query('.//Opt-in_date').value('(.)[1]', 'varchar(500)') [Opt-in_date]
	,C.M.query('.//Campaign').value('(.)[1]', 'varchar(500)') [Campaign]
	,C.M.query('.//GDPR_Compliant_Signup_Form').value('(.)[1]', 'varchar(500)') [GDPR_Compliant_Signup_Form]
	,C.M.query('.//May_18_Status').value('(.)[1]', 'varchar(500)') [May_18_Status]
	,C.M.query('.//Fiscal_Year').value('(.)[1]', 'varchar(500)') [Fiscal_Year]
	,C.M.query('.//RPO').value('(.)[1]', 'varchar(500)') [RPO]
	,C.M.query('.//Grant_Manager').value('(.)[1]', 'varchar(500)') [Grant_Manager]
	,C.M.query('.//Tag').value('(.)[1]', 'varchar(500)') [Tag]
	,C.M.query('.//CfSJ_Campaign_Version').value('(.)[1]', 'varchar(500)') [CfSJ_Campaign_Version]
	,C.M.query('.//Mailing_Address').value('(.)[1]', 'varchar(500)') [Mailing_Address]
	,C.M.query('.//Zip_Country_Code').value('(.)[1]', 'varchar(100)') [Zip_Country_Code]
	,C.M.query('.//C/O').value('(.)[1]', 'varchar(100)') [C/O]
	,C.M.query('.//Nominees_YES_Full_Name').value('(.)[1]', 'varchar(250)') [Nominees_YES_Full_Name]
	,C.M.query('.//Nominess_NO_Full_Name').value('(.)[1]', 'varchar(250)') [Nominess_NO_Full_Name]
	,C.M.query('.//Nominess_ALL_Full_Name').value('(.)[1]', 'varchar(250)') [Nominess_ALL_Full_Name]
	,C.M.query('.//Candidate_Full_Name').value('(.)[1]', 'varchar(500)') [Candidate_Full_Name]
	,C.M.query('.//Subscribe_to').value('(.)[1]', 'varchar(500)') [Subscribe_to]
	,C.M.query('.//Tell_us_more_about_your_interests').value('(.)[1]', 'varchar(500)') [Tell_us_more_about_your_interests]
	,C.M.query('.//Ford_Foundation').value('(.)[1]', 'varchar(500)') [Ford_Foundation]
	,C.M.query('.//Grantees_by_Regions').value('(.)[1]', 'varchar(500)') [Grantees_by_Regions]
	,C.M.query('.//Grantees_by_Program').value('(.)[1]', 'varchar(500)') [Grantees_by_Program]
	,C.M.query('.//Int155b14559d').value('(.)[1]', 'varchar(500)') [Int155b14559d]
	,C.M.query('.//MEMBER_RATING').value('(.)[1]', 'varchar(500)') [MEMBER_RATING]
	,C.M.query('.//OPTIN_TIME').value('(.)[1]', 'varchar(500)') [OPTIN_TIME]
	,C.M.query('.//OPTIN_IP').value('(.)[1]', 'varchar(500)') [OPTIN_IP]
	,C.M.query('.//CONFIRM_TIME').value('(.)[1]', 'varchar(500)') [CONFIRM_TIME]
	,C.M.query('.//CONFIRM_IP').value('(.)[1]', 'varchar(500)') [CONFIRM_IP]
	,C.M.query('.//LATITUDE').value('(.)[1]', 'varchar(500)') [LATITUDE]
	,C.M.query('.//LONGITUDE').value('(.)[1]', 'varchar(500)') [LONGITUDE]
	,C.M.query('.//GMTOFF').value('(.)[1]', 'varchar(500)') [GMTOFF]
	,C.M.query('.//DSTOFF').value('(.)[1]', 'varchar(500)') [DSTOFF]
	,C.M.query('.//TIMEZONE').value('(.)[1]', 'varchar(500)') [TIMEZONE]
	,C.M.query('.//CC').value('(.)[1]', 'varchar(500)') [CC]
	,C.M.query('.//REGION1').value('(.)[1]', 'varchar(200)') [REGION1]
	,C.M.query('.//CLEAN_TIME').value('(.)[1]', 'varchar(200)') [CLEAN_TIME]
	,C.M.query('.//CLEAN_CAMPAIGN_TITLE').value('(.)[1]', 'varchar(200)') [CLEAN_CAMPAIGN_TITLE]
	,C.M.query('.//CLEAN_CAMPAIGN_ID').value('(.)[1]', 'varchar(200)') [CLEAN_CAMPAIGN_ID]
	,C.M.query('.//LEID').value('(.)[1]', 'varchar(500)') [LEID]
	,C.M.query('.//EUID').value('(.)[1]', 'varchar(500)') [EUID]
	,C.M.query('.//NOTES').value('(.)[1]', 'varchar(500)') [NOTES]
	,C.M.query('.//TAGS').value('(.)[1]', 'varchar(8000)') [TAGS]
   FROM @MailChimpRespXml.nodes('/EventResponse/MailChimp') C(M)
	
		INSERT INTO Stg_TblContacts(Prefix,
			Firstname,Lastname,PrimaryEmail,JobTitle,Organization,Notes,[Source],Tag,IsActive,TwitterUsername,Telephone,Cellphone,MiddleInitial
		)
				SELECT DISTINCT  [Prefix],[First Name],[Last Name],[EmailAddress],
				[Job Title],Organization,NOTES,[Sources],[TAGS],1,[Twitter username (Optional)],[Telephone],[Cell Phone],[Middle Initial] 
				FROM TblMailChimpCleanedContacts T
	UPDATE C SET 
			   C.IsActive=0
		FROM Stg_TblRemovecontacts U
		INNER JOIN Stg_TblContacts C ON C.PrimaryEmail=U.EmailAddress

INSERT INTO TblContacts(Prefix,Firstname,Lastname,VIP,PrimaryEmail,SecondaryEmail,ThirdEmail,AssistantEmail,Telephone,Cellphone,JobTitle
			,Organization,FordfoundationOwnerEmail,Notes,Source,Tag,IsActive,Delete_at,Unsubscribe,GDPRCompliant,TwitterUsername)
SELECT DISTINCT Prefix,Firstname,Lastname,VIP,PrimaryEmail,SecondaryEmail,ThirdEmail,AssistantEmail,Telephone,Cellphone,JobTitle
			,Organization,FordfoundationOwnerEmail,Notes,Source,Tag,IsActive,Delete_at,Unsubscribe,GDPRCompliant,TwitterUsername from Stg_TblContacts T
			WHERE ISNULL(IsDelete,0)=0
			AND NOT EXISTS (SELECT 1 from #TempTblContacts C where c.EmailAddress=T.PrimaryEmail)		
			AND PrimaryEmail NOT IN  ('event@fordfoundation.org', 'events@fordfoundation.org', 'rsvp@fordfoundation.org', 'fordevent@fordfoundation.org', 'fordevents@fordfoundation.org', 'c.caronan@fordfoundation.org', 'k.hughes@fordfoundation.org')
		
		UPDATE C SET 
		C.IsActive=0
		FROM Stg_TblContacts U
		INNER JOIN TblContacts C ON C.PrimaryEmail=U.PrimaryEmail

   end 
 ELSE IF @UserType = 'Subscribed'-----------------------------------------------------------SUBSCRIBED------------------------------------------
Begin
Truncate table TblMailChimpSubscribedContacts

select * from TblMailChimpSubscribedContacts
INSERT INTO TblMailChimpSubscribedContacts
SELECT                                               
    C.M.query('.//EmailAddress').value('(.)[1]', 'nvarchar(250)') [EmailAddress]
   ,C.M.query('.//Prefix').value('(.)[1]', 'nvarchar(20)') [Prefix]
   ,C.M.query('.//First_Name').value('(.)[1]', 'nvarchar(50)') [First_Name]
   ,C.M.query('.//Middle_Initial').value('(.)[1]', 'nvarchar(150)') [Middle_Initial]
   ,C.M.query('.//Last_Name').value('(.)[1]', 'nvarchar(max)') [Last_Name] 
   ,C.M.query('.//Full_name').value('(.)[1]', 'varchar(200)') [Full_name]
	,C.M.query('.//Job_Title').value('(.)[1]', 'varchar(500)') [Job_Title]
	,C.M.query('.//Organization').value('(.)[1]', 'varchar(500)') [Organization]
	,C.M.query('.//Your_field').value('(.)[1]', 'varchar(500)') [Your_field]
	,C.M.query('.//Position_Type').value('(.)[1]', 'varchar(500)') [Position_Type]
	,C.M.query('.//Region').value('(.)[1]', 'varchar(500)') [Region]
	,C.M.query('.//Country').value('(.)[1]', 'varchar(500)') [Country]
	,C.M.query('.//State').value('(.)[1]', 'varchar(500)') [State]
	,C.M.query('.//Twitter_username').value('(.)[1]', 'varchar(500)') [Twitter_username]
	,C.M.query('.//Grantee_Status').value('(.)[1]', 'varchar(500)') [Grantee_Status]
	,C.M.query('.//Telephone').value('(.)[1]', 'varchar(500)') [Telephone]
	,C.M.query('.//Ford_Staff_Category').value('(.)[1]', 'varchar(500)') [Ford_Staff_Category]
	,C.M.query('.//Sources').value('(.)[1]', 'varchar(500)') [Sources]
	,C.M.query('.//Grantee_Organization').value('(.)[1]', 'varchar(500)') [Grantee_Organization]
	,C.M.query('.//RPO_Office').value('(.)[1]', 'varchar(500)') [RPO_Office]
	,C.M.query('.//Grant_Type').value('(.)[1]', 'varchar(500)') [Grant_Type]
	,C.M.query('.//City').value('(.)[1]', 'varchar(500)') [City]
	,C.M.query('.//GPP_Announcement').value('(.)[1]', 'varchar(500)') [GPP_Announcement]
	,C.M.query('.//Domain_country').value('(.)[1]', 'varchar(500)') [Domain_country]
	,C.M.query('.//Source_List').value('(.)[1]', 'varchar(500)') [Source_List]
	,C.M.query('.//FF_Management_Level').value('(.)[1]', 'varchar(500)') [FF_Management_Level]
	,C.M.query('.//Cell_Phone').value('(.)[1]', 'varchar(500)') [Cell_Phone]
	,C.M.query('.//FF_Department').value('(.)[1]', 'varchar(500)') [FF_Department]
	,C.M.query('.//FF_Division').value('(.)[1]', 'varchar(500)') [FF_Division]
	,C.M.query('.//SalesForce_ID').value('(.)[1]', 'varchar(500)') [SalesForce_ID]
	,C.M.query('.//GDPR_Compliant').value('(.)[1]', 'varchar(500)') [GDPR_Compliant]
	,C.M.query('.//Domain_from_EU').value('(.)[1]', 'varchar(500)') [Domain_from_EU]
	,C.M.query('.//Opt-in_date').value('(.)[1]', 'varchar(500)') [Opt-in_date]
	,C.M.query('.//Campaign').value('(.)[1]', 'varchar(500)') [Campaign]
	,C.M.query('.//GDPR_Compliant_Signup_Form').value('(.)[1]', 'varchar(500)') [GDPR_Compliant_Signup_Form]
	,C.M.query('.//May_18_Status').value('(.)[1]', 'varchar(500)') [May_18_Status]
	,C.M.query('.//Fiscal_Year').value('(.)[1]', 'varchar(500)') [Fiscal_Year]
	,C.M.query('.//RPO').value('(.)[1]', 'varchar(500)') [RPO]
	,C.M.query('.//Grant_Manager').value('(.)[1]', 'varchar(500)') [Grant_Manager]
	,C.M.query('.//Tag').value('(.)[1]', 'varchar(500)') [Tag]
	,C.M.query('.//CfSJ_Campaign_Version').value('(.)[1]', 'varchar(500)') [CfSJ_Campaign_Version]
	,C.M.query('.//Mailing_Address').value('(.)[1]', 'varchar(500)') [Mailing_Address]
	,C.M.query('.//Zip_Country_Code').value('(.)[1]', 'varchar(100)') [Zip_Country_Code]
	,C.M.query('.//C/O').value('(.)[1]', 'varchar(100)') [C/O]
	,C.M.query('.//Nominees_YES_Full_Name').value('(.)[1]', 'varchar(250)') [Nominees_YES_Full_Name]
	,C.M.query('.//Nominess_NO_Full_Name').value('(.)[1]', 'varchar(250)') [Nominess_NO_Full_Name]
	,C.M.query('.//Nominess_ALL_Full_Name').value('(.)[1]', 'varchar(250)') [Nominess_ALL_Full_Name]
	--,C.M.query('.//Candidate_Full_Name').value('(.)[1]', 'varchar(500)') [Candidate_Full_Name]
	,C.M.query('.//Subscribe_to').value('(.)[1]', 'varchar(500)') [Subscribe_to]
	,C.M.query('.//Tell_us_more_about_your_interests').value('(.)[1]', 'varchar(500)') [Tell_us_more_about_your_interests]
	,C.M.query('.//Ford_Foundation').value('(.)[1]', 'varchar(500)') [Ford_Foundation]
	,C.M.query('.//Grantees_by_Regions').value('(.)[1]', 'varchar(500)') [Grantees_by_Regions]
	,C.M.query('.//Grantees_by_Program').value('(.)[1]', 'varchar(500)') [Grantees_by_Program]
	,C.M.query('.//Int155b14559d').value('(.)[1]', 'varchar(500)') [Int155b14559d]
	,C.M.query('.//MEMBER_RATING').value('(.)[1]', 'varchar(500)') [MEMBER_RATING]
	,C.M.query('.//OPTIN_TIME').value('(.)[1]', 'varchar(500)') [OPTIN_TIME]
	,C.M.query('.//OPTIN_IP').value('(.)[1]', 'varchar(500)') [OPTIN_IP]
	,C.M.query('.//CONFIRM_TIME').value('(.)[1]', 'varchar(500)') [CONFIRM_TIME]
	,C.M.query('.//CONFIRM_IP').value('(.)[1]', 'varchar(500)') [CONFIRM_IP]
	,C.M.query('.//LATITUDE').value('(.)[1]', 'varchar(500)') [LATITUDE]
	,C.M.query('.//LONGITUDE').value('(.)[1]', 'varchar(500)') [LONGITUDE]
	,C.M.query('.//GMTOFF').value('(.)[1]', 'varchar(500)') [GMTOFF]
	,C.M.query('.//DSTOFF').value('(.)[1]', 'varchar(500)') [DSTOFF]
	,C.M.query('.//TIMEZONE').value('(.)[1]', 'varchar(500)') [TIMEZONE]
	,C.M.query('.//CC').value('(.)[1]', 'varchar(500)') [CC]
	,C.M.query('.//REGION1').value('(.)[1]', 'varchar(500)') [REGION1]
	,C.M.query('.//LAST_CHANGED').value('(.)[1]', 'varchar(500)') [LAST_CHANGED]
	,C.M.query('.//LEID').value('(.)[1]', 'varchar(500)') [LEID]
	,C.M.query('.//EUID').value('(.)[1]', 'varchar(500)') [EUID]
	,C.M.query('.//NOTES').value('(.)[1]', 'varchar(500)') [NOTES]
	,C.M.query('.//TAGS').value('(.)[1]', 'varchar(8000)') [TAGS]

   FROM @MailChimpRespXml.nodes('/EventResponse/MailChimp') C(M)

			-- SCRIPT 1
   		


		TRUNCATE TABLE Stg_TblContacts		
		INSERT INTO Stg_TblContacts(Prefix,
					Firstname,Lastname,PrimaryEmail,JobTitle,Organization,Notes,[Source],Tag,IsActive,TwitterUsername,Telephone,Cellphone,MiddleInitial,SubscribeTo)
		SELECT DISTINCT LEFT([Prefix],20),[First Name],[Last Name],[EmailAddress],[Job Title],Organization,NOTES,[Sources],[TAGS],1 IsActive,[Twitter username (Optional)],[Telephone],[Cell Phone],[Middle Initial],[Subscribe to] 
						FROM TblMailChimpSubscribedContacts T
		
		--SCRIPT 4

		--SCRIPT 5
		update Stg_tblContacts set Tag=null --where tag ='' is not null

		UPDATE C SET C.Tag= CASE WHEN ISNULL(S.[Country (Optional)],'')='' THEN ISNULL(C.Tag,'') ELSE ISNULL(C.Tag,'') +';'+S.[Country (Optional)] END 
		from Stg_tblContacts c inner join
		TblMailChimpSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
		where S.[Country (Optional)] !='' 

		UPDATE C SET C.Tag= CASE WHEN ISNULL(S.[State],'')='' THEN ISNULL(C.Tag,'') ELSE ISNULL(C.Tag,'') +';'+S.[State] END 
		from Stg_tblContacts c inner join
		TblMailChimpSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
		where S.[State] !='' 

		UPDATE C SET C.Tag= CASE WHEN ISNULL(S.City,'')='' THEN ISNULL(C.Tag,'') ELSE ISNULL(C.Tag,'') +';'+S.City END 
		from Stg_tblContacts c inner join
		TblMailChimpSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
		where S.City !='' 

		UPDATE C SET C.Tag= CASE WHEN ISNULL(S.[Tell us more about your interests],'')='' THEN ISNULL(C.Tag,'') ELSE ISNULL(C.Tag,'') +';'+S.[Tell us more about your interests] END 
		from Stg_tblContacts c inner join
		TblMailChimpSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
		where S.[Tell us more about your interests] !='' 

		UPDATE C SET C.Tag= CASE WHEN ISNULL(S.[Your field (Optional)],'')='' THEN ISNULL(C.Tag,'') ELSE ISNULL(C.Tag,'') +';'+S.[Your field (Optional)] END 
		from Stg_tblContacts c inner join
		TblMailChimpSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
		where S.[Your field (Optional)] !='' 

		--Grantees by Regions
		UPDATE C SET C.Tag= CASE WHEN ISNULL(S.[Grantees by Regions],'')='' THEN ISNULL(C.Tag,'') ELSE ISNULL(C.Tag,'') +';'+S.[Grantees by Regions] END 
		from Stg_tblContacts c inner join
		TblMailChimpSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
		where S.[Grantees by Regions] !='' 

		--Grantees by Program
		UPDATE C SET C.Tag= CASE WHEN ISNULL(S.[Grantees by Program],'')='' THEN ISNULL(C.Tag,'') ELSE ISNULL(C.Tag,'') +';'+S.[Grantees by Program] END 
		from Stg_tblContacts c inner join
		TblMailChimpSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
		where S.[Grantees by Program] !='' 

		 Update Stg_tblContacts set Tag=REPLACE(Tag,'"','')
		 Update Stg_tblContacts set JobTitle=REPLACE(JobTitle,'"','')
 
		UPDATE CM SET CM.FordfoundationOwnerEmail = K.FFContact FROM(
		SELECT S.EMailAddress,
		CASE WHEN ISNULL(S.RPO,'') ='' THEN CASE  ISNULL(S.[Grant Manager],'') WHEN '' THEN '' ELSE S.[Grant Manager]  END
		ELSE S.RPO+';'+S.[Grant Manager] END FFContact FROM 
		Stg_tblContacts c 
		inner join TblMailChimpSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail) K 
		INNER JOIN Stg_tblContacts CM ON CM.PrimaryEmail=K.EmailAddress where K.FFContact !=''

		UPDATE C SET C.JobTitle = S.[Job Title]  FROM Stg_tblContacts c 
		inner join TblMailChimpSubscribedContacts S on s.[EmailAddress]=c.PrimaryEmail
		where S.[Job Title] !=''

		Update Stg_tblContacts set Tag=REPLACE(Tag,',',';')
		update Stg_TblContacts set Firstname=rtrim(ltrim(Replace(Firstname,'"',''))) where CHARINDEX('"',firstname) > =1
		update Stg_TblContacts set Lastname=rtrim(ltrim(Replace(Lastname,'"',''))) where CHARINDEX('"',Lastname) > =1
		update Stg_TblContacts set Lastname=rtrim(ltrim(Replace(Lastname,Char(13),''))) where CHARINDEX(Char(13),Lastname) > =1
		update Stg_TblContacts set Lastname=rtrim(ltrim(Replace(Firstname,Char(13),''))) where CHARINDEX(Char(13),Firstname) > =1
		update Stg_TblContacts set tag= SUBSTRING(tag,2,LEN(tag)) where CHARINDEX(';',tag)=1
		
		--SCRIPT 6
		
				SELECT FirstName,LastName,[EmailAddress],Organization  INTO #TempContacts FROM (
				SELECT FirstName,LastName,PrimaryEmail [EmailAddress],Organization from Stg_TblContacts				
				union
				SELECT  FirstName,LastName,PrimaryEmail [EmailAddress],Organization from TblContacts
				union 
				SELECT  FirstName,LastName,SecondaryEmail [EmailAddress],Organization from TblContacts where SecondaryEmail is not null
				union 
				SELECT  FirstName,LastName,ThirdEmail [EmailAddress],Organization from TblContacts where ThirdEmail is not null
			)K


			SELECT DISTINCT  T.[First Name]FirstName,T.[Last Name]LastName,t.[EmailAddress]Email,t.Organization,
			SlNo=ROW_NUMBER() OVER(PARTITION BY T.[First Name],T.[Last Name],t.Organization ORDER BY T.[First Name],T.[Last Name],t.Organization)
			INTO #DuplicateContacts
						FROM TblMailChimpSubscribedContacts  T 
						INNER JOIN #TempContacts C on C.[EmailAddress]=T.[EmailAddress] Inner join (
						SELECT [First Name],[Last Name],Organization FROM TblMailChimpSubscribedContacts
						GROUP BY [First Name],[Last Name],Organization HAVING COUNT(*)>1 ) D
						ON ISNULL(D.[First Name],'')=ISNULL(T.[First Name],'') 
						AND ISNULL(d.[Last Name],'')=ISNULL(t.[Last Name],'') and d.Organization=t.Organization
						WHERE ISNULL(T.[First Name],'') !='' and ISNULL(T.[Last Name],'')!=''
						AND ISNULL(t.organization,'')!=''
						ORDER BY t.[First Name],t.[Last Name], SlNo


			SELECT Firstname,Lastname,[1] as PrimaryEmail,[2] as SecondaryEmail,ISNULL([3],'') as ThirdEmail,
			Organization,0 As SecContactId,0 as ThirdContactId INTO #Second_thirdMail 
			FROM (
			SELECT firstname,lastname,SlNo,Email,Organization from #DuplicateContacts
			) t
			PIVOT(
			MAX(Email)
			FOR SlNo in([1],[2],[3],[4]) 
			) AS L

			--select * from #Second_thirdMail

			Update C Set C.SecondaryEmail=s.SecondaryEmail,
			c.ThirdEmail=s.ThirdEmail
			from #Second_thirdMail S 
			inner join Stg_TblContacts C 
			On S.PrimaryEmail=C.PrimaryEmail

			Update Stg_TblContacts set IsDelete=1
			where PrimaryEmail in (select SecondaryEmail from #Second_thirdMail)

			Update Stg_TblContacts set IsDelete=1
			where PrimaryEmail in (select ThirdEmail from #Second_thirdMail)
		   --SCRIPT 7
INSERT INTO TblContacts(Prefix,Firstname,Lastname,VIP,PrimaryEmail,SecondaryEmail,ThirdEmail,AssistantEmail,Telephone,Cellphone,JobTitle
		,Organization,FordfoundationOwnerEmail,Notes,Source,Tag,IsActive,Delete_at,Unsubscribe,GDPRCompliant,TwitterUsername,SubscribeTo)

SELECT DISTINCT Prefix,Firstname,Lastname,VIP,PrimaryEmail,SecondaryEmail,ThirdEmail,AssistantEmail,Telephone,Cellphone,JobTitle
			,Organization,FordfoundationOwnerEmail,Notes,Source,Tag,IsActive,Delete_at,Unsubscribe,GDPRCompliant,TwitterUsername,SubscribeTo from Stg_TblContacts T
			WHERE ISNULL(IsDelete,0)=0
			AND NOT EXISTS (SELECT 1 from #TempTblContacts C where c.EmailAddress=T.PrimaryEmail)		
			AND PrimaryEmail NOT IN  ('event@fordfoundation.org', 'events@fordfoundation.org', 'rsvp@fordfoundation.org', 'fordevent@fordfoundation.org', 'fordevents@fordfoundation.org', 'c.caronan@fordfoundation.org', 'k.hughes@fordfoundation.org')
	
			
   END

--END
--To check the attendees exist or not   - end
SET @returnVal='Success';
DROP table #TempTblContacts
  -- DROP TABLE #TempMailResp;
   END TRY   
BEGIN CATCH   
--set @returnVal= Error_Message() 
--print Error_Message()  
throw
END CATCH 
   END
GO



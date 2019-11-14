
DECLARE @PROCESSFILE AS NVARCHAR(500)

SET @PROCESSFILE ='\\ffgcp3320\backup\subscribed_members_export_027429d482.csv'
DECLARE  @SQLQuery AS NVARCHAR(1000)

		SET @SQLQuery='BULK INSERT TblSubscribedContacts  
		FROM '''+REPLACE(@PROCESSFILE,'''','''''')  +''''+char(10)+
		' WITH   
		(  FIRSTROW=2,
		FIELDTERMINATOR ='','',  
		ROWTERMINATOR =''0x0a''  
		);'
		--row delimiter \n is not working using 0x0a
		print @SQLQuery
		--DELETE FROM TblSubscribedContacts
		EXEC(@SQLQuery)

		
		UPDATE TblSubscribedContacts set Prefix=null where len(prefix)>10 
		
		INSERT INTO TblContacts(Prefix,
		Firstname,Lastname,PrimaryEmail,JobTitle,Organization,Notes,[Source],Tag,IsActive,TwitterUsername,Telephone,Cellphone
		)
		SELECT [Prefix],[First Name],[Last Name],[EmailAddress],
		[Job Title],Organization,NOTES,[Sources],[TAGS],1,[Twitter username (Optional)],[Telephone],[Cell Phone] 
		FROM TblSubscribedContacts T
		WHERE Not EXists (SELECT 1 from TblContacts C where c.PrimaryEmail=T.[EmailAddress])
		order by [First Name],[Last Name]

		--truncate table TblContacts

		select contactid from TblContacts order by 1 asc
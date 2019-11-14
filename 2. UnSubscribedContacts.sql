
DECLARE @PROCESSFILE AS NVARCHAR(500)

SET @PROCESSFILE ='\\ffgcp3320\backup\unsubscribed_members_export_027429d482.csv'
DECLARE  @SQLQuery AS NVARCHAR(1000)

		SET @SQLQuery='BULK INSERT TblUnSubscribedContacts  
		FROM '''+REPLACE(@PROCESSFILE,'''','''''')  +''''+char(10)+
		' WITH   
		(  FIRSTROW=2,
		FIELDTERMINATOR ='','',  
		ROWTERMINATOR =''0x0a''  
		);'
		--row delimiter \n is not working using 0x0a
		print @SQLQuery
		--DELETE FROM TblUnSubscribedContacts
		EXEC(@SQLQuery)
			UPDATE TblUnSubScribedContacts set Prefix=null where len(prefix)>10 
--	select * from TblUnSubscribedContacts
		INSERT INTO TblContacts(
		Firstname,Lastname,PrimaryEmail,JobTitle,Organization,Notes,[Source],Tag,IsActive,TwitterUsername,Telephone,Cellphone,Prefix)
		SELECT [FirstName],[LastName],[EmailAddress],[JobTitle],Organization,NOTES,[Sources],[TAGS],1,[Twitterusername(Optional)]
		,[Telephone],[CellPhone],[Prefix] FROM TblUnSubscribedContacts T
		WHERE Not EXists (SELECT 1 from TblContacts C where c.PrimaryEmail=T.[EmailAddress])

		UPDATE C SET C.Unsubscribe =1--,
			   --C.IsActive=0
		fROM TblUnSubscribedContacts U
		INNER JOIN TblContacts C ON C.PrimaryEmail=U.EmailAddress



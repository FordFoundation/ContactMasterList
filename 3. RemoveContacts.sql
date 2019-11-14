

DECLARE @PROCESSFILE AS NVARCHAR(500)

SET @PROCESSFILE ='\\ffgcp3320\backup\cleaned_members_export_027429d482.csv'
DECLARE  @SQLQuery AS NVARCHAR(1000)

		SET @SQLQuery='BULK INSERT TblRemovecontacts  
		FROM '''+REPLACE(@PROCESSFILE,'''','''''')  +''''+char(10)+
		' WITH   
		(  FIRSTROW=2,
		FIELDTERMINATOR ='','',  
		ROWTERMINATOR =''0x0a''  
		);'
		--row delimiter \n is not working using 0x0a
		print @SQLQuery
		--DELETE FROM TblRemovecontacts
		EXEC(@SQLQuery)
		
	
		UPDATE C SET 
			   C.IsActive=0
		fROM TblRemovecontacts U
		INNER JOIN TblContacts C ON C.PrimaryEmail=U.EmailAddress

		



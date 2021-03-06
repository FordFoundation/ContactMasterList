DECLARE @PROCESSFILE AS NVARCHAR(500)

SET @PROCESSFILE ='\\ffgcp3320\backup\EventBriteEvents.csv'
DECLARE  @SQLQuery AS NVARCHAR(1000)

		SET @SQLQuery='BULK INSERT TblEventBriteEventInfo  
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
		
UPDATE TblEventBriteEventInfo set eventName=Replace(eventName,'|',',') 



INSERT INTO TblEvents(EventName,EventBriteEventId)
SELECT distinct ltrim(Rtrim(EventName)),EventbriteEventId FROM TblEventBriteEventInfo EB
WHERE not exists(select 1 from TblEvents E WHERE E.EventName=EB.EventName)
Go


--Create Temp Table

CREATE TABLE #CSVFileTable(csvFileName VARCHAR(200));
CREATE TABLE #ImportCsv(
		[Order]	nvarchar(100),	
		FirstName	nvarchar(200),	
		LastName	nvarchar(200),	
		Email	nvarchar(200),	
		Quantity	nvarchar(200),	
		[Attendee Status]	nvarchar(200),	
		[Job Title]	nvarchar(200),	
		Company	nvarchar(200)
	)

CREATE TABLE #EventImportCsv(
		[Order]	nvarchar(100),	
		FirstName	nvarchar(200),	
		LastName	nvarchar(200),	
		Email	nvarchar(200),	
		Quantity	nvarchar(200),	
		[Attendee Status]	nvarchar(200),	
		[Job Title]	nvarchar(200),	
		Company	nvarchar(200),
		EventName nvarchar(200)
)

Create Table #Result
(	
	EventID nvarchar(25),
	NoOfRecords int
)
--drop table #CsvImportCsv
DECLARE @CSVFilePath as NVARCHAR(1000)
DECLARE @CSVFileName AS VARCHAR(100)
SET @CSVFilePath ='\\ffgcp3320\Backup'
DECLARE @SQLQuery AS NVARCHAR(2000)
DECLARE @FileCmd as nvarchar(2000)
DECLARE @ArchiveFile as NVARCHAR(200)
DECLARE @ArchiveFolder as NVARCHAR(200)
SET @ArchiveFolder='\\ffgcp3320\Backup\CSVFiles'
DECLARE @KeyFileName AS VARCHAR(100)
DECLARE @PROCESSFILE AS VARCHAR(100)
DECLARE @EventName AS NVARCHAR(200)
 SET @SQLQuery='dir /B "'+ @CSVFilePath +'"'
INSERT INTO #CSVFileTable
EXEC xp_cmdshell @SQLQuery;
--EXEC xp_cmdshell 'dir /B "\\ffgcp3320\backup"';
--Delete non csv files and folder
DELETE FROM #CSVFileTable WHERE csvFileName IS NULL OR CHARINDEX('.csv',csvFileName,1)=0


--Loop each file in folder
WHILE(SELECT COUNT(csvFileName) FROM #CSVFileTable ) > 0
BEGIN
	SELECT TOP 1 @CSVFileName=csvFileName FROM #CSVFileTable
	--PRINT @CSVFileName
	SET @KeyFileName=Substring(@CSVFileName,0,CHARINDEX('_',@CSVFileName,1)) 
	--print @KeyFileName	
	SELECT @EventName=EventName FROM TblEventBriteEventInfo where EventbriteEventId=@KeyFileName
		print @EventName			 
	BEGIN
			--PRINT @CSVFileName			
			SET @PROCESSFILE=@CSVFilePath+'\'+@CSVFileName
			SET @SQLQuery='BULK INSERT #ImportCsv  
			   FROM '''+REPLACE(@PROCESSFILE,'''','''''')  +''''+char(10)+
			  ' WITH   
				  (  FIRSTROW=2,
					 FIELDTERMINATOR =''","'',  
					 ROWTERMINATOR =''0x0a''  
				  );'
				  --row delimiter \n is not working using 0x0a
				  print @SQLQuery
				
				 exec(@SQLQuery)
				 Insert into #EventImportCsv
				 SELECT [Order],FirstName,LastName,Email,Quantity,[Attendee Status],[Job Title],Company, @EventName FROM #ImportCsv

				 Insert Into #Result
				 Select @KeyFileName,@@ROWCOUNT

				 DELETE FROM #ImportCsv

	END
	

			DELETE FROM #CSVFileTable WHERE csvFileName=@CSVFileName
			--Rename the file
			SELECT @ArchiveFile=SUBSTRING(@CSVFileName,0,CHARINDEX('.',@CSVFileName)) +'_'+REPLACE(CONVERT(VARCHAR, GETDATE(),101),'/','')+SUBSTRING(@CSVFileName,CHARINDEX('.',@CSVFileName),Len(@CSVFileName)-CHARINDEX('.',@CSVFileName)+1)
			SET @FileCmd='Rename '+@CSVFilePath +'\' +@CSVFileName +CHAR(32) +@ArchiveFile
			--\\ffgcp3320\backup\cleaned_segment_export_c9f5cd37e8.csv cleaned_segment_export_c9f5cd37e8_DDMMYYYY.csv'
			print @FileCmd
			EXEC xp_cmdshell @FileCmd

			--Move the file to archive folder
			SET @FileCmd='MOVE /Y "'+@CSVFilePath+'\'+@ArchiveFile+'" '+CHAR(32)+' "' +@ArchiveFolder+'\"'
			--\\ffgcp3320\backup\Arch\cleaned_segment_export_c9f5cd37e8.csv" "\\ffgcp3320\backup\"'
			print @FileCmd
			EXEC xp_cmdshell @FileCmd
END

		DROP TABLE #CSVFileTable
		drop table #ImportCsv
			   		
INSERT INTO TblEventBriteBulkImportCsv([Order],FirstName,LastName,Email,Quantity,[Attendee Status],[Job Title],[Company],EventName)
Select [Order],FirstName,LastName,Email,Quantity,[Attendee Status],[Job Title],[Company]  from #CsvEventImportCsv



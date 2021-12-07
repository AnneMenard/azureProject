create Master Key;


CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential
WITH
	IDENTITY = 'movies',
	SECRET = 'sw8/XNb+etpHPNnUBY2oCXg0VRPI6+zYyIYNRX11IDUzSWBYwx5LKQ844E4JMQsnJlcBrUq6cb2dYztbakoAIQ=='
;

CREATE EXTERNAL DATA SOURCE StorageCurated
WITH
(
	TYPE = HADOOP ,
	LOCATION = 'abfss://curated@moviescurated2022.dfs.core.windows.net/',
	CREDENTIAL = AzureStorageCredential
);

CREATE EXTERNAL FILE FORMAT TextFileFormat
WITH
(
	FORMAT_TYPE = Parquet
);

DROP EXTERNAL TABLE EXT_Movies
CREATE EXTERNAL TABLE EXT_Movies(
MovieID varchar(100),MovieTitle varchar(100), Category varchar(50),ReleaseDate varchar(100),CreatedDate varchar(100), Source varchar(100), Active int
)
WITH (LOCATION='/movies/',
DATA_SOURCE = StorageCurated,
FILE_FORMAT = TextFileFormat,
REJECT_TYPE = VALUE,
REJECT_VALUE = 0
);


select * from EXT_Movies;

Create Schema DWInternal;

--DROP TABLE INT_Movies
Create Table INT_Movies WITH (DISTRIBUTION = HASH(MovieID)) AS SELECT * FROM EXT_Movies;

Select * from INT_Movies

--DROP TABLE INT_Movies2
select * 
INTO INT_Movies2
FROM EXT_Movies
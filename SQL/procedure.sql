CREATE PROC [dbo].[UpdateMovies] AS

BEGIN

	Declare @MaxDate Datetime
	Set @MaxDate = (Select Max(CreatedDate) From EXT_Movies);
	select count(MovieId) From EXT_Movies where CreatedDate = @MaxDate;
	UPDATE INT_Movies SET Active=0 where MovieID in (select MovieId from EXT_Movies where CreatedDate = @MaxDate)

	INSERT INTO INT_Movies
	SELECT
	MovieID,
	MovieTitle,
	Category,

	CASE WHEN Source = 'WestHighway' Then Convert(datetime, ReleaseDate, 101)
		 WHEN Source = 'BigBrother' Then Convert(datetime, ReleaseDate, 101)
		 WHEN Source = 'OpenGate' Then Convert(datetime, left(ReleaseDate, 19))
		 WHEN Source = 'WestHighway2017' Then Convert(datetime, left(ReleaseDate, 19))
		 END AS ReleaseDate,
		 Source,
		 CreatedDate,
		 1 AS Active
		 FROM EXT_Movies
		 where CreatedDate = @MaxDate
END
GO
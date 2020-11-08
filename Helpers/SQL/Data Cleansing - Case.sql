CREATE FUNCTION dbo.Capitalize(@String NVARCHAR(300))
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @pos INT
    SELECT @String = STUFF(LOWER(@String),1,1,UPPER(LEFT(@String,1))) COLLATE Latin1_General_Bin
        ,@pos = PATINDEX('%[^A-Za-z''][a-z]%',@String COLLATE Latin1_General_Bin)

    WHILE @pos > 0
        SELECT @String   = STUFF(@String,@pos,2,UPPER(SUBSTRING(@String,@pos,2))) COLLATE Latin1_General_Bin
            ,@pos = PATINDEX('%[^A-Za-z''][a-z]%',@String COLLATE Latin1_General_Bin)

    RETURN LEFT(@String,100);
END
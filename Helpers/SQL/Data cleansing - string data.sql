CREATE FUNCTION StringCleanup (@String NVARCHAR(MAX))
RETURNS VARCHAR(100)
AS 
BEGIN 
    DECLARE @CleanString VARCHAR(100) 
    SET @CleanString = TRIM(@String)

    IF (@CleanString = '' OR @CleanString IS NULL) RETURN ''

    -- is character only
    IF PATINDEX('%[^a-zA-Z .,/\''"£§!@#$%^&*()<>?`~]%', @CleanString) = 0 RETURN @CleanString 
    
    -- remove multiple spaces
    -- remove wrong chars

    

    -- 

    RETURN LEFT(@CleanString,100)
END 
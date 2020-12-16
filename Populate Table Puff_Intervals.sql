SET NOCOUNT ON;

-- VARIABLES
DECLARE @current_Puff INT,
    @current_start DATETIME,
    @current_end DATETIME,
    @current_time_s FLOAT,
    @previous_Puff INT,
    @previous_start DATETIME,
    @previous_end DATETIME,
    @previous_time_s FLOAT,
    @difference_seconds INT,
    @counter INT;


-- DECLARE the cursor as a SELECT statement
DECLARE cursor_Puff CURSOR
FOR SELECT
    [Puff],
    [Date_Time],
    [Time__s_]
FROM dbo.[Puff]
ORDER BY [Date_Time], [Puff];


-- OPEN the cursor for reading
OPEN cursor_Puff;

-- Initialize the counter 
SELECT @counter = 0;

-- (Try to) get the first result from the cursor
FETCH NEXT FROM cursor_Puff 
    INTO @current_Puff, @current_start, @current_time_s;

-- Loop through the cursor results
-- @@FETCH_STATUS is 0 when the previous FETCH returned something
WHILE @@FETCH_STATUS = 0
    BEGIN
    -- PRINT 'Current Puff: ' + CAST(@current_Puff AS varchar);
    -- PRINT 'Current Start: ' + CAST(@current_start AS varchar);
    -- PRINT 'Current Time in Seconds: ' + CAST(@current_time_s AS varchar);

    -- Get the current end time
    SELECT @current_end = DATEADD(SECOND, @current_time_s, @current_start)
    -- PRINT 'Current End: ' + CAST(@current_end AS varchar);

    -- Insert rows into table 'Puff_interval'
    INSERT INTO [dbo].[Puff_interval]
        ( [Id], [End_Time], [Start_Time] )
    VALUES
        (@current_Puff, @current_end, @current_start)

    IF (@previous_start IS NOT NULL)
    BEGIN
        SET @difference_seconds = DATEDIFF(SECOND, @current_start, @previous_start)
        -- PRINT 'Difference in Seconds: ' + CAST(@difference_seconds AS varchar);

        UPDATE [dbo].[Puff_Interval]
        SET
            [Interval] = ABS( @difference_seconds ),
            [Previous_Start] = @previous_start
        WHERE 
            [Id] = @current_Puff
    END

    -- Save the current row's values as @previous for use in the next run
    SELECT @previous_Puff = @current_Puff
    SELECT @previous_start = @current_start
    SELECT @previous_time_s = @current_time_s

    -- Increment the counter
    SELECT @counter = @counter + 1;
    IF (@counter % 420 = 0)
        PRINT 'Rows inserted: ' + CAST(@counter AS varchar);

    FETCH NEXT FROM cursor_Puff 
        INTO @current_Puff, @current_start, @current_time_s;
END;

PRINT 'Total rows inserted: ' + CAST(@counter AS varchar);


-- CLOSE and DEALLOCATE the cursor to clean up
CLOSE cursor_Puff;
DEALLOCATE cursor_Puff;
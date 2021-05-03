-- =============================================
-- Author:		Carlos Valdes
-- Create date: 12/1/2007
-- Description:	Converts Inches to Imperial
-- =============================================
CREATE FUNCTION [dbo].[InchesToFeet]
(
	@Inches float
)
RETURNS nvarchar(10)
AS
BEGIN
	
	DECLARE @a INT
	DECLARE @ImperialResult nvarchar(20)
		--SET @ImperialResult = 0
	DECLARE @FinalRESULT nvarchar(20)


		SET @A = @Inches * 100000
	DECLARE @JustInches INT
		SET @JustInches = isnull(CONVERT(INT,@Inches),0)
	DECLARE @B INT 
		SET @B = @JustInches * 100000
	DECLARE @C INT 
		SET @C = @A - @B
	DECLARE @FEET INT
		SET @FEET = 0
	DECLARE @RemainedINCHES int
		SET @RemainedINCHES = 0
	
	IF @JustInches >= 12
		BEGIN
			SET @FEET = @JustINCHES / 12
			SET @ImperialResult = rtrim(ltrim(CONVERT(nvarchar(10),@FEET ))) + ''''
			SET @RemainedINCHES = @JustINCHES % 12 
		  END
	ELSE 
		SET @RemainedINCHES = @JustINCHES

	IF @RemainedINCHES > 0 AND @C <> 0
		SET @ImperialResult = isnull(nullif(rtrim(ltrim(@ImperialResult)),'0'),'') + rtrim(ltrim(CONVERT(nvarchar(10),@RemainedINCHES ))) 
	ELSE 
		IF (@C = 0) AND (@RemainedINCHES = 0)
			SET @FinalRESULT = @ImperialResult 
	IF (@C = 0) AND (@RemainedINCHES > 0)
		SET @FinalRESULT = isnull(nullif(rtrim(ltrim(@ImperialResult)),'0'),'') + rtrim(ltrim(CONVERT(nvarchar(10),@RemainedINCHES ))) + '"'
	ELSE 
		BEGIN
			DECLARE @TempUP INT 
				SET @TempUP = @C / 6250
			DECLARE @FloatC float
				SET @FloatC = @C
			 IF @TempUP = 0 
				BEGIN
				IF (@FloatC / 6250 >= 0.5)
					SET @FinalRESULT = isnull(nullif(rtrim(ltrim(@ImperialResult)),'0'),'') + ' 1/16' + '"'
				ELSE 
					SET @FinalRESULT = CASE WHEN nullif(rtrim(ltrim(@ImperialResult)),'0') is null 
											THEN '0"' 
											ELSE CASE WHEN nullif(@FEET,0) is null THEN @ImperialResult + '"' 
																					ELSE @ImperialResult 
												  END
										END
				END
		     ELSE
					BEGIN
						IF ((@FloatC/6250)-@TempUP > 0.5) 
							SET @TempUP = @TempUP + 1
						DECLARE @TempLow INT
							SET @TempLow = 16
						  WHILE (@TempUP % 2 = 0)
							BEGIN
								SET @TempLow = @TempLow/2
								SET @TempUP = @TempUP/2
							  END
						SET @FinalRESULT = isnull(nullif(@ImperialResult,'0'),'') + ' ' + rtrim(ltrim(CONVERT(nvarchar(10),@TempUP )))+'/'+rtrim(ltrim(CONVERT(nvarchar(10),@TempLow )))+ '"'
					  END
		END 

	RETURN @FinalRESULT

END

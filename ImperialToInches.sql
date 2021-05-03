CREATE FUNCTION [dbo].[ImperialToInches]
(
	@ImperialInput VARCHAR(50)
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here

	DECLARE @Result VARCHAR(50);
	DECLARE @myFeet as varchar(50);
	DECLARE @myInch as varchar(50);
	
	set @ImperialInput = RTRIM(ltrim(@ImperialInput));
	if charindex(' ',@ImperialInput) > 0 
		begin
		  set @myFeet=  SUBSTRING(@ImperialInput,1,charindex(' ',@ImperialInput))
		end
		  else set @myfeet = @imperialinput
	set @MyFeet = REPLACE(@MyFeet,'''' ,'');
	-- SEPARATE FEET AND INCH SECTION
	-- GET THE FEET SECTION

	--GET THE INCH SECTION	
	if charindex(' ',@ImperialInput) > 0 
	begin
	   set @myInch = substring(@ImperialInput,charindex(' ',@ImperialInput)+1, len(@ImperialInput)-charindex(' ',@ImperialInput))
	end   else
	   set @myinch = '0"'

   --set @myInch = REPLACE(@myInch,'''' ,'');
	set @myInch = REPLACE(@myInch,'"' ,'');
	set @Result = cast(@myFeet as float) * 12 + CAST( @myInch as float);
	
	Return @Result;
END

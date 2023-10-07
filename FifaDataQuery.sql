-- Create a temporary column that stores the first substring from the playerUrl
alter table FifaData.dbo.FIFA2021DATA
add TempCol Nvarchar(255);


-- Reversing the string and counting manually counting from the number of strings before the name 
-- Which is where the substring will start extracting from
-- Updating the created column with the substring data
update FifaData.dbo.FIFA2021DATA
set TempCol = substring(reverse(playerUrl), 9, LEN(playerUrl))
from FifaData.dbo.FIFA2021DATA


-- Create the fullname column that stores the second substring from the TempCol 
-- Which is the names of the players
alter table FifaData.dbo.FIFA2021DATA
add Fullname Nvarchar(255);


-- Update the fullname column with string extracted from the TempCol
update FifaData.dbo.FIFA2021DATA
set Fullname = reverse(substring((TempCol), 1, CHARINDEX('/', TempCol)-1)) 
from FifaData.dbo.FIFA2021DATA

-- Droppping uneccessary columns
alter table FifaData.dbo.FIFA2021DATA
drop column TempCol, TempCol2, Name, LongName, photoUrl, playerUrl


-- Replace the '-' with space and capitalize the names
update FifaData.dbo.FIFA2021DATA
set Fullname = upper(replace(Fullname, '-', ' '))
from FifaData.dbo.FIFA2021DATA



alter table FifaData.dbo.FIFA2021DATA
add POT_ DECIMAL(5, 2), BOV_ DECIMAL(5, 2);

alter table FifaData.dbo.FIFA2021DATA
drop column  [â†“OVA];


update FifaData.dbo.FIFA2021DATA
set BOV_ = BOV/100.0
from FifaData.dbo.FIFA2021DATA

select * from FifaData.dbo.FIFA2021DATA
where OVA = 0



SELECT Height,
    CASE 
        -- If the value contains 'cm', convert cm to inches (1 cm = 0.393701 inches)
        WHEN Height LIKE '%cm' THEN CAST(REPLACE(Height, 'cm', '') AS FLOAT) * 0.393701
        -- If the value contains feet and inches (e.g., 6'7"), convert to inches (1 foot = 12 inches)
        WHEN Height LIKE '%"%' THEN 
            CAST(LEFT(Height, 1) AS FLOAT) * 12 + 
            CAST(SUBSTRING(Height, len(Height) - 1, 1) AS FLOAT)
        -- For other cases, assume the value is already in inches
        ELSE CAST(Height AS FLOAT)
    END AS HeightInInches
FROM FifaData.dbo.FIFA2021DATA

-- Create new column namely Height(Inch)
alter table FifaData.dbo.FIFA2021DATA
add Height_In_Inch FLOAT;

-- Convert Height to inches and update the table
update FifaData.dbo.FIFA2021DATA
set Height_In_Inch = CASE 
						-- If the value contains 'cm', convert cm to inches (1 cm = 0.393701 inches)
						WHEN Height LIKE '%cm' THEN CAST(REPLACE(Height, 'cm', '') AS FLOAT) * 0.393701
						-- If the value contains feet and inches (e.g., 6'7"), convert to inches (1 foot = 12 inches)
						WHEN Height LIKE '%"%' THEN CAST(LEFT(Height, 1) AS FLOAT) * 12 + CAST(SUBSTRING(Height, len(Height) - 1, 1) AS FLOAT)
						-- For other cases, assume the value is already in inches
						ELSE CAST(Height AS FLOAT)
					END
from FifaData.dbo.FIFA2021DATA


-- Create new column namely Weight(lbs)
alter table FifaData.dbo.FIFA2021DATA
add Weight_In_Lbs FLOAT;


-- Convert Weight to Lbs and update the table
update FifaData.dbo.FIFA2021DATA
set Weight_In_Lbs = CASE 
						-- If the value contains 'kg', convert kg to lbs (1 kg = 2.20462 pounds)
						WHEN Weight LIKE '%kg' THEN CAST(REPLACE(Weight, 'kg', '') AS FLOAT) * 2.20462
						-- If the value contains lbs, remove the appended 'lbs' and convert to float
						WHEN Weight LIKE '%lbs' THEN CAST(REPLACE(Weight, 'lbs', '') AS FLOAT)
						-- For other cases, assume the value is already in lbs
						ELSE CAST(Weight AS FLOAT)
					END
from FifaData.dbo.FIFA2021DATA


-- Drop the initial weight and height columns
alter table FifaData.dbo.FIFA2021DATA
drop column  POT, BOV



-- Working on the value, Wage, Release Clause Columns

-- Adding new columns to represent them
alter table FifaData.dbo.FIFA2021DATA
add ValueIN$ float, WageIN$ float, Release_ClauseIN$ float

-- Updating the newly created columns with the refined values in the similar columns
update FifaData.dbo.FIFA2021DATA
set ValueIN$ = 
			case
				-- Eliminate "â‚¬", "M", convert to million then convert to $ using $1.183 per euro xchnage rate
				when Value like '%â‚¬%' and Value like '%M%' then (cast(replace(replace(Value, 'â‚¬', ''), 'M', '') as float) * 1000000) * 1.183
				-- Eliminate "â‚¬", "K", convert to thousand then convert to $ using $1.183 per euro xchnage rate
				when Value like '%â‚¬%' and Value like '%K%' then (cast(replace(replace(Value, 'â‚¬', ''), 'K', '') as float) * 1000) * 1.183
				-- Eliminate "â‚¬", convert to float then convert to $ using $1.183 per euro xchnage rate
				else cast(replace(Value, 'â‚¬', '') as float) * 1.183
			end
from FifaData.dbo.FIFA2021DATA


update FifaData.dbo.FIFA2021DATA
set ValueIN$ = 
			case
				-- Eliminate "â‚¬", "M", convert to million then convert to $ using $1.183 per euro xchnage rate
				when Value like '%â‚¬%' and Value like '%M%' then (cast(replace(replace(Value, 'â‚¬', ''), 'M', '') as float) * 1000000) * 1.183
				-- Eliminate "â‚¬", "K", convert to thousand then convert to $ using $1.183 per euro xchnage rate
				when Value like '%â‚¬%' and Value like '%K%' then (cast(replace(replace(Value, 'â‚¬', ''), 'K', '') as float) * 1000) * 1.183
				-- Eliminate "â‚¬", convert to float then convert to $ using $1.183 per euro xchnage rate
				else cast(replace(Value, 'â‚¬', '') as float) * 1.183
			end,
	WageIN$ = 
			case
				-- Eliminate "â‚¬", "M", convert to million then convert to $ using $1.183 per euro xchnage rate
				when Wage like '%â‚¬%' and Wage like '%M%' then (cast(replace(replace(Wage, 'â‚¬', ''), 'M', '') as float) * 1000000) * 1.183
				-- Eliminate "â‚¬", "K", convert to thousand then convert to $ using $1.183 per euro xchnage rate
				when Wage like '%â‚¬%' and Wage like '%K%' then (cast(replace(replace(Wage, 'â‚¬', ''), 'K', '') as float) * 1000) * 1.183
				-- Eliminate "â‚¬", convert to float then convert to $ using $1.183 per euro xchnage rate
				else cast(replace(Wage, 'â‚¬', '') as float) * 1.183
			end,
	Release_ClauseIN$ = 
			case
				-- Eliminate "â‚¬", "M", convert to million then convert to $ using $1.183 per euro xchnage rate
				when [Release Clause] like '%â‚¬%' and [Release Clause] like '%M%' then (cast(replace(replace([Release Clause], 'â‚¬', ''), 'M', '') as float) * 1000000) * 1.183
				-- Eliminate "â‚¬", "K", convert to thousand then convert to $ using $1.183 per euro xchnage rate
				when [Release Clause] like '%â‚¬%' and [Release Clause] like '%K%' then (cast(replace(replace([Release Clause], 'â‚¬', ''), 'K', '') as float) * 1000) * 1.183
				-- Eliminate "â‚¬", convert to float then convert to $ using $1.183 per euro xchnage rate
				else cast(replace([Release Clause], 'â‚¬', '') as float) * 1.183
			end
from FifaData.dbo.FIFA2021DATA


-- Creating the Contract status column
alter table FifaData.dbo.FIFA2021DATA
add ContractStatus nvarchar(255)

-- Updating the contract status column with the Contract column
update FifaData.dbo.FIFA2021DATA
set ContractStatus = 
					case
						when Contract like '%Free%' then Contract
						when Contract like '%Loan%' then 'On Loan'
						else 'On Contract'
					end
from FifaData.dbo.FIFA2021DATA


--Creating the ContractStartDate column and the ContractEndDate column
alter table FifaData.dbo.FIFA2021DATA
add ContractStartDate date, ContractEndDate nvarchar(255)


-- Updating the ContractStartDate column using the Joined column
update FifaData.dbo.FIFA2021DATA
set ContractStartDate = 
case
	when Contract not like '%Loan%' and Contract not like '%Free%' and isdate(Joined) = 1 then Joined
	else null
end
from FifaData.dbo.FIFA2021DATA

---- Updating the ContractEndDate column using the Joined column
update FifaData.dbo.FIFA2021DATA
set ContractEndDate = 
						case
							when Contract not like '%Loan%' and Contract not like '%Free%' 
							then parsename(replace(Contract, '~', '.'), 1)
							else null
						end
from FifaData.dbo.FIFA2021DATA


--Creating the LoanStartDate column and the LoanEndDate column
alter table FifaData.dbo.FIFA2021DATA
add LoanStartDate date, LoanEndDate date


-- Updating the LoanStartDate
update FifaData.dbo.FIFA2021DATA
set LoanStartDate = 
case
	when [Loan Date End] is not null and isdate(Joined) = 1 then Joined
	else null
end
from FifaData.dbo.FIFA2021DATA


-- Updating the LoanEndDate
update FifaData.dbo.FIFA2021DATA
set LoanEndDate = 
case
	when [Loan Date End] is not null and isdate([Loan Date End]) = 1 then [Loan Date End]
	else null
end
from FifaData.dbo.FIFA2021DATA



--Dropping columns
alter table FifaData.dbo.FIFA2021DATA
drop column Contract, Joined, [Loan Date End]


-- Creating new column for Club 
ALTER TABLE FifaData.dbo.FIFA2021DATA
ADD Club_ NVARCHAR(255) COLLATE SQL_Latin1_General_CP1_CI_AI;


-- Update the new club column with carefully formatted column
update FifaData.dbo.FIFA2021DATA
set Club_ = rtrim(ltrim(Club))
from  FifaData.dbo.FIFA2021DATA


-- Creating new columns for W/F, SM, IR
ALTER TABLE FifaData.dbo.FIFA2021DATA
ADD [W/F_] int, SM_ int, IR_ int


-- Updating the newly created columns
update FifaData.dbo.FIFA2021DATA
set [W/F_] = rtrim(ltrim(replace([W/F], 'â˜…', ''))),
	SM_ = rtrim(ltrim(replace(SM, 'â˜…', ''))),
	IR_ = rtrim(ltrim(replace(IR, 'â˜…', '')))
from  FifaData.dbo.FIFA2021DATA


--Dropping the intial columns
alter table FifaData.dbo.FIFA2021DATA
drop column [W/F], SM, IR
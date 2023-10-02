# MY DATA CLEANING PROJECT WITH SQL
Data Wrangling - also referred to as data cleaning, data remediation, or data munging - encompasses a range of processes aimed at converting raw data into more easily usable formats. This step is crucial for successful data analysis as it enables proper and efficient data examination, leading to informed business decisions.

## PROJECT OVERVIEW
In this project, I will meticulously detail every step I undertook to remediate a substantial FIFA 2021 dataset. This dataset was sourced from Kaggle and contains comprehensive records of over 18,000 players, featuring information such as ID, Name, Age, Country, Club, and numerous other attributes across 77 columns.
My motivation for selecting this dataset is to demonstrate my proficiency in working with poorly formatted variables, rectifying data inconsistencies to establish a well-structured dataset devoid of errors during subsequent analysis. My aim is to showcase my ability to transform exceedingly messy data into a clean and usable format.

## DATA PREPARATION
Prior to importing the dataset into Microsoft SQL Server Management Studio (MSSMS), I initially opened the dataset in Excel and saved it as an xlsx file. This saved file was then imported into MSSMS using the MSSMS Import and Export wizard.
DATA CLEANING PROCESS
The steps I executed during the data cleaning project within MSSMS encompassed the following phases:
- Data Discovery: Examining the dataset to gain insights into its structure, dimensions, and initial quality.
- Data Structuring: Organizing and structuring the data for analysis, including reformatting incorrectly formatted data types.
- Cleaning: Addressing data entry inconsistencies and irregularities, handling missing or blank values, identifying, and resolving duplicates, and other necessary data quality enhancements.
  
By meticulously following these steps, I aimed to transform the FIFA 2021 dataset into a clean, well-organized, and error-free resource, ready for in-depth analysis and valuable insights. This project serves as a testament to my data wrangling skills and my ability to turn challenging data into an asset for decision-making.

## LET’S GET STARTED!!!
You can take a look at the entire SQL code here on my GitHub profile.
I used Microsoft SQL Server Management Studio to develop this project.

## DATA DISCOVERY
```SQL
select * from FifaData.dbo.FIFA2021DATA
 ```
![image](https://github.com/Korede34/DATA-CLEANING-PROJECT-WITH-SQL/assets/64113122/492de8d7-3dc7-4f4c-98f5-a90d05db340b)


## COLUMN STANDARDIZATION
When I initially examined my dataset, I observed that both the 'NAME' and 'LONGNAME' columns contained inconsistent data. However, the 'PLAYERURL' column consistently held the full names of the players. I decided to extract this information from the 'PLAYERURL' column and create a new column named 'FULLNAME.' Consequently, I eliminated the previous two inconsistent columns.

Procedure:
Step 1: Adding a Temporary Column
Added a new column named "tempcol" to the existing table.
```SQL
-- Create a temporary column that stores the first substring from the playerUrl
alter table FifaData.dbo.FIFA2021DATA
add TempCol Nvarchar(255);
```

Wrote SQL queries to manipulate the data within "playerUrl" to extract the player names.
```SQL
-- Reversing the string and counting manually counting from the number of strings before the name 
-- Which is where the substring will start extracting from
-- Updating the created column with the substring data
update FifaData.dbo.FIFA2021DATA
set TempCol = substring(reverse(playerUrl), 9, LEN(playerUrl))
from FifaData.dbo.FIFA2021DATA
```

Step 2: Adding the Fullname Column
Added a new column named "Fullname" to the existing table.
```SQL
-- Create the fullname column that stores the second substring from the TempCol 
-- Which is the names of the players
alter table FifaData.dbo.FIFA2021DATA
add Fullname Nvarchar(255);
```

Wrote SQL queries to manipulate the data within "tempcol" to extract the player names.
```SQL
-- Update the fullname column with string extracted from the TempCol
update FifaData.dbo.FIFA2021DATA
set Fullname = reverse(substring((TempCol), 1, CHARINDEX('/', TempCol)-1)) 
from FifaData.dbo.FIFA2021DATA
```

Step 3: Dropping columns that are no more needed
```SQL
-- Droppping uneccessary columns
alter table FifaData.dbo.FIFA2021DATA
drop column TempCol, TempCol2, Name, LongName, photoUrl, playerUrl
```

Step 4: Replace the dashes in the name and capitalize them.
```SQL
-- Replace the '-' with space and capitalize the names
update FifaData.dbo.FIFA2021DATA
set Fullname = upper(replace(Fullname, '-', ' '))
from FifaData.dbo.FIFA2021DATA
```
Before:

![image](https://github.com/Korede34/DATA-CLEANING-PROJECT-WITH-SQL/assets/64113122/5edc30ca-8c2b-4e6d-9b89-c7243d8ac6ea)

After:

![image](https://github.com/Korede34/DATA-CLEANING-PROJECT-WITH-SQL/assets/64113122/f4587c5a-ad61-4de7-824a-9745b0d5b45b)


The dataset now has a standardized "fullname" column, and redundant columns "name" and "longname" have been removed.

## COLUMN NORMALIZATION
The primary goal was to scale various columns within our dataset to the percentage format, allowing for uniform representation of percentage-based data points.
For each relevant column, integers were converted into decimals by dividing the integer values by 100. This transformation ensured that the data, originally presented as whole numbers, were accurately scaled to fit within the percentage range of 0 to 100. 
The SQL statement 
```SQL 
set BOV_ = BOV/100.0
```
was utilized to convert integer values in the column `BOV`  and other relevant columns into decimal format, representing percentages.
The initial columns were dropped after and the new created columns replaced them.

Before:

![image](https://github.com/Korede34/DATA-CLEANING-PROJECT-WITH-SQL/assets/64113122/dc8f651b-0f10-49c5-af6c-a8550fed1626)

After:

![image](https://github.com/Korede34/DATA-CLEANING-PROJECT-WITH-SQL/assets/64113122/aff425cd-7c74-4fec-91e9-5e5c94148a5f)

## COLUMN UNIT STANDARDIZATION
The dataset contained heights recorded in both centimeter (cm) and in feet and inches (e.g., 6'7"), weights recorder in kilogram (kg) and pounds (lbs), leading to inconsistencies and potential misinterpretations. To ensure accuracy and uniformity, a crucial step was taken to convert all weight values to pounds, and all height values to inches.

### Height Conversion
Heights, presented in both centimeters (cm) and the feet and inches format (e.g., 6'7"), were standardized into inches (inch). For centimeters, the conversion factor of 1 cm equals approximately 0.393701 inches was applied. For the feet and inches format, the feet value was multiplied by 12 to convert it into inches, which was then added to the remaining inches.
The query:
```SQL
-- Convert Height to inches and update the table
update FifaData.dbo.FIFA2021DATA
set Height_In_Inch =
CASE 
    -- If the value contains 'cm', convert cm to inches (1 cm = 0.393701 inches)
    WHEN Height LIKE '%cm' THEN CAST(REPLACE(Height, 'cm', '') AS FLOAT) * 0.393701
    -- If the value contains feet and inches (e.g., 6'7"), convert to inches (1 foot = 12 inches)
    WHEN Height LIKE '%"%' THEN CAST(LEFT(Height, 1) AS FLOAT) * 12 + CAST(SUBSTRING(Height, len(Height) - 1, 1) AS FLOAT)
    -- For other cases, assume the value is already in inches
    ELSE CAST(Height AS FLOAT)
END
from FifaData.dbo.FIFA2021DATA
```

Before: This shows that we are having inconsistencies in the Height column

![image](https://github.com/Korede34/DATA-CLEANING-PROJECT-WITH-SQL/assets/64113122/aa194da1-a3a4-4950-bb1a-77a94ee0de27)


After: This inconsistencies as now been fixed and the column has been standardized

![image](https://github.com/Korede34/DATA-CLEANING-PROJECT-WITH-SQL/assets/64113122/6fd49541-9c2a-4759-90e6-e0cb19a76a5a)

### Weight Conversion
The weight data in the dataset shows a variety of formats, including 'kg' and 'lbs' appended to the numerical values (e.g., '23kg', '44lbs'). To ensure uniformity, a two-step approach was adopted.

#### Handling 'kg' Values:
   - Values with 'kg' units were first parsed to remove the 'kg' suffix.
   - The parsed values were then converted to floating-point numbers to ensure numerical accuracy.
   - These numerical values were subsequently converted into pounds using the conversion factor of 1 kilogram equals approximately 2.20462 pounds.

#### Handling 'lbs' Values:
   - Values with 'lbs' units were parsed to remove the 'lbs' suffix.
   - The parsed values were converted to floating-point numbers directly since the goal was to represent all weights in pounds uniformly.

The Query:
```SQL
-- Convert Weight to Lbs and update the table
update FifaData.dbo.FIFA2021DATA
set Weight_In_Lbs =
CASE 
    -- If the value contains 'kg', convert kg to lbs (1 kg = 2.20462 pounds)
    WHEN Weight LIKE '%kg' THEN CAST(REPLACE(Weight, 'kg', '') AS FLOAT) * 2.20462
    -- If the value contains lbs, remove the appended 'lbs' and convert to float
    WHEN Weight LIKE '%lbs' THEN CAST(REPLACE(Weight, 'lbs', '') AS FLOAT)
    -- For other cases, assume the value is already in lbs
    ELSE CAST(Weight AS FLOAT)
END
from FifaData.dbo.FIFA2021DATA
```
Result:

![image](https://github.com/Korede34/DATA-CLEANING-PROJECT-WITH-SQL/assets/64113122/282ab0df-429f-407a-91ad-d5392689ef26)

## Currency and Unit Normalization
Within the dataset, the columns Value, Wage, and Release Clause had some special characters that needed fixing. These columns featured the Euro sign (â‚¬) before the numerical values, indicating amounts in euros. These euro values were then converted to dollars using the average 2021 exchange rate. Additionally, the values were tagged with 'K' for thousands and 'M' for millions. To make sure the data was consistent for accurate analysis, i performed the following steps:

### Approach:
1. Identify Euro Values:
   - I locate rows containing the euro symbol (â‚¬) in the respective columns: `Value`, `Wage`, and `Release Clause`.
   - I identify values denoted in millions (M) or thousands (K).

2. Conversion Process:
   - Millions Conversion:
     - Eliminate the euro symbol (â‚¬) and the 'M' suffix.
     - Convert the numeric part to float.
     - Multiply by 1,000,000 to get the equivalent value in euros.
     - Multiply by the exchange rate of 1.183 to convert to US dollars.
       
   - Thousands Conversion:
     - Eliminate the euro symbol (â‚¬) and the 'K' suffix.
     - Convert the numeric part to float.
     - Multiply by 1,000 to get the equivalent value in euros.
     - Multiply by the exchange rate of 1.183 to convert to US dollars.
       
   - Other Values:
     - Eliminate the euro symbol (â‚¬).
     - Convert the numeric part to float.
     - Multiply by the exchange rate of 1.183 to convert to US dollars.

3. SQL Implementation:
   - Utilized SQL `CASE` statements to handle different scenarios for millions, thousands, and other values.
   - Replaced euro symbols and suffixes ('M', 'K') with empty strings.
   - Converted numeric parts to floats and applied necessary multiplications for conversion.
   - Applied the exchange rate of 1.183 to get the final values in US dollars.

SQL QUERY
```SQL
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
```
Before:

![image](https://github.com/Korede34/DATA-CLEANING-PROJECT-WITH-SQL/assets/64113122/7c830cee-3711-49de-95f5-8f44b262492b)

After: 

![image](https://github.com/Korede34/DATA-CLEANING-PROJECT-WITH-SQL/assets/64113122/a62576f6-b72b-4704-b1ec-d5dfeb694aee)

The columns `ValueIN$`, `WageIN$`, and `Release_ClauseIN$` now contain the corresponding values in US dollars after the conversion process.

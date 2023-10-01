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
COLUMN NORMALIZATION
The primary goal was to scale various columns within our dataset to the percentage format, allowing for uniform representation of percentage-based data points.
For each relevant column, integers were converted into decimals by dividing the integer values by 100. This transformation ensured that the data, originally presented as whole numbers, were accurately scaled to fit within the percentage range of 0 to 100. 
The SQL statement `set BOV_ = BOV/100.0` was utilized to convert integer values in the column `YourColumn` into decimal format, representing percentages.
The initial columns were dropped after and the new created columns replaced them.
Before:
 
After:
 



COLUMN UNIT STANDARDIZATION
The dataset contained heights recorded in both centimeter (cm) and in feet and inches (e.g., 6'7"), weights recorder in kilogram (kg) and pounds (lbs), leading to inconsistencies and potential misinterpretations. To ensure accuracy and uniformity, a crucial step was taken to convert all weight values to pounds, and all height values to inches.
Height Conversion
Heights, presented in both centimeters (cm) and the feet and inches format (e.g., 6'7"), were standardized into inches (inch). For centimeters, the conversion factor of 1 cm equals approximately 0.393701 inches was applied. For the feet and inches format, the feet value was multiplied by 12 to convert it into inches, which was then added to the remaining inches.
The query:

Before: This shows that we are having inconsistencies in the Height column
 
After: This inconsistencies as now been fixed and the column has been standardized
 
Weight Conversion:The weight data in the dataset shows a variety of formats, including 'kg' and 'lbs' appended to the numerical values (e.g., '23kg', '44lbs'). To ensure uniformity, a two-step approach was adopted.
1. Handling 'kg' Values:
   - Values with 'kg' units were first parsed to remove the 'kg' suffix.
   - The parsed values were then converted to floating-point numbers to ensure numerical accuracy.
   - These numerical values were subsequently converted into pounds using the conversion factor of 1 kilogram equals approximately 2.20462 pounds.

2. **Handling 'lbs' Values:**
   - Values with 'lbs' units were parsed to remove the 'lbs' suffix.
   - The parsed values were converted to floating-point numbers directly since the goal was to represent all weights in pounds uniformly.

By applying these steps, all weight values, regardless of their original unit representation, were harmonized into pounds. The meticulous removal of units and conversion into a consistent unit of measurement not only standardized the dataset but also enabled precise weight comparisons and analyses. This methodological rigor ensured that the weight data adhered to a single unit across the entire dataset, eliminating discrepancies and enhancing the dataset's coherence and analytical integrity.
Methodology: The process involved converting weight from kilograms (kg) to pounds (lbs) and height from centimeter (cm) and in feet and inches(e.g., 6'7") to inches (inch) using a simple conversion factor: 1 kilogram equals approximately 2.20462 pounds, 1 cm equals approximately 0.393701 inches and feet to inches (by multiplying by 12), adds the inches.Each values in weight column was converted to pounds and each values in height column was converted to inches, providing the equivalent value in pounds and equivalent value in inches. This systematic approach ensured that all height dat adhered to the same unit of measurement and all the weight data adhered to the same unit of measurement.



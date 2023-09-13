# WELCOME TO MY DATA CLEANING CHALLENGE DOCUMENTATION

## This is my journey of the #dataCleaningChallenge organized by @PromiseNonso_ and @vicSomadina via twitter.

### This data cleaning project focuses on cleaning and preparing a large dataset of FIFA 2021 data for further analysis. The goal of this project is to transform the messy and inconsistent data into a clean and structured format suitable for generating insights and making data-driven decisions.

### The original dataset is available on [Kaggle](https://www.kaggle.com/)

### The goal of the data cleaning process is to: Removing duplicates, Handling missing values, Standardizing formats, etc.
  
### The whole cleaning process is going to be done using Microsoft Excel & Power Query

### Please note that the described steps are not a comprehensive representation of the entire process. Additionally, the steps are not strictly sequential due to the complexity of the messy data; sometimes, i may need to revisit certain steps after moving on to others. This experience offers an exciting and challenging opportunity for a data analyst student to gain practical experience, helping to reinforce and solidify their learning.



## Load the raw data into Power Query.
#### This is what it looks like
![Screenshot (18)](https://github.com/Korede34/Data-cleaning-process-documentation/assets/64113122/6e04fa04-a61c-42e7-81ad-a3d0cd9aab4b)


After loading the data into the Power Query, the rows and columns were full of unnecessary white spaces which i get rid of by navigating to the View Tab in the ribbon then unchecking the show white space's check box.
## Before 
![image](https://user-images.githubusercontent.com/64113122/225513067-11fdff0d-4206-469c-b62e-48437ed90e0c.png)
## After 
![image](https://user-images.githubusercontent.com/64113122/225513099-e45fe205-68c7-4e1b-a5df-26e874fd65a8.png)

## The ID column
The ID are in form of digit, but since there's not going to be any calculation or whatsoever with the ID column, I change the data type to text then trim the column using trim button located in the Transform tab in the ribbon, to make sure it's free of unnecessary spaces.

## Name column and LongName column
The Name column and the LongName column are not in normal format as there were abreviations and diacritics in some names, so i noticed there was a more cleaner Long names in the playerUrl col,i duplicated the player url col and then split the duplicated col by delimiter which gave the me the more cleaner long names then i got rid of the not needed columns, i then used this extracted column in place of LongName column which i also renamed to fullName. Because i want to have first name and last name column instead of just the Name column, i split the Name column by delimiter and used the most complete column as the last name column and also got the first name from the fullname column by duplicating it and spliting by delimiter, which i use the left-most column after spliting by space delimiter as the first name. 

## Before
![image](https://user-images.githubusercontent.com/64113122/225519492-0db1dc37-bb48-4bc8-9f79-25307f6e88dd.png)

## After
![image](https://user-images.githubusercontent.com/64113122/225519780-f1c6ff89-9b34-4039-bfcf-1dad7e77119d.png)

## Getting rid of unecessary columns
As i proceed in cleaning the data, i was doing the cleaning column by column, i noticed the next two columns which are photoUrl and playerUrl are not going to be needed during the analysis so i decided to get rid of them

## Before
![image](https://user-images.githubusercontent.com/64113122/225520762-74df82eb-7398-4ab0-b541-806a312bcbff.png)

## After
![image](https://user-images.githubusercontent.com/64113122/225520776-855af2d1-572e-4d05-b822-17771a11fec2.png)

## Changing data types
As mentioned stated in the data dictionary the OVA and POT column are rates in percentage, so i change the data type to percentage by first adding the percentage sign as suffix and then change the data type to percentage because if the data type is changed without doing that, it will just multiply the value by 100 which will give inaccurate result.

## Before
![image](https://user-images.githubusercontent.com/64113122/225588165-09092e8a-d6f0-4e3e-9611-431a0660df4d.png)

## After
![image](https://user-images.githubusercontent.com/64113122/225588237-1b245538-95c8-4eb4-9379-a1145de0e3d2.png)

## Removing the diacritics and accents
Moving on to the next column which is the club names, i noticed there are some first names that have diacritics and accents as their first letter which will the affect the sorting result, but these names are not much so i manually find and replace them one by one

## Before

## After








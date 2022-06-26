/*

CLEANING RAW DATA FOR EXPLORATION AND VISUALIZATION  

Cleaning Data in SQL Queries

*/
USE PortfolioProject;

SELECT *
FROM PortfolioProject..[NashvilleHousing ];

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

-- If it doesn't Update properly


-- Standardize Date Format  Alternative

UPDATE [NashvilleHousing ]                      --setting salesdate to date only 
SET SaleDate =CONVERT (Date,SaleDate);

SELECT  CONVERT (Date,SaleDate)  --Selecting the new column
FROM PortfolioProject..[NashvilleHousing ]

ALTER TABLE NashvilleHousing      --To create new column  in the table
ADD SaleDateConverted Date;


UPDATE [NashvilleHousing ]               --To Update the new column
SET SaleDateConverted =CONVERT (Date,SaleDate);

SELECT SaleDateConverted, CONVERT (Date,SaleDate)  --Selecting the new column
FROM PortfolioProject..[NashvilleHousing ] 




--Update [NashvilleHousing ]
--SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE PortfolioProject..[NashvilleHousing]
Add SaleDateConverted Date

Update PortfolioProject..[NashvilleHousing ]
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.[NashvilleHousing ];
 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortfolioProject.dbo.[NashvilleHousing ]
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.[NashvilleHousing ] a
JOIN PortfolioProject.dbo.[NashvilleHousing ] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.[NashvilleHousing ] a
JOIN PortfolioProject.dbo.[NashvilleHousing ] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

 
--Where PropertyAddress is null
--order by ParcelID



--USING SUBSTRING 

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.[NashvilleHousing ]


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.[NashvilleHousing ]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar (255);

Update PortfolioProject.dbo.[NashvilleHousing ]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
from PortfolioProject.dbo.[NashvilleHousing ]

Select OwnerAddress
From PortfolioProject.dbo.[NashvilleHousing ]


--Alternatative Method Using PASRENAME
-----------------------

select PropertyAddress
from PortfolioProject.dbo.[NashvilleHousing ];

Select
PARSENAME(REPLACE(PropertyAddress, ',', '.') , 2)
,PARSENAME(REPLACE(PropertyAddress, ',', '.') , 1)
From PortfolioProject.dbo.[NashvilleHousing ]


ALTER TABLE [PortfolioProject]..[NashvilleHousing ]
Add PropertySplitAddress Nvarchar(255)

 Update [PortfolioProject]..[NashvilleHousing ]
SET PropertySplitAddress = PARSENAME(REPLACE(PropertyAddress, ',', '.') , 2)

ALTER TABLE [PortfolioProject]..[NashvilleHousing ]
Add PropertySplitCity Nvarchar (255);

 Update [PortfolioProject]..[NashvilleHousing ]
SET PropertySplitCity = PARSENAME(REPLACE(PropertyAddress, ',', '.') , 1)

Select PropertySplitCity,PropertySplitAddress 
from [PortfolioProject]..[NashvilleHousing ];





--------------------------------------------------





Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.[NashvilleHousing ]



ALTER TABLE [PortfolioProject]..[NashvilleHousing ]
Add OwnerSplitAddress Nvarchar(255);

Update [PortfolioProject]..[NashvilleHousing ]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [PortfolioProject]..[NashvilleHousing ]
Add OwnerSplitCity Nvarchar(255);

Update [PortfolioProject]..[NashvilleHousing ]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [PortfolioProject]..[NashvilleHousing ]
Add OwnerSplitState Nvarchar(255);

Update [PortfolioProject]..[NashvilleHousing ]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.dbo.[NashvilleHousing ]









--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT (SoldAsvacant), count(SoldAsVacant)
from PortfolioProject.dbo.[NashvilleHousing ]
GROUP BY SoldAsVacant;


SELECT (SoldAsVacant),
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant 
	 END

from PortfolioProject.dbo.[NashvilleHousing ]

UPDATE PortfolioProject..[NashvilleHousing ]
SET SoldAsVacant =CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant 
	 END

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates USING COMMON TABLE EXPRESSION 

WITH ROWnumCTE AS(

SELECT *,ROW_NUMBER() OVER (
PARTITION BY ParcelID,PropertyAddress,Saledate,LegalReference
ORDER BY UniqueID) row_num

FROM PortfolioProject..[NashvilleHousing ])
--ORDER BY parcelID;
SELECT *   ---- To pull duplicate rows 
FROM ROWnumCTE 
WHERE row_num > 1
--ORDER BY PropertyAddress

/*DELETE 
FROM ROWnumCTE 
WHERE row_num > 1*/




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM PortfolioProject..[NashvilleHousing ]

ALTER TABLE PortfolioProject..[NashvilleHousing ]
DROP  COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

                             
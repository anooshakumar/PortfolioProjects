/*DATA CLEANING USING SQL */

SELECT *
FROM Portfolio.dbo.NashvilleHousing

----Stanadardizing data format 

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM Portfolio.dbo.NashvilleHousing

--Just updating dint work --
UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- so altering the tablet and updating 

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM Portfolio.dbo.NashvilleHousing


---Populate property address data 

SELECT PropertyAddress
FROM Portfolio.dbo.NashvilleHousing
WHERE PropertyAddress is null

SELECT *
FROM Portfolio.dbo.NashvilleHousing
---WHERE PropertyAddress is null
ORDER BY ParcelID

-- Creating a join with the same table as there is a relation between parcel Id and property address and so we can populate the null values in address
SELECT a.ParcelID ,a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null

-- if the a.propertyaddress is null replace the values of b.propertaddress

SELECT a.ParcelID ,a.PropertyAddress, b.ParcelID, b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null


--updating the values 

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null


---- Breaking the address into Individual columns( address, city , state)

SELECT PropertyAddress
FROM Portfolio.dbo.NashvilleHousing

-- using CHARINDEX to find the comma and then eliminating it 
SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1) AS Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
FROM Portfolio.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress= SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

----Splitting owner address


SELECT OwnerAddress
FROM Portfolio.dbo.NashvilleHousing

SELECT 
PARSENAME( REPLACE(OwnerAddress,',','.'),3),
PARSENAME( REPLACE(OwnerAddress,',','.'),2),
PARSENAME( REPLACE(OwnerAddress,',','.'),1)
FROM Portfolio.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From Portfolio.dbo.NashvilleHousing

---Changing Y to Yes and N to No in 'SolaAsVacant' field 

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Portfolio.dbo.NashvilleHousing
GROUP BY SoldAsVacant


SELECT SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
FROM Portfolio.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-----Remove Duplicates 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Portfolio.dbo.NashvilleHousing
--order by ParcelID
)
SELECT *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

DELETE
From RowNumCTE
Where row_num > 1
---Order by PropertyAddress


Select *
From Portfolio.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From Portfolio.dbo.NashvilleHousing


ALTER TABLE Portfolio.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate















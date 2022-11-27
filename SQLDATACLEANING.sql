
--Cleaning Data in SQL Queries

select *
from Portproject.dbo.Nashvillehousing

--Standardize date format

Alter table Nashvillehousing
add Saledate2 date;

Update Nashvillehousing
SET Saledate2=CONVERT(date,SaleDate)

Select Saledate2 from Portproject.dbo.Nashvillehousing


--Populate property adresss data

Select a.ParcelID, a.propertyaddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from Portproject.dbo.Nashvillehousing a
JOIN Portproject.dbo.Nashvillehousing b
on a.ParcelID=b.ParcelID
AND a.[UniqueID]<>b.[UniqueID]
where a.propertyAddress is null

Update a
SET propertyaddress=ISNULL(a.PropertyAddress, b.PropertyAddress)
from Portproject.dbo.Nashvillehousing a
JOIN Portproject.dbo.Nashvillehousing b
on a.ParcelID=b.ParcelID
AND a.[UniqueID]<>b.[UniqueID]
where a.propertyAddress is null

--Breaking out adress into indivisual columns (Adress, city, state)


SELECT
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) as address
, SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, LEN(propertyaddress)) as address1

From Portproject.dbo.Nashvillehousing

Alter table Nashvillehousing
add propertysplitaddress nvarchar(255);

Update Nashvillehousing
SET propertysplitaddress=SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1)

Alter table Nashvillehousing
add propertysplitcity nvarchar(255);

Update Nashvillehousing
SET propertysplitcity=SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, LEN(propertyaddress))

Select *from Portproject.dbo.Nashvillehousing


Select OwnerAddress
From Portproject.dbo.Nashvillehousing


Select
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
from Portproject.dbo.Nashvillehousing


Alter table Nashvillehousing
add Ownersplitadress nvarchar(255);

Update Nashvillehousing
SET Ownersplitadress=PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

Alter table Nashvillehousing
add Ownersplitcity nvarchar(255);

Update Nashvillehousing
SET Ownersplitcity=PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

Alter table Nashvillehousing
add Ownersplitstate nvarchar(255);

Update Nashvillehousing
SET Ownersplitstate=PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

--Change Y and N to Yes and No in "Sold in Vacant" field

select Distinct(Soldasvacant), Count(Soldasvacant)
from Portproject.dbo.Nashvillehousing
Group by Soldasvacant




Select Soldasvacant
, Case when Soldasvacant= 'Y' THEN 'Yes'
		when Soldasvacant= 'N' THEN 'No'
		ELSE Soldasvacant
		END
from Portproject.dbo.Nashvillehousing

Update Nashvillehousing
SET Soldasvacant= Case when Soldasvacant= 'Y' THEN 'Yes'
		when Soldasvacant= 'N' THEN 'No'
		ELSE Soldasvacant
		END


--Remove Duplicates

With RowNumCTE AS(
Select *,
ROW_Number() over(
Partition BY parcelID,
Propertyaddress,
saleprice,
saledate,
legalreference
order By 
uniqueID
)row_num
from Portproject.dbo.Nashvillehousing
--order by parcelID
)

SELECT *
from RowNumCTE
where row_num>1


--Delete unused columns

Select *
from Portproject.dbo.Nashvillehousing

Alter table Nashvillehousing
DROP column ownerAddress, taxdistrict, propertyaddress, saledate

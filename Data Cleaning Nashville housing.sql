select * from NashvilleHousing;
select * from [Deekshitha Portfolio].dbo.NashvilleHousing;

--standardize date fromat
select SaleDate from [Deekshitha Portfolio].dbo.NashvilleHousing;
Alter table [Deekshitha Portfolio].dbo.NashvilleHousing alter column SaleDate Date
update [Deekshitha Portfolio].dbo.NashvilleHousing
set SaleDate = CONVERT(date,SaleDate) --Convert (Target data type, expression(column name), Data style) Returns the date

--poppulate property address
select [PropertyAddress] from [Deekshitha Portfolio].dbo.NashvilleHousing
where PropertyAddress is null;

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Deekshitha Portfolio].dbo.NashvilleHousing as a 
JOIN [Deekshitha Portfolio].dbo.NashvilleHousing as b
ON a.ParcelID = b.ParcelID 
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

Update a
SET a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Deekshitha Portfolio].dbo.NashvilleHousing as a 
JOIN [Deekshitha Portfolio].dbo.NashvilleHousing as b
ON a.ParcelID = b.ParcelID 
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

Select [PropertyAddress] from [dbo].[NashvilleHousing]
where [PropertyAddress] is null

--Break the Property adress into Individual columns - Address City using Substring function
select SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)
from [dbo].[NashvilleHousing]

select SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
from [dbo].[NashvilleHousing]

Alter table [dbo].[NashvilleHousing]
add PropertySplitAddress nvarchar(255)

Alter table [dbo].[NashvilleHousing]
add PropertyAddressCity nvarchar(255)

UPDATE [Deekshitha Portfolio].dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

UPDATE [Deekshitha Portfolio].dbo.NashvilleHousing
SET PropertyAddressCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select * from [Deekshitha Portfolio].dbo.NashvilleHousing

--Break the Owner address into indvidual columns - Address City Sate 
select [OwnerAddress] from [Deekshitha Portfolio].dbo.NashvilleHousing

select PARSENAME(REPLACE(OwnerAddress,',','.'),1),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),3) 
from [Deekshitha Portfolio].dbo.NashvilleHousing

Alter table [dbo].[NashvilleHousing]
add OwnerSplitAddress nvarchar(255)

Alter table [dbo].[NashvilleHousing]
add OwnerCity nvarchar(255)

Alter table [dbo].[NashvilleHousing]
add OwnerState nvarchar(255)

Update [dbo].[NashvilleHousing]
SET OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Update [dbo].[NashvilleHousing]
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Update [dbo].[NashvilleHousing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

select * from [dbo].[NashvilleHousing]


_-- replacing Y /N in SoldAsVacant column with YES/NO

select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from [dbo].[NashvilleHousing]
group by SoldAsVacant
order by 2 desc

select [SoldAsVacant],
CASE 
When [SoldAsVacant] = 'Y' then 'Yes'
When [SoldAsVacant] ='N' then 'No'
Else SoldAsVacant
END 
from [dbo].[NashvilleHousing]

update [dbo].[NashvilleHousing]
SET [SoldAsVacant] = CASE 
When [SoldAsVacant] = 'Y' then 'Yes'
When [SoldAsVacant] ='N' then 'No'
Else SoldAsVacant
END 

--Removing of Duplicates using CTE and Windows function Row_number 
With rownumCTE As (
select *, ROW_NUMBER() over(partition by ParcelID,SalePrice,PropertyAddress,SaleDate,LegalReference order by UniqueID) as row_num
from [dbo].[NashvilleHousing]
--order by ParcelID
)
delete from rownumCTE
where row_num > 1

With rownumCTE As (
select *, ROW_NUMBER() over(partition by ParcelID,SalePrice,PropertyAddress,SaleDate,LegalReference order by UniqueID) as row_num
from [dbo].[NashvilleHousing]
--order by ParcelID
)
select * from rownumCTE
order by ParcelID
	
--Deleting columns which are not of use to improve performance
Alter table [dbo].[NashvilleHousing]
drop column [TaxDistrict]

Alter table [dbo].[NashvilleHousing]
drop column [BuildingValue]

Alter table [dbo].[NashvilleHousing]
drop column [OwnerAddress]

Alter table [dbo].[NashvilleHousing]
drop column [PropertyAddress]
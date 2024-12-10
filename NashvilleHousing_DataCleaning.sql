Select *
from HousingData..NashvilleHousing

--Cleaning  Data

Select *
from HousingData..NashvilleHousing
--

--Standardizing Date format

Select SaleDate, CONVERT(date,SaleDate)
from HousingData...NashvilleHousing

Update NashvilleHousing
SET SaleDate= CONVERT(date,SaleDate)

Alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(date,SaleDate)


Select SaleDateConverted, CONVERT(date,SaleDate)
from HousingData...NashvilleHousing

--populating property address

Select *
from HousingData..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from HousingData..NashvilleHousing a 
join HousingData..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from HousingData..NashvilleHousing a 
join HousingData..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


-- breaking address

Select PropertyAddress
from HousingData..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) as Address
from HousingData..NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

Alter table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) 

Select *
from HousingData..NashvilleHousing

--owner address

Select OwnerAddress
from HousingData..NashvilleHousing

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from HousingData..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


Select *
from HousingData..NashvilleHousing

--changing Y and N to yes and no in "sold as vacant" field

select distinct(SoldAsVacant)
from HousingData..NashvilleHousing



select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from HousingData..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant ='Y' THEN 'Yes'
		when SoldAsVacant ='N' THEN 'No'
		ELSE SoldAsVacant
		end
from HousingData..NashvilleHousing

update NashvilleHousing
set SoldAsVacant=case when SoldAsVacant ='Y' THEN 'Yes'
		when SoldAsVacant ='N' THEN 'No'
		ELSE SoldAsVacant
		end


--removing duplicates(CTE'S)



WITH RowNumCTE as(
Select *,
	ROW_NUMBER() over(
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by UniqueID) row_num

from HousingData..NashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE
where row_num>1
--order by PropertyAddress





---deleting unused columns


Select *
from HousingData..NashvilleHousing


alter table HousingData..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
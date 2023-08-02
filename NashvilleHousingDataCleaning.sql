Select *
From PortfolioProject.dbo.NashvilleHousing


--Standardize Date Format 


Select SaleDateConverted, Convert(date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDate = Convert(date, SaleDate)

Alter Table PortfolioProject.dbo.NashvilleHousing
add SaleDateConverted date;

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDateConverted = Convert (Date, SaleDate)



--Populate Property Address Data


Select *
From  PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From  PortfolioProject.dbo.NashvilleHousing a 
Join PortfolioProject.dbo.NashvilleHousing b
	On a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 


Update a
Set PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From  PortfolioProject.dbo.NashvilleHousing a 
Join PortfolioProject.dbo.NashvilleHousing b
	On a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 


--Breaking out Address into Individual Columns 


Select PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing


Alter Table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress nvarchar (255); 

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity nvarchar (255); 

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing





Select OwnerAddress 
From PortfolioProject.dbo.NashvilleHousing

Select 
PARSENAME (Replace(OwnerAddress, ',', '.'), 3), 
PARSENAME (Replace(OwnerAddress, ',', '.'), 2),
PARSENAME (Replace(OwnerAddress, ',', '.'), 1)
From PortfolioProject.dbo.NashvilleHousing



Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress nvarchar (255); 

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitAddress =  PARSENAME (Replace(OwnerAddress, ',', '.'), 3)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity nvarchar (255); 

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitCity = PARSENAME (Replace(OwnerAddress, ',', '.'), 2)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState nvarchar (255); 

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitState = PARSENAME (Replace(OwnerAddress, ',', '.'), 1) 

Select * 
From PortfolioProject.dbo.NashvilleHousing


--Change Y and N to Yes and No 


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group By SoldAsVacant
Order By 2



Select SoldAsVacant, 
Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No' 
	 Else SoldAsVacant 
	 End
From PortfolioProject.dbo.NashvilleHousing


Update PortfolioProject.dbo.NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No' 
	 Else SoldAsVacant 
	 End



--Remove Duplicates 


With RowNumCTE As(
Select *, 
	ROW_NUMBER() over (
	Partition by ParcelID, 
			PropertyAddress,
			SalePrice, 
			SaleDate, 
			LegalReference
			Order by 
				UniqueID 
				) row_num
From PortfolioProject.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing




--Delete Unused Columns 


Select *
From PortfolioProject.dbo.NashvilleHousing


Alter table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter table PortfolioProject.dbo.NashvilleHousing
Drop Column SaleDate


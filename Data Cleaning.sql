Data Cleaning using SQL

Aim - To Learn Advanced SQL Concepts like from Basics of SQL to Functions,Triggers, CTE,Views Temp Tables,Operations of Data exploration and Cleaning.
         
DataSet - Refer Given Dataset of National-Housing 

- Import .xlsx(Dataset File) into SQL(Microsoft SQL Server) 

- Queries on Data for Exploration as Follows 


  SELECT * FROM NashVilleHousing;




1.Standardize Date Format

	SELECT SaleDate, CONVERT(Date, SaleDate) FROM NashVilleHousing;
	
	ALTER TABLE NashVilleHousing ADD SaleDateConverted Date;
	
	UPDATE NashVilleHousing SET SaleDateCoverted = CONVERT(Date, SaleDate);
	

	
	
	
2.Populate Property Address Column

	SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) FROM NashVilleHousing a JOIN NashVilleHousing b ON a.ParcelID = b.ParcelID WHERE a.PropertyAddress is NULL;
	
	UPDATE a SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) FROM NashVilleHousing a JOIN NashVilleHousing b ON a.ParcelID = b.ParcelID WHERE a.PropertyAddress is NULL;
	
	
	
	
	
	
	
	
3.Creating New Columns By Splitting Data
	
3.1 ) Breaking Housing Address into Individual Columns (Address,City) | E.G. New Peth,Balamtakali ==> New Peth | Balamtakali

	SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address , SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS Addr FROM NashVilleHousing;
	
	ALTER TABLE NashVilleHousing ADD PropertySplitAddress varchar(255);
	
	UPDATE NashVilleHousing SET PropertySplitAdddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);
	
	
	ALTER TABLE NashVilleHousing ADD PropertySplitCity varchar(255);
	
	UPDATE NashVilleHousing SET PropertySplitCity = SSUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress));
	
	
3.2 ) Breaking Owner Address into Individual As Address,City,State ==> Address | City | State.

	SELECT 
	PARSENAME(REPLACE(ownerAddress,',','.'),3) AS Addr,
	PARSENAME(REPLACE(ownerAddress,',','.'),2) AS City,
	PARSENAME(REPLACE(ownerAddress,',','.'),1) AS State
	FROM NashVilleHousing;
	
	ALTER TABLE NashVilleHousing ADD OwnerSplitAddress varchar(255);
	
	UPDATE NashVilleHousing SET OwnerSplitAddress = PARSENAME(REPLACE(ownerAddress,',','.'),3);
	
	
	ALTER TABLE NashVilleHousing ADD OwnerSplitCity varchar(255);
	
	UPDATE NashVilleHousing SET OwnerSplitCity = PARSENAME(REPLACE(ownerAddress,',','.'),2);
	
	
	ALTER TABLE NashVilleHousing ADD OwnerSplitState varchar(255);
	
	UPDATE NashVilleHousing SET OwnerSplitState = PARSENAME(REPLACE(ownerAddress,',','.'),1);
	
	
	SELECT OwnerSplitAddress, OwnerSplitCity, OwnerSplitState FROM NashVilleHousing;
	
	
	
	
	
4.Change Y & N to YES & NO in 'SoldAsVacant' Column.


	SELECT DISTINCT(SoldAsVacant) FROM NashVilleHousing;
	
	SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant='Y' THEN 'YES'
	     WHEN SoldAsVacant='N' THEN 'NO'
	     ELSE SoldAsVacant
	END
	FROM NashVilleHousing;
	
	
	UPDATE NashVilleHousing SET SoldAsVacant = 
		CASE WHEN SoldAsVacant='Y' THEN 'YES'
	     	     WHEN SoldAsVacant='N' THEN 'NO'
	             ELSE SoldAsVacant
	        END
	
	
	
	
	
5.Remove Duplicates with CTE

	With RowNumCTE AS(
		SELECT *,
			ROW_NUMBER() OVER (
				PARTITION BY ParcelID,PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID
				) AS Row_Num
		FROM NashVilleHousing;
	)

	SELECT * FROM RowNumCTE WHERE Row_num>1 ORDER BY PropertyAddress;

	DELETE FROM RowNumCTE WHERE Row_num>1;
	
	
	
	
	
6.Delete Unused Columns ==> Feature Selection.

	ALTER TABLE NashVilleHousing DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;

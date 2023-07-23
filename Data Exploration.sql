Data Exploration using SQL

Aim - To Learn Advanced SQL Concepts like from Basics of SQL to Functions,Triggers, CTE,Views Temp Tables,Operations of Data exploration and Cleaning.
         
DataSet - Covid Dataset from https://www.ourworldindata.org/covid-deaths 

- Import .xlsx(Dataset File) into SQL(Microsoft SQL Server) 


- Queries on Data for Exploration as Follows 


1. SELECT * FROM CovidDeaths Order By Country,Date;



2. SELECT Location,date,total_cases,new_cases,total_deaths,population FROM CovidDeaths;
	//Extracting Info needed Only.
	
	
	
3. --Looking at Total_cases vs Total_Deaths in INDIA.
	
	SELECT Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage FROM CovidDeaths WHERE Location LIKE '%india%' ORDER BY Country,Date;
	
	
	
4.--Looking at Totall_cases vs Population.
  --Shows What Percentage of Population got Covid.
  	
	SELECT Location,date,total_cases,population,(total_cases/population)*100 AS PercentagePopulationInfected FROM CovidDeaths WHERE Location LIKE '%india%' ORDER BY Country,Date;  
	


5.--Looking at Countries with Highest Infection Rate.
	
	SELECT Location,population,MAX(total_cases) AS HighestInfectionCount,MAX(total_cases/population)*100 AS PercentagePopulationInfected FROM CovidDeaths GROUP BY Location,population ORDER BY Country,Date. 



6.--Looking at Countries with Highest Death Count per Population.

	SELECT Location,MAX(cast(total_deaths as int)) AS TotalDeathCount FROM CovidDeaths GROUP BY Location ORDER BY TotalDeathCount DESC;



7.--Global Numbers i.e.WorldWide Counts of Deaths,Cases and Its Percentage.

	SELECT SUM(new_cases) AS Total_Cases, SUM(cast(new_deaths as INT)) AS Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS Percentage FROM CovidDeaths WHERE continent IS NOT NULL ORDER BY Country,Date;
	
	
	
8.--Looking at Total Populatin vs Vaccinations by Joining 2 Tables.

	SELECT dea.continent, dea.Location, dea.Date, dea.Population, vac.new_vaccinations FROM CovidDeaths dea JOIN CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date WHERE dea.continent IS NOT NULL ORDER BY 2,3;

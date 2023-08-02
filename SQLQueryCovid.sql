SELECT *
FROM PortfolioProject..CovidDeaths
ORDER BY 3,4

SELECT *
From PortfolioProject..CovidDeaths
Where continent is not null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths 
--Shows likelihood of dying from Covid in various countries 
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths 
where continent is not null
order by 1,2 


--Total Cases vs Population 
--Percentage of population that got covid in US

SELECT location, date, population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths 
Where location like '%states%'
order by 1,2


--Countries with Highest Infection Rate compared to Population 

Select Location, Population, MAX(total_cases) as HighestInfectedCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by location, population
order by PercentPopulationInfected desc
--Andorra has a 17% of population infected 
--United States has 9th highest at 9.77%

--Countries with highest death count by population 

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths 
Where continent is not null
Group by Location 
Order by TotalDeathCount desc
--United States at #1 with 576,232 


--Continent with Highest Death Count 

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths 
Where continent is null
Group by location 
Order by TotalDeathCount desc
--Europe highest with 1,016,750

 
--Global Numbers

 Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
 From PortfolioProject..CovidDeaths
 where continent is not null
 order by 1,2
 --total_cases = 150,574,977. total_deaths = 3,140,206. DeathPercentage = 2.11%


 --Total Population vs Vaccinations 

 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(CONVERT(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 From PortfolioProject..CovidDeaths dea
 Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


--USE CTE 

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 From PortfolioProject..CovidDeaths dea
 Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--TEMP TABLE 

Drop table if exists #PercentPopulationVaccinated 
Create table #PercentPopulationVaccinated 
(
Continent nvarchar(225), 
Location nvarchar(225), 
Date datetime, 
Population numeric, 
New_Vaccinations numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 From PortfolioProject..CovidDeaths dea
 Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



--Views For Visualizations 

Create View PercentPopulationVaccinated as 
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 From PortfolioProject..CovidDeaths dea
 Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select *
From PercentPopulationVaccinated


Create View GlobalNumbers as 
 Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
 From PortfolioProject..CovidDeaths
 where continent is not null

 Select *
 From GlobalNumbers


 Create View HighestInfectionComparePopulation as
 Select Location, Population, MAX(total_cases) as HighestInfectedCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by location, population

Select *
From HighestInfectionComparePopulation


Create View HighestDeathCountByPop as
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths 
Where continent is not null
Group by Location 

Select *
From HighestDeathCountByPop


Create View ContinentDeathCount as
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths 
Where continent is null
Group by location

Select *
From ContinentDeathCount

 

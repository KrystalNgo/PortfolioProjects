Select *
From PortfolioProject..CovidDeaths
Where continent is not null
Order By 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--Order By 3,4

-- Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
Order By 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
And continent is not null
Order By 1,2

-- Looking at Total cases vs Population
-- Shows What percentage of population got covid
Select location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
Order By 1,2

-- Looking at Countries with Highest Infection Rate Compared to Population
Select location, population,  Max(total_cases) As HightestInfectionCount,  Max((total_cases/population))*100 as
PercentagePopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by location, population
Order By PercentagePopulationInfected Desc

-- LET'S BREAK THINGS DOWN BY CONTINENT 

-- Showing continents with the highest death count per population
Select continent,  Max(Cast(total_deaths as int)) As TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
Order By TotalDeathCount Desc

-- GLOBAL NUMBERS

Select Date, Sum(New_cases) as total_cases, Sum(cast(New_deaths as int)) as total_Deaths, 
(Sum(cast(New_deaths as int))/Sum(New_cases))*100 as DeathPercentage
From  PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by date
Order By total_cases Desc

-- Looking at Total population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) 
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
order by 2,3

-- USE CTE

with PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) 
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 
From PopvsVac 

-- USE Temp Table

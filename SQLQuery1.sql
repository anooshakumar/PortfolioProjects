/*
Covid 19 Data Exploration 

Skills used: Joins, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

SELECT *
FROM Portfolio.dbo.CovidDeaths
ORDER BY 3,4


--SELECT *
--FROM Portfolio.dbo.CovidVaccinations
--ORDER BY 3,4

SELECT location,continent ,date,total_cases,new_cases,total_deaths,population
FROM Portfolio.dbo.CovidDeaths
ORDER BY 1,2

--Total cases vs Total Deaths

SELECT location,continent, date,total_cases,total_deaths,(total_deaths/total_cases) *100 AS DeathPercentage 
FROM Portfolio.dbo.CovidDeaths
WHERE location like '%kingdom%'
ORDER BY 1,2

--Total cases vs population

SELECT location,continent , date,total_cases,population,(total_cases/population) *100 AS PercentPopulationInfected
FROM Portfolio.dbo.CovidDeaths
WHERE location like '%kingdom%'
ORDER BY 1,2

-- infection rate compared to population

SELECT location,continent,population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)) *100 AS PercentPopulationInfected
FROM Portfolio.dbo.CovidDeaths
WHERE continent is not null
GROUP BY location,population,continent
ORDER BY 4 desc


--Countries with highest death count per population

SELECT location,MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM Portfolio.dbo.CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

SELECT *
FROM Portfolio.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 3,4

-- By continent
SELECT continent,MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM Portfolio.dbo.CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

SELECT location,MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM Portfolio.dbo.CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount desc

--- continents with highest death count per population

SELECT continent,MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM Portfolio.dbo.CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc


----global numbers 

SELECT date,SUM(new_cases),SUM( cast(new_deaths as int))--,total_deaths,(total_cases/total_deaths) * 100 AS DeathPercenatage  
FROM Portfolio.dbo.CovidDeaths
WHERE continent is not null 
GROUP BY date
ORDER BY 1,2


SELECT date,SUM(new_cases) as total_cases,SUM( cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) *100 AS DeathPercenatge
FROM Portfolio.dbo.CovidDeaths
WHERE continent is not null 
GROUP BY date
ORDER BY 1,2

-- total cases globally 

SELECT SUM(new_cases) as total_cases,SUM( cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) *100 AS DeathPercenatge
FROM Portfolio.dbo.CovidDeaths
WHERE continent is not null 
ORDER BY 1,2

--total population vs vaccinations

SELECT dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations , SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
FROM Portfolio.dbo.CovidDeaths dea
JOIN Portfolio.dbo.CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date 
WHERE dea.continent is not null
ORDER BY 2,3

---- creating temp table 

DROP Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
Select dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations ,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
FROM Portfolio.dbo.CovidDeaths dea
JOIN Portfolio.dbo.CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date 
---WHERE dea.continent is not null
--ORDER BY 2,3

SELECT * , (RollingPeopleVaccinated/population) *100
FROM #PercentPopulationVaccinated


---setting data for viz

CREATE VIEW PercentPopulationVaccinated AS
Select dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
FROM Portfolio.dbo.CovidDeaths dea
JOIN Portfolio.dbo.CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date 
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated




















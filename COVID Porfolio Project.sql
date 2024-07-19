SELECT *
FROM PortfolioProject..CovidDeaths
ORDER BY 3,4;

----------------------------------------------------------------------------------------------

-- Select data that we are going to be using (NA)

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2;

----------------------------------------------------------------------------------------------

-- Looking at the total cases vs total deaths 
-- Shows likelihood of dying if you contract COVID in your country

SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%India%'
ORDER BY 1,2;

----------------------------------------------------------------------------------------------

-- Looking at the total cases vs the population
-- Shows what percentage of population got COVID

SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%India%'
ORDER BY 1,2;

----------------------------------------------------------------------------------------------

-- Looking at countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
-- WHERE location LIKE '%India%'
GROUP BY Location, population
ORDER BY PercentPopulationInfected DESC;

----------------------------------------------------------------------------------------------

-- Showing the countries with the highest death count per population

SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
-- WHERE location LIKE '%India%'
WHERE continent IS NOT NULL -- To remove the redundant data of the continents
GROUP BY Location
ORDER BY TotalDeathCount DESC;

----------------------------------------------------------------------------------------------

-- CONTINENT-WISE BREAKDOWN

-- Showing the continents with the highest death count per population

SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount DESC;

----------------------------------------------------------------------------------------------

-- GLOBAL NUMBERS

SELECT date, SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS INT)) AS TotalDeaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

----------------------------------------------------------------------------------------------

-- Looking at Total Population Vs Vaccinations

SELECT Dea.continent, Dea.location, Dea.date, Dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated -- Gives a rolling count
FROM PortfolioProject..CovidDeaths Dea
JOIN PortfolioProject..CovidVaccinations Vac
	ON Dea.location = vac.location 
	AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
ORDER BY 2,3;

----------------------------------------------------------------------------------------------

-- USE CTE

WITH PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated -- Gives a rolling count
FROM PortfolioProject..CovidDeaths Dea
JOIN PortfolioProject..CovidVaccinations Vac
	ON Dea.location = vac.location 
	AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
--ORDER BY 2,3;
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

----------------------------------------------------------------------------------------------


-- TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated  --If we are running it multiple times
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
RollingPeoplevaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated -- Gives a rolling count
FROM PortfolioProject..CovidDeaths Dea
JOIN PortfolioProject..CovidVaccinations Vac
	ON Dea.location = vac.location 
	AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
--ORDER BY 2,3;
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

----------------------------------------------------------------------------------------------


-- Creating View to store data for later visualisations

CREATE VIEW PercentPopulationVaccinated AS 
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated -- Gives a rolling count
FROM PortfolioProject..CovidDeaths Dea
JOIN PortfolioProject..CovidVaccinations Vac
	ON Dea.location = vac.location 
	AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
--ORDER BY 2,3;

-- Permanent View

SELECT *
FROM PercentPopulationVaccinated;

----------------------------------------------------------------------------------------------

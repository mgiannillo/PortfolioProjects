SELECT location, date,
total_cases, new_cases,
total_deaths, population
FROM
PortfolioProject..coviddeaths
WHERE continent IS NOT null
ORDER BY 1, 2

-- Looking at Total Cases vs Total Deaths
--Shows rate of death per covid case by country.

SELECT location, 
date, 
total_cases, 
total_deaths, 
(total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProject..coviddeaths
WHERE continent IS NOT null
ORDER BY 1,2

-- Looking at total cases vs. population
-- Shows covid 19 cases as percentage of population

SELECT location, 
date, 
population,
total_cases,  
(total_cases/population)*100 AS case_percentage
FROM PortfolioProject..coviddeaths
WHERE location = 'United States' AND
continent IS NOT null
ORDER BY 1,2

-- Showing countries with the highest death count per population

 SELECT 
 location,
 MAX(cast(total_deaths AS int)) AS total_deathcount
 FROM PortfolioProject..coviddeaths 
 WHERE continent IS NOT null
 GROUP BY location
 ORDER BY total_deathcount DESC

 
-- total cases per capita
 SELECT
location, population, Max(total_cases) AS total_cases,	
MAX((total_cases/population))*100 AS totalcases_percentage
FROM PortfolioProject..coviddeaths
WHERE continent IS NOT null
GROUP BY location, population
ORDER BY totalcases_percentage DESC

-- Continental outlook
-- Showing death rate per covid case in each continent

 SELECT 
 location,
 MAX(cast(total_deaths AS int)) AS total_deathcount
 FROM PortfolioProject..coviddeaths 
 WHERE continent IS null AND 
location <> 'International'
 GROUP BY location
 ORDER BY total_deathcount DESC

-- total cases as percentage of popoulation in each continent
 SELECT
location, population, Max(total_cases) AS total_cases,	
MAX((total_cases/population))*100 AS totalcases_percentage
FROM PortfolioProject..coviddeaths
WHERE continent IS null AND 
location <> 'International'
GROUP BY location, population
ORDER BY totalcases_percentage DESC

-- GLOBAL NUMBERS

SELECT 
date, SUM(new_cases) AS total_cases,
SUM(cast(new_deaths AS INT)) AS total_deaths, 
SUM(CAST(new_deaths AS INT)) / SUM(new_cases)*100 AS death_percentage
FROM PortfolioProject..coviddeaths
WHERE continent IS NOT null
GROUP BY date
ORDER BY 1,2

-- Looking at total population vs vaccinations

--  USE CTE

With PopvsVac (Continent, location, date, population, new_vaccinations, population_vaxxd)
AS (
SELECT death.continent, death.location,
death.date, death.population,
vax.new_vaccinations, 
SUM(CONVERT( INT, vax.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS population_vaxxd 
FROM 
PortfolioProject..coviddeaths AS death
JOIN PortfolioProject..covidvaccinations AS vax 
ON death.location = vax.location 
AND death.date = vax.date
WHERE death.continent IS NOT NULL
-- ORDER BY 2, 3
)
SELECT *
FROM  PopvsVac

-- TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
population_vaxxd numeric
)

INSERT INTO #PercentPopulationVaccinated

SELECT death.continent, death.location,
death.date, death.population,
vax.new_vaccinations, 
SUM(CONVERT( INT, vax.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS population_vaxxd 
FROM 
PortfolioProject..coviddeaths AS death
JOIN PortfolioProject..covidvaccinations AS vax 
ON death.location = vax.location 
AND death.date = vax.date
WHERE death.continent IS NOT NULL
-- ORDER BY 2, 3

SELECT *, (population_vaxxd/population)*100
FROM #PercentPopulationVaccinated

CREATE VIEW PercentPopulationVaccinated AS
SELECT death.continent, death.location,
death.date, death.population,
vax.new_vaccinations, 
SUM(CONVERT( INT, vax.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS population_vaxxd 
FROM 
PortfolioProject..coviddeaths AS death
JOIN PortfolioProject..covidvaccinations AS vax 
ON death.location = vax.location 
AND death.date = vax.date
WHERE death.continent IS NOT NULL
--ORDER BY 2, 3
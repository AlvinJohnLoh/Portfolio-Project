--Looking at totalcases_vs_totaldeaths
--Shows likelihood of dying if you contract covid in your country

SELECT location, 
		date, 
		total_cases,  
		total_deaths, 
		(total_deaths/total_cases)*100 AS death_percentage
FROM ['Covid Deaths$']
WHERE location like 'australia'
ORDER BY 1,2


--Looking at TotalCases_vs_Population

SELECT location, 
		date, 
		population,
		total_cases,  
		(total_cases/population) *100 AS death_percentage
FROM ['Covid Deaths$']
WHERE location like 'australia'
ORDER BY 1,2


--Looking at Countries with Highest Infection Rate compared to Population

SELECT location, 
		population,
		MAX(total_cases) AS highest_infection_count,
		MAX(total_cases/population) *100 AS percentage_population_infected
FROM ['Covid Deaths$']
--WHERE location like 'australia'
GROUP BY population, location
ORDER BY percentage_population_infected DESC


--Showing Countries with Highest Death Count per Population

SELECT location, 
	   MAX(cast(total_deaths as INT)) AS total_death_count
FROM ['Covid Deaths$']
--WHERE location like 'australia'
GROUP BY location
ORDER BY total_death_count DESC


--Let's Break Things Down By Continent

--Showing continents with the highest death count per population

SELECT continent, 
	   MAX(cast(total_deaths as INT)) AS total_death_count
FROM ['Covid Deaths$']
WHERE continent IS NOT NULL
--WHERE location like 'australia'
GROUP BY continent
ORDER BY total_death_count DESC


--GLOBAL NUMBERS

SELECT  date, 
		SUM(new_cases) AS total_cases, 
		SUM(cast(new_deaths as INT)) AS total_deaths,
		SUM(cast(new_deaths as INT))/SUM(new_cases)*100 AS death_percentage
FROM ['Covid Deaths$']
--WHERE location like 'australia'
WHERE continent IS NOT NULl
GROUP BY date
ORDER BY 1,2


--Looking at Total Populations vs Vaccinations

SELECT cod.continent, 
	   cod.location, 
	   cod.date,
	   cod.population,
	   cov.new_vaccinations,
	   SUM(CONVERT(INT,cov.new_vaccinations)) OVER (PARTITION BY cod.location ORDER BY cod.location, cod.date) AS rolling_people_vaccinated
FROM ['Covid Deaths$'] cod
JOIN ['Covid Vaccination$'] cov
	  ON cod.location = cov.location and cod.date = cov.date
WHERE cod.continent IS NOT NULL
ORDER BY 2,3


--USE CTE

WITH population_vs_vaccination 
	 (Continent, location, date, population, new_vaccinations, rolling_people_vaccinated) AS
(
	 SELECT cod.continent, 
	   cod.location, 
	   cod.date,
	   cod.population,
	   cov.new_vaccinations,
	   SUM(CONVERT(INT,cov.new_vaccinations)) OVER (PARTITION BY cod.location ORDER BY cod.location, cod.date) AS rolling_people_vaccinated
FROM ['Covid Deaths$'] cod
JOIN ['Covid Vaccination$'] cov
	  ON cod.location = cov.location and cod.date = cov.date
WHERE cod.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (rolling_people_vaccinated/population) * 100
FROM Population_vs_vaccination 



--Creating View to store data for visualizations later

CREATE VIEW totalcases_vs_totaldeaths AS
SELECT location, 
		date, 
		total_cases,  
		total_deaths, 
		(total_deaths/total_cases)*100 AS death_percentage
FROM ['Covid Deaths$']
WHERE location like 'australia'
--ORDER BY 1,2


CREATE VIEW TotalCases_vs_Population AS
SELECT location, 
		date, 
		population,
		total_cases,  
		(total_cases/population) *100 AS death_percentage
FROM ['Covid Deaths$']
WHERE location like 'australia'
--ORDER BY 1,2


CREATE VIEW HighestInfectionRate_compared_to_Population AS
SELECT location, 
		population,
		MAX(total_cases) AS highest_infection_count,
		MAX(total_cases/population) *100 AS percentage_population_infected
FROM ['Covid Deaths$']
--WHERE location like 'australia'
GROUP BY population, location
--ORDER BY percentage_population_infected DESC


CREATE VIEW HighestDeathCount_per_Population AS
SELECT location, 
	   MAX(cast(total_deaths as INT)) AS total_death_count
FROM ['Covid Deaths$']
--WHERE location like 'australia'
GROUP BY location
--ORDER BY total_death_count DESC


CREATE VIEW Continent_HighestDeathCount_per_population AS
SELECT continent, 
	   MAX(cast(total_deaths as INT)) AS total_death_count
FROM ['Covid Deaths$']
WHERE continent IS NOT NULL
--WHERE location like 'australia'
GROUP BY continent
--ORDER BY total_death_count DESC


CREATE VIEW TotalPopulations_vs_Vaccinations AS
SELECT cod.continent, 
	   cod.location, 
	   cod.date,
	   cod.population,
	   cov.new_vaccinations,
	   SUM(CONVERT(INT,cov.new_vaccinations)) OVER (PARTITION BY cod.location ORDER BY cod.location, cod.date) AS rolling_people_vaccinated
FROM ['Covid Deaths$'] cod
JOIN ['Covid Vaccination$'] cov
	  ON cod.location = cov.location and cod.date = cov.date
WHERE cod.continent IS NOT NULL
--ORDER BY 2,3



Select *
From CovidDeaths
where continent is not null
order by 3,4;


Select *
From CovidVaccinations
Order by 3,4;


Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
where continent is not null
order by 1,2;



Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
From CovidDeaths
where continent is not null
where location like 'Turkey'
order by 1,2;


Select Location, date, total_cases, population, (total_cases/population)*100 AS covid_percentage
From CovidDeaths
where continent is not null
where location like 'Turkey'
order by 1,2


Select Location, population, MAX(total_cases) as HighestInfectionNo, MAX((total_cases/population))*100 AS Infection_percentage
From CovidDeaths
Group by location, population
order by Infection_percentage desc



Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc


Select Location, MAX(cast(total_deaths as int)) as HighestDeathNo, population, MAX((total_deaths/population))*100 AS Totaldeath_percentage
From CovidDeaths
where continent is not null
Group by location, population
order by Totaldeath_percentage desc


Select Location, MAX(cast(total_deaths as int)) as HighestDeathNo
From CovidDeaths
where continent is not null
Group by location
order by HighestDeathNo desc




Select continent, MAX(cast(total_deaths as int)) as HighestDeathNo
From CovidDeaths
where continent is not null
Group by continent
order by HighestDeathNo desc


Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


Select date, SUM(new_cases) as totalnewcases, SUM(cast(new_deaths as int)) as totalnewdeaths, SUM(cast(new_deaths as int)) /SUM(new_cases)*100 AS deathpercentage
From CovidDeaths
where continent is not null
Group by Date
order by 1,2;


--Total cases, total death global
Select SUM(new_cases) as totalnewcases, SUM(cast(new_deaths as int)) as totalnewdeaths, SUM(cast(new_deaths as int)) /SUM(new_cases)*100 AS deathpercentage
From CovidDeaths
where continent is not null
order by 1,2;


--Total population vs Vaccinations:
Select dead.continent, dead.location, dead.date, dead.population, vacc.new_vaccinations, SUM(CONVERT(int,vacc.new_vaccinations)) 
OVER (Partition by dead.location Order by dead.location, dead.date) as CumVaccination
From CovidDeaths dead
Join CovidVaccinations vacc
    On dead.location = vacc.location
	and dead.date = vacc.date
where dead.continent is not NULL 
order by 2,3


Select dead.continent, dead.location, dead.date, dead.population
, MAX(vacc.total_vaccinations) as CumVaccination
From CovidDeaths dead
Join CovidVaccinations vacc
	On dead.location = vacc.location
	and dead.date = vacc.date
where dead.continent is not null 
group by dead.continent, dead.location, dead.date, dead.population
order by 1,2,3


Select dead.continent, dead.location, dead.date, dead.population, vacc.new_vaccinations, SUM(CONVERT(int,vacc.new_vaccinations)) 
OVER (Partition by dead.location Order by dead.location, dead.date) as CumVaccination
From CovidDeaths dead
Join CovidVaccinations vacc
    On dead.location = vacc.location
	and dead.date = vacc.date
where dead.continent is not NULL 
order by 2,3


--Cumulative percentage of vaccinations vs. Population
With Popvsvaccin (Continent, location, date, population, new_vaccinations, CumVaccination) as 
(Select dead.continent, dead.location, dead.date, dead.population, vacc.new_vaccinations, SUM(CONVERT(int,vacc.new_vaccinations)) 
OVER (Partition by dead.location Order by dead.location, dead.date) as CumVaccination
From CovidDeaths dead
Join CovidVaccinations vacc
    On dead.location = vacc.location
	and dead.date = vacc.date
where dead.continent is not NULL )
Select *, (CumVaccination/Population)*100
From Popvsvaccin
order by 2,3


--- Data for Visualization:
Create View PercentPopVaccinated as
Select dead.continent, dead.location, dead.date, dead.population, vacc.new_vaccinations, SUM(CONVERT(int,vacc.new_vaccinations)) 
OVER (Partition by dead.location Order by dead.location, dead.date) as CumVaccination
From CovidDeaths dead
Join CovidVaccinations vacc
    On dead.location = vacc.location
	and dead.date = vacc.date
where dead.continent is not NULL

Select *
From PercentPopVaccinated
order by 2,3
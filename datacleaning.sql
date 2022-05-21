select *
from portofolio.dbo.death
order by 3,4

select *
from portofolio.dbo.vacc
order by 3,4

select location, date, total_cases , new_cases, total_deaths, population
from portofolio.dbo.death
 order by 1,2
 
 
 --  Total cases vs total deaths in Egypt

 select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 deaths_percent
from portofolio.dbo.death
where location = 'Egypt'
 order by 1,2
  

-- Total cases vs total deaths in States
 select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 deaths_percent
from portofolio.dbo.death
where location like '%states%'
 order by 1,2
  
-- Total cases vs population
-- percentage of pop got covid in Egypt

 select location, date, total_cases,population ,(total_cases/population)*100 covid_percent
from portofolio.dbo.death
where location = 'Egypt'
 order by 1,2
  
  -- Total cases vs population
-- percentage of pop got covid 
 select location, date, total_cases,population ,(total_cases/population)*100 covid_percent
from portofolio.dbo.death
 order by 1,2

 -- Countries with highest infection rate compared to population
  select location,population , MAx(total_cases) highest_count ,max((total_cases/population))*100 covid_percent
from portofolio.dbo.death
group by location,population
 order by covid_percent desc


 -- Countries with the highest deaths count
  select location, MAx(cast(total_deaths as int)) max_deaths 
from portofolio.dbo.death
where continent is not null
group by location
 order by max_deaths desc

 -- continents with highest death
   select continent, MAx(cast(total_deaths as int)) max_deaths 
from portofolio.dbo.death
where continent is not null
group by continent
 order by max_deaths desc

 -- Global numbers
 Select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) total_deaths,
(sum(cast(new_deaths  as int))/sum(new_cases))*100 as deaths_percent
from portofolio.dbo.death
where continent is not null
order by 1,2

select *
from portofolio.dbo.death  D
join portofolio.dbo.vacc V
on D.location = V.location
and D.date = V.date
order by 3,4

-- Rolling count of vaccinations
select continent, location, date, population, new_vaccinations,
sum(cast(new_vaccinations as bigint)) over (partition by location order by location, date) rolling_count_newvacc
from portofolio.dbo.vacc
where continent is not null
order by 2,3

-- with 
with  population_vacc (continent, location, date, population, new_vaccinations,rolling_vaccinated)
as(select continent, location, date, population, new_vaccinations,
sum(cast(new_vaccinations as bigint)) over (partition by location order by location, date) rolling_vaccinated
from portofolio.dbo.vacc
where continent is not null
)
select * ,(rolling_vaccinated/population)*100
from population_vacc
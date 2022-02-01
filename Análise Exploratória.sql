/* Covid Portfolio Project 


Autor: Rayssa Banti
Date: 05/01/2022

*/

-- Data Exploration

-- Base de mortes
Select  * 
From [PortfolioProject].[dbo].[covid-deaths]
order by 1,2 


-- Base de vacinas 
Select  * 
From [PortfolioProject].[dbo].[covid-vaccinations]
order by 1,2 

alter table [PortfolioProject].[dbo].[covid-vaccinations] alter column [people_fully_vaccinated] bigint  null


-- Casos de covid x Total de Mortes
-- Mostra a chance de morrer se você contrair covid no seu país
Select location as [Localização], date as [Data], total_cases as [Contagem de Casos], total_deaths as [Contagem de Mortes],  (total_deaths / nullif(total_cases,0)) * 100 as [Porcentagem de Mortes com Covid]
from [PortfolioProject].[dbo].[covid-deaths]
where location like '%Brazil%' and  continent <> ''
order by 1,2 


-- Total de Casos x População
-- Mostra a porcentagem da população que contraiu covid
Select location as [Localização], date as [Data], max(total_cases) as [Contagem de Casos], max(population) as [População], max((total_cases/nullif(population,0))) * 100 as [Porcentagem da população com Covid]
from [PortfolioProject].[dbo].[covid-deaths]
where  continent <> ''
group by Location, Population, date
order by [Porcentagem da população com Covid] desc
 


-- Países com a maior taxa de infecção comparado com a População 
Select location as [Localização], population [População],  MAX(total_cases) as [Contagem de Casos], Max((total_cases * 100/nullif(population,0)))  as [Porcentagem da população com Covid]
from [PortfolioProject].[dbo].[covid-deaths]
where  continent <> ''
group by Location, Population
order by  [Porcentagem da população com Covid] desc

-- Mostrando os países com a maior contagem de mortes por população 
Select location as [Localização], MAX(Total_deaths) as [Contagem de Mortes]
from [PortfolioProject].[dbo].[covid-deaths]
where  continent <> ''
group by Location, continent
order by  [Contagem de Mortes] desc


-- Mostrando os continentes com a maior taxa de morte por população 
Select location as [Continente], MAX(Total_deaths) as [Contagem de Mortes]
from [PortfolioProject].[dbo].[covid-deaths]
where  continent = '' and location in ('Europe', 'Asia', 'North America', 'South America', 'Africa', 'Oceania')
group by  location
order by  [Contagem de Mortes] desc



-- Olhando globalmente 
Select SUM(new_cases) as [Contagem de Casos] , sum(new_deaths) as [Contagem de Mortes]
,  SUM(cast(new_deaths as int)*100)/SUM(New_Cases) as [Porcentagem de mortes]
from [PortfolioProject].[dbo].[covid-deaths]
where  continent <> ''




-- Olhando a quantidade de pessoas vacinadas por país
select CD.location, MAX(cv.people_vaccinated) as [Contagem de pessoas Vacinadas], cd.population as [População], 
MAX(cv.people_vaccinated) / nullif(population,0) * 100 as [Porcentagem de pessoas vacinadas]
from [PortfolioProject].[dbo].[covid-deaths] CD
join [dbo].[covid-vaccinations] CV
	on cd.location = cv.location
	and cd.date = cv.date
where  CD.continent <> ''
group by  CD.location, cd.population
order by 1,2


-- Olhando a quantidade de pessoas vacinadas por dia 

select  cd.location as [Localização], cd.date as [Data], cd.population as [População], cv.new_vaccinations as [Novas Vacinações]
, sum(cv.new_vaccinations) over (Partition by cd.location order by cd.location, cd.date) as [Pessoas Vacinadas], cd.new_deaths as [Novas Mortes]
--into [PortfolioProject].[dbo].[populacao_vacinada]
from [PortfolioProject].[dbo].[covid-deaths] CD
join [PortfolioProject].[dbo].[covid-vaccinations] CV
	on cd.location = cv.location
	and cd.date = cv.date
where  CD.continent <> '' 
order by 1,2

select pv.*, ([Pessoas Vacinadas]* 100/nullif( [População],0) ) as [Taxa de Pessoas Vacinadas]
from [PortfolioProject].[dbo].[populacao_vacinada] PV
where [Localização] = 'Brazil'
GROUP BY DATEADD(MONTH, DATEDIFF(MONTH, 0, [Data]),0)



-- Criando View para ajudar depois 
CREATE VIEW 
PessoasVacinadasPorLocalizacaoTempo as 
select pv.*, (PessoasVacinadas/nullif(population,0) * 100) as TotalPessoasVacinadas
from [PortfolioProject].[dbo].[Population_Vaccinations] PV






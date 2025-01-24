CREATE DATABASE Netflix
USE Netflix

--Netflix Project

SELECT * FROM netflix_project

SELECT COUNT (*) AS total_content FROM netflix_project

SELECT DISTINCT type FROM netflix_project

--Business Problems and Solutions

--1. Count the Number of Movies vs TV Shows

SELECT type, COUNT (*) AS total_content FROM netflix_project GROUP BY type  

--2. Find the Most Common Rating for Movies and TV Shows

SELECT type, rating FROM netflix_project

SELECT type, rating FROM
(SELECT type, rating, 
COUNT(*) AS total_count, 
RANK() OVER(PARTITION BY TYPE ORDER BY COUNT (*) DESC) AS ranking 
FROM netflix_project GROUP BY type, rating) AS t1
WHERE ranking = 1

--3.List All Movies Released in a Specific Year (e.g., 2020)

SELECT title FROM netflix_project WHERE release_year = 2020 and type ='Movie'

--4.Find the Top 5 Countries with the Most Content on Netflix

SELECT TOP 5
    new_country,
    COUNT(*) AS country_count
FROM 
    (SELECT 
        Split.a.value('.', 'VARCHAR(100)') AS new_country
     FROM 
        (SELECT CAST('<X>' + REPLACE(country, ',', '</X><X>') + '</X>' AS XML) AS xml_country
         FROM netflix_project) AS Data
     CROSS APPLY xml_country.nodes('/X') AS Split(a)) AS SplitCountries
GROUP BY new_country
ORDER BY country_count DESC

--5. Identify the Longest Movie

SELECT * FROM netflix_project WHERE type = 'movie' AND duration = (SELECT MAX(duration) FROM netflix_project)

--6. Find Content Added in the Last 5 Years

SELECT * 
FROM netflix_project 
WHERE CAST(date_added AS DATE) >= DATEADD(YEAR, -5, GETDATE());

--7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT * 
FROM netflix_project 
WHERE director LIKE '%Rajiv Chilaka%' COLLATE SQL_Latin1_General_CP1_CI_AS;

--8. List All TV Shows with More Than 5 Seasons

SELECT * FROM netflix_project WHERE type = 'TV Show'
AND CAST(SUBSTRING(duration, 1, CHARINDEX(' ', duration) - 1) AS INT) > 5

--9. Count the Number of Content Items in Each Genre

SELECT 
    value AS genre, 
    COUNT(*) AS total_content
FROM netflix_project
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY value
ORDER BY total_content DESC

--10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        CAST(COUNT(show_id) AS FLOAT) / 
        (SELECT COUNT(show_id) FROM netflix_project WHERE country = 'India') * 100, 2
    ) AS avg_release
FROM netflix_project
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY

--11. List All Movies that are Documentaries

SELECT * FROM netflix_project WHERE listed_in LIKE '%Documentaries%' COLLATE SQL_Latin1_General_CP1_CI_AS;

--12. Find All Content Without a Director

SELECT * FROM netflix_project
WHERE director IS NULL

--13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * 
FROM netflix_project
WHERE cast LIKE '%Salman Khan%'
  AND release_year > YEAR(GETDATE()) - 10

--14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India.

SELECT 
    value AS actor, 
    COUNT(*) AS total_count
FROM netflix_project
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE country = 'India'
GROUP BY value
ORDER BY total_count DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

--15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description LIKE '%kill%' COLLATE SQL_Latin1_General_CP1_CI_AS 
                 OR description LIKE '%violence%' COLLATE SQL_Latin1_General_CP1_CI_AS 
            THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix_project
) AS categorized_content
GROUP BY category
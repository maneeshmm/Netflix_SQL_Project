# Netflix_SQL_Project
![Netflix Logo](https://github.com/maneeshmm/Netflix_SQL_Project/blob/main/download.png)


Overview
This project involves a detailed analysis of Netflix's movies and TV shows dataset using SQL. The goal of the project is to derive actionable insights and answer various business-related questions based on the dataset. The analysis covers different aspects of Netflix's content, including content types, ratings, release years, countries, genres, directors, and actors.

Objectives
Analyze the distribution of content types (movies vs TV shows).
Identify the most common ratings for movies and TV shows.
List and analyze content based on release years, countries, and durations.
Explore and categorize content based on specific keywords such as "kill" and "violence".
Dataset
The data used in this project is sourced from the Netflix movies and TV shows dataset available on Kaggle. The dataset contains detailed information about various shows and movies available on Netflix, such as:

Show ID
Title
Type (Movie/TV Show)
Country
Release Year
Duration
Genres
Director
Cast
Description
Date Added
SQL Queries
Below are the main queries used to analyze the dataset:

1. Count the Number of Movies vs TV Shows
sql
Copy
Edit
SELECT type, COUNT (*) AS total_content FROM netflix_project GROUP BY type;
This query calculates the number of movies and TV shows present in the dataset by grouping by the type column.

2. Find the Most Common Rating for Movies and TV Shows
sql
Copy
Edit
SELECT type, rating FROM
(SELECT type, rating, 
COUNT(*) AS total_count, 
RANK() OVER(PARTITION BY TYPE ORDER BY COUNT (*) DESC) AS ranking 
FROM netflix_project GROUP BY type, rating) AS t1
WHERE ranking = 1;
This query identifies the most common ratings for movies and TV shows by ranking the ratings and selecting the most frequent ones.

3. List All Movies Released in a Specific Year (e.g., 2020)
sql
Copy
Edit
SELECT title FROM netflix_project WHERE release_year = 2020 AND type ='Movie';
This query retrieves all movie titles that were released in the year 2020.

4. Find the Top 5 Countries with the Most Content on Netflix
sql
Copy
Edit
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
ORDER BY country_count DESC;
This query splits the country column into individual countries and counts the number of occurrences for each country, returning the top 5 countries with the most content.

5. Identify the Longest Movie
sql
Copy
Edit
SELECT * FROM netflix_project WHERE type = 'movie' AND duration = (SELECT MAX(duration) FROM netflix_project);
This query finds the movie with the longest duration.

6. Find Content Added in the Last 5 Years
sql
Copy
Edit
SELECT * 
FROM netflix_project 
WHERE CAST(date_added AS DATE) >= DATEADD(YEAR, -5, GETDATE());
This query retrieves all content added to Netflix in the last 5 years.

7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
sql
Copy
Edit
SELECT * 
FROM netflix_project 
WHERE director LIKE '%Rajiv Chilaka%' COLLATE SQL_Latin1_General_CP1_CI_AS;
This query finds all content directed by Rajiv Chilaka.

8. List All TV Shows with More Than 5 Seasons
sql
Copy
Edit
SELECT * FROM netflix_project WHERE type = 'TV Show'
AND CAST(SUBSTRING(duration, 1, CHARINDEX(' ', duration) - 1) AS INT) > 5;
This query lists all TV shows that have more than 5 seasons.

9. Count the Number of Content Items in Each Genre
sql
Copy
Edit
SELECT 
    value AS genre, 
    COUNT(*) AS total_content
FROM netflix_project
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY value
ORDER BY total_content DESC;
This query splits the genres listed in the listed_in column and counts the number of content items in each genre.

10. Find Each Year and the Average Number of Content Releases in India
sql
Copy
Edit
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
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
This query calculates the average number of content releases in India by year and returns the top 5 years with the highest average release.

11. List All Movies that are Documentaries
sql
Copy
Edit
SELECT * FROM netflix_project WHERE listed_in LIKE '%Documentaries%' COLLATE SQL_Latin1_General_CP1_CI_AS;
This query retrieves all movies classified as documentaries.

12. Find All Content Without a Director
sql
Copy
Edit
SELECT * FROM netflix_project
WHERE director IS NULL;
This query retrieves all content items that don't have a director listed.

13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
sql
Copy
Edit
SELECT * 
FROM netflix_project
WHERE cast LIKE '%Salman Khan%'
  AND release_year > YEAR(GETDATE()) - 10;
This query retrieves all movies or TV shows that Salman Khan appeared in during the last 10 years.

14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
sql
Copy
Edit
SELECT 
    value AS actor, 
    COUNT(*) AS total_count
FROM netflix_project
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE country = 'India'
GROUP BY value
ORDER BY total_count DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
This query identifies the top 10 actors who have appeared in the highest number of movies produced in India.

15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
sql
Copy
Edit
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
GROUP BY category;
This query categorizes content as 'Bad' if it contains the keywords "kill" or "violence" and counts the number of 'Good' and 'Bad' content items.

Conclusions
The dataset provides valuable insights into Netflix's content distribution, including the number of movies vs TV shows, most common ratings, and the most frequent countries for Netflix content.
Specific trends, such as the popularity of directors, actors, and the release patterns over the years, can be extracted from the data.
Keywords like "kill" and "violence" provide a way to categorize content based on specific themes or topics.
License
This project is licensed under the MIT License.

This README provides a comprehensive guide to the analysis performed in the Netflix SQL Analysis Project, detailing the objectives, dataset, and key SQL queries used to extract insights.

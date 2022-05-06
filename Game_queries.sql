-- First glance at the data

SELECT * 
FROM 
project..games

-- Break up into separate tables for joining

-- GAME INFO
SELECT
Name,
Platform,
Year_of_Release AS year,
Genre,
Publisher,
Developer,
Rating INTO game_info
FROM
project..games

-- GAME SALES
SELECT
Name,
Year_of_Release,
NA_Sales,
EU_Sales,
JP_Sales,
Other_Sales,
Global_Sales
INTO game_sales
FROM
project..games

-- CRITIC SCORES/COUNTS
SELECT
Name,
Year_of_Release,
Critic_Score,
Critic_Count
INTO critic_scorecount
FROM
project..games
WHERE
Critic_Score IS NOT NULL AND
Critic_Count IS NOT NULL

-- USER INFO

SELECT
Name,
Year_of_Release,
User_Count,
User_Score
INTO user_scorecount
FROM
project..games
WHERE 
USER_COUNT IS NOT NULL AND
USER_SCORE IS NOT NULL

-- Query top 10 Global Sales
SELECT TOP 10
i.Name,
s.Year_of_Release,
s.Global_Sales
FROM
project..game_info as i
INNER JOIN project..game_sales AS s
ON i.name = s.name 
ORDER BY Global_Sales DESC

-- TOP 10 DEVELOPERS by GLOBAL SALES
SELECT TOP 10
i.Developer,
SUM(s.Global_Sales) AS total_sales
FROM
project..game_info as i
INNER JOIN project..game_sales AS s
ON i.name = s.name 
WHERE Developer IS NOT NULL
GROUP BY Developer
ORDER BY total_sales DESC

-- TOP 10 PLATFORMS BY GLOBAL SALES
SELECT TOP 10
i.Platform,
SUM(s.Global_Sales) AS total_sales
FROM
project..game_info as i
INNER JOIN project..game_sales AS s
ON i.name = s.name 
WHERE Platform IS NOT NULL
GROUP BY Platform
ORDER BY total_sales DESC

-- TOTAL GAME SALES BY YEAR
SELECT
s.Year_of_Release,
SUM(s.Global_Sales) AS total_sales
FROM
project..game_info as i
INNER JOIN project..game_sales AS s
ON i.name = s.name 
WHERE Platform IS NOT NULL
GROUP BY s.Year_of_Release
ORDER BY s.Year_of_Release DESC

















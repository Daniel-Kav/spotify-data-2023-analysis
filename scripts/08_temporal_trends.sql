-- 1. How has the distribution of song valence percentages changed over the months in 2023?
SELECT 
    MONTHNAME(STR_TO_DATE(released_month, '%m')) AS month_name,
    AVG(valence_percentage) AS avg_valence,
    COUNT(*) AS song_count
FROM spotify_data
WHERE released_year = 2023
GROUP BY released_month, month_name
ORDER BY released_month;

-- 2. Are there any noticeable trends in the key of songs over the years?
SELECT 
    released_year,
    `key`,
    COUNT(*) AS song_count
FROM spotify_data
WHERE released_year >= 2010  -- Focus on recent years
GROUP BY released_year, `key`
ORDER BY released_year, song_count DESC;

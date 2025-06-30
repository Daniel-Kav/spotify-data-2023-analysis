-- 1. Is there a noticeable difference in danceability percentages between songs in major and minor modes?
SELECT 
    mode,
    AVG(danceability_percentage) AS avg_danceability
FROM spotify_data
WHERE mode IN ('Major', 'Minor')
GROUP BY mode;

-- 2. How does the distribution of acousticness percentages vary across different keys?
SELECT 
    `key`,
    AVG(acousticness_percentage) AS avg_acousticness,
    COUNT(*) AS song_count
FROM spotify_data
GROUP BY `key`
ORDER BY avg_acousticness DESC;

-- 3. Are there any trends in the energy levels of songs over the years?
SELECT 
    released_year,
    AVG(energy_percentage) AS avg_energy
FROM spotify_data
WHERE released_year >= 2000  -- Focus on recent years
GROUP BY released_year
ORDER BY released_year;

-- 4. What are the most common song keys for the entire dataset?
SELECT 
    `key`,
    COUNT(*) AS song_count
FROM spotify_data
GROUP BY `key`
ORDER BY song_count DESC;

-- 1. What are the top 5 most streamed songs in 2023?
SELECT track_name, artist_name, streams
FROM spotify_data
WHERE released_year = 2023
ORDER BY CAST(streams AS UNSIGNED) DESC
LIMIT 5;

-- 2. How many unique artists contributed to the dataset?
SELECT COUNT(DISTINCT artist_name) AS unique_artists
FROM spotify_data;

-- 3. What is the distribution of songs across different release years?
SELECT released_year, COUNT(*) AS song_count
FROM spotify_data
GROUP BY released_year
ORDER BY song_count DESC;

-- 4. Who are the top 10 artists based on popularity, and what are their tracks' average danceability and energy?
SELECT 
    artist_name,
    AVG(danceability_percentage) AS avg_danceability,
    AVG(energy_percentage) AS avg_energy
FROM spotify_data
GROUP BY artist_name
ORDER BY AVG(danceability_percentage + energy_percentage) / 2 DESC
LIMIT 10;

-- 5. What artists released the longest and the shortest songs?
-- Longest song
SELECT track_name, artist_name, duration_ms
FROM spotify_data
ORDER BY duration_ms DESC
LIMIT 1;

-- Shortest song
SELECT track_name, artist_name, duration_ms
FROM spotify_data
WHERE duration_ms > 0
ORDER BY duration_ms ASC
LIMIT 1;

-- 6. What is the average tempo of songs released in 2023?
SELECT AVG(tempo) AS avg_tempo
FROM spotify_data
WHERE released_year = 2023;

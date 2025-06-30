-- 1. What is the distribution of key and mode combinations across the dataset?
SELECT 
    CONCAT(`key`, '-', mode) AS key_mode,
    COUNT(*) AS song_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM spotify_data), 2) AS percentage
FROM spotify_data
WHERE `key` IS NOT NULL AND mode IS NOT NULL
GROUP BY key_mode
ORDER BY song_count DESC;

-- 2. How do speechiness percentages vary for songs in different Apple Music playlists?
SELECT 
    CASE 
        WHEN in_apple_playlists = 0 THEN 'Not in Apple Playlists'
        WHEN in_apple_playlists < 100 THEN '1-99 Playlists'
        WHEN in_apple_playlists < 1000 THEN '100-999 Playlists'
        ELSE '1000+ Playlists'
    END AS apple_playlist_category,
    AVG(speechiness_percentage) AS avg_speechiness,
    COUNT(*) AS song_count
FROM spotify_data
GROUP BY apple_playlist_category
ORDER BY apple_playlist_category;

-- 3. Are there any patterns in the release days of songs that make it to the charts?
SELECT 
    DAYNAME(STR_TO_DATE(CONCAT(released_year, '-', 
                             LPAD(released_month, 2, '0'), '-', 
                             LPAD(released_day, 2, '0')), '%Y-%m-%d')) AS day_of_week,
    COUNT(*) AS song_count
FROM spotify_data
WHERE in_spotify_charts > 0 OR in_apple_charts > 0 OR in_deezer_charts > 0
  AND released_year IS NOT NULL 
  AND released_month IS NOT NULL 
  AND released_day IS NOT NULL
GROUP BY day_of_week
ORDER BY 
    FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- 4. How do instrumentalness percentages correlate with energy levels?
SELECT 
    FLOOR(instrumentalness_percentage/10)*10 AS instrumentalness_range,
    AVG(energy_percentage) AS avg_energy,
    COUNT(*) AS song_count
FROM spotify_data
GROUP BY instrumentalness_range
HAVING song_count >= 5  -- Only include ranges with sufficient data
ORDER BY instrumentalness_range;

-- 5. Can we identify any outliers or anomalies in the dataset based on various features?
-- Example: Find songs with unusually high or low values for certain metrics
SELECT 
    track_name,
    artist_name,
    'High BPM' AS outlier_type,
    bpm AS value
FROM spotify_data
WHERE bpm > 200

UNION ALL

SELECT 
    track_name,
    artist_name,
    'Low Danceability' AS outlier_type,
    danceability_percentage AS value
FROM spotify_data
WHERE danceability_percentage < 20

UNION ALL

SELECT 
    track_name,
    artist_name,
    'High Energy' AS outlier_type,
    energy_percentage AS value
FROM spotify_data
WHERE energy_percentage > 90

ORDER BY outlier_type, value DESC;

-- 6. Create a table with the popularity rankings for each song key.
WITH key_popularity AS (
    SELECT 
        `key`,
        AVG(CAST(streams AS UNSIGNED)) AS avg_streams,
        COUNT(*) AS song_count
    FROM spotify_data
    WHERE streams IS NOT NULL AND streams != ''
    GROUP BY `key`
    HAVING song_count >= 10  -- Only include keys with sufficient data
)
SELECT 
    `key`,
    avg_streams,
    song_count,
    RANK() OVER (ORDER BY avg_streams DESC) AS popularity_rank
FROM key_popularity
ORDER BY popularity_rank;

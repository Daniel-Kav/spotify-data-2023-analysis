-- Advanced Analysis Script for Spotify Data
-- This script demonstrates advanced SQL capabilities for data analysis

-- 1. Time Series Analysis: Monthly trends in song releases and popularity
WITH monthly_stats AS (
    SELECT 
        released_year,
        released_month,
        COUNT(*) AS songs_released,
        AVG(streams) AS avg_streams,
        AVG(danceability_percentage) AS avg_danceability,
        AVG(energy_percentage) AS avg_energy,
        ROW_NUMBER() OVER (PARTITION BY released_year ORDER BY COUNT(*) DESC) AS month_rank
    FROM cleaned_songs
    WHERE released_year IS NOT NULL AND released_month IS NOT NULL
    GROUP BY released_year, released_month
)
SELECT 
    CONCAT(released_year, '-', LPAD(released_month, 2, '0')) AS year_month,
    songs_released,
    ROUND(avg_streams) AS avg_streams,
    ROUND(avg_danceability, 1) AS avg_danceability,
    ROUND(avg_energy, 1) AS avg_energy
FROM monthly_stats
ORDER BY released_year, released_month
LIMIT 12;

-- 2. Artist Impact Analysis: Top artists by platform presence
WITH artist_platforms AS (
    SELECT 
        a.artist_name,
        COUNT(DISTINCT s.track_id) AS total_songs,
        SUM(s.in_spotify_playlists) AS spotify_playlists,
        SUM(s.in_apple_playlists) AS apple_playlists,
        SUM(s.in_deezer_playlists) AS deezer_playlists,
        SUM(COALESCE(s.in_spotify_charts, 0) + 
            COALESCE(s.in_apple_charts, 0) + 
            COALESCE(s.in_deezer_charts, 0)) AS total_chart_appearances
    FROM songs s
    JOIN artists a ON s.artist_id = a.artist_id
    GROUP BY a.artist_name
    HAVING total_songs >= 3  -- Only consider artists with 3+ songs
)
SELECT 
    artist_name,
    total_songs,
    spotify_playlists,
    apple_playlists,
    deezer_playlists,
    total_chart_appearances,
    RANK() OVER (ORDER BY total_chart_appearances DESC) AS chart_rank
FROM artist_platforms
ORDER BY total_chart_appearances DESC
LIMIT 10;

-- 3. Audio Feature Correlations
WITH feature_correlations AS (
    SELECT 
        'danceability' AS feature1, 
        'energy' AS feature2,
        ROUND(CORR(danceability_percentage, energy_percentage), 3) AS correlation
    FROM cleaned_songs
    WHERE danceability_percentage IS NOT NULL AND energy_percentage IS NOT NULL
    
    UNION ALL
    
    SELECT 
        'danceability', 
        'valence',
        ROUND(CORR(danceability_percentage, valence_percentage), 3)
    FROM cleaned_songs
    WHERE danceability_percentage IS NOT NULL AND valence_percentage IS NOT NULL
    
    UNION ALL
    
    SELECT 
        'energy', 
        'valence',
        ROUND(CORR(energy_percentage, valence_percentage), 3)
    FROM cleaned_songs
    WHERE energy_percentage IS NOT NULL AND valence_percentage IS NOT NULL
    
    UNION ALL
    
    SELECT 
        'acousticness', 
        'energy',
        ROUND(CORR(acousticness_percentage, energy_percentage), 3)
    FROM cleaned_songs
    WHERE acousticness_percentage IS NOT NULL AND energy_percentage IS NOT NULL
)
SELECT * FROM feature_correlations
ORDER BY ABS(correlation) DESC;

-- 4. Platform-Specific Performance Analysis
WITH platform_performance AS (
    SELECT 
        track_name,
        artist_name,
        streams,
        in_spotify_playlists,
        in_apple_playlists,
        in_deezer_playlists,
        (COALESCE(in_spotify_playlists, 0) * 0.4 + 
         COALESCE(in_apple_playlists, 0) * 0.3 + 
         COALESCE(in_deezer_playlists, 0) * 0.3) AS weighted_platform_score,
        RANK() OVER (ORDER BY streams DESC) AS streams_rank,
        RANK() OVER (ORDER BY in_spotify_playlists DESC) AS spotify_rank,
        RANK() OVER (ORDER BY in_apple_playlists DESC) AS apple_rank,
        RANK() OVER (ORDER BY in_deezer_playlists DESC) AS deezer_rank
    FROM cleaned_songs
    WHERE streams IS NOT NULL
)
SELECT 
    track_name,
    artist_name,
    streams,
    in_spotify_playlists,
    in_apple_playlists,
    in_deezer_playlists,
    ROUND(weighted_platform_score) AS platform_score,
    streams_rank,
    spotify_rank,
    apple_rank,
    deezer_rank,
    (streams_rank + spotify_rank + apple_rank + deezer_rank) / 4 AS avg_rank
FROM platform_performance
ORDER BY weighted_platform_score DESC
LIMIT 15;

-- 5. Temporal Pattern Analysis: Best time to release a song
WITH monthly_avg AS (
    SELECT 
        released_month,
        MONTHNAME(STR_TO_DATE(CONCAT('2023-', LPAD(released_month, 2, '0'), '-01'), '%Y-%m-%d')) AS month_name,
        COUNT(*) AS songs_released,
        AVG(streams) AS avg_streams,
        AVG(in_spotify_playlists) AS avg_spotify_playlists,
        AVG(in_apple_playlists) AS avg_apple_playlists,
        AVG(in_deezer_playlists) AS avg_deezer_playlists,
        AVG(danceability_percentage) AS avg_danceability,
        AVG(energy_percentage) AS avg_energy
    FROM cleaned_songs
    WHERE released_year = 2023 AND released_month IS NOT NULL
    GROUP BY released_month, month_name
    HAVING COUNT(*) >= 5  -- Only include months with enough data
)
SELECT 
    month_name,
    songs_released,
    ROUND(avg_streams) AS avg_streams,
    ROUND(avg_spotify_playlists) AS avg_spotify_playlists,
    ROUND(avg_apple_playlists) AS avg_apple_playlists,
    ROUND(avg_deezer_playlists) AS avg_deezer_playlists,
    ROUND(avg_danceability, 1) AS avg_danceability,
    ROUND(avg_energy, 1) AS avg_energy,
    RANK() OVER (ORDER BY avg_streams DESC) AS streams_rank,
    RANK() OVER (ORDER BY (avg_spotify_playlists + avg_apple_playlists + avg_deezer_playlists) / 3 DESC) AS playlist_rank
FROM monthly_avg
ORDER BY released_month;

-- 6. Audio Feature Clusters (using NTILE for simple clustering)
WITH feature_clusters AS (
    SELECT 
        track_name,
        artist_name,
        danceability_percentage,
        energy_percentage,
        valence_percentage,
        acousticness_percentage,
        NTILE(4) OVER (ORDER BY danceability_percentage) AS danceability_quartile,
        NTILE(4) OVER (ORDER BY energy_percentage) AS energy_quartile,
        NTILE(4) OVER (ORDER BY valence_percentage) AS valence_quartile,
        NTILE(4) OVER (ORDER BY acousticness_percentage) AS acousticness_quartile
    FROM cleaned_songs
    WHERE danceability_percentage IS NOT NULL 
      AND energy_percentage IS NOT NULL
      AND valence_percentage IS NOT NULL
      AND acousticness_percentage IS NOT NULL
)
SELECT 
    CONCAT('Danceability: ', danceability_quartile, 
           ', Energy: ', energy_quartile,
           ', Valence: ', valence_quartile,
           ', Acousticness: ', acousticness_quartile) AS feature_profile,
    COUNT(*) AS song_count,
    AVG(danceability_percentage) AS avg_danceability,
    AVG(energy_percentage) AS avg_energy,
    AVG(valence_percentage) AS avg_valence,
    AVG(acousticness_percentage) AS avg_acousticness
FROM feature_clusters
GROUP BY danceability_quartile, energy_quartile, valence_quartile, acousticness_quartile
HAVING COUNT(*) >= 5
ORDER BY song_count DESC
LIMIT 10;

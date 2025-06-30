-- 1. Do songs with higher valence percentages tend to have more streams on Spotify?
-- Note: This would typically be calculated with a correlation coefficient
-- but we can see the relationship with:
SELECT 
    FLOOR(valence_percentage/10)*10 AS valence_range,
    AVG(CAST(streams AS UNSIGNED)) AS avg_streams,
    COUNT(*) AS song_count
FROM spotify_data
WHERE streams IS NOT NULL AND streams != ''
GROUP BY valence_range
ORDER BY valence_range;

-- 2. Is there a relationship between the number of Spotify playlists and the presence on Apple Music charts?
SELECT 
    CASE 
        WHEN in_apple_charts > 0 THEN 'In Apple Charts'
        ELSE 'Not in Apple Charts'
    END AS apple_charts_status,
    AVG(in_spotify_playlists) AS avg_spotify_playlists,
    COUNT(*) AS song_count
FROM spotify_data
GROUP BY apple_charts_status;

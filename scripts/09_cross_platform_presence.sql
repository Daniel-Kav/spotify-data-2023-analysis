-- 1. Which songs have a significant presence across Spotify, Apple Music, Deezer, and Shazam?
SELECT 
    track_name,
    artist_name,
    in_spotify_playlists,
    in_apple_playlists,
    in_deezer_playlists,
    in_shazam_charts
FROM spotify_data
WHERE in_spotify_playlists > 0
  AND in_apple_playlists > 0
  AND in_deezer_playlists > 0
  AND in_shazam_charts > 0
ORDER BY in_spotify_playlists + in_apple_playlists + in_deezer_playlists + in_shazam_charts DESC
LIMIT 10;

-- 2. How does the distribution of streams on Spotify compare to the presence on Apple Music charts?
SELECT 
    CASE 
        WHEN in_apple_charts > 0 THEN 'In Apple Charts'
        ELSE 'Not in Apple Charts'
    END AS apple_charts_status,
    AVG(CAST(streams AS UNSIGNED)) AS avg_spotify_streams,
    COUNT(*) AS song_count
FROM spotify_data
WHERE streams IS NOT NULL AND streams != ''
GROUP BY apple_charts_status;

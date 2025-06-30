-- 1. How many songs made it to both Apple Music charts and Spotify charts?
SELECT COUNT(*) AS songs_in_both_charts
FROM spotify_data
WHERE in_apple_charts > 0 AND in_spotify_charts > 0;

-- 2. Do songs in Apple Music playlists have higher valence percentages on average?
SELECT 
    CASE 
        WHEN in_apple_playlists > 0 THEN 'In Apple Playlists'
        ELSE 'Not in Apple Playlists'
    END AS playlist_status,
    AVG(valence_percentage) AS avg_valence_percentage
FROM spotify_data
GROUP BY playlist_status;

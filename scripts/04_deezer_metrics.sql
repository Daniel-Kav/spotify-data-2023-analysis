-- 1. Are there any trends in the presence of songs on Deezer charts based on the release month?
SELECT 
    MONTHNAME(STR_TO_DATE(released_month, '%m')) AS month_name,
    COUNT(*) AS songs_in_deezer_charts
FROM spotify_data
WHERE in_deezer_charts > 0
GROUP BY released_month, month_name
ORDER BY released_month;

-- 2. How many songs are common between Deezer and Spotify playlists?
SELECT COUNT(*) AS songs_in_both_platforms
FROM spotify_data
WHERE in_deezer_playlists > 0 AND in_spotify_playlists > 0;

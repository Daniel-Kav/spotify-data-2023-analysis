-- 1. Which song is present in the highest number of Spotify playlists?
SELECT track_name, artist_name, in_spotify_playlists
FROM spotify_data
ORDER BY in_spotify_playlists DESC
LIMIT 1;

-- 2. Is there a correlation between the number of streams and a song's presence in Spotify charts?
-- This would typically be calculated using a correlation coefficient in a statistical tool,
-- but we can see the relationship with a query like this:
SELECT 
    track_name,
    streams,
    in_spotify_charts,
    (in_spotify_charts / NULLIF(CAST(streams AS UNSIGNED), 0)) * 1000000 AS streams_per_chart_appearance
FROM spotify_data
WHERE in_spotify_charts > 0
ORDER BY streams_per_chart_appearance DESC
LIMIT 10;

-- 3. What is the average BPM (Beats Per Minute) of songs on Spotify?
SELECT AVG(bpm) AS average_bpm
FROM spotify_data;

-- 4. What is the average danceability of the top 15 most popular songs?
WITH top_songs AS (
    SELECT track_name, danceability_percentage
    FROM spotify_data
    ORDER BY CAST(streams AS UNSIGNED) DESC
    LIMIT 15
)
SELECT AVG(danceability_percentage) AS avg_danceability_top_15
FROM top_songs;

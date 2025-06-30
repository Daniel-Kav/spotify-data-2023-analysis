-- 1. What is the average number of artists contributing to a song that makes it to the charts?
SELECT AVG(artist_count) AS avg_artists_per_song
FROM (
    SELECT 
        track_name,
        LENGTH(artist_name) - LENGTH(REPLACE(artist_name, ',', '')) + 1 AS artist_count
    FROM spotify_data
    WHERE in_spotify_charts > 0 OR in_apple_charts > 0 OR in_deezer_charts > 0
) AS artist_counts;

-- 2. Do songs with a higher number of artists tend to have higher or lower danceability percentages?
SELECT 
    CASE 
        WHEN LENGTH(artist_name) - LENGTH(REPLACE(artist_name, ',', '')) + 1 > 1 THEN 'Collaboration (2+ artists)'
        ELSE 'Solo or Duet (1-2 artists)'
    END AS collaboration_type,
    AVG(danceability_percentage) AS avg_danceability,
    COUNT(*) AS song_count
FROM spotify_data
GROUP BY collaboration_type;

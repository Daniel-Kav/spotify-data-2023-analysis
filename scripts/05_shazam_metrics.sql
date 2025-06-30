-- 1. Do songs that perform well on Shazam charts have higher danceability percentages?
SELECT 
    CASE 
        WHEN in_shazam_charts > 0 THEN 'In Shazam Charts'
        ELSE 'Not in Shazam Charts'
    END AS shazam_status,
    AVG(danceability_percentage) AS avg_danceability
FROM spotify_data
GROUP BY shazam_status;

-- 2. What is the distribution of speechiness percentages for songs on Shazam charts?
SELECT 
    FLOOR(speechiness_percentage/10)*10 AS speechiness_range,
    COUNT(*) AS song_count
FROM spotify_data
WHERE in_shazam_charts > 0
GROUP BY speechiness_range
ORDER BY speechiness_range;

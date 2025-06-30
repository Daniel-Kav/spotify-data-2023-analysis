-- 1. Is there a correlation between BPM and danceability percentages?
-- Note: This would typically be calculated with a statistical function,
-- but we can see the relationship with:
SELECT 
    track_name,
    bpm,
    danceability_percentage
FROM spotify_data
ORDER BY ABS(bpm - 120) ASC, danceability_percentage DESC
LIMIT 20;

-- 2. How does the presence of live performance elements (liveness) correlate with acousticness percentages?
SELECT 
    CASE 
        WHEN liveness_percentage > 50 THEN 'High Liveness'
        ELSE 'Low Liveness'
    END AS liveness_level,
    AVG(acousticness_percentage) AS avg_acousticness,
    COUNT(*) AS song_count
FROM spotify_data
GROUP BY liveness_level;

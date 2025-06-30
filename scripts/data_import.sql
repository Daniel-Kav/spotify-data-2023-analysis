-- Data Import Script for Spotify Analysis
-- This script handles the import of CSV data into the database

-- First, ensure the database and tables are created
SOURCE ../database_schema.sql;

-- Set session variables for data import
SET GLOBAL local_infile = 1;
SET SESSION sql_mode = ''; -- Temporarily disable strict mode for data import

-- Load data from CSV into temporary table
CREATE TEMPORARY TABLE temp_import (
    track_id VARCHAR(50),
    track_name VARCHAR(255),
    artist_name VARCHAR(255),
    artist_count INT,
    released_year INT,
    released_month INT,
    released_day INT,
    in_spotify_playlists INT,
    in_spotify_charts INT,
    streams VARCHAR(20), -- Storing as string to handle potential formatting
    in_apple_playlists INT,
    in_apple_charts INT,
    in_deezer_playlists INT,
    in_deezer_charts INT,
    in_shazam_charts INT,
    bpm INT,
    `key` VARCHAR(5),
    mode VARCHAR(10),
    danceability_percentage INT,
    valence_percentage INT,
    energy_percentage INT,
    acousticness_percentage INT,
    instrumentalness_percentage INT,
    liveness_percentage INT,
    speechiness_percentage INT
);

-- Load data from CSV
LOAD DATA LOCAL INFILE '../dataset/spotify-2023.csv' 
INTO TABLE temp_import
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(track_id, track_name, artist_name, @artist_count, 
 @released_year, @released_month, @released_day,
 @in_spotify_playlists, @in_spotify_charts, streams,
 @in_apple_playlists, @in_apple_charts,
 @in_deezer_playlists, @in_deezer_charts, @in_shazam_charts,
 @bpm, `key`, mode,
 @danceability, @valence, @energy,
 @acousticness, @instrumentalness, @liveness, @speechiness)
SET 
    artist_count = NULLIF(@artist_count, ''),
    released_year = NULLIF(@released_year, ''),
    released_month = NULLIF(@released_month, ''),
    released_day = NULLIF(@released_day, ''),
    in_spotify_playlists = NULLIF(@in_spotify_playlists, ''),
    in_spotify_charts = NULLIF(@in_spotify_charts, ''),
    in_apple_playlists = NULLIF(@in_apple_playlists, ''),
    in_apple_charts = NULLIF(@in_apple_charts, ''),
    in_deezer_playlists = NULLIF(@in_deezer_playlists, ''),
    in_deezer_charts = NULLIF(@in_deezer_charts, ''),
    in_shazam_charts = NULLIF(@in_shazam_charts, ''),
    bpm = NULLIF(@bpm, ''),
    danceability_percentage = NULLIF(REPLACE(@danceability, '%', ''), ''),
    valence_percentage = NULLIF(REPLACE(@valence, '%', ''), ''),
    energy_percentage = NULLIF(REPLACE(@energy, '%', ''), ''),
    acousticness_percentage = NULLIF(REPLACE(@acousticness, '%', ''), ''),
    instrumentalness_percentage = NULLIF(REPLACE(@instrumentalness, '%', ''), ''),
    liveness_percentage = NULLIF(REPLACE(@liveness, '%', ''), ''),
    speechiness_percentage = NULLIF(REPLACE(@speechiness, '%', ''), '');

-- Insert artists first to avoid foreign key constraints
INSERT IGNORE INTO artists (artist_name)
SELECT DISTINCT TRIM(SUBSTRING_INDEX(artist_name, ',', -1)) AS single_artist
FROM temp_import
WHERE artist_name IS NOT NULL AND artist_name != ''
UNION
SELECT DISTINCT TRIM(SUBSTRING_INDEX(artist_name, ',', 1)) AS single_artist
FROM temp_import
WHERE artist_name LIKE '%,%' AND artist_name IS NOT NULL AND artist_name != '';

-- Insert data into songs table
INSERT INTO songs (
    track_id, track_name, artist_id, artist_count,
    released_date, in_spotify_playlists, in_spotify_charts, streams,
    in_apple_playlists, in_apple_charts, in_deezer_playlists,
    in_deezer_charts, in_shazam_charts, bpm, `key`, mode,
    danceability_percentage, valence_percentage, energy_percentage,
    acousticness_percentage, instrumentalness_percentage,
    liveness_percentage, speechiness_percentage
)
SELECT 
    ti.track_id,
    ti.track_name,
    a.artist_id,
    ti.artist_count,
    CASE 
        WHEN ti.released_year IS NOT NULL AND ti.released_month IS NOT NULL AND ti.released_day IS NOT NULL
        THEN STR_TO_DATE(CONCAT(ti.released_year, '-', ti.released_month, '-', ti.released_day), '%Y-%m-%d')
        ELSE NULL
    END AS released_date,
    ti.in_spotify_playlists,
    ti.in_spotify_charts,
    NULLIF(REPLACE(REPLACE(ti.streams, ',', ''), '"', ''), '') AS streams,
    ti.in_apple_playlists,
    ti.in_apple_charts,
    ti.in_deezer_playlists,
    ti.in_deezer_charts,
    ti.in_shazam_charts,
    ti.bpm,
    ti.`key`,
    ti.mode,
    ti.danceability_percentage,
    ti.valence_percentage,
    ti.energy_percentage,
    ti.acousticness_percentage,
    ti.instrumentalness_percentage,
    ti.liveness_percentage,
    ti.speechiness_percentage
FROM temp_import ti
LEFT JOIN artists a ON ti.artist_name = a.artist_name
WHERE ti.track_id IS NOT NULL AND ti.track_name IS NOT NULL;

-- Clean up
DROP TEMPORARY TABLE IF EXISTS temp_import;

-- Re-enable strict mode
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';

-- Run data analysis procedures
CALL clean_and_analyze_data();

-- Display import summary
SELECT 
    'Data Import Complete' AS status,
    COUNT(*) AS total_songs_imported,
    COUNT(DISTINCT artist_name) AS unique_artists
FROM songs s
JOIN artists a ON s.artist_id = a.artist_id;

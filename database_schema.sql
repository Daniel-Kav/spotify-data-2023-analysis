-- Create and use the database
CREATE DATABASE IF NOT EXISTS spotify_analysis;
USE spotify_analysis;

-- Enable strict mode for better data integrity
SET SQL_MODE = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';

-- Create artists table
CREATE TABLE IF NOT EXISTS artists (
    artist_id INT AUTO_INCREMENT PRIMARY KEY,
    artist_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_artist (artist_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create songs table with comprehensive schema
CREATE TABLE IF NOT EXISTS songs (
    track_id VARCHAR(50) PRIMARY KEY,
    track_name VARCHAR(255) NOT NULL,
    artist_id INT,
    artist_count INT DEFAULT 1,
    released_date DATE,
    in_spotify_playlists INT DEFAULT 0,
    in_spotify_charts INT DEFAULT 0,
    streams BIGINT,
    in_apple_playlists INT DEFAULT 0,
    in_apple_charts INT DEFAULT 0,
    in_deezer_playlists INT DEFAULT 0,
    in_deezer_charts INT DEFAULT 0,
    in_shazam_charts INT DEFAULT 0,
    bpm INT,
    `key` VARCHAR(5),
    mode VARCHAR(10),
    danceability_percentage INT,
    valence_percentage INT,
    energy_percentage INT,
    acousticness_percentage INT,
    instrumentalness_percentage INT,
    liveness_percentage INT,
    speechiness_percentage INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE SET NULL,
    INDEX idx_artist (artist_id),
    INDEX idx_streams (streams),
    INDEX idx_release_date (released_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create a table for audio features analysis
CREATE TABLE IF NOT EXISTS audio_features_analysis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    feature_name VARCHAR(50) NOT NULL,
    avg_value DECIMAL(10,2),
    min_value DECIMAL(10,2),
    max_value DECIMAL(10,2),
    std_dev DECIMAL(10,2),
    analysis_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Create a view for cleaned data
CREATE OR REPLACE VIEW cleaned_songs AS
SELECT 
    s.track_id,
    s.track_name,
    a.artist_name,
    s.artist_count,
    YEAR(s.released_date) AS released_year,
    MONTH(s.released_date) AS released_month,
    DAY(s.released_date) AS released_day,
    s.in_spotify_playlists,
    s.in_spotify_charts,
    s.streams,
    s.in_apple_playlists,
    s.in_apple_charts,
    s.in_deezer_playlists,
    s.in_deezer_charts,
    s.in_shazam_charts,
    s.bpm,
    s.`key`,
    s.mode,
    s.danceability_percentage,
    s.valence_percentage,
    s.energy_percentage,
    s.acousticness_percentage,
    s.instrumentalness_percentage,
    s.liveness_percentage,
    s.speechiness_percentage
FROM songs s
LEFT JOIN artists a ON s.artist_id = a.artist_id
WHERE 
    s.track_name IS NOT NULL 
    AND a.artist_name IS NOT NULL
    AND s.released_date BETWEEN '1900-01-01' AND DATE_ADD(CURRENT_DATE, INTERVAL 1 YEAR);

-- Create a view for summary statistics
CREATE OR REPLACE VIEW song_statistics AS
SELECT 
    COUNT(*) AS total_songs,
    COUNT(DISTINCT artist_name) AS unique_artists,
    AVG(streams) AS avg_streams,
    AVG(bpm) AS avg_bpm,
    AVG(danceability_percentage) AS avg_danceability,
    AVG(energy_percentage) AS avg_energy,
    AVG(valence_percentage) AS avg_valence,
    AVG(acousticness_percentage) AS avg_acousticness,
    AVG(instrumentalness_percentage) AS avg_instrumentalness,
    AVG(liveness_percentage) AS avg_liveness,
    AVG(speechiness_percentage) AS avg_speechiness
FROM cleaned_songs;

-- Create a stored procedure for data cleaning
DELIMITER //
CREATE PROCEDURE clean_and_analyze_data()
BEGIN
    -- Clean and analyze data
    INSERT INTO audio_features_analysis 
    (feature_name, avg_value, min_value, max_value, std_dev)
    SELECT 
        'danceability' AS feature_name,
        AVG(danceability_percentage) AS avg_value,
        MIN(danceability_percentage) AS min_value,
        MAX(danceability_percentage) AS max_value,
        STDDEV(danceability_percentage) AS std_dev
    FROM cleaned_songs;
    
    -- Add more feature analysis as needed
    
    COMMIT;
END //
DELIMITER ;

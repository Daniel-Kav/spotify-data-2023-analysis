-- Database User Setup Script for Spotify Analysis
-- This script creates users with appropriate permissions

-- Create read-only user for reporting
CREATE USER IF NOT EXISTS 'spotify_reader'@'localhost' IDENTIFIED BY 'secure_password_123';
GRANT SELECT ON spotify_analysis.* TO 'spotify_reader'@'localhost';

-- Create read-write user for analysts
CREATE USER IF NOT EXISTS 'spotify_analyst'@'localhost' IDENTIFIED BY 'analyst_password_456';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON spotify_analysis.* TO 'spotify_analyst'@'localhost';

-- Create admin user with full privileges
CREATE USER IF NOT EXISTS 'spotify_admin'@'localhost' IDENTIFIED BY 'admin_password_789';
GRANT ALL PRIVILEGES ON spotify_analysis.* TO 'spotify_admin'@'localhost' WITH GRANT OPTION;

-- Create a user for the application
CREATE USER IF NOT EXISTS 'spotify_app'@'%' IDENTIFIED BY 'app_password_101';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON spotify_analysis.* TO 'spotify_app'@'%';

-- Apply the changes
FLUSH PRIVILEGES;

-- Show the created users and their permissions
SELECT 
    user, 
    host, 
    password_expired,
    password_last_changed,
    account_locked,
    password_lifetime
FROM mysql.user 
WHERE user LIKE 'spotify%';

-- Show grants for each user
SHOW GRANTS FOR 'spotify_reader'@'localhost';
SHOW GRANTS FOR 'spotify_analyst'@'localhost';
SHOW GRANTS FOR 'spotify_admin'@'localhost';
SHOW GRANTS FOR 'spotify_app'@'%';

# Spotify Music Analysis - 2023 

<p align="center">  
	<a href="https://open.spotify.com/">
        <img src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.YQg9PUaYHoYCyG2SqFWSwwHaDt%26pid%3DApi&f=1&ipt=d62add352227128017bbc009d68f3ca869e386ae81a22badab1b028fa5cba1d3&ipo=images" width="300"> 
    </a>
    <h2>SQL Analysis of Top Spotify Songs 2023</h2>
</p>

## Table of Contents
- [Project Overview](#project-overview)
- [Project Structure](#project-structure)
- [Dataset Description](#dataset-description)
- [SQL Analysis](#sql-analysis)
- [Key Insights](#key-insights)
- [Getting Started](#getting-started)
- [Requirements](#requirements)
- [License](#license)

## Project Overview

This project provides a comprehensive SQL-based analysis of the top Spotify songs from 2023. The analysis covers various aspects of the dataset, including song characteristics, artist impact, platform performance, and audio features across different music streaming services.

The project includes a collection of SQL scripts that answer specific analytical questions, organized into logical categories for easy navigation and understanding.

## Project Structure

```
spotify-data-2023-analysis/
├── dataset/
│   └── spotify-2023.csv       # Raw dataset
├── scripts/
│   ├── 01_general_song_information.sql      # Basic song and artist analysis
│   ├── 02_spotify_metrics.sql               # Spotify-specific metrics
│   ├── 03_apple_music_metrics.sql           # Apple Music analysis
│   ├── 04_deezer_metrics.sql                # Deezer platform analysis
│   ├── 05_shazam_metrics.sql                # Shazam metrics and trends
│   ├── 06_audio_features.sql                # Audio characteristics analysis
│   ├── 07_artist_impact.sql                 # Artist collaboration impact
│   ├── 08_temporal_trends.sql               # Time-based analysis
│   ├── 09_cross_platform_presence.sql       # Cross-platform comparison
│   ├── 10_correlation_analysis.sql          # Relationships between metrics
│   ├── 11_popularity_analysis.sql           # What makes songs popular
│   └── 12_miscellaneous.sql                 # Additional analyses
├── insights.md               # Key findings and insights
├── questions.md              # Research questions
├── schema.sql                # Database schema
└── README.md                 # This file
```

## Dataset Description

The dataset provides a comprehensive set of features from the top Spotify songs of 2023, including song attributes, popularity metrics, and presence across various music platforms. The dataset is available on [Kaggle](https://www.kaggle.com/datasets/nelgiriyewithana/top-spotify-songs-2023).

### Key Features

| Feature | Description |
|---------|-------------|
| `track_name` | Name of the song |
| `artist_name` | Name of the artist(s) |
| `artist_count` | Number of artists contributing to the song |
| `released_year` | Year when the song was released |
| `released_month` | Month when the song was released |
| `released_day` | Day of the month when the song was released |
| `in_spotify_playlists` | Number of Spotify playlists the song is in |
| `in_spotify_charts` | Presence and rank on Spotify charts |
| `streams` | Total number of streams on Spotify |
| `in_apple_playlists` | Number of Apple Music playlists the song is in |
| `in_apple_charts` | Presence and rank on Apple Music charts |
| `in_deezer_playlists` | Number of Deezer playlists the song is in |
| `in_deezer_charts` | Presence and rank on Deezer charts |
| `in_shazam_charts` | Presence and rank on Shazam charts |
| `bpm` | Beats per minute (song tempo) |
| `key` | Musical key of the song |
| `mode` | Mode of the song (major or minor) |
| `danceability_%` | How suitable the song is for dancing |
| `valence_%` | Positivity of the song's musical content |
| `energy_%` | Perceived energy level |
| `acousticness_%` | Amount of acoustic sound |
| `instrumentalness_%` | Amount of instrumental content |
| `liveness_%` | Presence of live performance elements |
| `speechiness_%` | Amount of spoken words |

## SQL Analysis

The project includes 12 SQL scripts, each focusing on a specific aspect of the data:

1. **General Song Information**: Basic analysis of songs and artists
2. **Spotify Metrics**: In-depth analysis of Spotify-specific data
3. **Apple Music Metrics**: Analysis of Apple Music performance
4. **Deezer Metrics**: Insights from Deezer platform data
5. **Shazam Metrics**: Analysis of Shazam chart performance
6. **Audio Features**: Exploration of musical characteristics
7. **Artist Impact**: How artists and collaborations affect song performance
8. **Temporal Trends**: How music trends change over time
9. **Cross-Platform Presence**: Comparison across different music platforms
10. **Correlation Analysis**: Relationships between different song metrics
11. **Popularity Analysis**: What makes songs popular
12. **Miscellaneous**: Additional interesting queries and analyses

## Key Insights

Some of the key findings from our analysis include:

- The top 5 most streamed songs in 2023
- Correlation between streams and chart performance
- Average BPM and danceability of popular songs
- Cross-platform performance across Spotify, Apple Music, and Deezer
- Impact of artist collaborations on song success
- Trends in music characteristics over time

For detailed insights, check out the [insights.md](insights.md) file.

## Getting Started

### Prerequisites

- MySQL or compatible SQL database
- The dataset file: `dataset/spotify-2023.csv`

### Setup

1. Create the database and import the data:
   ```sql
   mysql -u username -p < schema.sql
   ```

2. Import the CSV data into your database using your preferred method.

3. Run the SQL scripts in the `scripts/` directory to perform the analyses.

## Usage

Each script in the `scripts/` directory is self-contained and focuses on a specific aspect of the data. You can run them individually in your SQL environment to see the results.

Example:
```sql
-- Run a specific analysis
SOURCE scripts/01_general_song_information.sql;
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

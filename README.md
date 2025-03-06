# Spotify Vs Youtube Music Analysis Using SQL
![](https://github.com/aurosgit/Spotify-Vs-Youtube-Music-/blob/main/Spout%20Logo.png)

## Overview
This project analyzes a combined dataset of Spotify and YouTube music data to uncover insights into song performance, artist popularity, and platform-specific trends. By using SQL queries, we explore:

## Objective
✅ Engagement Trends 
✅ Revenue Estimations
✅ Song Characteristics 
✅ Artist & Album Impact 
✅ Correlation Analysis 

The Data For this project is sourced from Gigasheet below is the dataset link:
LINK --> ** [Song Dataset](https://gigasheet-export-uploads.s3.amazonaws.com/6b8abf6e_0406_46ee_8d20_ff53cfb4d35f-20250305065413.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAXTOLCDI7G5IZZAUQ%2F20250306%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250306T053038Z&X-Amz-Expires=1800&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3D%22Spotify%20dataset%20export%202025-03-05%2006-54-10.zip%22&X-Amz-Signature=cafe3eebaeede28d4a528a1591f8d32d2d05f66ac1a1b66a5d4842f546851a80)

## Schema

SQL

DROP table IF EXISTS spout;

CREATE 
  TABLE spout(
  Artist VARCHAR(60),
	Track VARCHAR(220),
	Album VARCHAR(220),
	Album_type VARCHAR(15),
	Danceability DECIMAL(15,3),
	Energy DECIMAL(10,3),	
  Loudness DECIMAL(10,3),	
  Speechiness	DECIMAL(15,3),
  Acousticness DECIMAL(15,3),
	Instrumentalness DECIMAL(20,4),	
  Liveness DECIMAL(10,4),	
  Valence DECIMAL(10,4),	
  Tempo DECIMAL(10,4),
	Duration_min DECIMAL(15,2),
	Title VARCHAR(220),
	Channel	VARCHAR(70),
  Views BIGINT,	
  Likes BIGINT,
	Comments BIGINT,
	Licensed BOOLEAN,
	official_video BOOLEAN,
	Stream BIGINT,
	EnergyLiveness DECIMAL(15,4), 	
  most_playedon VARCHAR(15)
);

COPY 
  spout
FROM 'Dataset_location'
Delimiter ','
CSV HEADER;




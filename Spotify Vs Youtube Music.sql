select * from spout

select count(*) from spout

SELECT 
    SUM(CASE WHEN Track IS NULL THEN 1 ELSE 0 END) AS null_track,
    SUM(CASE WHEN Album IS NULL THEN 1 ELSE 0 END) AS null_album,
    SUM(CASE WHEN Album_type IS NULL THEN 1 ELSE 0 END) AS null_album_type,
    SUM(CASE WHEN Danceability IS NULL THEN 1 ELSE 0 END) AS null_danceability,
    SUM(CASE WHEN Energy IS NULL THEN 1 ELSE 0 END) AS null_energy,
    SUM(CASE WHEN Loudness IS NULL THEN 1 ELSE 0 END) AS null_loudness,
    SUM(CASE WHEN Speechiness IS NULL THEN 1 ELSE 0 END) AS null_speechiness,
    SUM(CASE WHEN Acousticness IS NULL THEN 1 ELSE 0 END) AS null_acousticness,
    SUM(CASE WHEN Instrumentalness IS NULL THEN 1 ELSE 0 END) AS null_instrumentalness,
    SUM(CASE WHEN Liveness IS NULL THEN 1 ELSE 0 END) AS null_liveness,
    SUM(CASE WHEN Valence IS NULL THEN 1 ELSE 0 END) AS null_valence,
    SUM(CASE WHEN Tempo IS NULL THEN 1 ELSE 0 END) AS null_tempo,
    SUM(CASE WHEN Duration_min IS NULL THEN 1 ELSE 0 END) AS null_duration,
    SUM(CASE WHEN Title IS NULL THEN 1 ELSE 0 END) AS null_title,
    SUM(CASE WHEN Channel IS NULL THEN 1 ELSE 0 END) AS null_channel,
    SUM(CASE WHEN Views IS NULL THEN 1 ELSE 0 END) AS null_views,
    SUM(CASE WHEN Likes IS NULL THEN 1 ELSE 0 END) AS null_likes,
    SUM(CASE WHEN Comments IS NULL THEN 1 ELSE 0 END) AS null_comments,
    SUM(CASE WHEN Licensed IS NULL THEN 1 ELSE 0 END) AS null_licensed,
    SUM(CASE WHEN official_video IS NULL THEN 1 ELSE 0 END) AS null_official_video,
    SUM(CASE WHEN Stream IS NULL THEN 1 ELSE 0 END) AS null_stream,
    SUM(CASE WHEN EnergyLiveness IS NULL THEN 1 ELSE 0 END) AS null_energy_liveness,
    SUM(CASE WHEN most_playedon IS NULL THEN 1 ELSE 0 END) AS null_most_playedon
FROM spout;

SELECT * FROM spout
--Business Problems for SQL Analysis
--Song Popularity & Engagement

--1.Which songs are the top most popular?

SELECT 
	artist,track,album,views,likes 
FROM spout 
ORDER BY views DESC 
LIMIT 10;
    
--2.What is the like-to-view ratio for each song and find out the best complimented once? 

SELECT
	track,artist,views,likes,
	CASE 
	    when views = 0 or views IS NULL THEN 0
		ELSE ROUND((likes::numeric/NULLIF(views,0))*100,2)
	END as like_to_view_ratio,
	CASE
		when(likes :: numeric/ NULLIF(views,0))* 100 >= 10 THEN 'Highly Liked'
		when(likes :: numeric/ NULLIF(views,0))* 100 BETWEEN 5 AND 9.99 THEN 'Fan Favourite'
		when(likes :: numeric/NULLIF(views,0))* 100 BETWEEN 2 and 4.99 THEN 'Well Appreciated'
		when(likes :: numeric/NULLIF(views,0))* 100 BETWEEN 0.5 and 1.99 THEN 'Decent Engagement'
		ELSE 'needs more love'
	END AS compliment
FROM spout 
ORDER BY like_to_view_ratio DESC;

--3.Which songs generate the most discussions? 

SELECT 
	track,artist,comments 
FROM spout 
ORDER BY comments DESC
LIMIT 10;

--4.Which artists consistently maintain high engagement? – Find out which artists have multiple hit songs.

SELECT 
    artist,
    COUNT(track) AS total_songs,
    SUM(views) AS total_views,
    SUM(likes) AS total_likes,
    SUM(comments) AS total_comments,
    ROUND(AVG(NULLIF(likes, 0)::NUMERIC / NULLIF(views, 0) * 100), 2) AS avg_like_to_view_ratio,
    ROUND(AVG(NULLIF(comments, 0)::NUMERIC / NULLIF(views, 0) * 100), 2) AS avg_comment_to_view_ratio
FROM spout
GROUP BY artist
ORDER BY total_views DESC, avg_like_to_view_ratio DESC
LIMIT 10;

--Platform Performance (Spotify vs YouTube)
--5.Which platform (Spotify or YouTube) has more streams per song? – Compare the total streams on both platforms.

SELECT 
	most_playedon AS Platform,
	COUNT(track) AS total_songs,
	SUM(stream) AS total_streams,
	ROUND(AVG(stream),2) AS Avg_Streams_Per_Songs
FROM spout
GROUP BY Platform
ORDER BY total_streams;


--6.	Does YouTube popularity impact Spotify streams? 

SELECT 
	CORR(views,stream) AS view_to_stream_correlation,
	CORR(likes,stream) AS likes_to_stream_correlation,
	CORR(comments, stream) AS comments_to_stream_correlation
FROM spout;

--7.Which platform is likely generating more revenue? – Based on views, likes, and engagement, which platform is more profitable for artists?

SELECT 
	most_playedon as platform,
	COUNT(track) AS total_songs,
	SUM(stream) AS total_streams,
	SUM(views) AS total_views,
	ROUND(SUM(stream)*0.004,2) AS estimated_spotify_revenue,
	ROUND(SUM(views)*0.0018,2) AS estimated_youtube_revenue
FROM spout
GROUP BY most_playedon
ORDER BY estimated_youtube_revenue DESC;
	
--8.What type of songs perform better on YouTube vs. Spotify? – Analyze tempo, energy, and loudness trends per platform.

SELECT 
	most_playedon AS platform,
	album_type,
	COUNT(track) AS total_songs,
	ROUND(AVG(energy),2) as avg_energy,
	ROUND(AVG(loudness),2) as avg_loudness,
	ROUND(AVG(tempo),2) as avg_tempo
FROM spout
GROUP BY album_type,most_playedon
ORDER BY most_playedon DESC,total_songs DESC;

--9.	How do user engagement patterns differ between YouTube and Spotify? – Do users interact more on one platform than the other?

SELECT
	most_playedon as platform,
	COUNT(track) AS total_songs,
	ROUND(AVG(views),2) AS avg_total_views,
	ROUND(AVG(stream),2) AS avg_total_stream,
	ROUND(AVG(likes),2) AS avg_total_likes,
	ROUND(AVG(comments),2) AS avg_total_comments,
	ROUND(AVG(liveness),2) AS avg_liveness
FROM spout
GROUP BY most_playedon
ORDER BY avg_liveness DESC,total_songs DESC;

--Artist & Album Performance

--10.	Which albums are the most successful? – Identify albums with the highest total streams and engagement.

SELECT 
	album,
	album_type,
	COUNT(track) as total_songs,
	SUM(views) AS total_views,
	SUM(stream) AS total_streams,
	SUM(likes+comments) AS total_engagement
FROM spout
GROUP BY album_type,album
ORDER BY total_views DESC, total_streams DESC, total_engagement DESC;
	
--11.	What are the most successful songs for each artist? 

SELECT
	artist,
	track,
	SUM(views) AS total_views,
	SUM(stream) AS total_streams,
	SUM(likes+comments) AS total_engagement
FROM spout
GROUP BY artist,track
ORDER BY total_views DESC, total_streams DESC, total_engagement DESC;

--12.	Which artists have the highest overall engagement? 

SELECT
	artist,
	track,
	album,
	SUM(views) AS total_views,
	SUM(stream) AS total_streams,
	SUM(likes) AS total_likes,
	SUM(comments) AS total_comments
FROM spout
GROUP BY artist,track,album
ORDER BY total_views DESC, total_streams DESC, total_likes DESC,total_comments DESC;

--Song Attributes Analysis (Audio Features)

--13.	Do highly danceable songs get more views? – Analyze the relationship between danceability and popularity.

SELECT
	CASE 
		WHEN danceability >=0.75 THEN 'Highly Danceability'
		WHEN danceability BETWEEN 0.50 AND 0.74 THEN 'Medium Danceability'
		ELSE 'Low Danceability'
	END AS danceability_category,
	COUNT(track) AS total_songs,
	ROUND(AVG(views),2) AS avg_views,
	ROUND(AVG(stream),2) AS avg_streams,
	ROUND(AVG(likes),2) AS avg_likes,
	ROUND(AVG(comments),2) AS avg_comments
FROM spout
GROUP BY danceability_category
ORDER BY avg_views DESC,avg_streams DESc,avg_likes DESC,avg_comments DESC;

--14.	Does energy and loudness impact song success? 

SELECT
	CASE 
		WHEN energy >=0.75 THEN 'More Energetic'
		WHEN danceability BETWEEN 0.50 AND 0.74 THEN 'Medium Energetic'
		ELSE 'Less Energetic'
	END AS energy_category,
	CASE 
		WHEN loudness >=-5 THEN 'Highly Loudness'
		WHEN danceability BETWEEN -15 AND -5 THEN 'Medium Loud'
		ELSE 'Low Loudness'
	END AS loudness_category,
	COUNT(track) AS total_songs,
	ROUND(AVG(views),2) AS avg_views,
	ROUND(AVG(stream),2) AS avg_streams,
	ROUND(AVG(likes),2) AS avg_likes,
	ROUND(AVG(comments),2) AS avg_comments
FROM spout
GROUP BY energy_category,loudness_category
ORDER BY avg_views DESC,avg_streams DESc,avg_likes DESC,avg_comments DESC ;

--15.	Do happy (high valence) songs perform better than sad songs? 

SELECT
	CASE 
		WHEN valence >=0.75 THEN 'Happy'
		WHEN valence BETWEEN 0.50 AND 0.74 THEN 'Neutral'
		ELSE 'Sad'
	END AS Feeling_category,
	COUNT(track) AS total_songs,
	ROUND(AVG(views),2) AS avg_views,
	ROUND(AVG(stream),2) AS avg_streams,
	ROUND(AVG(likes),2) AS avg_likes,
	ROUND(AVG(comments),2) AS avg_comments
FROM spout
GROUP BY Feeling_category
ORDER BY avg_views DESC,avg_streams DESc,avg_likes DESC,avg_comments DESC ;

--16.	Are instrumental songs less popular? – Check if songs with higher instrumentalness have lower engagement.

SELECT
	CASE 
		WHEN instrumentalness>=0.75 THEN 'Instrumental'
		ELSE 'With Lyrics'
	END AS Song_type,
	COUNT(track) AS total_songs,
	ROUND(AVG(views),2) AS avg_views,
	ROUND(AVG(stream),2) AS avg_streams,
	ROUND(AVG(likes),2) AS avg_likes,
	ROUND(AVG(comments),2) AS avg_comments
FROM spout
GROUP BY Song_type
ORDER BY avg_views DESC,avg_streams DESc,avg_likes DESC,avg_comments DESC ;


--17. Are longer-duration songs more popular? – Check if longer songs get more views and streams than shorter ones.

SELECT
	CASE 
		WHEN duration_min<3 THEN 'Short Duration'
		WHEN duration_min BETWEEN 3 AND 4.5 THEN 'Medium Duration'
		ELSE 'Long Duration'
	END AS Song_Duration,
	COUNT(track) AS total_songs,
	ROUND(AVG(views),2) AS avg_views,
	ROUND(AVG(stream),2) AS avg_streams,
	ROUND(AVG(likes),2) AS avg_likes,
	ROUND(AVG(comments),2) AS avg_comments
FROM spout
GROUP BY Song_Duration
ORDER BY avg_views DESC,avg_streams DESc,avg_likes DESC,avg_comments DESC ;


/*
-----------------------------------------------------------------------------------------
 Project Title : Spotify Global Music Dataset (2009–2025) (Raw → Cleaned → SQL Import)
 Author        : Siddharth Dave

 Description   :
     This project uses a Spotify dataset downloaded from Kaggle. The raw CSV was cleaned
     using Python (Pandas) to fix missing values, incorrect formats, duplicates, and
     inconsistent entries. Both the original and cleaned datasets are included for reference.

     After cleaning, the dataset was imported into a MySQL database (Spotify_Database),
     where analytical SQL queries were written to explore tracks, artists, albums, genres,
     and popularity trends.

     All SQL practice questions and exercises in this project were generated using ChatGPT.

 Repository Links:
     📂 GitHub Repository:
         https://github.com/SiddharthDave-Dev/SpotifyProject

     📄 Raw Dataset:
         https://github.com/SiddharthDave-Dev/SpotifyProject/tree/main/Spotify_Original_Data

     🧹 Cleaned Dataset:
         https://github.com/SiddharthDave-Dev/SpotifyProject/tree/main/Spotify_Cleaned_Data

     📝 Python Cleaning Notebook:
         https://github.com/SiddharthDave-Dev/SpotifyProject/tree/main/Spotify_Data_Cleaning

 Notes:
     • Import the cleaned dataset for all SQL analysis.
     • Project covers ETL, cleaning, database design, and SQL analytics.
-----------------------------------------------------------------------------------------
*/



#Created a Database
create database Spotify_Database;

#Use Database
use Spotify_Database;

#Checking Table Imported
show tables;

#Changing the Size of the data Because it was giving an error
alter table spotify_cleaned_data  modify column artist_genres varchar(225);
alter table spotify_cleaned_data  modify column track_name varchar(225);

#Checking Data Imported
select * from spotify_cleaned_data scd;


#1. Basic SELECT & Projection

#1) Show all columns for all tracks.

select * from spotify_cleaned_data;



#2)Show only track_name, artist_name, and album_name.

select track_name, artist_name, album_name 
from spotify_cleaned_data;



#3) List distinct artist_name values.

select distinct artist_name 
from spotify_cleaned_data;



#4) List distinct album_type values.

select distinct album_type 
from spotify_cleaned_data;



#5)List distinct pairs of artist_name and artist_genres.

select distinct artist_name, artist_genres 
from spotify_cleaned_data;



#6) Show the first 20 rows from the table.

select * from spotify_cleaned_data
limit 20;



#7) Show all tracks where explicit is TRUE.

select * from spotify_cleaned_data scd 
where explicit = 1;



#8) Show all tracks where explicit is FALSE.

select * from spotify_cleaned_data scd 
where explicit = 0;



#9)Show track_name and track_duration_min for all tracks.

select track_name, track_duration_min 
from spotify_cleaned_data;



#10) Show all tracks for a specific artist_name (e.g., 'Diplo').

create procedure find_specific_artist_name(in name varchar(225))
select * from spotify_cleaned_data
where artist_name = name;

call find_specific_artist_name('Diplo');


#2. Filtering with WHERE (AND / OR / BETWEEN / IN)

#11) Find tracks with track_popularity greater than 50.

select * from spotify_cleaned_data
where track_popularity > 50;



#12) Find tracks with track_popularity between 30 and 70 (inclusive).

select * from spotify_cleaned_data
where track_popularity between 30 and 70;



#13) Find tracks with track_duration_min less than 2.5 minutes.

select * from spotify_cleaned_data
where track_duration_min < 2.5;



#14) Find tracks that are both explicit = TRUE and have track_popularity > 60.

select * from spotify_cleaned_data
where explicit = 1 and track_popularity > 60;



#15) Find tracks that are explicit = FALSE or have track_popularity > 80.

select * from spotify_cleaned_data
where explicit = 0 or track_popularity > 80;



#16) Get tracks for a list of artists, e.g. artist_name IN ('Diplo', 'Yelawolf', 'Drake').

select * from spotify_cleaned_data
where artist_name in ('Diplo', 'Yelawolf', 'Drake');



#17) Find tracks where artist_followers is greater than 1,000,000.

select * from spotify_cleaned_data
where artist_followers > 1000000;



#18) Find tracks where artist_popularity is less than 40.

select * from spotify_cleaned_data
where artist_popularity < 40;



#19) Find tracks where track_number is the first track of the album (track_number = 1).

select * from spotify_cleaned_data
where track_number = 1;



#20) Find tracks where track_number is in the last 3 positions of the album
#(track_number >= album_total_tracks - 2).

select * from spotify_cleaned_data
where track_number >= album_total_tracks - 2;



#3. Sorting & Limiting

#21) List all tracks sorted by track_popularity in descending order.

select * from spotify_cleaned_data
order by track_popularity Desc;



#22) Show the top 10 most popular tracks.

select * from spotify_cleaned_data
order by track_popularity Desc
limit 10;



#23) Show the top 10 least popular tracks (ascending popularity).

select * from spotify_cleaned_data
order by track_popularity
limit 10;



#24) List tracks ordered by artist_name (A → Z) and then by track_name.

select * from spotify_cleaned_data
order by artist_name;



#25) List tracks ordered by album_release_date (newest first).

select * from spotify_cleaned_data
order by album_release_date Desc;



#26) Show the 5 longest tracks by track_duration_min.

select * from spotify_cleaned_data
order by track_duration_min Desc
limit 5;



#4. Aggregations (COUNT, SUM, AVG, MIN, MAX)

#27) Count how many rows (tracks) are in the table.

select count(*) from spotify_cleaned_data;



#28) Count how many distinct artists are in the dataset.

SELECT count(distinct artist_name)
FROM spotify_cleaned_data;



#29) Count how many distinct albums are in the dataset.

select count(distinct album_name )
from spotify_cleaned_data;



#30) Find the minimum, maximum, and average track_popularity.

select min(track_popularity) as `Minimum Track Popularity`, 
	   max(track_popularity) as `Maximum Track Popularity`, 
	   round(avg(track_popularity), 2) as `Average Track Popularity`
from spotify_cleaned_data;



#31) Find the minimum, maximum, and average track_duration_min.

select min(track_duration_min) as `Minimum Track Duration Minute`, 
	   max(track_duration_min) as `Maximum Track Duration Minute`, 
	   round(avg(track_duration_min), 2) as `Average Track Duration Minute`
from spotify_cleaned_data;



#32) Find the total sum of album_total_tracks (total tracks across all albums).

select sum(album_total_tracks) 
from spotify_cleaned_data;



#33) Count how many tracks are explicit (explicit = TRUE).

select count(*)
from spotify_cleaned_data
where explicit = 1;



#34) Count how many tracks are non-explicit (explicit = FALSE).

select count(*)
from spotify_cleaned_data
where explicit = 0;



#35) Find the average artist_popularity for all artists.

select round(avg(artist_popularity), 2)
from spotify_cleaned_data;



#36) Find the average artist_followers for all artists.

select round(avg(artist_followers), 2) 
from spotify_cleaned_data;



#5. GROUP BY & HAVING

#37) For each artist_name, count how many tracks they have.

select artist_name, 
	   count(track_id)
from spotify_cleaned_data
group by artist_name;



#38) For each artist_name, find their average track_popularity.

select artist_name, 
	   round(avg(track_popularity), 2)
from spotify_cleaned_data
group by artist_name;



#39) For each album_name, count how many tracks are on that album (based on this table, not album_total_tracks).

select album_name, 
	   count(*)
from spotify_cleaned_data
group by album_name;



#40) For each album_type, count how many albums there are.

select album_type, 
	   count(Distinct album_name )
from spotify_cleaned_data
group by album_type;



#41) For each artist_genres, compute the average artist_popularity.

select artist_genres, 
  	   round(avg(artist_popularity), 2)
from spotify_cleaned_data
group by artist_genres;



#42) For each artist_name, find the maximum track_popularity among their tracks.

select artist_name, 
	   max(track_popularity)
from spotify_cleaned_data
group by artist_name;



#43) Show only those artists who have more than 10 tracks in the dataset.

select artist_name, 
	   count(Distinct track_id)
from spotify_cleaned_data
group by artist_name
having count(Distinct track_id) > 10;



#44) Show only those albums that have at least 5 tracks in this table.

select album_name, 
	   count(Distinct track_id)
from spotify_cleaned_data
group by album_name
having count(Distinct track_id) >= 5;



#45) For each album_release_date, count how many tracks were released on that date.

select album_release_date, 
	   count(Distinct track_id)
from spotify_cleaned_data
group by album_release_date;



#46) For each artist_name, find the average track_duration_min, and show only artists whose average duration > 3 minutes.

select artist_name, 
	   round(avg(track_duration_min), 2) as average_track_duration_min
from spotify_cleaned_data
group by artist_name
having average_track_duration_min > 3;



#6. Date-based Questions

#47) List all tracks released in a specific year (e.g. 2025)
#(Hint: extract the year from album_release_date).


select * from spotify_cleaned_data
where year(album_release_date) = 2025;


#48) Count how many tracks were released in each year.

select Year(album_release_date), 
	   count(distinct track_id)
from spotify_cleaned_data
group by Year(album_release_date);




#49) Find the earliest album_release_date in the dataset.

select * from spotify_cleaned_data
order by album_release_date
limit 1;




#50) Find the most recent album_release_date in the dataset.

select * from spotify_cleaned_data
order by album_release_date Desc
limit 1;




#51) Count how many albums were released per month (group by year and month).

select Concat(	
				year(album_release_date),
				"-", 
				month(album_release_date)
			) as `Year_Month`,
			count(distinct album_id) total_albums
from spotify_cleaned_data
group by `Year_Month`
ORDER BY `Year_Month` Desc;



#52) Find the average track_popularity of tracks released in 2025.

select DATE_FORMAT(album_release_date, "%Y") as `Year`,
		round(avg(track_popularity), 2) average_track_popularity
from spotify_cleaned_data
group by `Year`
having `Year` = 2025;



#53) Compare the number of tracks released before 2020 vs from 2020 onwards.

With `Before 2020` as (
			select count(track_id) as track_count
			from spotify_cleaned_data
			where Year(album_release_date) < 2020
	),
	`Onward 2020` as (
			select count(track_id) as track_count
			from spotify_cleaned_data
			where Year(album_release_date) >= 2020
	)
select `Before 2020`.track_count as tracks_before_2020,  
		`Onward 2020`.track_count as tracks_from_2020_onwards
from `Before 2020`
cross join `Onward 2020`;


SELECT
    SUM(CASE WHEN YEAR(album_release_date) < 2020 THEN 1 ELSE 0 END) AS tracks_before_2020,
    SUM(CASE WHEN YEAR(album_release_date) >= 2020 THEN 1 ELSE 0 END) AS tracks_from_2020_onwards
FROM spotify_cleaned_data;



#54) Find the average track_duration_min of tracks released in the most recent year present in the data.

select Date_Format(album_release_date, "%Y") as `Year`, 
		round(avg(track_duration_min), 2)
from spotify_cleaned_data
group by `Year`
order by `Year` Desc
limit 5;



#55) For each year, calculate the total number of distinct artists who released tracks that year.

select Date_Format(album_release_date, "%Y") as `Year`,
		count(distinct artist_name)
from spotify_cleaned_data
group by `Year`
order by `Year` Desc;



#56) Find tracks released in the last 30 days relative to the maximum date in album_release_date.

SELECT * FROM spotify_cleaned_data
WHERE album_release_date >= (
    SELECT DATE_SUB(MAX(album_release_date), INTERVAL 30 DAY)
    FROM spotify_cleaned_data
)
ORDER BY album_release_date DESC;



#7. String / Pattern Matching (LIKE, LENGTH, etc.)

#57) Find tracks where track_name contains the word 'love' (case-insensitive if your DB supports it).

select track_name from spotify_cleaned_data
where track_name like "%love%";



#58) Find tracks where track_name starts with 'The'.

select track_name from spotify_cleaned_data
where track_name like "the%";



#59) Find tracks where artist_name ends with 'Band'.

select artist_name from spotify_cleaned_data
where artist_name like "%band";



#60) Find tracks where artist_genres contains 'hip hop'.

select artist_genres from spotify_cleaned_data
where artist_genres like "%hip hop%";



#61) Find tracks where album_name contains 'Live'.

select album_name from spotify_cleaned_data
where album_name like "%live%";



#62) Show tracks where track_name length is greater than 30 characters.

select *, length(track_name) from spotify_cleaned_data
where length(track_name) > 30;



#63) For each artist_name, return the length of their name (using string length function).

select distinct artist_name, 
		length(artist_name) name_length
from spotify_cleaned_data;



#64) List tracks whose track_name has no spaces (single word titles).

select track_name
from spotify_cleaned_data
where track_name not like "% %";



#65) Find tracks where track_name contains parentheses '(' (e.g., featuring info).

select track_name 
from spotify_cleaned_data
where track_name like "%(%";



#66) Standardize search: find all tracks that mention 'ft.' or 'feat.' in track_name.

select * from spotify_cleaned_data
where track_name like "%ft.%" or track_name like "%feat.%"



#8. Subqueries (IN, EXISTS, Scalar, Correlated)

#67) Find artists whose average track_popularity is greater than the overall average track_popularity.

select artist_name, 
		avg(track_popularity) as artist_average_track_popularity
from spotify_cleaned_data
group by artist_name
having artist_average_track_popularity > (
	select avg(track_popularity) from spotify_cleaned_data
);



#68) List tracks that have track_popularity equal to the maximum track_popularity in the entire table.

select track_name, 
		max(track_popularity) as track_maximum_track_popularity
from spotify_cleaned_data
group by track_name
having track_maximum_track_popularity = (
	select max(track_popularity) from spotify_cleaned_data
);




#69) List tracks whose track_duration_min is above the overall average duration.

select track_name, 
		avg(track_duration_min) as track_average_track_duration_min
from spotify_cleaned_data
group by track_name
having track_average_track_duration_min > (
	select avg(track_duration_min) from spotify_cleaned_data
);




#70) Find artists who have at least one track with track_popularity > 80 (using a WHERE EXISTS subquery).

SELECT DISTINCT st1.artist_name
FROM spotify_cleaned_data st1
WHERE EXISTS (
    SELECT 1
    FROM spotify_cleaned_data st2
    WHERE st2.artist_name = st1.artist_name
      AND st2.track_popularity > 80
);


#71) Find albums that have more tracks than the average tracks per album (using a subquery over GROUP BY album_name).

select album_name,
    COUNT(track_id) as track_count
from spotify_cleaned_data
group by album_name
having COUNT(track_id) > (
    select AVG(album_track_count)
    from (
        select COUNT(track_id) as album_track_count
        from spotify_cleaned_data
        group by album_name
    ) as album_counts
);



#72) List tracks released in the same year as the most popular track (based on track_popularity).

#found pouplar track Year

select Concat(Year(album_release_date)), track_popularity  
from spotify_cleaned_data
order by track_popularity desc
limit 1;

select track_name 
from spotify_cleaned_data scd1
where Concat(Year(album_release_date)) = (
	select Concat(Year(album_release_date))  
	from spotify_cleaned_data scd2
	order by track_popularity desc
	limit 1
);




#73) Find the top 5 artists by artist_followers using a subquery instead of ORDER BY ... LIMIT directly.

SELECT *
FROM (
    SELECT 
        artist_name,
        MAX(artist_followers) AS followers
    FROM spotify_cleaned_data
    GROUP BY artist_name
    ORDER BY followers DESC
    LIMIT 5
) AS top5;


WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM numbers
    WHERE n < 5
)
SELECT n
FROM numbers;



#74) For each artist, list tracks whose popularity is above their own average popularity (correlated subquery).

select scd1.artist_name,
		scd1.track_name,
		scd1.track_popularity
from spotify_cleaned_data scd1
where track_popularity > (
	select avg(scd2.track_popularity) 
	from spotify_cleaned_data scd2
	where scd2.artist_name = scd1.artist_name
);


#75) List albums whose maximum track_popularity is less than the global average track_popularity.

select scd1.album_name, 
		max(scd1.track_popularity)
from spotify_cleaned_data scd1
group by album_name
having max(scd1.track_popularity) < (
	select avg(scd2.track_popularity ) from spotify_cleaned_data scd2
);



#76) Find tracks whose track_popularity is in the top 10% of all tracks (using a subquery with a threshold).

WITH ranked AS (
    SELECT 
        track_popularity,
        ROW_NUMBER() OVER (ORDER BY track_popularity DESC) AS rn
    FROM spotify_cleaned_data
),
counts AS (
    SELECT COUNT(*) AS total_rows
    FROM spotify_cleaned_data
),
threshold AS (
    SELECT r.track_popularity AS cutoff
    FROM ranked r
    JOIN counts c
      ON r.rn = CEIL(c.total_rows * 0.10)
)
SELECT *
FROM spotify_cleaned_data
WHERE track_popularity >= (SELECT cutoff FROM threshold);




#9. Window Functions (Ranking, Running Totals, Percentiles)

#77) For each artist_name, assign a row number to their tracks ordered by track_popularity (use ROW_NUMBER()).

SELECT
    artist_name,
    track_name,
    track_popularity,
    ROW_NUMBER() OVER (
        PARTITION BY artist_name
        ORDER BY track_popularity DESC
    ) AS track_rank
FROM spotify_cleaned_data;




#78) For each artist_name, find their most popular track using ROW_NUMBER() or RANK() in a subquery/CTE.

SELECT 
    t.artist_name,
    t.track_name,
    t.track_popularity
FROM (
    SELECT
        artist_name,
        track_name,
        track_popularity,
        RANK() OVER (
            PARTITION BY artist_name
            ORDER BY track_popularity DESC
        ) AS rnk
    FROM spotify_cleaned_data
) AS t
WHERE t.rnk = 1;



#79) Compute a running total of tracks ordered by track_popularity (using COUNT(*) OVER).

SELECT 
    track_name,
    track_popularity,
    COUNT(*) OVER (ORDER BY track_popularity DESC) AS running_total
FROM spotify_cleaned_data
ORDER BY track_popularity DESC;




#80) For each album, calculate the rank of each track by track_number (using ROW_NUMBER() over partition by album).

SELECT
    album_name,
    track_name,
    track_number,
    ROW_NUMBER() OVER (
        PARTITION BY album_id
        ORDER BY track_number
    ) AS track_rank
FROM spotify_cleaned_data;



#81) For each artist, compute the average track_popularity as a window function (AVG() OVER (PARTITION BY artist_name)).

select artist_name,
		track_popularity,
		avg(track_popularity) over(partition by artist_name)
from spotify_cleaned_data;



#82) Compute the difference between each track’s track_popularity and the artist’s average popularity using window functions.

SELECT 
    artist_name,
    track_name,
    track_popularity,
    AVG(track_popularity) OVER (
        PARTITION BY artist_name
    ) AS artist_avg_popularity,
    track_popularity 
      - AVG(track_popularity) OVER (PARTITION BY artist_name)
        AS popularity_diff_from_avg
FROM spotify_cleaned_data
ORDER BY artist_name, track_popularity DESC;





#83) For each artist, compute the cumulative count of tracks ordered by album_release_date.

SELECT 
    artist_name,
    track_name,
    album_release_date,
    COUNT(*) OVER (
        PARTITION BY artist_name
        ORDER BY album_release_date
    ) AS cumulative_track_count
FROM spotify_cleaned_data;




#84) Assign a global rank to each track based on track_popularity (no partition).

SELECT
    track_name,
    artist_name,
    track_popularity,
    ROW_NUMBER() OVER (
        ORDER BY track_popularity DESC
    ) AS global_rank
FROM spotify_cleaned_data
ORDER BY global_rank;




#85) For each album_type, compute the average track_duration_min and show it as a window column for every track in that album_type.

SELECT 
    album_type,
    track_name,
    track_duration_min,
    AVG(track_duration_min) OVER (
        PARTITION BY album_type
    ) AS avg_duration_per_album_type
FROM spotify_cleaned_data;




#86) Calculate the percentile rank of each track’s popularity among all tracks (if your DB supports PERCENT_RANK() or similar).

SELECT
    track_name,
    artist_name,
    track_popularity,
    PERCENT_RANK() OVER (
        ORDER BY track_popularity
    ) AS percentile_rank
FROM spotify_cleaned_data
ORDER BY track_popularity;



#10. CTEs (WITH clauses)

#87) Use a CTE to first compute each artist’s average track_popularity, then select only the top 10 artists by that average.

WITH average_track_popularity AS (
    SELECT 
        artist_name,
        AVG(track_popularity) AS avg_popularity
    FROM spotify_cleaned_data
    GROUP BY artist_name
)
SELECT 
    artist_name,
    avg_popularity
FROM average_track_popularity
ORDER BY avg_popularity DESC
LIMIT 10;



#88) Use a CTE to get all tracks released in 2025, then on that subset compute the most popular track per artist.

with tracks_released_in_2025 as (
	select * 
	from spotify_cleaned_data
	where Year(album_release_date) = 2025
)
select artist_name, 
		max(track_popularity) 
from tracks_released_in_2025
group by artist_name;


#89) Use a CTE to compute per-album stats: number of tracks, average popularity, average duration, and then select only albums with avg_popularity > 60.

WITH album_stats AS (
    SELECT 
        album_id,
        album_name,
        album_type,
        COUNT(track_id) AS total_tracks,
        AVG(track_popularity) AS avg_popularity,
        AVG(track_duration_min) AS avg_duration
    FROM spotify_cleaned_data
    GROUP BY album_id, album_name, album_type
)
SELECT 
    album_id,
    album_name,
    album_type,
    total_tracks,
    avg_popularity,
    avg_duration
FROM album_stats
WHERE avg_popularity > 60
ORDER BY avg_popularity DESC;




#90) Use a CTE to calculate the top 3 tracks per artist (using row_number inside the CTE).

WITH top_3_tracks_per_artist AS (
    SELECT 
        artist_name,
        track_name,
        track_popularity,
        ROW_NUMBER() OVER (
            PARTITION BY artist_name
            ORDER BY track_popularity DESC
        ) AS rn
    FROM spotify_cleaned_data
)
SELECT 
    artist_name,
    track_name,
    track_popularity,
    rn
FROM top_3_tracks_per_artist
WHERE rn <= 3
ORDER BY artist_name, rn;


#91) Use a CTE to calculate year-wise average popularity, and then find the year with the highest average popularity.

WITH year_avg_popularity AS (
    SELECT 
        YEAR(album_release_date) AS release_year,
        AVG(track_popularity) AS avg_popularity
    FROM spotify_cleaned_data
    GROUP BY YEAR(album_release_date)
)
SELECT 
    release_year,
    avg_popularity
FROM year_avg_popularity
ORDER BY avg_popularity DESC
LIMIT 1;




#92) Use a recursive CTE to generate a series of numbers (e.g. 1–12) and join to months extracted from album_release_date to show months with zero releases 
#(if your DB supports recursive CTEs).

WITH RECURSIVE months AS (
    SELECT 1 AS month_no
    UNION ALL
    SELECT month_no + 1
    FROM months
    WHERE month_no < 12
),
monthly_releases AS (
    SELECT 
        YEAR(album_release_date)  AS release_year,
        MONTH(album_release_date) AS release_month,
        COUNT(DISTINCT track_id)  AS track_count
    FROM spotify_cleaned_data
    WHERE YEAR(album_release_date) = 2025      -- change year if you want
    GROUP BY YEAR(album_release_date), MONTH(album_release_date)
)
SELECT 
    m.month_no                      AS month,
    COALESCE(mr.release_year, 2025) AS year,
    COALESCE(mr.track_count, 0)     AS track_count
FROM months m
LEFT JOIN monthly_releases mr
       ON mr.release_month = m.month_no
ORDER BY m.month_no;




#11. Data Quality / Cleaning–Style Questions

#93) Find rows where track_name is NULL or empty (if any).

select track_name
from spotify_cleaned_data
where track_name is null or track_name = "";



#94) Find rows where artist_genres is NULL or empty.

select artist_genres
from spotify_cleaned_data
where artist_genres is null or artist_genres = "";



#95) Count how many tracks have track_duration_min = 0 or very small (< 0.5), indicating possible data issues.

select track_name,
		track_duration_min
from spotify_cleaned_data
where track_duration_min = 0 or track_duration_min < 0.5;



#96) Find duplicate tracks based on track_name, artist_name, and album_name.

SELECT 
    track_name,
    artist_name,
    album_name,
    COUNT(*) AS duplicate_count
FROM spotify_cleaned_data
GROUP BY 
    track_name,
    artist_name,
    album_name
HAVING COUNT(*) > 1;



#97) For duplicates found above, keep only the row with highest track_popularity (design a query for that).

WITH ranked_duplicates AS (
    SELECT
        track_name,
        artist_name,
        album_name,
        track_popularity,
        ROW_NUMBER() OVER (
            PARTITION BY track_name, artist_name, album_name
            ORDER BY track_popularity DESC
        ) AS rn
    FROM spotify_cleaned_data
)
SELECT
    track_name,
    artist_name,
    album_name,
    track_popularity
FROM ranked_duplicates
WHERE rn = 1;



#98) Standardize genres: select distinct artist_genres values trimmed and lowercased (using TRIM/LOWER).

SELECT DISTINCT 
    LOWER(TRIM(artist_genres)) AS cleaned_genres
FROM spotify_cleaned_data
ORDER BY cleaned_genres;


#99) Replace NULL or empty artist_genres with 'unknown' (design an UPDATE statement or a COALESCE in SELECT).

SELECT 
    track_name,
    artist_genres,
    COALESCE(NULLIF(TRIM(artist_genres), ''), 'unknown') AS cleaned_genres
FROM spotify_cleaned_data;




#100) Check if track_number ever exceeds album_total_tracks (data inconsistency detection).

SELECT 
    track_name,
    artist_name,
    album_name,
    track_number,
    album_total_tracks
FROM spotify_cleaned_data
WHERE track_number > album_total_tracks;




#12. DDL / DML Practice (based on this table)

#101) Write a CREATE TABLE spotify_tracks statement matching this CSV structure with appropriate data types and primary key.

create table spotify_tracks as select * from spotify_cleaned_data;



#102) Add a primary key constraint on track_id.

ALTER TABLE spotify_tracks
ADD CONSTRAINT pk_track_id PRIMARY KEY (track_id);




#103) Add an index on artist_name and another index on (album_name, track_number).

CREATE INDEX idx_artist_name
ON spotify_tracks (artist_name);




#104) Add a new column created_at with a default current timestamp.

ALTER TABLE spotify_tracks
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;




#105) Insert a sample new track row into the table (assume some realistic values).

INSERT INTO spotify_tracks (
    track_id,
    track_name,
    track_number,
    track_popularity,
    explicit,
    artist_name,
    artist_popularity,
    artist_followers,
    artist_genres,
    album_id,
    album_name,
    album_release_date,
    album_total_tracks,
    album_type,
    track_duration_min,
    created_at
) VALUES (
    '7gQZK6b8LJVvMhgNsx3Rp1',                       -- track_id
    'Midnight Dreams',                              -- track_name
    3,                                              -- track_number
    78,                                             -- track_popularity
    0,                                              -- explicit
    'Dua Lipa',                                     -- artist_name
    92,                                             -- artist_popularity
    53300000,                                       -- artist_followers
    'pop, dance pop',                               -- artist_genres
    '4ZL8Qxr3NsRWSavwgJeayE',                       -- album_id
    'Future Nostalgia',                             -- album_name
    '2023-04-14',                                   -- album_release_date
    12,                                             -- album_total_tracks
    'album',                                        -- album_type
    3.45,                                           -- track_duration_min
    CURRENT_TIMESTAMP                               -- created_at
);




#106) Update all tracks for a specific artist to increase track_popularity by 5 (but max 100, using LEAST if supported).

UPDATE spotify_tracks
SET track_popularity = LEAST(track_popularity + 5, 100)
WHERE artist_name = 'Diplo';




#107) Delete tracks with track_popularity = 0 and artist_followers < 1000 (as “test data”).

DELETE FROM spotify_tracks
WHERE track_popularity = 0
  AND artist_followers < 1000;




#108) Create a view top_tracks_per_artist that shows each artist’s tracks with popularity > 70.

CREATE VIEW top_tracks_per_artist AS
SELECT 
    artist_name,
    track_name,
    track_popularity,
    album_name
FROM spotify_tracks
WHERE track_popularity > 70;




#109) Create a view daily_releases that shows album_release_date, album_name, and count of tracks per day.

CREATE VIEW daily_releases AS
SELECT 
    album_release_date,
    album_name,
    COUNT(track_id) AS tracks_released
FROM spotify_tracks
GROUP BY album_release_date, album_name;





#110) Drop the view you created above.

DROP VIEW IF EXISTS top_tracks_per_artist;
DROP VIEW IF EXISTS daily_releases;




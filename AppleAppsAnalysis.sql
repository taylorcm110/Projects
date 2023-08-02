Create Table applestore_description_combined as 

Select * From appleStore_description1

Union all 

Select * from appleStore_description2

union all 

Select * from appleStore_description3

union all 

select * from appleStore_description4

--Number of unique apps 
Select count(DISTINCT id) as UniqueAppIDs
From AppleStore
-- 7197

Select count(DISTINCT id) as UniqueAppIDs
From applestore_description_combined
--7197

--Check for missing values 
Select Count(*) as MissingValues
From AppleStore
where track_name is null or user_rating is null or prime_genre is null 
-- 0 missing values

Select Count(*) as MissingValues
From applestore_description_combined
where app_desc is null 
-- 0 missing values 

--Number of apps per genre
select prime_genre, count(*) as numapps
from AppleStore 
group by prime_genre
order by numapps desc 
--games 3862, entertainment 535, education 453, photo and video 349, utilities 248, health and fitness 180, 
--productivty 178, social networking 167, lifestyle 144, music 138, shopping 122, sports 114, book 112, finance 104, travel 81, news 75, 
--weather 72, reference 64, food and drink 63, business 57, navigation 46, medical 23, catalogs 10AppleStore

--Overview of apps' ratings
Select min(user_rating) as MinRating,
	   max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating 
From AppleStore
--MinRating 0, MaxRating 5, AvgRating 3.53

--Do paid apps have higher ratings than free apps? 
Select case 
			when price >0 then 'Paid' 
   			else 'Free' 
       End as App_Type, 
       avg(user_rating) as Avg_Rating 
From AppleStore
Group by App_Type 
-- Free Avg_Rating 3.38, Paid Avg_Rating 3.72

--Do apps that have more supported languages have higher ratings 
Select case 
			When lang_num < 10 then '<10 Languages' 
            When lang_num between 10 and 30 then '10-30 Languages' 
            Else '>30 Languages' 
       End as Language_Bucket,
       avg(user_rating) as Avg_Rating
From AppleStore
Group by Language_Bucket 
Order by Avg_Rating Desc 
-- <10 Languages Avg_Rating 3.37, 10-30 Language Avg_Rating 4.13, >30 Languages Avg_Rating 3.78

--Genres with low ratings 
Select prime_genre, 
	   avg(user_rating) as Avg_Rating 
From AppleStore
Group by prime_genre
Order by Avg_Rating ASc 
Limit 10 
-- Catalogs 2.1, Finance 2.43, Book 2.48, Navigation 2.68, Lifestyle 2.81, News 2.98, Sports 2.98 Social Netwroking 2.99, 
-- Food and Drink 3.18, Entertainment 3.25
    
-- Correlation between length of app description and user rating 
Select Case 
			When length(b.app_desc) <500 then 'Short' 
            When length(b.app_desc) between 500 and 1000 then 'Medium' 
            WHen length(b.app_desc) >1000 then 'Large' 
       End as Description_Length_Bucket,
       avg(a.user_rating) as Average_Rating 
From 
	AppleStore as A 
Join 
    applestore_description_combined as B 
On A.id = B.id 
Group By Description_Length_Bucket
order by Average_Rating DESC
-- Short Average_Rating 2.53, Medium Average_Rating 3.23, Large Average_Rating 3.86

--Top rated apps for each genre 
Select prime_genre, track_name, user_rating
FROM (
  	  select prime_genre, track_name, user_rating, RANK() OVER  
        (PARTITION BY prime_genre 
         Order by user_rating desc, rating_count_tot desc) as rank 
 	  from AppleStore
  	 ) as a
Where a.rank = 1

--Conlusion 
--Paid apps have better ratings than free apps
--Apps that support between 10 and 30 languages have the highest ratings over less than 10 and more than 30 
--Finance and book apps have low ratings 
--Apps with longer descriptions have higher ratings 
--A new app should aim for a rating above 3.5 
--Games and entertainment apps have high competition 
                                                                

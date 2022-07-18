-- create vine_table
CREATE TABLE vine_table (
  review_id TEXT PRIMARY KEY,
  star_rating INTEGER,
  helpful_votes INTEGER,
  total_votes INTEGER,
  vine TEXT,
  verified_purchase TEXT
)
;

-- create a table for reviews with at least 20 total votes
CREATE TABLE greater_than_twenty_votes AS
    SELECT * 
    FROM vine_table 
    WHERE total_votes >= 20
;

-- create a table for helpful reviews, defined as having helpful votes being at least 50% of the total votes
CREATE TABLE helpful_reviews AS
    SELECT * 
    FROM greater_than_twenty_votes 
    WHERE helpful_votes::FLOAT / total_votes::FLOAT >= 0.5
;

-- create a table of five-star reviews, building off the tables created above
CREATE TABLE five_star_reviews AS 
    SELECT *
    FROM helpful_reviews
    WHERE star_rating = 5
;    

-- create a table where reviews are part of the Vine program
CREATE TABLE paid_reviews AS 
    SELECT *
    FROM vine_table
    WHERE vine = 'Y'
; 

-- create a table where reviews are NOT part of the Vine program
CREATE TABLE unpaid_reviews AS 
    SELECT *
    FROM vine_table
    WHERE vine = 'N'
;

-- get the number of paid, or Vine reviews
SELECT 
	 COUNT(review_id) as num_vine_reviews
FROM paid_reviews
;

-- get the number of unpaid, or non-Vine reviews
SELECT 
	 COUNT(review_id) as num_vine_reviews
FROM unpaid_reviews
;

-- get the number of 5-star Vine and non-Vine reviews
SELECT 
	 vine, 
	 COUNT(review_id) num_reviews
FROM vine_table
WHERE star_rating = 5
GROUP BY vine
;

-- get the total number of reviews in the dataset, the number of 5-star reviews, the pct of Vine 5-star reviews out of all Vine reviews, and the pct of non-Vine 5-star reviews out of all non-Vine reviews
SELECT 
	 COUNT(review_id) as total_reviews,
	 SUM(CASE WHEN star_rating = 5 THEN 1 ELSE 0 END) num_five_star_reviews,
	 SUM(CASE WHEN vine = 'Y' AND star_rating = 5 THEN 1 ELSE 0 END)::FLOAT 
		 / 
	 	SUM(CASE WHEN vine = 'Y' THEN 1 ELSE 0 END)::FLOAT * 100 as pct_vine_five_star_reviews,
	 SUM(CASE WHEN vine = 'N' AND star_rating = 5 THEN 1 ELSE 0 END)::FLOAT 
	 	/ 
		SUM(CASE WHEN vine = 'N' THEN 1 ELSE 0 END)::FLOAT * 100 as pct__reviews
FROM vine_table 
;
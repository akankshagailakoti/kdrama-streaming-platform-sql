-- Scenario: Design a database for a K-Drama streaming platform that stores details about available dramas, registered users, 
-- and their watch history. The database will allow tracking of which dramas are most popular, how often users watch episodes, 
-- and what genres are trending over time.

CREATE DATABASE IF NOT EXISTS Kdrama;
USE Kdrama;

CREATE TABLE users 
(user_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL, 
username VARCHAR(55) NOT NULL, 
email VARCHAR(55) DEFAULT 'Not provided',     
subscription_type VARCHAR(55) NOT NULL, 
join_date DATE NOT NULL
);

CREATE TABLE dramas 
(drama_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL, 
title VARCHAR(55) NOT NULL, 
genre VARCHAR(55) NOT NULL, 
episodes INT NOT NULL, 
release_year YEAR NOT NULL, 
rating DECIMAL(4,2) NOT NULL, 
subtitles BOOLEAN NOT NULL);

CREATE TABLE watch_history 
(history_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL, 
user_id INT NOT NULL, 
drama_id INT NOT NULL, 
episodes_watched INT NOT NULL, 
date_watched DATE NOT NULL, 
duration_minutes INT NOT NULL,
FOREIGN KEY (user_id) REFERENCES users(user_id),
FOREIGN KEY (drama_id) REFERENCES dramas(drama_id)
);

SELECT * FROM users;
SELECT * FROM dramas;
SELECT * FROM watch_history;

INSERT INTO users (username, email, subscription_type, join_date)
VALUES
('akanksha', 'akanksha@email.com', 'Premium', '2023-09-15'),
('kimsoojin', 'soo.jin@email.com', 'Standard', '2023-10-02'),
('parktae', 'park.tae@email.com', 'Basic', '2023-11-12'),
('sungho_92', 'sung.ho@email.com', 'Premium', '2024-01-25'),
('yejin.k', 'yejin.k@email.com', 'Standard', '2024-02-05'),
('minjoo_07', 'minjoo@email.com', 'Premium', '2024-03-08'),
('leechan', 'lee.chan@email.com', 'Basic', '2024-04-18'),
('soomin_09', 'soomin@email.com', 'Premium', '2024-06-10'),
('jungwoo', 'jung.woo@email.com', 'Standard', '2024-07-20'),
('daisykim', 'daisy.kim@email.com', 'Premium', '2024-08-02');

INSERT INTO dramas (title, genre, episodes, release_year, rating, subtitles)
VALUES
('Crash Landing on You', 'Romance', 16, 2019, 9.2, TRUE),
('Vincenzo', 'Action', 20, 2021, 8.9, TRUE),
('Goblin', 'Fantasy', 16, 2016, 9.0, TRUE),
('Business Proposal', 'Comedy', 12, 2022, 8.5, FALSE),
('Itaewon Class', 'Drama', 16, 2020, 8.8, TRUE),
('Descendants of the Sun', 'Romance', 16, 2016, 9.1, TRUE),
('Sweet Home', 'Horror', 10, 2020, 8.3, TRUE),
('Alchemy of Souls', 'Fantasy', 20, 2022, 8.7, FALSE),
('The Glory', 'Thriller', 16, 2022, 8.9, TRUE),
('Twenty-Five Twenty-One', 'Youth', 16, 2022, 8.6, TRUE);

INSERT INTO watch_history (user_id, drama_id, episodes_watched, date_watched, duration_minutes)
VALUES
(1, 1, 1, '2024-06-01', 70),
(1, 1, 2, '2024-06-02', 68),
(2, 2, 1, '2024-06-03', 75),
(3, 4, 1, '2024-06-05', 65),
(4, 3, 1, '2024-06-07', 72),
(5, 5, 1, '2024-06-09', 68),
(6, 2, 2, '2024-06-10', 74),
(7, 6, 1, '2024-06-11', 70),
(8, 1, 3, '2024-06-13', 68),
(9, 8, 1, '2024-06-14', 73),
(10, 9, 1, '2024-06-15', 60),
(2, 2, 3, '2024-06-18', 70),
(4, 3, 2, '2024-06-19', 72),
(5, 4, 2, '2024-06-21', 67),
(6, 5, 2, '2024-06-22', 69),
(7, 7, 1, '2024-06-24', 66),
(8, 10, 1, '2024-06-25', 64),
(9, 9, 2, '2024-06-26', 61),
(10, 8, 2, '2024-06-27', 72),
(1, 6, 1, '2024-07-01', 70),
(2, 3, 3, '2024-07-02', 71),
(3, 1, 3, '2024-07-03', 68),
(4, 2, 4, '2024-07-04', 75),
(5, 9, 3, '2024-07-05', 63),
(6, 10, 2, '2024-07-06', 65);

SELECT * FROM dramas;
SELECT * FROM users;
SELECT * FROM watch_history;

-- ADDING, DELETING, AND UPDATING

-- 1. ADD a new drama called "Our Beloved Summer", genre "Romance", 16 episodes, released in 2021, rating 8.9, subtitles available.
INSERT INTO dramas (title, genre, episodes, release_year, rating, subtitles)
VALUES 
('Our beloved summer', 'romance', 16, 2021, 8.9, TRUE);

-- 2. Update episodes_watched for hana_lee to +1 for "Crash Landing on You" and increase the duration by 70 minutes
UPDATE watch_history AS wh  
JOIN users AS u ON wh.user_id = u.user_id
JOIN dramas AS d ON wh.drama_id = d.drama_id
SET 
	wh.episodes_watched = episodes_watched + 1,
    wh.duration_minutes = duration_minutes + 70
WHERE u.username = 'akanksha'
AND d.title = 'Crash Landing on You';

SELECT * FROM watch_history;

-- USING SET FUNCTIONS

-- 1. Find the average rating of all dramas
SELECT AVG (rating)
FROM dramas;

-- 2. Count how many dramas each user has watched
SELECT u.username, COUNT(DISTINCT drama_id) AS total_dramas_watched 
FROM watch_history AS wh
JOIN users AS u ON wh.user_id = u.user_id
GROUP BY u.username;

-- 3. Sum up the total episodes watched by all users
SELECT SUM(episodes_watched) as sum_all_episodes
FROM watch_history;

-- 4. Find the top 3 popular dramas based on total episodes watched
-- to find this i have to find which drama has the highest total episodes watched
SELECT d.title,
SUM(wh.episodes_watched) as popular_dramas
FROM watch_history AS wh
JOIN dramas AS d ON wh.drama_id = d.drama_id
GROUP BY wh.drama_id
ORDER BY popular_dramas DESC
Limit 3;

-- 5. Find the total viewing time per genre
SELECT d.genre, SUM(wh.duration_minutes) as viewing_time
FROM watch_history AS wh
JOIN dramas as d ON wh.drama_id = d.drama_id
GROUP BY d.genre
ORDER BY viewing_time DESC;

-- JOIN QUERIES
-- 1. List all dramas watched by akanksha, including the number of episodes watched and the date
SELECT u.username, d.title, wh.episodes_watched, wh.date_watched
FROM watch_history as wh
JOIN users as u ON wh.user_id = u.user_id
JOIN dramas as d ON wh.drama_id = d.drama_id
WHERE u.username = 'akanksha'
ORDER BY wh.date_watched ASC;

-- 2. Show each user with the titles of all dramas they watched
SELECT u.username, d.title AS dramas_watched
FROM watch_history AS wh
JOIN users AS u ON wh.user_id = u.user_id
JOIN dramas AS d ON wh.drama_id = d.drama_id
ORDER BY u.username ASC;

-- 3. Find the total episodes watched per user along with their subscription type
SELECT u.username, u.subscription_type, SUM(DISTINCT wh.episodes_watched) AS total_episodes_watched
FROM watch_history AS wh
JOIN users AS u ON wh.user_id = u.user_id
GROUP BY u.username, u.subscription_type
ORDER BY total_episodes_watched DESC;

-- 4. Find all users who watched dramas of the "Romance" genre
SELECT u.username, d.title
FROM watch_history AS wh
JOIN users AS u ON wh.user_id = u.user_id
JOIN dramas AS d ON wh.drama_id = d.drama_id
WHERE d.genre = 'Romance'
ORDER BY u.username ASC;

-- Using Built-in Functions
-- 1. Count how many episodes were watched in July 2024
SELECT SUM(episodes_watched) AS July24
FROM watch_history
WHERE MONTH(date_watched) = 7 AND YEAR(date_watched) = 2024;

-- Calculate the average number of episodes watched per month for each user
SELECT u.username, MONTH(wh.date_watched) AS month, AVG(wh.episodes_watched) AS average_episodes_watched
FROM watch_history AS wh
JOIN users AS u ON wh.user_id = u.user_id
GROUP BY u.username, MONTH(wh.date_watched);

-- ADDING, DELETING, AND UPDATING
-- 3. Remove the user parktae from the users table
DELETE FROM watch_history
WHERE user_id = (SELECT user_id FROM users WHERE username = 'parktae');

DELETE FROM users
WHERE username = 'parktae';


-- STORED PROCEDURE
-- Create a procedure that returns the most-watched dramas of June 2024.
DELIMITER //
CREATE PROCEDURE Get_most_watched_dramas_of_June()
BEGIN
	SELECT d.title, SUM(wh.episodes_watched) AS episodes_watched_june
    FROM watch_history AS wh
    JOIN dramas AS d ON wh.drama_id = d.drama_id
    WHERE MONTH(wh.date_watched) = 6
    GROUP BY d.title
    ORDER BY episodes_watched_june DESC
    LIMIT 3;
END //
DELIMITER //
    
CALL Get_most_watched_dramas_of_June();

/* QUERIES */

USE mvsocialdb;

/****************************/
/* MOVIE + DIRECTOR QUERIES */
/****************************/

/* Get the movie(s) directed by Joss Whedon. 
Outputs the movies name and directors First and Last name */
SELECT movie.title, director.first_name, director.last_name
FROM movie_direct
JOIN movie USING (movie_id)
JOIN director USING (director_id)
WHERE director.first_name = 'Joss' AND director.last_name = 'Whedon';

/* Get all the movies with more than 1 director */
SELECT movie.movie_id, movie.title, count(director.director_id) as `director number`
FROM movie_direct
JOIN movie USING (movie_id)
JOIN director USING (director_id)
GROUP BY movie.movie_id
HAVING `director number` > 1;

/* Get the top 3 longest movies by Runtime */
SELECT movie_id, title, length_mins as 'Runtime'
FROM movie
ORDER BY length_mins desc
limit 3;

/* Find out the director for the avengers series and get the average rating of the movie.
   The output displays the movie title , movie length, release year , average rate of movie and 
     the director first name ,last name and sorted by release year desc*/
SELECT movie.title, movie.Length_mins, movie.Release_Year, 
ROUND(AVG(rating.rating),2) As `average rating`, 
director.First_name, director.Last_name
FROM Movie_direct
JOIN movie USING (movie_id)
JOIN director USING (director_id)
NATURAL JOIN rating
GROUP BY movie.title
HAVING movie.title LIKE '%avengers%'
ORDER BY movie.Release_Year DESC;


/******************************/
/* LOCATION + THEATER QUERIES */
/******************************/

/* Get the movies that played in VIP rooms during 2019 */
SELECT movie.movie_id, movie.title, showing.show_date, theatreHasRoom.room_code
FROM movie
NATURAL JOIN showing
JOIN theatreHasRoom ON showing.theatreHasRoom_id = theatreHasRoom.theatreHasRoom_id
WHERE theatreHasRoom.room_code = 'VIP' AND showing.show_date LIKE '2019%'
ORDER BY showing.show_date;


/*****************************************/
/*SHOWING + THEATER + MOVIE QUERIES */
/*****************************************/

/* Find out the movie whose showing time is between 2019/11/15~2019/11/21 and in which theatre.
	The output displays the showing date between 2019/11/15~2019/11/21, movie title, movie length, 
    theatre name , theatre address and theatre state and sorted by show_date*/
SELECT showing.show_date, movie.title, movie.Length_mins,
theatre.theatre_name, theatre.theatre_address, theatre_state 
FROM showing 
INNER JOIN movie ON showing.movie_id=movie.movie_id
NATURAL JOIN theatrehasroom JOIN theatre ON theatrehasroom.theatre_id=theatre.theatre_id
WHERE showing.show_date BETWEEN '2019-11-15' AND '2019-11-21'
ORDER BY show_date ASC;

/**************************/
/* TICKET + SALES QUERIES */
/**************************/

/* Get the number of tickets sold and the total value of each showing, 
	ordered by profit and showing id*/
SELECT showing.showing_id AS `ID`, showing.show_date AS `Show Date`, showing.show_time AS `Show Time`, 
movie.title AS `Movie Title`, 
COUNT(ticket_id) AS `Number of Tickets Sold`, 
SUM(ticket_price) AS `Total Sales`
FROM ticket
JOIN showing USING (showing_id)
JOIN movie USING (movie_id)
GROUP BY showing.showing_id
ORDER BY `Total Sales` DESC, showing.showing_id;

/* Get the number of available seats for each showing, 
	ordered by available seats and showing id*/
SELECT showing.showing_id AS `Showing ID`, showing.show_date AS `Date`, showing.show_time AS `Time`, 
ABS(theatrehasroom.room_capacity - COUNT(ticket.ticket_id)) AS `Available Seats`
FROM showing
JOIN theatrehasroom USING (theatrehasroom_id)
NATURAL JOIN ticket
GROUP BY showing.showing_id
ORDER BY `Available Seats`, showing.showing_id;

/* Get the total sales for each movie showing */
SELECT showing.show_date as `showing date`, showing.show_time as `showing time`,
movie.movie_id as `movie id`, movie.title as `movie title`,
SUM(ticket.ticket_price) AS `total sales`
FROM ticket
INNER JOIN showing
ON ticket.showing_id = showing.showing_id
INNER JOIN movie
ON movie.movie_id = showing.movie_id
GROUP BY showing.show_date, showing.show_time, movie.movie_id;

/*************************/
/* USER + RATING QUERIES */
/*************************/


/* Get the highest rated movies (from everyone)*/
SELECT movie.title as `Title`, ROUND(AVG(rating.rating),2) as `Average Rating`
FROM movie
NATURAL JOIN rating
GROUP BY movie.movie_id
ORDER BY `Average Rating` DESC;

/* Get the movies with the largest number of ratings*/
SELECT movie.movie_id as `ID`, movie.title as `Title`, COUNT(rating_id) as `Number of Ratings`
FROM movie
NATURAL JOIN rating
GROUP BY movie.movie_id
ORDER BY `Number of Ratings` DESC;


/**** Call stored procedures and test****/
CALL getAllUserFriends(5);

CALL getAllUserRatings(1);

CALL getHighestRatedMoviesAmongFriends(45);


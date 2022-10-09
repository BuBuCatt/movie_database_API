-- ----------- 
-- -- SETUP --
-- -----------
DROP DATABASE IF EXISTS `mvsocialdb`;
CREATE SCHEMA IF NOT EXISTS `mvsocialdb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
use mvsocialdb;

-- -----------------------------------------------------
-- Table `mvsocialdb`.`theatre`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mvsocialdb`.`theatre`(
    `theatre_id` INT NOT NULL,
    `theatre_name` VARCHAR(20),
    `theatre_address` VARCHAR(40),
    `theatre_state` VARCHAR(10),
    `theatre_zip` INT,
PRIMARY KEY(theatre_id)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
KEY_BLOCK_SIZE = 1;

-- -----------------------------------------------------
-- Table `mvsocialdb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mvsocialdb`.`user` (
  `user_id` INT NOT NULL,
  `user_fname` VARCHAR(45) NULL,
  `user_lname` VARCHAR(45) NULL,
  `user_email` VARCHAR(45) NULL DEFAULT NULL,
  `user_birthdate` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `mvsocialdb`.`is_friends_with`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mvsocialdb`.`is_friends_with` (
  `is_friends_with_id` INT NOT NULL auto_increment,
  `user_id` INT NOT NULL,
  `friend_id` INT NOT NULL,
  PRIMARY KEY (`is_friends_with_id`),
  INDEX `fk_is_friends_with_user2_idx` (`friend_id` ASC) VISIBLE,
  CONSTRAINT `fk_is_friends_with_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mvsocialdb`.`user` (`user_id`),
  CONSTRAINT `fk_is_friends_with_user2`
    FOREIGN KEY (`friend_id`)
    REFERENCES `mvsocialdb`.`user` (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `mvsocialdb`.`director`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mvsocialdb`.`director` (
    director_id     INTEGER   NOT NULL,
    First_name       CHAR (50),
    Last_name        CHAR (50),
    Director_country varchar(50),
    PRIMARY KEY (
        Director_ID
    ))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mvsocialdb`.`movie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mvsocialdb`.`movie` (
  `movie_id` INT NOT NULL,
  `title` VARCHAR(45) NULL DEFAULT NULL,
  `Release_Year` INTEGER NULL,
    `Length_mins` INTEGER,
    `Movie_country`  varchar(50),
  PRIMARY KEY (`movie_id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `mvsocialdb`.`rating`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mvsocialdb`.`rating` (
  `rating_id` INT NOT NULL,
  `movie_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `rating_text` TEXT NULL DEFAULT NULL,
  `rating` INT NOT NULL,
  PRIMARY KEY (`rating_id`),
  FOREIGN KEY (`movie_id`)
     REFERENCES `mvsocialdb`.`movie` (`movie_id`)
     ON DELETE CASCADE,
  FOREIGN KEY (`user_id`)
     REFERENCES `mvsocialdb`.`user` (`user_id`)
     ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
KEY_BLOCK_SIZE = 1;

-- -----------------------------------------------------
-- Table `mvsocialdb`.`Movie_direct`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mvsocialdb`.`Movie_direct` (
    director_id  INT NOT NULL,
    movie_id INT NOT NULL,
    PRIMARY KEY( director_id ,movie_id),
    FOREIGN KEY(director_id ) 
        REFERENCES director(director_id )
        ON DELETE CASCADE,
    FOREIGN KEY(movie_id) 
        REFERENCES movie(movie_id)
        ON DELETE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `mvsocialdb`.`theaterHasRoom`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mvsocialdb`.`theatreHasRoom` (
    `theatreHasRoom_id` INT NOT NULL,
    `theatre_id` INT NOT NULL,
    `room_code` VARCHAR(3),
    `room_capacity` INT NOT NULL,
PRIMARY KEY(theatreHasRoom_id),
FOREIGN KEY (theatre_id) REFERENCES theatre (theatre_id)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `mvsocialdb`.`showing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mvsocialdb`.`showing` (
  `showing_id` INT NOT NULL,
  `theatreHasRoom_id` INT NOT NULL,
  `movie_id` INT NOT NULL,
  `show_date` DATE NULL DEFAULT NULL,
  `show_time` VARCHAR(50)  NULL DEFAULT NULL,
  PRIMARY KEY (`showing_id`, `theatreHasRoom_id`, `movie_id`),
  UNIQUE INDEX `showing_id_UNIQUE` (`showing_id` ASC) VISIBLE,
  INDEX `fk_Showing_Theater1_idx` (`theatreHasRoom_id` ASC) VISIBLE,
  INDEX `fk_Showing_Movie1_idx` (`movie_id` ASC) VISIBLE,
  CONSTRAINT `fk_Showing_Movie1`
    FOREIGN KEY (`theatreHasRoom_id`)
    REFERENCES `mvsocialdb`.`theatreHasRoom` (`theatreHasRoom_id`),
  CONSTRAINT `fk_Showing_Theater1`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mvsocialdb`.`movie` (`movie_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mvsocialdb`.`ticket`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mvsocialdb`.`ticket` (
  `ticket_id` INT NOT NULL,
  `showing_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `ticket_price` DECIMAL(13,2) NOT NULL,
  `ticket_seat_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`ticket_id`, `showing_id`, `user_id`),
  UNIQUE INDEX `ticket_id_UNIQUE` (`ticket_id` ASC) VISIBLE,
  INDEX `fk_Ticket_Showing1_idx` (`showing_id` ASC) VISIBLE,
  INDEX `fk_ticket_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_Ticket_Showing1`
    FOREIGN KEY (`showing_id`)
    REFERENCES `mvsocialdb`.`showing` (`showing_id`),
  CONSTRAINT `fk_ticket_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mvsocialdb`.`user` (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

/****************************************************/
/**************** STORED PROCEDURES *****************/
/****************************************************/

/* Find all ratings from a given user */
DROP PROCEDURE IF EXISTS getAllUserRatings;
DELIMITER //
CREATE PROCEDURE getAllUserRatings(Puser_id INT)
BEGIN
    SELECT rating.user_id, movie.title, rating.rating_text, rating.rating
    FROM rating
    JOIN movie USING (movie_id)
    WHERE user_id = Puser_id
    ORDER BY rating.rating DESC;
END //
DELIMITER ;

/* Get all friends for a given user  */
DROP PROCEDURE IF EXISTS getAllUserFriends;
DELIMITER $$
CREATE PROCEDURE getAllUserFriends(Puser_id INT)
BEGIN
    SELECT user.user_fname AS `First Name`, user.user_lname AS `Last Name`, user.user_email AS `Email`, 
    user.user_birthdate AS `DOB`
    FROM is_friends_with
    JOIN user ON is_friends_with.friend_id = user.user_id
    WHERE is_friends_with.user_id = Puser_id;
END $$
DELIMITER ;

/* Get the highest rated movies from friends */
DROP PROCEDURE IF EXISTS getHighestRatedMoviesAmongFriends;
DELIMITER !!
CREATE PROCEDURE getHighestRatedMoviesAmongFriends(Puser_id INT)
BEGIN
    SELECT movie.title AS `Title`, AVG(rating.rating) AS `Average Rating Among Friends`
    FROM rating
    JOIN movie USING (movie_id)
    WHERE rating.user_id IN (
        SELECT friend_id 
		FROM is_friends_with 
        WHERE user_id = 5
	)
    GROUP BY movie.title
    ORDER BY `Average Rating Among Friends` DESC;
END !!
DELIMITER ;


-- --------------------
-- -- SEED DIRECTOR ---
-- --------------------
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (1, 'Anthony', 'Russo', 'United States');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (2, 'Joe', 'Russo', 'United States');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (3, 'Colin', 'Trevorrow', 'United States');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (4, 'James', 'Wan', 'Australia');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (5, 'Michael', 'Bay', 'United States');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (6, 'F.Gary', 'Gray', 'United States');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (7, 'Haruo', 'Sotozaki', 'Japan');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (8, 'J.A', 'Bayona', 'Spain');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (9, 'Shane', 'Black', 'United States');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (10, 'Joss', 'Whedon', 'United States');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (11, 'Li', 'An', 'Taiwan');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (12, 'Jon', 'Watts', 'United States');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (13, 'Ryan', 'Coogler', 'United States');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (14, 'Bill', 'Condon', 'United States');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (15, 'Anna', 'Boden', 'United States');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (16, 'Ryan', 'Fleck', 'United States');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (17, 'Todd', 'Philips', 'United States');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (18, 'Jacob', 'Abrams', 'United States');
INSERT INTO Director (Director_ID, First_name, Last_name, Director_country) VALUES (19, 'Josh', 'Cooley', 'United States');

-- -----------------
-- -- SEED MOVIE ---
-- -----------------
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (1, 'Avengers Endgame', 2019, 181, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (2, 'Jurassic World', 2015, 124, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (3, 'Furious 7', 2015, 137, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (4, 'Transformers 3', 2011, 154, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (5, 'Furious8', 2017, 136, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (6, 'Avengers Infinity War', 2018, 149, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (7, 'Demon Slayer Infinte Train', 2020, 117, 'Japan');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (8, 'Jurassic World Fallen Kingdom', 2018, 128, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (9, 'Transformers 4 Rebirth from Extinction', 2014, 165, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (10, 'Iron Man 3 ', 2013, 131, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (11, 'The Avengers', 2012, 143, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (12, 'Avengers 2 Age of Ultron', 2015, 141, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (13, 'Spider Man : Far From Home', 2019, 129, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (14, 'Black Panther', 2018, 134, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (15, 'Beauty and the Beast', 2017, 129, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (16, 'Aquaman', 2019, 143, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (17, 'Captain Marvel', 2019, 124, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (18, 'Joker', 2019, 122, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (19, 'Star Wars: the rise of skywalker', 2019, 142, 'United States');
INSERT INTO Movie (Movie_ID, Title, Release_Year, Length_mins, Movie_country) VALUES (20, 'Toy Story', 2019, 100, 'United States');

-- -----------------------
-- -- SEED MOVIE_DIRECT --
-- ----------------------- 
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (1, 1);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (1, 2);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (2, 3);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (3, 4);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (4, 5);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (5, 6);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (6, 1);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (6, 2);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (7, 7);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (8, 8);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (9, 5);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (10, 9);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (11, 10);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (12, 10);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (13,12);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (14, 13);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (15, 14);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (16, 4);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (17, 15);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (17, 16);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (18, 17);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (19, 18);
INSERT INTO Movie_Direct (Movie_ID, Director_ID) VALUES (20, 19);

-- ------------------
-- -- SEED THEATRE --
-- ------------------
INSERT INTO theatre (theatre_id, theatre_name, theatre_address, theatre_state, theatre_zip) VALUES (1,'The Grandview','50 Gerald Crossing','WA',99252);
INSERT INTO theatre (theatre_id, theatre_name, theatre_address, theatre_state, theatre_zip) VALUES(2,'Amc Theaters ','36 Maryland Crossing','WA',98417);
INSERT INTO theatre (theatre_id, theatre_name, theatre_address, theatre_state, theatre_zip) VALUES(3,'Cygnet Theatre','1 Bartelt Crossing','WA',98121);
INSERT INTO theatre (theatre_id, theatre_name, theatre_address, theatre_state, theatre_zip) VALUES(4,'AMC Oak Tree 6','22 Fair Oaks Crossing','WA',98447);
INSERT INTO theatre (theatre_id, theatre_name, theatre_address, theatre_state, theatre_zip) VALUES(5,'Charm City','9832 Pennsylvania Pass','WA',99252);
INSERT INTO theatre (theatre_id, theatre_name, theatre_address, theatre_state, theatre_zip) VALUES(6,'MovieTown','05 Bluestem Parkway','WA',98042);
INSERT INTO theatre (theatre_id, theatre_name, theatre_address, theatre_state, theatre_zip) VALUES(7,'Coalition Theater','16 Ruskin Court','WA',98417);
INSERT INTO theatre (theatre_id, theatre_name, theatre_address, theatre_state, theatre_zip) VALUES(8,'Movie Town','08029 Alpine Center','WA',98687);
INSERT INTO theatre (theatre_id, theatre_name, theatre_address, theatre_state, theatre_zip) VALUES(9,'Regal Meridian 16','05211 Clemons Way','WA',99252);
INSERT INTO theatre (theatre_id, theatre_name, theatre_address, theatre_state, theatre_zip) VALUES(10,'AMC Pacific Place 11','826 Bartillon Point','WA',98687);
    
-- -------------------------
-- -- SEED THEATREHASROOM --
-- -------------------------
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(2,1,'B',125);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES (1,1,'A',100);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(3,1,'C',125);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(4,1,'D',150);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(5,1,'E',150);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(6,2,'A',150);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(7,2,'B',150);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(8,2,'C',175);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(9,3,'A',100);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(10,3,'B',100);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(11,3,'C',150);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(12,3,'D',200);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(13,4,'A',115);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(14,4,'B',125);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(15,4,'C',135);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(16,4,'D',145);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(17,4,'E',150);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(18,4,'VIP',80);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(19,5,'A',90);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(20,5,'B',90);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(21,5,'C',150);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(22,6,'A',150);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(23,6,'B',150);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(24,6,'C',250);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(25,6,'D',250);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(26,6,'E',300);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(27,6,'VIP',100);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(28,7,'A',50);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(29,7,'B',60);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(30,7,'C',80);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(31,8,'A',125);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(32,8,'B',125);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(33,8,'C',150);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(34,8,'D',150);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(35,9,'A',200);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(36,9,'B',250);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(37,9,'C',250);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(38,9,'D',350);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(39,9,'E',350);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(40,10,'A',100);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(41,10,'B',100);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(42,10,'C',250);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(43,10,'D',250);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(44,10,'E',500);
INSERT INTO theatreHasRoom (theatreHasRoom_id,theatre_id,room_code,room_capacity) VALUES(45,10,'VIP',75);

-- -------------------
-- -- SEED SHOWING ---
-- -------------------
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES (1,1,13,'2019-10-22 ','19:08:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(2,2,17,'2019-11-20 ','12:26:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(3,3,18,'2019-01-20 ','10:46:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(4,4,19,'2019-06-04 ','10:54:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(5,5,20,'2019-02-24 ','16:39:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(6,6,1,'2019-07-16 ','14:24:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(7,7,7,'2019-06-02 ','16:56:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(8,18,13,'2019-11-25 ','17:22:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(9,9,17,'2019-07-10 ','11:05:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(10,10,18,'2019-09-18 ','12:29:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(11,11,19,'2019-01-03 ','13:49:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(12,12,20,'2019-08-18 ','19:51:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(13,13,1,'2019-07-17 ','14:06:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(14,14,7,'2019-03-03','12:44:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(15,15,13,'2019-02-09 ','18:41:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(16,16,17,'2019-07-21 ','20:12:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(17,17,18,'2019-11-17 ','12:48:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(18,18,19,'2019-04-19 ','16:57:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(19,19,20,'2019-04-19 ','16:45:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(20,20,1,'2019-06-23 ','10:18:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(21,21,7,'2019-09-18 ','20:05:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(22,15,13,'2019-01-03 ','19:24:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(23,23,17,'2019-08-18 ','20:54:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(24,24,18,'2019-07-17 ','21:16:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(25,18,19,'2019-03-03 ','18:24:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(26,26,8,'2018-08-18 ','10:48:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(27,27,1,'2019-07-17 ','18:26:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(28,1,7,'2018-03-03 ','14:32:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(29,2,13,'2019-02-09 ','20:01:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(30,3,17,'2019-12-28 ','13:36:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(31,4,18,'2019-02-28 ','23:36:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(32,5,19,'2019-03-19 ','12:35:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(33,6,20,'2019-11-16 ','23:38:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(34,7,1,'2019-10-21 ','23:28:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(35,8,14,'2018-02-10 ','22:09:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(36,9,15,'2017-04-19 ','12:44:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(37,37,15,'2017-10-17 ','21:43:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(38,38,14,'2018-05-22 ','21:25:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(39,39,15,'2017-07-16 ','11:44:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(40,40,5,'2017-08-16 ','20:08:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(41,41,5,'2017-08-16 ','19:43:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(42,42,5,'2017-07-05 ','12:22:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(43,43,6,'2018-01-19 ','23:09:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(44,44,15,'2017-06-23 ','23:48:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(45,45,5,'2017-04-10 ','20:57:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(46,15,15,'2017-04-09 ','13:44:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(47,20,6,'2018-07-21 ','13:53:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(48,27,5,'2017-09-19 ','16:32:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(49,18,6,'2018-10-31 ','13:09:00');
INSERT INTO showing (showing_id, theatreHasRoom_id, movie_id, show_date, show_time) VALUES(50,21,15,'2017-04-09 ','16:25:00');

-- ---------------
-- -- SEED USER --
-- ---------------
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (1, 'Willetta', 'Earland', 'wearland0@yellowbook.com', '1926-02-27');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (2, 'Wini', 'Maccraw', 'wmaccraw1@mac.com', '1980-06-20');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (3, 'Jordan', 'Bland', 'jbland2@tumblr.com', '1953-03-30');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (4, 'Kenn', 'Langstone', 'klangstone3@tamu.edu', '1965-05-25');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (5, 'Sallyann', 'Tireman', 'stireman4@springer.com', '1926-09-04');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (6, 'Dionysus', 'Muscott', 'dmuscott5@seattletimes.com', '1992-04-29');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (7, 'Enos', 'Sharplin', 'esharplin6@odnoklassniki.ru', '1922-11-02');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (8, 'Dorita', 'Danser', 'ddanser7@trellian.com', '1935-01-23');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (9, 'Herschel', 'McIleen', 'hmcileen8@earthlink.net', '1941-07-24');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (10, 'Lothaire', 'Shuker', 'lshuker9@geocities.jp', '1966-05-16');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (11, 'Karoly', 'Carse', 'kcarsea@pcworld.com', '1959-12-01');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (12, 'Missie', 'Cicetti', 'mcicettib@nationalgeographic.com', '1952-03-19');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (13, 'Torry', 'Gration', 'tgrationc@ezinearticles.com', '1992-04-06');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (14, 'Deanna', 'Shaw', 'dshawd@phpbb.com', '1920-01-09');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (15, 'Silvana', 'Hoggan', 'shoggane@imageshack.us', '1924-04-05');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (16, 'Dorotea', 'Craker', 'dcrakerf@1und1.de', '1997-02-23');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (17, 'Emera', 'Bothe', 'ebotheg@webnode.com', '1948-07-12');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (18, 'Timmie', 'Tait', 'ttaith@arizona.edu', '1933-11-23');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (19, 'Eveline', 'Barnewell', 'ebarnewelli@nyu.edu', '1924-11-30');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (20, 'Mayer', 'Baike', 'mbaikej@nps.gov', '1967-07-16');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (21, 'Nefen', 'Tarbett', 'ntarbettk@homestead.com', '1934-05-11');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (22, 'Bartholomeo', 'Mallender', 'bmallenderl@intel.com', '1964-06-12');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (23, 'Timothea', 'Bahia', 'tbahiam@usda.gov', '2005-09-06');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (24, 'Rock', 'Loughnan', 'rloughnann@salon.com', '2004-08-15');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (25, 'Ardath', 'Bowry', 'abowryo@whitehouse.gov', '2001-06-24');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (26, 'Janeczka', 'Womack', 'jwomackp@china.com.cn', '1949-05-13');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (27, 'Shelagh', 'Fairest', 'sfairestq@tripadvisor.com', '1974-10-31');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (28, 'Ellis', 'Rosso', 'erossor@timesonline.co.uk', '1951-01-31');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (29, 'Rani', 'Borg', 'rborgs@jugem.jp', '1998-05-01');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (30, 'Leah', 'Dunbobin', 'ldunbobint@businesswire.com', '1968-08-31');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (31, 'Jessalyn', 'Hazelden', 'jhazeldenu@sphinn.com', '2006-05-15');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (32, 'Sada', 'Venditti', 'svendittiv@webeden.co.uk', '1905-03-11');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (33, 'Kat', 'Giacometti', 'kgiacomettiw@buzzfeed.com', '1944-08-19');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (34, 'Malva', 'Hedden', 'mheddenx@freewebs.com', '1982-02-24');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (35, 'Purcell', 'Pressnell', 'ppressnelly@mysql.com', '2006-10-01');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (36, 'Goddart', 'O''Corren', 'gocorrenz@dot.gov', '1943-05-28');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (37, 'Orbadiah', 'Janousek', 'ojanousek10@sphinn.com', '1927-01-14');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (38, 'Reginald', 'Whitcombe', 'rwhitcombe11@webmd.com', '1945-06-08');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (39, 'Bryant', 'Senter', 'bsenter12@t.co', '1981-10-06');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (40, 'Conrade', 'Norker', 'cnorker13@rambler.ru', '1986-12-09');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (41, 'Stevena', 'Breeder', 'sbreeder14@etsy.com', '1993-03-11');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (42, 'Rudy', 'Kennerknecht', 'rkennerknecht15@cornell.edu', '1980-05-19');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (43, 'Jimmy', 'Galton', 'jgalton16@purevolume.com', '1969-12-03');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (44, 'Bartram', 'Hallsworth', 'bhallsworth17@vinaora.com', '1958-05-01');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (45, 'Sisely', 'Cormode', 'scormode18@elpais.com', '1932-12-22');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (46, 'Niels', 'Maundrell', 'nmaundrell19@cbc.ca', '1939-05-03');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (47, 'Webb', 'Kibbey', 'wkibbey1a@rediff.com', '1937-07-30');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (48, 'Carin', 'Alexis', 'calexis1b@wordpress.com', '1994-02-12');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (49, 'Sim', 'Fallanche', 'sfallanche1c@technorati.com', '1922-08-16');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (50, 'Elbertine', 'Hellcat', 'ehellcat1d@e-recht24.de', '1943-01-04');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (51, 'Candy', 'Faber', 'cfaber1e@google.ru', '1976-02-16');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (52, 'Justinn', 'Walczynski', 'jwalczynski1f@lulu.com', '1900-10-11');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (53, 'Morgana', 'Pethick', 'mpethick1g@storify.com', '1904-08-08');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (54, 'Glen', 'Fuentez', 'gfuentez1h@nydailynews.com', '1969-02-07');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (55, 'Kailey', 'Bencher', 'kbencher1i@dmoz.org', '1913-09-02');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (56, 'Roddy', 'Glasard', 'rglasard1j@unicef.org', '1949-11-10');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (57, 'Brittaney', 'Shyram', 'bshyram1k@cnbc.com', '1900-04-04');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (58, 'Hube', 'Treske', 'htreske1l@blogspot.com', '1909-05-09');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (59, 'Jeffie', 'Pikett', 'jpikett1m@freewebs.com', '1917-12-28');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (60, 'Devonna', 'Loughnan', 'dloughnan1n@cargocollective.com', '1908-06-21');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (61, 'Winni', 'Waylen', 'wwaylen1o@mapy.cz', '1989-06-21');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (62, 'Gratia', 'Keningley', 'gkeningley1p@unicef.org', '2018-05-19');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (63, 'Filia', 'Guilbert', 'fguilbert1q@sciencedaily.com', '1965-01-14');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (64, 'Lexi', 'Woolacott', 'lwoolacott1r@blogtalkradio.com', '2000-06-09');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (65, 'Nancee', 'Petrie', 'npetrie1s@china.com.cn', '1980-02-26');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (66, 'Zora', 'Balmer', 'zbalmer1t@yellowpages.com', '1932-01-25');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (67, 'Anastasie', 'Bilton', 'abilton1u@cloudflare.com', '1967-01-23');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (68, 'Zitella', 'Van Der Walt', 'zvanderwalt1v@trellian.com', '1926-08-30');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (69, 'Ashla', 'Fickling', 'afickling1w@oracle.com', '1963-09-08');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (70, 'Ashbey', 'Rawcliff', 'arawcliff1x@nasa.gov', '1976-09-02');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (71, 'Walliw', 'Massie', 'wmassie1y@devhub.com', '1988-06-04');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (72, 'Rivy', 'Bevans', 'rbevans1z@usa.gov', '1934-08-22');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (73, 'Philbert', 'Boleyn', 'pboleyn20@surveymonkey.com', '2012-01-19');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (74, 'Adriano', 'Olivie', 'aolivie21@reuters.com', '1993-01-12');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (75, 'Kristine', 'Denington', 'kdenington22@mozilla.org', '1962-09-02');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (76, 'Heinrick', 'Pettican', 'hpettican23@arizona.edu', '2007-12-30');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (77, 'Gavan', 'Broughton', 'gbroughton24@mashable.com', '2005-03-25');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (78, 'Andonis', 'Venes', 'avenes25@pagesperso-orange.fr', '1934-02-26');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (79, 'Bran', 'Bendel', 'bbendel26@shinystat.com', '1982-08-08');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (80, 'Sadye', 'Hardstaff', 'shardstaff27@skyrock.com', '1998-10-07');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (81, 'Dorolisa', 'Levett', 'dlevett28@census.gov', '1904-09-02');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (82, 'Efren', 'Schoular', 'eschoular29@accuweather.com', '2003-05-25');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (83, 'Binny', 'Kester', 'bkester2a@bluehost.com', '1995-06-12');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (84, 'Cordey', 'Luckin', 'cluckin2b@umich.edu', '1916-09-02');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (85, 'Aprilette', 'Brisbane', 'abrisbane2c@rediff.com', '1964-12-07');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (86, 'Myrvyn', 'Fahrenbacher', 'mfahrenbacher2d@livejournal.com', '1986-05-02');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (87, 'Aurilia', 'Geffe', 'ageffe2e@jiathis.com', '2017-03-28');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (88, 'Lena', 'Woodruffe', 'lwoodruffe2f@zimbio.com', '1924-03-16');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (89, 'Alister', 'Evitts', 'aevitts2g@qq.com', '1956-01-07');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (90, 'Nathan', 'Toby', 'ntoby2h@tamu.edu', '1908-10-03');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (91, 'Ryley', 'Benadette', 'rbenadette2i@github.com', '1950-03-09');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (92, 'Nerti', 'Freezor', 'nfreezor2j@tinypic.com', '1995-05-11');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (93, 'Mireille', 'Dominguez', 'mdominguez2k@apple.com', '1920-04-12');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (94, 'Tobe', 'Lilian', 'tlilian2l@npr.org', '2010-06-09');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (95, 'Garvy', 'Geaveny', 'ggeaveny2m@sun.com', '1939-01-29');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (96, 'Laure', 'Jennemann', 'ljennemann2n@aboutads.info', '1907-02-07');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (97, 'Guinna', 'Mawd', 'gmawd2o@cocolog-nifty.com', '1930-08-03');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (98, 'Cariotta', 'Joselson', 'cjoselson2p@netlog.com', '2017-02-28');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (99, 'Elsy', 'Fetherstone', 'efetherstone2q@moonfruit.com', '1991-10-20');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (100, 'Mattheus', 'Blake', 'mblake2r@biblegateway.com', '2012-02-17');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (101, 'Corrinne', 'Gibbins', 'cgibbins2s@symantec.com', '1924-01-24');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (102, 'Thornie', 'Measham', 'tmeasham2t@techcrunch.com', '2015-03-21');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (103, 'Michele', 'Brehat', 'mbrehat2u@redcross.org', '1990-03-26');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (104, 'Konstance', 'Scotts', 'kscotts2v@who.int', '1936-01-05');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (105, 'Birgitta', 'Garcia', 'bgarcia2w@gmpg.org', '1972-04-24');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (106, 'Ellynn', 'Maxweell', 'emaxweell2x@blogs.com', '1964-11-05');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (107, 'Kori', 'Shiers', 'kshiers2y@tiny.cc', '1934-02-04');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (108, 'Genny', 'de Leon', 'gdeleon2z@tripadvisor.com', '1984-02-04');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (109, 'Christalle', 'Potebury', 'cpotebury30@amazonaws.com', '1944-07-01');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (110, 'Tiffy', 'Carmo', 'tcarmo31@nature.com', '1985-11-07');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (111, 'Randene', 'Barrasse', 'rbarrasse32@webeden.co.uk', '1920-08-18');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (112, 'Ardeen', 'Robertson', 'arobertson33@si.edu', '1922-09-29');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (113, 'Haleigh', 'Burker', 'hburker34@cbc.ca', '1950-08-13');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (114, 'Roslyn', 'Hallahan', 'rhallahan35@bbb.org', '1933-12-30');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (115, 'Maurine', 'Dulen', 'mdulen36@constantcontact.com', '1946-01-15');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (116, 'Paolina', 'Dedham', 'pdedham37@delicious.com', '2008-02-22');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (117, 'Orsa', 'Devoy', 'odevoy38@gmpg.org', '2000-03-11');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (118, 'Boyd', 'Jansa', 'bjansa39@is.gd', '1973-11-11');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (119, 'Coriss', 'Spalls', 'cspalls3a@parallels.com', '1914-05-19');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (120, 'Umeko', 'Gasken', 'ugasken3b@tinypic.com', '1907-05-15');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (121, 'Nancee', 'Ochterlony', 'nochterlony3c@answers.com', '1984-12-18');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (122, 'Patrizia', 'Lindsell', 'plindsell3d@yale.edu', '2013-08-28');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (123, 'Jerrie', 'Binnie', 'jbinnie3e@cpanel.net', '1947-07-30');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (124, 'Coraline', 'O''Doohaine', 'codoohaine3f@miitbeian.gov.cn', '1929-10-06');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (125, 'Tom', 'Jeeves', 'tjeeves3g@simplemachines.org', '2018-01-16');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (126, 'Rowe', 'Bazelle', 'rbazelle3h@army.mil', '1975-05-30');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (127, 'Norean', 'Fradgley', 'nfradgley3i@qq.com', '1959-07-18');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (128, 'Sonny', 'Witterick', 'switterick3j@fc2.com', '1915-06-15');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (129, 'Lenette', 'Reddoch', 'lreddoch3k@fastcompany.com', '1946-08-17');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (130, 'Donni', 'Tait', 'dtait3l@tinypic.com', '2018-08-10');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (131, 'Suzette', 'Kellar', 'skellar3m@odnoklassniki.ru', '1965-09-13');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (132, 'Esma', 'Stollberger', 'estollberger3n@skyrock.com', '1995-01-02');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (133, 'Cicily', 'Spellessy', 'cspellessy3o@apache.org', '1930-04-20');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (134, 'Sarette', 'Borne', 'sborne3p@simplemachines.org', '1968-05-29');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (135, 'Clerissa', 'Ledes', 'cledes3q@t.co', '1942-10-27');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (136, 'Reeta', 'Gibb', 'rgibb3r@studiopress.com', '1965-03-23');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (137, 'Jonis', 'Faltin', 'jfaltin3s@ihg.com', '2007-02-10');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (138, 'Allegra', 'Hands', 'ahands3t@hugedomains.com', '2006-11-27');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (139, 'Ronni', 'Sugar', 'rsugar3u@washingtonpost.com', '1922-08-29');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (140, 'Yves', 'Mugridge', 'ymugridge3v@sakura.ne.jp', '1914-11-21');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (141, 'Kizzie', 'Scrowston', 'kscrowston3w@google.com', '1982-08-07');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (142, 'Griselda', 'Gronous', 'ggronous3x@apache.org', '2019-05-28');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (143, 'Rachele', 'Andrea', 'randrea3y@wikia.com', '1944-04-05');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (144, 'Durant', 'Di Franceschi', 'ddifranceschi3z@loc.gov', '1955-10-01');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (145, 'Kayley', 'Jarman', 'kjarman40@tamu.edu', '1996-04-11');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (146, 'Kristine', 'Danter', 'kdanter41@php.net', '1931-07-09');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (147, 'Loren', 'Dod', 'ldod42@weibo.com', '1978-07-31');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (148, 'Vanna', 'Newlands', 'vnewlands43@amazon.co.jp', '1987-10-28');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (149, 'Hannis', 'Colcomb', 'hcolcomb44@mapy.cz', '1985-04-12');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (150, 'Celene', 'Whiteland', 'cwhiteland45@cbsnews.com', '1984-11-06');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (151, 'Sal', 'Petr', 'spetr46@cpanel.net', '2011-07-27');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (152, 'Amabel', 'MacGuiness', 'amacguiness47@aol.com', '1980-01-31');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (153, 'Flory', 'Bronger', 'fbronger48@cdc.gov', '1982-09-01');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (154, 'Elfrieda', 'Petrasso', 'epetrasso49@economist.com', '1906-06-21');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (155, 'Ashley', 'Inker', 'ainker4a@lulu.com', '1992-11-15');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (156, 'Kissiah', 'Kwietek', 'kkwietek4b@purevolume.com', '1998-12-28');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (157, 'Imogene', 'Dudson', 'idudson4c@cbc.ca', '1997-12-24');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (158, 'Raphaela', 'Goater', 'rgoater4d@ehow.com', '1949-01-09');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (159, 'Alvin', 'Radke', 'aradke4e@tripadvisor.com', '1989-09-22');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (160, 'Betty', 'Erswell', 'berswell4f@pinterest.com', '1952-11-10');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (161, 'Darill', 'Ditzel', 'dditzel4g@bloomberg.com', '1934-12-24');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (162, 'Thedric', 'Mutimer', 'tmutimer4h@slate.com', '1919-09-06');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (163, 'Darbie', 'Hein', 'dhein4i@dmoz.org', '1951-07-22');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (164, 'Leyla', 'Tregonna', 'ltregonna4j@spotify.com', '1926-09-04');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (165, 'Luis', 'Cornner', 'lcornner4k@globo.com', '1979-06-13');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (166, 'Antons', 'MacCahey', 'amaccahey4l@unc.edu', '1953-06-12');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (167, 'Starla', 'Longworthy', 'slongworthy4m@cornell.edu', '2003-04-22');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (168, 'Tildie', 'Elloit', 'telloit4n@opensource.org', '2019-11-30');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (169, 'Aron', 'Frangello', 'afrangello4o@washingtonpost.com', '1972-07-06');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (170, 'Anselm', 'Probart', 'aprobart4p@csmonitor.com', '1976-03-01');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (171, 'Anjela', 'Hearfield', 'ahearfield4q@google.ru', '1947-09-22');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (172, 'Georgette', 'Aim', 'gaim4r@google.ca', '2011-06-01');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (173, 'Carol', 'Maciaszczyk', 'cmaciaszczyk4s@examiner.com', '1969-01-26');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (174, 'Bunny', 'Berrey', 'bberrey4t@webeden.co.uk', '1935-05-08');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (175, 'Vida', 'Buick', 'vbuick4u@purevolume.com', '1926-10-19');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (176, 'Merna', 'Gurdon', 'mgurdon4v@barnesandnoble.com', '1940-07-24');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (177, 'Shelly', 'Hindrick', 'shindrick4w@wikia.com', '1907-04-04');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (178, 'Welby', 'Lakenden', 'wlakenden4x@google.com.hk', '1938-07-23');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (179, 'Radcliffe', 'Brearley', 'rbrearley4y@domainmarket.com', '1923-01-13');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (180, 'Brear', 'Tremayne', 'btremayne4z@so-net.ne.jp', '1929-12-23');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (181, 'Winni', 'Giraudou', 'wgiraudou50@hibu.com', '1961-06-28');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (182, 'Kirk', 'Mercy', 'kmercy51@themeforest.net', '2016-01-06');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (183, 'Lanny', 'Brashier', 'lbrashier52@bizjournals.com', '2021-07-15');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (184, 'Noni', 'Wescott', 'nwescott53@issuu.com', '1975-09-26');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (185, 'Eolande', 'Kiossel', 'ekiossel54@forbes.com', '1981-06-06');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (186, 'Ernaline', 'Dunston', 'edunston55@slideshare.net', '1924-08-16');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (187, 'Doloritas', 'Pullar', 'dpullar56@spiegel.de', '1965-04-26');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (188, 'Cora', 'Parkisson', 'cparkisson57@twitter.com', '1905-03-15');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (189, 'Guss', 'Labes', 'glabes58@rambler.ru', '1971-09-19');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (190, 'Shaw', 'Tudor', 'studor59@purevolume.com', '2019-05-28');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (191, 'Gunther', 'Folan', 'gfolan5a@myspace.com', '1906-01-08');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (192, 'Sampson', 'Wallworke', 'swallworke5b@studiopress.com', '1951-09-15');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (193, 'Madella', 'Skaif', 'mskaif5c@imageshack.us', '1961-09-04');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (194, 'Myer', 'Heugel', 'mheugel5d@nih.gov', '1957-12-03');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (195, 'Wye', 'Teml', 'wteml5e@dropbox.com', '1921-09-30');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (196, 'Catharina', 'Sarch', 'csarch5f@netlog.com', '1977-11-13');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (197, 'Urbain', 'Pashler', 'upashler5g@msu.edu', '1934-06-06');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (198, 'Zandra', 'Baltzar', 'zbaltzar5h@comsenz.com', '1931-03-25');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (199, 'Heywood', 'Harris', 'hharris5i@bloglovin.com', '1996-07-18');
insert into USER (user_id, user_fname, user_lname, user_email, user_birthdate) values (200, 'Farrel', 'Milesop', 'fmilesop5j@etsy.com', '1964-06-16');

-- -----------------
-- -- SEED RATING --
-- -----------------
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (1, 2, 39, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (2, 7, 93, 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (3, 9, 98, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (4, 5, 78, 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (5, 9, 125, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (6, 9, 42, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (7, 5, 147, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (8, 18, 74, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (9, 11, 90, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (10, 5, 58, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (11, 20, 88, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (12, 18, 158, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (13, 16, 39, 'In congue. Etiam justo. Etiam pretium iaculis justo.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (14, 4, 67, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (15, 16, 71, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (16, 8, 97, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (17, 17, 104, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (18, 6, 12, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (19, 7, 100, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (20, 7, 84, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (21, 16, 33, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (22, 19, 153, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (23, 1, 140, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (24, 7, 85, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (25, 15, 160, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (26, 17, 4, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (27, 8, 162, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (28, 2, 94, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (29, 2, 115, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (30, 5, 50, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (31, 2, 120, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (32, 3, 79, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (33, 17, 36, 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (34, 20, 193, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (35, 5, 106, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (36, 11, 189, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (37, 9, 8, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (38, 18, 127, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (39, 18, 182, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (40, 5, 136, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (41, 11, 198, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (42, 14, 19, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (43, 20, 99, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (44, 20, 19, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (45, 19, 165, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (46, 15, 57, 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (47, 11, 48, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (48, 1, 111, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (49, 8, 186, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (50, 7, 73, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (51, 19, 61, 'Fusce consequat. Nulla nisl. Nunc nisl.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (52, 5, 38, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (53, 7, 200, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (54, 13, 123, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (55, 7, 54, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (56, 10, 18, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (57, 12, 30, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (58, 13, 178, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (59, 4, 19, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (60, 7, 127, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (61, 15, 99, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (62, 19, 175, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (63, 13, 61, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (64, 13, 11, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (65, 11, 160, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (66, 12, 51, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (67, 5, 165, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (68, 16, 41, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (69, 14, 97, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (70, 2, 51, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (71, 17, 103, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (72, 5, 106, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (73, 19, 187, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (74, 10, 167, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (75, 14, 93, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (76, 2, 150, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (77, 4, 186, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (78, 15, 57, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (79, 17, 78, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (80, 12, 42, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (81, 16, 163, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (82, 14, 7, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (83, 2, 130, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (84, 13, 36, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (85, 20, 155, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (86, 7, 169, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (87, 11, 147, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (88, 1, 132, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (89, 1, 96, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (90, 18, 109, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (91, 9, 96, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (92, 19, 127, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (93, 2, 31, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (94, 16, 181, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (95, 18, 165, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (96, 2, 101, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (97, 5, 193, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (98, 14, 169, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (99, 10, 77, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (100, 2, 169, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (101, 15, 182, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (102, 9, 133, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (103, 16, 184, 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (104, 15, 109, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (105, 19, 140, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (106, 7, 196, 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (107, 10, 167, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (108, 12, 66, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (109, 10, 100, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (110, 4, 114, 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (111, 11, 122, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (112, 16, 133, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (113, 5, 141, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (114, 9, 75, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (115, 14, 129, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (116, 7, 45, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (117, 10, 37, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (118, 16, 80, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (119, 1, 44, 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (120, 12, 47, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (121, 2, 70, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (122, 16, 26, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (123, 5, 101, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (124, 10, 7, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (125, 3, 164, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (126, 14, 196, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (127, 15, 155, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.

Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (128, 14, 96, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (129, 13, 95, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (130, 19, 96, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (131, 9, 193, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (132, 16, 136, 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (133, 13, 31, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (134, 1, 9, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (135, 19, 140, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (136, 7, 91, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (137, 14, 73, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (138, 11, 183, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (139, 15, 72, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (140, 3, 54, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (141, 15, 81, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (142, 9, 1, 'In congue. Etiam justo. Etiam pretium iaculis justo.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (143, 12, 166, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (144, 3, 28, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (145, 14, 150, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (146, 7, 116, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (147, 3, 104, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (148, 10, 176, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (149, 8, 45, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (150, 4, 60, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (151, 7, 64, 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (152, 15, 91, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (153, 4, 13, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (154, 6, 92, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (155, 8, 37, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (156, 2, 190, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (157, 17, 14, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (158, 15, 167, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (159, 11, 182, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (160, 20, 33, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (161, 20, 58, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (162, 20, 163, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (163, 1, 196, 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (164, 3, 12, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (165, 18, 118, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (166, 7, 106, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (167, 4, 55, 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (168, 6, 145, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (169, 13, 144, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (170, 7, 148, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (171, 9, 151, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (172, 4, 141, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (173, 12, 106, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (174, 4, 18, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (175, 8, 14, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (176, 4, 119, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (177, 19, 177, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (178, 11, 76, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (179, 5, 163, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (180, 17, 177, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (181, 16, 18, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (182, 20, 182, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (183, 13, 127, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (184, 20, 137, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (185, 1, 23, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (186, 1, 118, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (187, 3, 193, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (188, 14, 33, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (189, 7, 148, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (190, 16, 9, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (191, 9, 97, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (192, 11, 197, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (193, 4, 120, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (194, 19, 136, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (195, 16, 198, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (196, 20, 184, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (197, 4, 48, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (198, 18, 176, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (199, 13, 15, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (200, 11, 18, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (201, 10, 199, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (202, 12, 116, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (203, 18, 23, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (204, 3, 26, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (205, 4, 145, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (206, 15, 61, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (207, 1, 101, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (208, 11, 69, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (209, 15, 48, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (210, 1, 173, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (211, 8, 65, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (212, 12, 169, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (213, 17, 47, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (214, 15, 55, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (215, 19, 21, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (216, 6, 171, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (217, 2, 104, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (218, 6, 83, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (219, 2, 79, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (220, 5, 168, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (221, 4, 25, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (222, 11, 152, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (223, 6, 123, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (224, 12, 148, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (225, 6, 1, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (226, 1, 62, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (227, 14, 189, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (228, 14, 127, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (229, 7, 158, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (230, 18, 70, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (231, 6, 28, 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (232, 9, 61, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (233, 5, 157, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (234, 7, 56, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (235, 3, 91, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (236, 9, 173, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (237, 20, 99, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (238, 5, 122, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (239, 3, 181, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (240, 14, 67, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (241, 15, 21, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (242, 4, 85, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (243, 14, 114, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (244, 16, 174, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (245, 18, 84, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (246, 7, 174, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (247, 12, 125, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (248, 6, 161, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (249, 1, 106, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (250, 8, 190, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (251, 11, 179, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (252, 20, 90, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (253, 16, 133, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (254, 3, 35, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (255, 6, 196, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (256, 3, 106, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (257, 13, 1, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (258, 9, 48, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (259, 12, 50, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (260, 16, 56, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (261, 3, 189, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (262, 6, 7, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (263, 18, 61, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (264, 12, 84, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (265, 6, 198, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (266, 15, 19, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (267, 6, 44, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (268, 13, 86, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (269, 10, 80, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (270, 8, 89, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (271, 6, 98, 'Fusce consequat. Nulla nisl. Nunc nisl.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (272, 16, 20, 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (273, 8, 122, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (274, 8, 21, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (275, 14, 66, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (276, 11, 140, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (277, 7, 156, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (278, 17, 10, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (279, 5, 9, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (280, 17, 63, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (281, 16, 117, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (282, 13, 15, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (283, 7, 92, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (284, 13, 17, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (285, 10, 171, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (286, 11, 88, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (287, 20, 103, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (288, 8, 33, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (289, 6, 11, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (290, 8, 104, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (291, 6, 24, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (292, 2, 122, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (293, 12, 130, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (294, 17, 171, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (295, 14, 41, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (296, 7, 104, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (297, 6, 166, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (298, 5, 108, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (299, 13, 160, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (300, 8, 71, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (301, 13, 185, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (302, 18, 135, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (303, 19, 94, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (304, 13, 130, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (305, 9, 2, 'Fusce consequat. Nulla nisl. Nunc nisl.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (306, 14, 100, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (307, 8, 119, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (308, 20, 189, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (309, 9, 53, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (310, 20, 57, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (311, 15, 3, 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (312, 12, 86, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (313, 5, 156, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (314, 16, 184, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (315, 6, 10, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (316, 20, 140, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (317, 20, 114, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (318, 8, 125, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (319, 18, 110, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (320, 1, 110, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (321, 19, 55, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (322, 9, 130, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (323, 10, 108, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (324, 8, 28, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (325, 14, 31, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (326, 9, 107, 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (327, 7, 176, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (328, 20, 111, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (329, 9, 81, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (330, 16, 73, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (331, 3, 85, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (332, 10, 70, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (333, 9, 124, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (334, 5, 43, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (335, 20, 20, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (336, 6, 92, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (337, 14, 101, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (338, 1, 194, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (339, 20, 138, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (340, 17, 103, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (341, 3, 56, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (342, 20, 116, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (343, 3, 161, 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (344, 10, 159, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (345, 15, 127, 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (346, 10, 45, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (347, 20, 185, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (348, 11, 98, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (349, 15, 43, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (350, 5, 73, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (351, 2, 45, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (352, 11, 178, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (353, 17, 3, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (354, 4, 94, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (355, 19, 139, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (356, 14, 126, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (357, 4, 12, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (358, 13, 128, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (359, 13, 117, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (360, 17, 149, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (361, 4, 8, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (362, 19, 134, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (363, 19, 32, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (364, 17, 155, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (365, 14, 28, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (366, 4, 55, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (367, 4, 3, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (368, 11, 53, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (369, 5, 58, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (370, 14, 108, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (371, 16, 24, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (372, 8, 128, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (373, 20, 69, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (374, 8, 18, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (375, 20, 70, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (376, 2, 113, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (377, 7, 36, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (378, 19, 200, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (379, 13, 119, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (380, 14, 144, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (381, 18, 18, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (382, 6, 115, 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (383, 5, 60, 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (384, 1, 5, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (385, 17, 22, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (386, 12, 20, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (387, 11, 47, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (388, 11, 48, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (389, 15, 89, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (390, 15, 198, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (391, 10, 194, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (392, 14, 127, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (393, 1, 114, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (394, 4, 116, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (395, 17, 52, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (396, 16, 17, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (397, 5, 135, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (398, 5, 69, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (399, 19, 154, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (400, 1, 162, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (401, 1, 125, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (402, 17, 10, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (403, 12, 162, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (404, 9, 152, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (405, 20, 2, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (406, 14, 42, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (407, 7, 69, 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (408, 5, 31, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (409, 10, 63, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (410, 17, 73, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (411, 14, 132, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (412, 15, 70, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (413, 19, 148, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (414, 7, 83, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (415, 7, 8, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (416, 1, 79, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (417, 2, 156, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (418, 9, 2, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (419, 20, 22, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (420, 8, 180, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (421, 5, 117, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (422, 1, 79, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (423, 15, 152, 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (424, 17, 86, 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (425, 16, 141, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (426, 4, 88, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (427, 10, 67, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (428, 7, 78, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (429, 14, 76, 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (430, 8, 197, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (431, 3, 199, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (432, 16, 72, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (433, 9, 42, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (434, 15, 10, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (435, 13, 84, 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (436, 9, 129, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (437, 2, 20, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (438, 20, 150, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (439, 8, 103, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (440, 15, 51, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (441, 19, 83, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (442, 12, 34, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (443, 10, 87, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (444, 20, 149, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (445, 2, 182, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (446, 18, 20, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (447, 3, 186, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (448, 16, 44, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (449, 16, 39, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (450, 1, 165, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (451, 5, 102, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (452, 12, 157, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (453, 20, 7, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (454, 18, 47, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (455, 4, 81, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (456, 12, 47, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.

Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (457, 4, 89, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (458, 3, 167, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (459, 10, 40, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (460, 15, 116, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (461, 7, 24, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (462, 14, 78, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (463, 16, 37, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (464, 9, 138, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (465, 15, 59, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (466, 17, 13, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (467, 17, 130, 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (468, 7, 117, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (469, 17, 189, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (470, 9, 66, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (471, 18, 126, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (472, 15, 81, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (473, 19, 151, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (474, 4, 200, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (475, 2, 126, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (476, 15, 173, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (477, 6, 52, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (478, 9, 100, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (479, 9, 178, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (480, 8, 11, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (481, 15, 162, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (482, 17, 27, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.

Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (483, 17, 46, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (484, 8, 189, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (485, 13, 42, 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (486, 15, 15, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (487, 3, 9, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (488, 2, 96, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (489, 19, 6, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (490, 8, 138, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (491, 11, 125, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (492, 4, 163, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 4);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (493, 10, 74, 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (494, 14, 29, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (495, 1, 31, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 5);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (496, 3, 96, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (497, 13, 65, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 3);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (498, 8, 8, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 2);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (499, 20, 177, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 1);
insert into rating (rating_id, movie_id, user_id, rating_text, rating) values (500, 9, 33, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 2);


-- --------------------------
-- -- SEED IS_FRIENDS_WITH --
-- --------------------------
insert into is_friends_with (user_id, friend_id) values (30, 123);
insert into is_friends_with (user_id, friend_id) values (99, 30);
insert into is_friends_with (user_id, friend_id) values (80, 161);
insert into is_friends_with (user_id, friend_id) values (87, 8);
insert into is_friends_with (user_id, friend_id) values (19, 108);
insert into is_friends_with (user_id, friend_id) values (74, 67);
insert into is_friends_with (user_id, friend_id) values (23, 77);
insert into is_friends_with (user_id, friend_id) values (43, 76);
insert into is_friends_with (user_id, friend_id) values (52, 68);
insert into is_friends_with (user_id, friend_id) values (67, 161);
insert into is_friends_with (user_id, friend_id) values (37, 170);
insert into is_friends_with (user_id, friend_id) values (5, 126);
insert into is_friends_with (user_id, friend_id) values (73, 155);
insert into is_friends_with (user_id, friend_id) values (23, 60);
insert into is_friends_with (user_id, friend_id) values (96, 32);
insert into is_friends_with (user_id, friend_id) values (14, 64);
insert into is_friends_with (user_id, friend_id) values (63, 90);
insert into is_friends_with (user_id, friend_id) values (34, 77);
insert into is_friends_with (user_id, friend_id) values (21, 197);
insert into is_friends_with (user_id, friend_id) values (80, 162);
insert into is_friends_with (user_id, friend_id) values (80, 1);
insert into is_friends_with (user_id, friend_id) values (8, 89);
insert into is_friends_with (user_id, friend_id) values (78, 133);
insert into is_friends_with (user_id, friend_id) values (13, 49);
insert into is_friends_with (user_id, friend_id) values (89, 142);
insert into is_friends_with (user_id, friend_id) values (44, 177);
insert into is_friends_with (user_id, friend_id) values (44, 170);
insert into is_friends_with (user_id, friend_id) values (58, 85);
insert into is_friends_with (user_id, friend_id) values (15, 33);
insert into is_friends_with (user_id, friend_id) values (22, 136);
insert into is_friends_with (user_id, friend_id) values (63, 126);
insert into is_friends_with (user_id, friend_id) values (66, 93);
insert into is_friends_with (user_id, friend_id) values (24, 52);
insert into is_friends_with (user_id, friend_id) values (90, 114);
insert into is_friends_with (user_id, friend_id) values (37, 71);
insert into is_friends_with (user_id, friend_id) values (99, 197);
insert into is_friends_with (user_id, friend_id) values (32, 158);
insert into is_friends_with (user_id, friend_id) values (62, 34);
insert into is_friends_with (user_id, friend_id) values (66, 111);
insert into is_friends_with (user_id, friend_id) values (51, 146);
insert into is_friends_with (user_id, friend_id) values (18, 110);
insert into is_friends_with (user_id, friend_id) values (50, 2);
insert into is_friends_with (user_id, friend_id) values (71, 72);
insert into is_friends_with (user_id, friend_id) values (47, 12);
insert into is_friends_with (user_id, friend_id) values (30, 128);
insert into is_friends_with (user_id, friend_id) values (30, 146);
insert into is_friends_with (user_id, friend_id) values (86, 122);
insert into is_friends_with (user_id, friend_id) values (62, 82);
insert into is_friends_with (user_id, friend_id) values (84, 119);
insert into is_friends_with (user_id, friend_id) values (96, 46);
insert into is_friends_with (user_id, friend_id) values (6, 48);
insert into is_friends_with (user_id, friend_id) values (87, 108);
insert into is_friends_with (user_id, friend_id) values (11, 176);
insert into is_friends_with (user_id, friend_id) values (54, 119);
insert into is_friends_with (user_id, friend_id) values (75, 37);
insert into is_friends_with (user_id, friend_id) values (54, 46);
insert into is_friends_with (user_id, friend_id) values (3, 166);
insert into is_friends_with (user_id, friend_id) values (45, 127);
insert into is_friends_with (user_id, friend_id) values (53, 103);
insert into is_friends_with (user_id, friend_id) values (81, 120);
insert into is_friends_with (user_id, friend_id) values (40, 51);
insert into is_friends_with (user_id, friend_id) values (28, 159);
insert into is_friends_with (user_id, friend_id) values (28, 50);
insert into is_friends_with (user_id, friend_id) values (26, 73);
insert into is_friends_with (user_id, friend_id) values (32, 13);
insert into is_friends_with (user_id, friend_id) values (76, 54);
insert into is_friends_with (user_id, friend_id) values (69, 153);
insert into is_friends_with (user_id, friend_id) values (43, 132);
insert into is_friends_with (user_id, friend_id) values (80, 115);
insert into is_friends_with (user_id, friend_id) values (63, 59);
insert into is_friends_with (user_id, friend_id) values (45, 171);
insert into is_friends_with (user_id, friend_id) values (59, 102);
insert into is_friends_with (user_id, friend_id) values (54, 180);
insert into is_friends_with (user_id, friend_id) values (26, 149);
insert into is_friends_with (user_id, friend_id) values (96, 38);
insert into is_friends_with (user_id, friend_id) values (80, 46);
insert into is_friends_with (user_id, friend_id) values (64, 171);
insert into is_friends_with (user_id, friend_id) values (87, 183);
insert into is_friends_with (user_id, friend_id) values (38, 110);
insert into is_friends_with (user_id, friend_id) values (82, 174);
insert into is_friends_with (user_id, friend_id) values (14, 2);
insert into is_friends_with (user_id, friend_id) values (22, 142);
insert into is_friends_with (user_id, friend_id) values (87, 64);
insert into is_friends_with (user_id, friend_id) values (44, 32);
insert into is_friends_with (user_id, friend_id) values (67, 76);
insert into is_friends_with (user_id, friend_id) values (28, 68);
insert into is_friends_with (user_id, friend_id) values (92, 82);
insert into is_friends_with (user_id, friend_id) values (93, 128);
insert into is_friends_with (user_id, friend_id) values (41, 59);
insert into is_friends_with (user_id, friend_id) values (59, 32);
insert into is_friends_with (user_id, friend_id) values (93, 154);
insert into is_friends_with (user_id, friend_id) values (41, 80);
insert into is_friends_with (user_id, friend_id) values (45, 184);
insert into is_friends_with (user_id, friend_id) values (91, 11);
insert into is_friends_with (user_id, friend_id) values (28, 61);
insert into is_friends_with (user_id, friend_id) values (40, 9);
insert into is_friends_with (user_id, friend_id) values (67, 168);
insert into is_friends_with (user_id, friend_id) values (30, 27);
insert into is_friends_with (user_id, friend_id) values (73, 6);
insert into is_friends_with (user_id, friend_id) values (23, 161);
insert into is_friends_with (user_id, friend_id) values (44, 112);
insert into is_friends_with (user_id, friend_id) values (28, 89);
insert into is_friends_with (user_id, friend_id) values (7, 22);
insert into is_friends_with (user_id, friend_id) values (83, 101);
insert into is_friends_with (user_id, friend_id) values (30, 144);
insert into is_friends_with (user_id, friend_id) values (7, 101);
insert into is_friends_with (user_id, friend_id) values (94, 180);
insert into is_friends_with (user_id, friend_id) values (99, 95);
insert into is_friends_with (user_id, friend_id) values (7, 89);
insert into is_friends_with (user_id, friend_id) values (92, 15);
insert into is_friends_with (user_id, friend_id) values (15, 127);
insert into is_friends_with (user_id, friend_id) values (99, 154);
insert into is_friends_with (user_id, friend_id) values (32, 59);
insert into is_friends_with (user_id, friend_id) values (65, 191);
insert into is_friends_with (user_id, friend_id) values (19, 129);
insert into is_friends_with (user_id, friend_id) values (19, 175);
insert into is_friends_with (user_id, friend_id) values (39, 74);
insert into is_friends_with (user_id, friend_id) values (64, 131);
insert into is_friends_with (user_id, friend_id) values (92, 14);
insert into is_friends_with (user_id, friend_id) values (59, 189);
insert into is_friends_with (user_id, friend_id) values (90, 121);
insert into is_friends_with (user_id, friend_id) values (82, 146);
insert into is_friends_with (user_id, friend_id) values (60, 135);
insert into is_friends_with (user_id, friend_id) values (12, 19);
insert into is_friends_with (user_id, friend_id) values (40, 125);
insert into is_friends_with (user_id, friend_id) values (68, 131);
insert into is_friends_with (user_id, friend_id) values (48, 173);
insert into is_friends_with (user_id, friend_id) values (83, 182);
insert into is_friends_with (user_id, friend_id) values (68, 165);
insert into is_friends_with (user_id, friend_id) values (55, 14);
insert into is_friends_with (user_id, friend_id) values (12, 75);
insert into is_friends_with (user_id, friend_id) values (79, 56);
insert into is_friends_with (user_id, friend_id) values (13, 90);
insert into is_friends_with (user_id, friend_id) values (10, 168);
insert into is_friends_with (user_id, friend_id) values (89, 135);
insert into is_friends_with (user_id, friend_id) values (38, 157);
insert into is_friends_with (user_id, friend_id) values (57, 183);
insert into is_friends_with (user_id, friend_id) values (96, 195);
insert into is_friends_with (user_id, friend_id) values (50, 55);
insert into is_friends_with (user_id, friend_id) values (61, 144);
insert into is_friends_with (user_id, friend_id) values (91, 36);
insert into is_friends_with (user_id, friend_id) values (75, 185);
insert into is_friends_with (user_id, friend_id) values (9, 16);
insert into is_friends_with (user_id, friend_id) values (22, 82);
insert into is_friends_with (user_id, friend_id) values (26, 13);
insert into is_friends_with (user_id, friend_id) values (57, 34);
insert into is_friends_with (user_id, friend_id) values (27, 104);
insert into is_friends_with (user_id, friend_id) values (90, 87);
insert into is_friends_with (user_id, friend_id) values (43, 130);
insert into is_friends_with (user_id, friend_id) values (82, 161);
insert into is_friends_with (user_id, friend_id) values (80, 76);
insert into is_friends_with (user_id, friend_id) values (99, 193);
insert into is_friends_with (user_id, friend_id) values (21, 8);
insert into is_friends_with (user_id, friend_id) values (33, 93);
insert into is_friends_with (user_id, friend_id) values (33, 82);
insert into is_friends_with (user_id, friend_id) values (83, 155);
insert into is_friends_with (user_id, friend_id) values (93, 21);
insert into is_friends_with (user_id, friend_id) values (58, 160);
insert into is_friends_with (user_id, friend_id) values (1, 79);
insert into is_friends_with (user_id, friend_id) values (28, 95);
insert into is_friends_with (user_id, friend_id) values (31, 124);
insert into is_friends_with (user_id, friend_id) values (48, 100);
insert into is_friends_with (user_id, friend_id) values (14, 68);
insert into is_friends_with (user_id, friend_id) values (82, 67);
insert into is_friends_with (user_id, friend_id) values (35, 181);
insert into is_friends_with (user_id, friend_id) values (17, 30);
insert into is_friends_with (user_id, friend_id) values (15, 55);
insert into is_friends_with (user_id, friend_id) values (75, 87);
insert into is_friends_with (user_id, friend_id) values (80, 41);
insert into is_friends_with (user_id, friend_id) values (73, 77);
insert into is_friends_with (user_id, friend_id) values (22, 106);
insert into is_friends_with (user_id, friend_id) values (82, 30);
insert into is_friends_with (user_id, friend_id) values (78, 130);
insert into is_friends_with (user_id, friend_id) values (63, 58);
insert into is_friends_with (user_id, friend_id) values (65, 141);
insert into is_friends_with (user_id, friend_id) values (17, 112);
insert into is_friends_with (user_id, friend_id) values (84, 25);
insert into is_friends_with (user_id, friend_id) values (84, 179);
insert into is_friends_with (user_id, friend_id) values (18, 46);
insert into is_friends_with (user_id, friend_id) values (72, 30);
insert into is_friends_with (user_id, friend_id) values (78, 28);
insert into is_friends_with (user_id, friend_id) values (27, 40);
insert into is_friends_with (user_id, friend_id) values (15, 21);
insert into is_friends_with (user_id, friend_id) values (15, 196);
insert into is_friends_with (user_id, friend_id) values (74, 136);
insert into is_friends_with (user_id, friend_id) values (11, 2);
insert into is_friends_with (user_id, friend_id) values (42, 86);
insert into is_friends_with (user_id, friend_id) values (72, 45);
insert into is_friends_with (user_id, friend_id) values (4, 21);
insert into is_friends_with (user_id, friend_id) values (21, 163);
insert into is_friends_with (user_id, friend_id) values (33, 76);
insert into is_friends_with (user_id, friend_id) values (5, 10);
insert into is_friends_with (user_id, friend_id) values (20, 183);
insert into is_friends_with (user_id, friend_id) values (88, 44);
insert into is_friends_with (user_id, friend_id) values (50, 135);
insert into is_friends_with (user_id, friend_id) values (16, 139);
insert into is_friends_with (user_id, friend_id) values (19, 185);
insert into is_friends_with (user_id, friend_id) values (37, 162);
insert into is_friends_with (user_id, friend_id) values (2, 172);
insert into is_friends_with (user_id, friend_id) values (6, 193);
insert into is_friends_with (user_id, friend_id) values (37, 154);
insert into is_friends_with (user_id, friend_id) values (98, 21);
insert into is_friends_with (user_id, friend_id) values (23, 11);
insert into is_friends_with (user_id, friend_id) values (24, 99);
insert into is_friends_with (user_id, friend_id) values (25, 77);
insert into is_friends_with (user_id, friend_id) values (27, 108);
insert into is_friends_with (user_id, friend_id) values (16, 70);
insert into is_friends_with (user_id, friend_id) values (93, 116);
insert into is_friends_with (user_id, friend_id) values (81, 99);
insert into is_friends_with (user_id, friend_id) values (7, 98);
insert into is_friends_with (user_id, friend_id) values (29, 106);
insert into is_friends_with (user_id, friend_id) values (24, 173);
insert into is_friends_with (user_id, friend_id) values (52, 85);
insert into is_friends_with (user_id, friend_id) values (61, 23);
insert into is_friends_with (user_id, friend_id) values (83, 96);
insert into is_friends_with (user_id, friend_id) values (74, 100);
insert into is_friends_with (user_id, friend_id) values (86, 5);
insert into is_friends_with (user_id, friend_id) values (55, 88);
insert into is_friends_with (user_id, friend_id) values (66, 13);
insert into is_friends_with (user_id, friend_id) values (25, 175);
insert into is_friends_with (user_id, friend_id) values (8, 10);
insert into is_friends_with (user_id, friend_id) values (73, 95);
insert into is_friends_with (user_id, friend_id) values (82, 189);
insert into is_friends_with (user_id, friend_id) values (92, 155);
insert into is_friends_with (user_id, friend_id) values (35, 7);
insert into is_friends_with (user_id, friend_id) values (59, 107);
insert into is_friends_with (user_id, friend_id) values (42, 97);
insert into is_friends_with (user_id, friend_id) values (71, 79);
insert into is_friends_with (user_id, friend_id) values (74, 73);
insert into is_friends_with (user_id, friend_id) values (52, 17);
insert into is_friends_with (user_id, friend_id) values (14, 79);
insert into is_friends_with (user_id, friend_id) values (82, 143);
insert into is_friends_with (user_id, friend_id) values (34, 74);
insert into is_friends_with (user_id, friend_id) values (65, 26);
insert into is_friends_with (user_id, friend_id) values (52, 44);
insert into is_friends_with (user_id, friend_id) values (37, 37);
insert into is_friends_with (user_id, friend_id) values (35, 23);
insert into is_friends_with (user_id, friend_id) values (31, 69);
insert into is_friends_with (user_id, friend_id) values (94, 121);
insert into is_friends_with (user_id, friend_id) values (65, 144);
insert into is_friends_with (user_id, friend_id) values (94, 52);
insert into is_friends_with (user_id, friend_id) values (76, 10);
insert into is_friends_with (user_id, friend_id) values (27, 63);
insert into is_friends_with (user_id, friend_id) values (45, 75);
insert into is_friends_with (user_id, friend_id) values (59, 37);
insert into is_friends_with (user_id, friend_id) values (76, 55);
insert into is_friends_with (user_id, friend_id) values (27, 7);
insert into is_friends_with (user_id, friend_id) values (83, 64);
insert into is_friends_with (user_id, friend_id) values (39, 181);
insert into is_friends_with (user_id, friend_id) values (96, 99);
insert into is_friends_with (user_id, friend_id) values (74, 10);
insert into is_friends_with (user_id, friend_id) values (18, 37);
insert into is_friends_with (user_id, friend_id) values (58, 143);
insert into is_friends_with (user_id, friend_id) values (62, 163);
insert into is_friends_with (user_id, friend_id) values (55, 98);
insert into is_friends_with (user_id, friend_id) values (5, 25);
insert into is_friends_with (user_id, friend_id) values (92, 80);
insert into is_friends_with (user_id, friend_id) values (66, 75);
insert into is_friends_with (user_id, friend_id) values (10, 128);
insert into is_friends_with (user_id, friend_id) values (79, 56);
insert into is_friends_with (user_id, friend_id) values (3, 137);
insert into is_friends_with (user_id, friend_id) values (75, 126);
insert into is_friends_with (user_id, friend_id) values (10, 86);
insert into is_friends_with (user_id, friend_id) values (54, 163);
insert into is_friends_with (user_id, friend_id) values (29, 176);
insert into is_friends_with (user_id, friend_id) values (10, 112);
insert into is_friends_with (user_id, friend_id) values (76, 1);
insert into is_friends_with (user_id, friend_id) values (47, 176);
insert into is_friends_with (user_id, friend_id) values (62, 185);
insert into is_friends_with (user_id, friend_id) values (29, 64);
insert into is_friends_with (user_id, friend_id) values (48, 28);
insert into is_friends_with (user_id, friend_id) values (20, 180);
insert into is_friends_with (user_id, friend_id) values (78, 92);
insert into is_friends_with (user_id, friend_id) values (45, 173);
insert into is_friends_with (user_id, friend_id) values (58, 185);
insert into is_friends_with (user_id, friend_id) values (29, 43);
insert into is_friends_with (user_id, friend_id) values (96, 187);
insert into is_friends_with (user_id, friend_id) values (82, 8);
insert into is_friends_with (user_id, friend_id) values (70, 1);
insert into is_friends_with (user_id, friend_id) values (30, 79);
insert into is_friends_with (user_id, friend_id) values (77, 107);
insert into is_friends_with (user_id, friend_id) values (34, 4);
insert into is_friends_with (user_id, friend_id) values (39, 72);
insert into is_friends_with (user_id, friend_id) values (14, 111);
insert into is_friends_with (user_id, friend_id) values (42, 73);
insert into is_friends_with (user_id, friend_id) values (94, 39);
insert into is_friends_with (user_id, friend_id) values (8, 145);
insert into is_friends_with (user_id, friend_id) values (27, 127);
insert into is_friends_with (user_id, friend_id) values (5, 99);
insert into is_friends_with (user_id, friend_id) values (96, 45);
insert into is_friends_with (user_id, friend_id) values (71, 173);
insert into is_friends_with (user_id, friend_id) values (90, 111);
insert into is_friends_with (user_id, friend_id) values (64, 30);
insert into is_friends_with (user_id, friend_id) values (80, 13);
insert into is_friends_with (user_id, friend_id) values (32, 46);
insert into is_friends_with (user_id, friend_id) values (74, 34);
insert into is_friends_with (user_id, friend_id) values (87, 66);
insert into is_friends_with (user_id, friend_id) values (7, 32);
insert into is_friends_with (user_id, friend_id) values (4, 152);
insert into is_friends_with (user_id, friend_id) values (64, 49);
insert into is_friends_with (user_id, friend_id) values (97, 35);
insert into is_friends_with (user_id, friend_id) values (10, 47);
insert into is_friends_with (user_id, friend_id) values (66, 28);
insert into is_friends_with (user_id, friend_id) values (52, 143);
insert into is_friends_with (user_id, friend_id) values (24, 108);
insert into is_friends_with (user_id, friend_id) values (7, 104);
insert into is_friends_with (user_id, friend_id) values (2, 17);
insert into is_friends_with (user_id, friend_id) values (41, 110);
insert into is_friends_with (user_id, friend_id) values (69, 189);
insert into is_friends_with (user_id, friend_id) values (95, 157);
insert into is_friends_with (user_id, friend_id) values (46, 140);
insert into is_friends_with (user_id, friend_id) values (69, 16);
insert into is_friends_with (user_id, friend_id) values (99, 4);
insert into is_friends_with (user_id, friend_id) values (15, 84);
insert into is_friends_with (user_id, friend_id) values (74, 61);
insert into is_friends_with (user_id, friend_id) values (54, 184);
insert into is_friends_with (user_id, friend_id) values (52, 109);
insert into is_friends_with (user_id, friend_id) values (19, 187);
insert into is_friends_with (user_id, friend_id) values (4, 40);
insert into is_friends_with (user_id, friend_id) values (7, 68);
insert into is_friends_with (user_id, friend_id) values (76, 32);
insert into is_friends_with (user_id, friend_id) values (97, 172);
insert into is_friends_with (user_id, friend_id) values (77, 83);
insert into is_friends_with (user_id, friend_id) values (44, 158);
insert into is_friends_with (user_id, friend_id) values (12, 121);
insert into is_friends_with (user_id, friend_id) values (46, 17);
insert into is_friends_with (user_id, friend_id) values (67, 20);
insert into is_friends_with (user_id, friend_id) values (86, 114);
insert into is_friends_with (user_id, friend_id) values (86, 91);
insert into is_friends_with (user_id, friend_id) values (96, 110);
insert into is_friends_with (user_id, friend_id) values (86, 149);
insert into is_friends_with (user_id, friend_id) values (64, 182);
insert into is_friends_with (user_id, friend_id) values (55, 25);
insert into is_friends_with (user_id, friend_id) values (9, 40);
insert into is_friends_with (user_id, friend_id) values (27, 48);
insert into is_friends_with (user_id, friend_id) values (55, 132);
insert into is_friends_with (user_id, friend_id) values (7, 88);
insert into is_friends_with (user_id, friend_id) values (8, 22);
insert into is_friends_with (user_id, friend_id) values (41, 32);
insert into is_friends_with (user_id, friend_id) values (5, 38);
insert into is_friends_with (user_id, friend_id) values (37, 155);
insert into is_friends_with (user_id, friend_id) values (92, 28);
insert into is_friends_with (user_id, friend_id) values (7, 20);
insert into is_friends_with (user_id, friend_id) values (2, 183);
insert into is_friends_with (user_id, friend_id) values (26, 193);
insert into is_friends_with (user_id, friend_id) values (100, 114);
insert into is_friends_with (user_id, friend_id) values (71, 95);
insert into is_friends_with (user_id, friend_id) values (89, 26);
insert into is_friends_with (user_id, friend_id) values (41, 112);
insert into is_friends_with (user_id, friend_id) values (75, 157);
insert into is_friends_with (user_id, friend_id) values (25, 76);
insert into is_friends_with (user_id, friend_id) values (73, 155);
insert into is_friends_with (user_id, friend_id) values (34, 140);
insert into is_friends_with (user_id, friend_id) values (45, 182);
insert into is_friends_with (user_id, friend_id) values (74, 158);
insert into is_friends_with (user_id, friend_id) values (40, 39);
insert into is_friends_with (user_id, friend_id) values (72, 2);
insert into is_friends_with (user_id, friend_id) values (77, 104);
insert into is_friends_with (user_id, friend_id) values (84, 59);
insert into is_friends_with (user_id, friend_id) values (70, 133);
insert into is_friends_with (user_id, friend_id) values (85, 193);
insert into is_friends_with (user_id, friend_id) values (50, 115);
insert into is_friends_with (user_id, friend_id) values (97, 17);
insert into is_friends_with (user_id, friend_id) values (40, 154);
insert into is_friends_with (user_id, friend_id) values (98, 75);
insert into is_friends_with (user_id, friend_id) values (88, 194);
insert into is_friends_with (user_id, friend_id) values (87, 81);
insert into is_friends_with (user_id, friend_id) values (24, 63);
insert into is_friends_with (user_id, friend_id) values (54, 70);
insert into is_friends_with (user_id, friend_id) values (79, 131);
insert into is_friends_with (user_id, friend_id) values (42, 114);
insert into is_friends_with (user_id, friend_id) values (53, 165);
insert into is_friends_with (user_id, friend_id) values (86, 118);
insert into is_friends_with (user_id, friend_id) values (76, 184);
insert into is_friends_with (user_id, friend_id) values (45, 12);
insert into is_friends_with (user_id, friend_id) values (7, 64);
insert into is_friends_with (user_id, friend_id) values (22, 44);
insert into is_friends_with (user_id, friend_id) values (100, 125);
insert into is_friends_with (user_id, friend_id) values (37, 168);
insert into is_friends_with (user_id, friend_id) values (15, 191);
insert into is_friends_with (user_id, friend_id) values (63, 11);
insert into is_friends_with (user_id, friend_id) values (41, 78);
insert into is_friends_with (user_id, friend_id) values (26, 59);
insert into is_friends_with (user_id, friend_id) values (39, 113);
insert into is_friends_with (user_id, friend_id) values (4, 29);
insert into is_friends_with (user_id, friend_id) values (22, 93);
insert into is_friends_with (user_id, friend_id) values (93, 34);
insert into is_friends_with (user_id, friend_id) values (63, 114);
insert into is_friends_with (user_id, friend_id) values (74, 71);
insert into is_friends_with (user_id, friend_id) values (90, 93);
insert into is_friends_with (user_id, friend_id) values (92, 164);
insert into is_friends_with (user_id, friend_id) values (59, 74);
insert into is_friends_with (user_id, friend_id) values (53, 83);
insert into is_friends_with (user_id, friend_id) values (13, 104);
insert into is_friends_with (user_id, friend_id) values (32, 144);
insert into is_friends_with (user_id, friend_id) values (29, 43);
insert into is_friends_with (user_id, friend_id) values (19, 187);
insert into is_friends_with (user_id, friend_id) values (54, 41);
insert into is_friends_with (user_id, friend_id) values (39, 172);
insert into is_friends_with (user_id, friend_id) values (51, 107);
insert into is_friends_with (user_id, friend_id) values (49, 139);
insert into is_friends_with (user_id, friend_id) values (16, 59);
insert into is_friends_with (user_id, friend_id) values (16, 56);
insert into is_friends_with (user_id, friend_id) values (75, 125);
insert into is_friends_with (user_id, friend_id) values (25, 86);
insert into is_friends_with (user_id, friend_id) values (44, 118);
insert into is_friends_with (user_id, friend_id) values (100, 135);
insert into is_friends_with (user_id, friend_id) values (20, 20);
insert into is_friends_with (user_id, friend_id) values (93, 22);
insert into is_friends_with (user_id, friend_id) values (91, 93);
insert into is_friends_with (user_id, friend_id) values (62, 96);
insert into is_friends_with (user_id, friend_id) values (77, 105);
insert into is_friends_with (user_id, friend_id) values (94, 32);
insert into is_friends_with (user_id, friend_id) values (86, 188);
insert into is_friends_with (user_id, friend_id) values (50, 9);
insert into is_friends_with (user_id, friend_id) values (98, 187);
insert into is_friends_with (user_id, friend_id) values (19, 101);
insert into is_friends_with (user_id, friend_id) values (15, 6);
insert into is_friends_with (user_id, friend_id) values (78, 170);
insert into is_friends_with (user_id, friend_id) values (92, 148);
insert into is_friends_with (user_id, friend_id) values (78, 75);
insert into is_friends_with (user_id, friend_id) values (98, 58);
insert into is_friends_with (user_id, friend_id) values (67, 105);
insert into is_friends_with (user_id, friend_id) values (91, 166);
insert into is_friends_with (user_id, friend_id) values (57, 182);
insert into is_friends_with (user_id, friend_id) values (83, 71);
insert into is_friends_with (user_id, friend_id) values (39, 119);
insert into is_friends_with (user_id, friend_id) values (16, 163);
insert into is_friends_with (user_id, friend_id) values (48, 149);
insert into is_friends_with (user_id, friend_id) values (76, 44);
insert into is_friends_with (user_id, friend_id) values (37, 167);
insert into is_friends_with (user_id, friend_id) values (22, 58);
insert into is_friends_with (user_id, friend_id) values (63, 106);
insert into is_friends_with (user_id, friend_id) values (96, 189);
insert into is_friends_with (user_id, friend_id) values (87, 178);
insert into is_friends_with (user_id, friend_id) values (12, 147);
insert into is_friends_with (user_id, friend_id) values (94, 197);
insert into is_friends_with (user_id, friend_id) values (4, 52);
insert into is_friends_with (user_id, friend_id) values (15, 60);
insert into is_friends_with (user_id, friend_id) values (25, 34);
insert into is_friends_with (user_id, friend_id) values (1, 22);
insert into is_friends_with (user_id, friend_id) values (89, 5);
insert into is_friends_with (user_id, friend_id) values (34, 67);
insert into is_friends_with (user_id, friend_id) values (98, 22);
insert into is_friends_with (user_id, friend_id) values (3, 158);
insert into is_friends_with (user_id, friend_id) values (87, 147);
insert into is_friends_with (user_id, friend_id) values (42, 30);
insert into is_friends_with (user_id, friend_id) values (75, 23);
insert into is_friends_with (user_id, friend_id) values (81, 117);
insert into is_friends_with (user_id, friend_id) values (57, 128);
insert into is_friends_with (user_id, friend_id) values (69, 91);
insert into is_friends_with (user_id, friend_id) values (97, 199);
insert into is_friends_with (user_id, friend_id) values (21, 21);
insert into is_friends_with (user_id, friend_id) values (2, 39);
insert into is_friends_with (user_id, friend_id) values (83, 17);
insert into is_friends_with (user_id, friend_id) values (98, 29);
insert into is_friends_with (user_id, friend_id) values (46, 106);
insert into is_friends_with (user_id, friend_id) values (54, 127);
insert into is_friends_with (user_id, friend_id) values (35, 177);
insert into is_friends_with (user_id, friend_id) values (56, 22);
insert into is_friends_with (user_id, friend_id) values (54, 154);
insert into is_friends_with (user_id, friend_id) values (60, 3);
insert into is_friends_with (user_id, friend_id) values (70, 199);
insert into is_friends_with (user_id, friend_id) values (68, 98);
insert into is_friends_with (user_id, friend_id) values (2, 71);
insert into is_friends_with (user_id, friend_id) values (28, 144);
insert into is_friends_with (user_id, friend_id) values (67, 182);
insert into is_friends_with (user_id, friend_id) values (98, 134);
insert into is_friends_with (user_id, friend_id) values (14, 74);
insert into is_friends_with (user_id, friend_id) values (44, 86);
insert into is_friends_with (user_id, friend_id) values (95, 40);
insert into is_friends_with (user_id, friend_id) values (84, 98);
insert into is_friends_with (user_id, friend_id) values (44, 184);
insert into is_friends_with (user_id, friend_id) values (28, 111);
insert into is_friends_with (user_id, friend_id) values (10, 52);
insert into is_friends_with (user_id, friend_id) values (61, 67);
insert into is_friends_with (user_id, friend_id) values (18, 173);
insert into is_friends_with (user_id, friend_id) values (26, 110);
insert into is_friends_with (user_id, friend_id) values (35, 106);
insert into is_friends_with (user_id, friend_id) values (92, 132);
insert into is_friends_with (user_id, friend_id) values (39, 2);
insert into is_friends_with (user_id, friend_id) values (79, 76);
insert into is_friends_with (user_id, friend_id) values (5, 97);
insert into is_friends_with (user_id, friend_id) values (26, 196);
insert into is_friends_with (user_id, friend_id) values (17, 102);
insert into is_friends_with (user_id, friend_id) values (54, 57);
insert into is_friends_with (user_id, friend_id) values (44, 67);
insert into is_friends_with (user_id, friend_id) values (66, 149);
insert into is_friends_with (user_id, friend_id) values (70, 74);
insert into is_friends_with (user_id, friend_id) values (98, 143);
insert into is_friends_with (user_id, friend_id) values (81, 155);
insert into is_friends_with (user_id, friend_id) values (84, 55);
insert into is_friends_with (user_id, friend_id) values (60, 47);
insert into is_friends_with (user_id, friend_id) values (30, 145);
insert into is_friends_with (user_id, friend_id) values (5, 158);
insert into is_friends_with (user_id, friend_id) values (97, 112);
insert into is_friends_with (user_id, friend_id) values (69, 71);
insert into is_friends_with (user_id, friend_id) values (82, 15);
insert into is_friends_with (user_id, friend_id) values (35, 106);
insert into is_friends_with (user_id, friend_id) values (92, 6);


-- -----------------
-- -- SEED TICKET --
-- -----------------
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (1, 30, 173, 17.5, 104);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (2, 11, 34, 10.44, 24);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (3, 9, 23, 18.57, 130);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (4, 3, 49, 15.77, 147);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (5, 13, 172, 10.44, 81);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (6, 37, 20, 15.08, 271);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (7, 10, 105, 11.44, 59);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (8, 31, 52, 11.0, 179);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (9, 39, 19, 16.64, 263);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (10, 14, 133, 11.22, 174);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (11, 12, 83, 11.69, 108);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (12, 6, 175, 17.78, 132);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (13, 14, 24, 11.52, 262);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (14, 43, 72, 15.29, 134);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (15, 22, 7, 16.93, 113);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (16, 26, 195, 11.08, 133);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (17, 21, 158, 12.04, 196);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (18, 4, 195, 13.0, 114);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (19, 17, 120, 18.88, 24);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (20, 37, 18, 12.24, 118);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (21, 35, 42, 18.95, 32);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (22, 23, 126, 13.3, 252);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (23, 11, 143, 17.56, 37);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (24, 24, 84, 12.74, 273);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (25, 11, 188, 11.79, 126);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (26, 25, 148, 12.28, 93);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (27, 18, 194, 16.17, 142);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (28, 39, 79, 19.73, 114);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (29, 9, 47, 18.27, 155);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (30, 20, 75, 14.85, 122);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (31, 13, 112, 14.29, 143);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (32, 5, 119, 11.25, 245);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (33, 11, 161, 15.86, 270);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (34, 38, 77, 12.03, 22);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (35, 2, 123, 13.38, 245);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (36, 9, 59, 12.34, 247);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (37, 25, 100, 17.7, 182);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (38, 36, 183, 18.49, 273);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (39, 20, 132, 10.13, 22);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (40, 17, 24, 14.36, 72);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (41, 8, 160, 16.89, 171);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (42, 42, 78, 19.11, 128);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (43, 41, 70, 11.88, 138);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (44, 30, 151, 15.18, 122);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (45, 44, 25, 17.42, 268);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (46, 22, 111, 17.48, 62);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (47, 25, 25, 18.16, 139);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (48, 45, 147, 13.25, 82);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (49, 46, 162, 13.25, 277);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (50, 26, 127, 16.49, 111);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (51, 27, 39, 13.61, 219);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (52, 1, 100, 13.87, 294);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (53, 45, 153, 11.9, 34);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (54, 27, 117, 14.72, 149);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (55, 35, 159, 11.08, 73);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (56, 23, 107, 16.38, 291);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (57, 24, 49, 18.61, 227);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (58, 22, 180, 16.72, 9);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (59, 20, 16, 17.88, 197);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (60, 44, 93, 11.39, 146);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (61, 9, 173, 15.94, 90);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (62, 45, 129, 16.5, 197);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (63, 16, 130, 15.36, 138);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (64, 49, 151, 13.85, 111);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (65, 4, 64, 12.2, 63);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (66, 19, 14, 14.23, 183);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (67, 27, 176, 17.8, 296);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (68, 28, 31, 17.1, 282);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (69, 8, 145, 19.3, 206);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (70, 16, 176, 12.07, 250);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (71, 19, 153, 16.28, 19);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (72, 17, 174, 18.7, 223);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (73, 7, 150, 14.7, 50);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (74, 6, 142, 11.05, 190);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (75, 24, 176, 18.17, 137);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (76, 40, 126, 15.41, 262);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (77, 26, 46, 13.03, 216);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (78, 33, 121, 17.68, 39);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (79, 44, 27, 13.67, 299);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (80, 7, 83, 13.84, 246);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (81, 13, 67, 15.66, 80);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (82, 12, 178, 19.49, 37);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (83, 17, 189, 13.85, 169);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (84, 15, 28, 12.48, 146);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (85, 4, 139, 12.66, 193);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (86, 17, 134, 18.18, 180);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (87, 40, 160, 16.18, 150);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (88, 30, 119, 13.33, 190);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (89, 32, 46, 10.33, 217);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (90, 45, 97, 16.49, 255);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (91, 33, 196, 13.4, 121);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (92, 37, 81, 18.98, 123);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (93, 2, 11, 14.63, 73);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (94, 49, 109, 16.81, 276);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (95, 47, 129, 13.35, 135);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (96, 47, 192, 15.77, 279);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (97, 6, 191, 13.27, 174);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (98, 48, 30, 15.85, 114);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (99, 1, 136, 13.68, 151);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (100, 36, 111, 13.18, 10);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (101, 25, 168, 11.99, 262);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (102, 32, 141, 15.08, 15);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (103, 2, 74, 14.5, 196);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (104, 40, 63, 13.59, 175);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (105, 26, 181, 15.51, 238);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (106, 18, 160, 13.34, 194);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (107, 43, 142, 16.34, 124);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (108, 12, 15, 15.47, 272);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (109, 23, 101, 13.05, 45);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (110, 4, 146, 16.85, 211);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (111, 44, 127, 13.95, 1);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (112, 13, 188, 14.26, 49);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (113, 14, 198, 18.14, 239);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (114, 23, 187, 12.81, 146);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (115, 34, 160, 12.52, 161);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (116, 48, 135, 14.75, 252);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (117, 29, 45, 19.25, 189);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (118, 47, 27, 13.03, 11);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (119, 23, 146, 15.06, 58);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (120, 13, 53, 19.17, 266);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (121, 28, 110, 11.43, 10);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (122, 38, 108, 17.12, 225);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (123, 44, 78, 11.09, 95);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (124, 50, 23, 19.79, 13);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (125, 16, 197, 13.71, 119);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (126, 4, 72, 18.91, 69);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (127, 20, 150, 19.43, 262);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (128, 12, 41, 17.59, 87);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (129, 43, 184, 13.91, 250);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (130, 15, 73, 14.19, 185);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (131, 5, 20, 19.19, 153);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (132, 4, 101, 13.78, 157);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (133, 37, 151, 19.97, 85);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (134, 19, 68, 12.58, 262);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (135, 35, 67, 13.89, 186);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (136, 45, 187, 18.81, 66);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (137, 16, 4, 10.6, 30);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (138, 35, 165, 18.24, 225);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (139, 34, 90, 12.87, 182);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (140, 39, 141, 12.92, 263);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (141, 15, 125, 10.19, 269);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (142, 10, 137, 16.73, 260);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (143, 42, 146, 13.15, 76);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (144, 49, 132, 13.24, 288);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (145, 25, 19, 14.48, 76);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (146, 7, 76, 13.54, 191);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (147, 37, 115, 15.61, 93);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (148, 34, 17, 18.07, 143);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (149, 42, 131, 18.63, 293);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (150, 33, 144, 12.76, 214);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (151, 19, 6, 17.94, 42);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (152, 37, 141, 15.61, 168);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (153, 45, 133, 18.44, 215);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (154, 45, 158, 17.17, 172);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (155, 42, 9, 16.85, 125);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (156, 22, 54, 15.01, 275);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (157, 27, 11, 13.02, 99);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (158, 26, 77, 16.77, 171);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (159, 14, 61, 13.63, 201);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (160, 23, 92, 15.04, 148);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (161, 16, 142, 19.0, 280);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (162, 17, 105, 14.31, 296);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (163, 28, 194, 10.86, 214);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (164, 34, 69, 18.21, 291);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (165, 31, 161, 14.8, 255);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (166, 16, 112, 16.67, 180);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (167, 8, 42, 13.32, 69);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (168, 22, 40, 13.5, 202);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (169, 24, 191, 16.1, 187);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (170, 25, 74, 12.94, 168);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (171, 17, 139, 14.46, 242);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (172, 26, 56, 15.87, 197);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (173, 2, 66, 17.05, 263);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (174, 11, 3, 16.34, 231);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (175, 27, 32, 10.2, 111);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (176, 10, 153, 11.55, 126);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (177, 17, 175, 16.84, 195);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (178, 4, 60, 14.99, 162);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (179, 43, 198, 14.67, 253);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (180, 38, 170, 15.68, 58);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (181, 48, 138, 18.4, 73);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (182, 22, 73, 14.41, 85);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (183, 27, 175, 10.17, 140);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (184, 13, 106, 16.18, 76);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (185, 34, 24, 10.7, 233);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (186, 20, 184, 11.56, 57);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (187, 12, 90, 13.79, 165);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (188, 41, 156, 17.91, 78);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (189, 34, 98, 12.49, 255);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (190, 24, 46, 11.64, 273);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (191, 25, 124, 13.33, 104);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (192, 8, 53, 18.67, 104);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (193, 6, 122, 14.29, 253);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (194, 7, 196, 13.62, 169);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (195, 38, 123, 19.55, 215);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (196, 3, 1, 13.93, 28);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (197, 44, 145, 17.75, 45);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (198, 19, 161, 11.55, 299);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (199, 33, 38, 17.99, 62);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (200, 44, 80, 10.79, 142);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (201, 14, 92, 12.14, 33);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (202, 17, 138, 10.54, 172);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (203, 25, 145, 11.7, 228);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (204, 17, 94, 18.74, 36);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (205, 17, 138, 14.85, 222);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (206, 12, 25, 10.22, 79);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (207, 20, 57, 13.49, 84);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (208, 7, 70, 17.75, 6);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (209, 42, 86, 19.17, 141);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (210, 17, 116, 11.39, 239);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (211, 39, 62, 19.34, 212);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (212, 43, 49, 17.45, 200);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (213, 16, 17, 16.67, 144);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (214, 11, 90, 13.19, 41);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (215, 15, 148, 18.25, 66);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (216, 11, 53, 14.8, 35);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (217, 13, 115, 17.5, 22);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (218, 34, 16, 13.94, 136);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (219, 42, 33, 19.07, 100);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (220, 11, 141, 15.82, 178);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (221, 44, 131, 10.64, 279);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (222, 19, 136, 17.15, 68);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (223, 39, 100, 18.65, 214);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (224, 27, 49, 17.6, 158);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (225, 43, 15, 13.17, 246);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (226, 33, 182, 10.25, 72);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (227, 33, 95, 15.18, 284);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (228, 30, 116, 19.27, 184);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (229, 12, 124, 19.88, 209);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (230, 26, 155, 17.2, 221);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (231, 27, 52, 19.1, 154);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (232, 5, 1, 10.75, 199);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (233, 35, 180, 14.74, 125);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (234, 16, 32, 10.07, 188);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (235, 8, 127, 18.76, 107);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (236, 3, 122, 19.72, 191);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (237, 45, 78, 17.17, 99);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (238, 26, 125, 11.76, 227);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (239, 35, 22, 18.0, 219);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (240, 16, 92, 13.07, 15);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (241, 31, 120, 13.37, 132);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (242, 42, 61, 13.2, 199);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (243, 46, 57, 15.66, 94);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (244, 45, 197, 16.46, 231);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (245, 37, 101, 17.08, 187);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (246, 12, 71, 14.78, 261);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (247, 18, 196, 10.75, 293);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (248, 32, 117, 19.28, 261);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (249, 35, 107, 15.98, 262);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (250, 27, 170, 17.84, 166);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (251, 47, 106, 10.88, 210);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (252, 12, 160, 18.22, 184);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (253, 42, 187, 18.64, 19);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (254, 46, 126, 17.33, 268);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (255, 21, 41, 16.86, 99);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (256, 5, 171, 11.05, 225);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (257, 49, 139, 11.62, 103);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (258, 31, 91, 18.13, 9);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (259, 7, 183, 12.05, 79);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (260, 32, 156, 15.13, 247);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (261, 35, 118, 19.0, 1);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (262, 1, 77, 14.61, 294);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (263, 10, 119, 10.54, 49);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (264, 50, 16, 14.58, 278);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (265, 2, 103, 10.65, 6);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (266, 27, 192, 19.4, 70);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (267, 32, 13, 11.4, 143);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (268, 13, 194, 14.06, 188);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (269, 23, 135, 19.31, 207);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (270, 16, 46, 10.26, 153);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (271, 21, 30, 16.05, 189);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (272, 16, 62, 13.54, 160);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (273, 40, 179, 19.06, 81);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (274, 46, 17, 18.37, 74);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (275, 8, 21, 11.66, 13);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (276, 31, 60, 16.69, 287);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (277, 2, 47, 15.1, 52);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (278, 50, 106, 19.54, 125);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (279, 32, 39, 13.1, 232);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (280, 31, 62, 11.36, 63);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (281, 33, 131, 18.46, 69);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (282, 21, 74, 11.37, 141);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (283, 35, 148, 13.92, 117);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (284, 37, 71, 12.63, 101);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (285, 49, 80, 16.93, 121);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (286, 42, 90, 10.34, 102);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (287, 1, 31, 11.85, 277);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (288, 15, 152, 16.67, 291);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (289, 2, 114, 12.55, 95);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (290, 34, 88, 10.7, 67);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (291, 48, 21, 12.15, 35);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (292, 15, 23, 15.29, 171);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (293, 2, 135, 14.26, 149);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (294, 8, 185, 17.05, 166);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (295, 27, 104, 14.24, 156);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (296, 48, 5, 13.25, 300);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (297, 28, 10, 10.32, 40);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (298, 13, 86, 11.09, 47);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (299, 35, 156, 16.31, 227);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (300, 24, 37, 18.07, 119);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (301, 36, 10, 12.22, 262);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (302, 9, 29, 14.88, 221);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (303, 39, 16, 12.27, 22);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (304, 31, 172, 10.16, 65);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (305, 25, 123, 11.34, 147);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (306, 22, 83, 11.59, 2);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (307, 43, 78, 13.89, 116);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (308, 1, 79, 13.84, 145);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (309, 44, 76, 10.19, 157);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (310, 38, 122, 17.23, 28);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (311, 37, 31, 19.94, 164);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (312, 40, 76, 16.6, 37);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (313, 7, 30, 12.17, 212);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (314, 42, 46, 10.58, 258);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (315, 21, 90, 16.59, 125);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (316, 40, 102, 12.59, 118);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (317, 49, 57, 11.95, 9);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (318, 46, 71, 19.33, 119);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (319, 5, 45, 18.9, 81);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (320, 15, 117, 12.98, 164);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (321, 14, 184, 14.66, 258);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (322, 46, 55, 16.16, 89);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (323, 30, 132, 15.45, 295);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (324, 23, 137, 17.49, 280);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (325, 31, 174, 14.31, 98);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (326, 31, 90, 12.02, 222);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (327, 8, 5, 10.71, 64);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (328, 32, 97, 15.23, 176);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (329, 46, 133, 13.18, 228);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (330, 1, 66, 10.07, 39);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (331, 46, 37, 19.12, 26);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (332, 35, 152, 17.73, 77);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (333, 22, 186, 16.99, 97);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (334, 28, 100, 14.02, 226);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (335, 41, 22, 15.91, 294);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (336, 50, 171, 16.82, 173);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (337, 41, 29, 10.92, 187);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (338, 19, 98, 13.22, 68);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (339, 3, 36, 10.44, 245);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (340, 21, 6, 19.43, 215);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (341, 22, 54, 18.85, 234);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (342, 1, 3, 11.61, 275);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (343, 28, 45, 18.22, 187);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (344, 27, 134, 11.73, 76);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (345, 40, 90, 12.97, 244);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (346, 17, 60, 12.17, 279);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (347, 1, 95, 13.8, 104);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (348, 25, 68, 11.81, 163);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (349, 8, 146, 15.72, 261);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (350, 42, 76, 10.5, 284);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (351, 4, 139, 18.76, 48);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (352, 10, 169, 19.8, 259);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (353, 24, 10, 11.06, 161);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (354, 46, 97, 12.98, 246);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (355, 30, 21, 12.87, 285);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (356, 2, 91, 17.64, 196);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (357, 42, 140, 17.3, 18);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (358, 7, 12, 11.89, 89);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (359, 37, 155, 18.39, 174);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (360, 8, 106, 15.99, 3);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (361, 34, 33, 17.73, 287);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (362, 9, 121, 13.88, 85);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (363, 50, 29, 18.22, 198);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (364, 25, 150, 14.41, 257);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (365, 34, 61, 10.86, 273);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (366, 17, 150, 19.83, 254);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (367, 33, 39, 16.43, 168);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (368, 20, 189, 11.55, 29);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (369, 38, 113, 14.64, 257);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (370, 7, 158, 16.14, 162);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (371, 39, 144, 17.18, 68);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (372, 5, 19, 19.87, 220);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (373, 20, 170, 15.01, 11);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (374, 16, 181, 16.78, 60);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (375, 50, 54, 15.12, 118);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (376, 44, 104, 10.44, 194);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (377, 33, 93, 18.13, 197);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (378, 33, 15, 19.69, 179);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (379, 32, 35, 18.73, 38);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (380, 46, 190, 18.38, 260);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (381, 1, 70, 18.28, 34);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (382, 4, 103, 19.75, 56);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (383, 1, 17, 14.12, 205);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (384, 18, 41, 18.48, 259);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (385, 33, 102, 15.85, 55);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (386, 39, 102, 14.09, 293);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (387, 8, 37, 12.24, 273);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (388, 21, 127, 14.4, 86);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (389, 11, 154, 19.98, 246);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (390, 11, 26, 19.71, 158);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (391, 10, 153, 15.86, 202);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (392, 3, 183, 14.95, 141);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (393, 33, 111, 12.58, 104);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (394, 27, 150, 18.58, 194);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (395, 7, 50, 15.4, 163);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (396, 26, 95, 10.03, 85);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (397, 23, 199, 19.32, 69);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (398, 46, 74, 19.18, 234);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (399, 18, 135, 18.81, 149);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (400, 44, 163, 16.61, 114);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (401, 40, 174, 14.86, 2);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (402, 26, 196, 15.52, 177);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (403, 46, 183, 15.14, 32);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (404, 40, 86, 16.18, 160);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (405, 43, 164, 16.37, 208);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (406, 34, 45, 19.45, 143);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (407, 49, 154, 12.39, 34);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (408, 12, 194, 18.33, 233);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (409, 21, 183, 19.07, 32);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (410, 49, 171, 10.42, 214);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (411, 24, 171, 19.24, 28);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (412, 50, 24, 19.57, 243);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (413, 28, 172, 18.45, 215);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (414, 11, 14, 18.2, 243);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (415, 3, 36, 19.44, 202);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (416, 36, 187, 13.08, 179);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (417, 47, 139, 16.56, 109);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (418, 18, 17, 16.37, 100);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (419, 23, 60, 15.53, 104);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (420, 44, 194, 10.21, 198);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (421, 49, 148, 12.29, 267);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (422, 19, 119, 13.12, 213);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (423, 23, 40, 15.26, 58);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (424, 28, 88, 20.0, 299);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (425, 40, 33, 17.38, 263);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (426, 38, 192, 12.33, 254);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (427, 22, 166, 13.17, 180);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (428, 7, 166, 14.88, 242);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (429, 5, 113, 13.71, 139);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (430, 25, 76, 11.49, 1);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (431, 16, 173, 13.31, 147);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (432, 48, 95, 16.01, 157);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (433, 16, 89, 13.28, 262);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (434, 38, 190, 18.82, 256);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (435, 26, 65, 10.51, 71);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (436, 33, 79, 10.03, 297);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (437, 31, 124, 13.96, 3);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (438, 22, 66, 12.11, 105);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (439, 49, 72, 19.83, 198);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (440, 7, 119, 13.66, 202);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (441, 43, 179, 16.88, 294);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (442, 27, 21, 18.59, 168);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (443, 38, 70, 10.42, 37);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (444, 1, 182, 13.64, 117);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (445, 14, 8, 15.81, 270);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (446, 33, 28, 17.13, 13);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (447, 3, 71, 13.56, 63);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (448, 45, 121, 14.07, 231);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (449, 34, 147, 19.64, 216);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (450, 46, 9, 12.72, 120);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (451, 29, 86, 10.39, 283);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (452, 21, 114, 19.64, 153);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (453, 16, 91, 19.64, 141);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (454, 32, 33, 13.41, 208);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (455, 47, 61, 13.43, 247);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (456, 28, 107, 13.48, 150);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (457, 23, 144, 10.85, 145);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (458, 21, 162, 15.74, 142);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (459, 34, 192, 11.9, 64);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (460, 42, 81, 18.72, 198);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (461, 31, 38, 17.2, 100);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (462, 12, 33, 14.06, 167);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (463, 34, 53, 15.98, 29);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (464, 7, 105, 19.9, 196);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (465, 12, 41, 11.65, 93);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (466, 35, 186, 19.92, 38);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (467, 30, 168, 13.14, 184);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (468, 37, 141, 19.8, 228);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (469, 37, 186, 14.97, 57);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (470, 36, 33, 13.98, 81);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (471, 10, 7, 18.76, 54);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (472, 46, 79, 11.81, 56);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (473, 28, 107, 12.81, 203);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (474, 5, 56, 17.88, 292);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (475, 17, 81, 10.46, 224);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (476, 48, 171, 12.81, 77);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (477, 36, 198, 16.95, 52);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (478, 9, 79, 15.1, 299);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (479, 4, 175, 17.83, 91);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (480, 33, 89, 13.45, 290);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (481, 9, 127, 13.38, 139);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (482, 17, 56, 14.35, 93);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (483, 4, 10, 13.72, 278);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (484, 2, 75, 16.99, 122);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (485, 2, 191, 13.98, 210);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (486, 38, 134, 18.97, 24);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (487, 31, 22, 18.18, 149);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (488, 43, 102, 13.25, 2);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (489, 20, 77, 18.57, 35);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (490, 3, 171, 13.04, 64);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (491, 18, 200, 19.23, 286);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (492, 6, 39, 19.03, 198);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (493, 26, 66, 15.17, 205);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (494, 40, 19, 17.76, 166);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (495, 4, 132, 17.97, 45);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (496, 48, 154, 18.72, 149);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (497, 17, 174, 15.98, 126);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (498, 23, 57, 10.07, 288);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (499, 44, 11, 17.05, 164);
insert into ticket (ticket_id, showing_id, user_id, ticket_price, ticket_seat_id) values (500, 35, 35, 10.69, 58);
CREATE TYPE TITLE_TYPE AS ENUM ('film', 'short film', 'series', 'animated');
CREATE TYPE LANGUAGE AS ENUM ('en', 'ua', 'fr');

CREATE TABLE titleBasic (
	titleBasic_id SERIAL PRIMARY KEY,
	originalTitle TEXT NOT NULL,
	promotionTitle TEXT,
	region TEXT,
	types TITLE_TYPE[],
	languages LANGUAGE[],
	startYear DATE,
	endYear DATE,
	runtimeMinutes INTEGER,
	genres TEXT[],
	isAdult BOOLEAN,
    averageRating INTEGER,
	numOfVotes INTEGER
);

CREATE TYPE ROLE AS ENUM ('director', 'actor', 'writer', 'operator', 'composer');

CREATE TABLE titleCrew (
	titleCrew_id SERIAL PRIMARY KEY,
	titleBasic_id INTEGER NOT NULL,
    nameBasics_id INTEGER NOT NULL,
    rolesInTitle ROLE[],
    CONSTRAINT fk_titleBasic_id FOREIGN KEY (titleBasic_id) REFERENCES titleBasic(titleBasic_id),
    CONSTRAINT fk_nameBasics_id FOREIGN KEY (nameBasics_id) REFERENCES nameBasics(nameBasics_id)
);

CREATE TYPE WATCH_STATUS AS ENUM ('watching', 'finished', 'abandoned', 'want to watch');

CREATE TABLE episodesTVShow (
	episodesTVShow_id SERIAL PRIMARY KEY,
    userProfile_id INTEGER,
    titleBasic_id INTEGER,
	numberOfEpisodes INTEGER,
    numberOfSeasons INTEGER,
	seasonNumber INTEGER,
	episodeNumber INTEGER,
	watchStatus WATCH_STATUS,
	CONSTRAINT fk_titleBasic_id FOREIGN KEY (titleBasic_id) REFERENCES titleBasic(titleBasic_id),
    CONSTRAINT fk_userProfile_id FOREIGN KEY (userProfile_id) REFERENCES userProfile(userProfile_id)
);

CREATE TABLE nameBasics (
	nameBasics_id SERIAL PRIMARY KEY,
	primaryName TEXT,
	birthDate DATE,
	deathDate DATE,
	primaryProfession TEXT,
	knownForShows TEXT[]
);

CREATE TYPE RATING AS ENUM (1, 2, 3, 4, 5);

CREATE TABLE userRatings (
    id SERIAL PRIMARY KEY,
    titleBasic_id INTEGER,
    userProfile_id INTEGER,
    review TEXT,
    rating RATING,
    CONSTRAINT fk_titleBasic_id FOREIGN KEY (titleBasic_id) REFERENCES titleBasic(titleBasic_id),
    CONSTRAINT fk_userProfile_id FOREIGN KEY (userProfile_id) REFERENCES userProfile(userProfile_id)
);

CREATE TABLE userProfile (
	userProfile_id SERIAL PRIMARY KEY,
	username TEXT,
    wantToWatch TEXT[]
);


INSERT INTO titleBasic 
VALUES (1,'Guardians of the Galaxy', 'Guardians of the Galaxy', 'USA', 'movie', 'english', '2014-01-01', '2014-01-01', 121, 'Comedy', 'N'),
(2, 'Black Mirror', 'Black Mirror', 'USA', 'TV-Show', 'english', '2011-01-01', '2019-01-01', 1, 'Drama', 'Y');
select * from titleBasic;

INSERT INTO titleCrew 
VALUES (1, 'James Gunn', 'James Gunn, Nicole Perlman, Dan Abnett', 'Chris Pratt, Zoe Saldana', 'executive producer: Victoria Alonso'),
(2, 'Owen Harris', 'Charlie Brooker', 'Charles Babalola, Michaela Coel, Hannah John-Kamen', 'executive producer: Annabel Jones');
select * from titleCrew;


DROP TABLE titlebasic CASCADE;
DROP TABLE titleCrew CASCADE;
DROP TABLE episodesTVShow CASCADE;
DROP TABLE ratings CASCADE;
DROP TABLE nameBasics CASCADE;
DROP TABLE userProfile CASCADE;
DROP TABLE watchedMovies CASCADE;
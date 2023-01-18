CREATE TYPE TITLE_TYPE AS ENUM ('film', 'short film', 'series', 'animated');
CREATE TYPE LANGUAGE AS ENUM ('en', 'ua', 'fr');

CREATE TABLE titleBasic (
	titleBasic_id SERIAL PRIMARY KEY,
	originalTitle TEXT NOT NULL,
	promotionTitle TEXT,
	region TEXT,
	types TITLE_TYPE,
	languages LANGUAGE,
	startYear DATE,
	endYear DATE,
	runtimeMinutes INTEGER,
	genres TEXT[],
	isAdult BOOLEAN,
    averageRating NUMERIC(3, 2),
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

CREATE TABLE userRatings (
    id SERIAL PRIMARY KEY,
    titleBasic_id INTEGER,
    userProfile_id INTEGER,
    review TEXT,
    rating INTEGER,
    CONSTRAINT fk_titleBasic_id FOREIGN KEY (titleBasic_id) REFERENCES titleBasic(titleBasic_id),
    CONSTRAINT fk_userProfile_id FOREIGN KEY (userProfile_id) REFERENCES userProfile(userProfile_id),
    CONSTRAINT rating_values CHECK (rating IN (1, 2, 3, 4, 5))
);

CREATE TABLE userProfile (
	userProfile_id SERIAL PRIMARY KEY,
	username TEXT,
    wantToWatch TEXT[]
);

ALTER TABLE titleBasic ALTER averageRating TYPE NUMERIC(3, 2);
ALTER TABLE titleBasic ALTER types 

INSERT INTO titleBasic 
VALUES (1, 'Guardians of the Galaxy', 'Guardians of the Galaxy', 'USA', 'film', 'en', '2014-01-01', '2014-01-01', 121, '{"Comedy"}', false, 4.13, 520234),
(2, 'Black Mirror', 'Black Mirror', 'USA', 'series', 'en', '2011-01-01', '2019-01-01', 1, '{"Drama", "Thriller"}', true, 4.76, 290124);
INSERT INTO titleBasic 
VALUES (3, 'The Forests Song', 'Мавка: Лісова Пісня', 'Ukraine', 'animated', 'ua', '2023-03-02', '2023-03-02', 90, '{"Animation", "Fantasy"}', false, 3.83, 13568);
select * from titleBasic;

INSERT INTO userProfile VALUES 
    (1, 'lee', '{"Green Elephant"}'),
    (2, 'sasha', '{"The Room", "Eurotour"}'),
    (3, 'danya', NULL);

INSERT INTO userRatings VALUES
    (
        1,
        (SELECT titleBasic_id FROM titleBasic WHERE originalTitle = 'Black Mirror'),
        (SELECT userProfile_id FROM userProfile WHERE username = 'lee'),
        'pisyayu kipyatochkom',
        5
    ),
    (
        2,
        (SELECT titleBasic_id FROM titleBasic WHERE originalTitle = 'Black Mirror'),
        (SELECT userProfile_id FROM userProfile WHERE username = 'sasha'),
        'pisyayu tyoplym chaykom',
        4
    ),
    (
        3,
        (SELECT titleBasic_id FROM titleBasic WHERE originalTitle = 'Black Mirror'),
        (SELECT userProfile_id FROM userProfile WHERE username = 'danya'),
        'chuynya iz pod konya',
        1
    ),
    (
        4,
        (SELECT titleBasic_id FROM titleBasic WHERE originalTitle LIKE '%Guardians%'),
        (SELECT userProfile_id FROM userProfile WHERE username = 'lee'),
        'mega top',
        5
    ),
    (
        5,
        (SELECT titleBasic_id FROM titleBasic WHERE originalTitle LIKE '%Guardians%'),
        (SELECT userProfile_id FROM userProfile WHERE username = 'sasha'),
        'take',
        3
    ),
    (
        6,
        (SELECT titleBasic_id FROM titleBasic WHERE originalTitle LIKE '%Forest%'),
        (SELECT userProfile_id FROM userProfile WHERE username = 'danya'),
        'nihuystvenno',
        4
    );

INSERT INTO userProfile VALUES (4, 'chuyesos', NULL);

INSERT INTO titleCrew 
VALUES (1, 'James Gunn', 'James Gunn, Nicole Perlman, Dan Abnett', 'Chris Pratt, Zoe Saldana', 'executive producer: Victoria Alonso'),
(2, 'Owen Harris', 'Charlie Brooker', 'Charles Babalola, Michaela Coel, Hannah John-Kamen', 'executive producer: Annabel Jones');
select * from titleCrew;


DROP TABLE titleBasic CASCADE;
DROP TABLE titleCrew CASCADE;
DROP TABLE episodesTVShow CASCADE;
DROP TABLE ratings CASCADE;
DROP TABLE nameBasics CASCADE;
DROP TABLE userProfile CASCADE;
DROP TABLE watchedMovies CASCADE;

SELECT * FROM titleBasic
WHERE genres = "Fantasy";

SELECT *
FROM titleBasic
WHERE promotionTitle NOT LIKE '%:%';

SELECT profiles.username, ratings.review
FROM userProfile profiles
JOIN userRatings ratings ON ratings.userProfile_id = profiles.userProfile_id
WHERE profiles.wantToWatch IS NOT NULL
  AND ratings.rating > 3;
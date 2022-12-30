CREATE DATABASE news;

CREATE TABLE IF NOT EXISTS sources (
	source_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	sourcename VARCHAR(255) NOT NULL,
	sourcelink VARCHAR(255) NOT NULL
	);


CREATE TABLE IF NOT EXISTS filesdata (
	file_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	filename VARCHAR(255) NOT NULL,
	xmldata XML NOT NULL
	);

CREATE TABLE IF NOT EXISTS news (
	news_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	link VARCHAR(255) NOT NULL,
	guid VARCHAR(255) NOT NULL,
	pubdate TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	description VARCHAR(255),                                
	author VARCHAR(255),
	enclosure VARCHAR(255),
	pdalink VARCHAR(255),
	source_id INTEGER REFERENCES sources (source_id), 
	file_id INTEGER REFERENCES filesdata (file_id)
	);

CREATE TABLE IF NOT EXISTS categories (
	category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	categoryname VARCHAR(255) NOT NULL
	);
	
	
CREATE TABLE IF NOT EXISTS newscategories (
	newscategory_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	news_id INTEGER REFERENCES news (news_id),
	category_id INTEGER REFERENCES categories (category_id)
	);

INSERT INTO sources (
    sourcename, sourcelink)
VALUES
    ('"Ведомости". Ежедневная деловая газета','https://www.vedomosti.ru/rss/news'),
    ('Lenta.ru : Новости','https://lenta.ru/rss/'),
    ('ИНФОРМАЦИОННОЕ АГЕНТСТВО РОССИИ ТАСС','https://tass.ru/rss/v2.xml');



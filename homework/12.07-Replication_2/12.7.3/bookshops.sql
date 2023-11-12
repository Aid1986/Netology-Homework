#############################
# books_fiction
#############################
CREATE DATABASE books;

\c books;

CREATE TABLE books (
    id bigint not null unique,
    title character varying not null,
    author character varying not null,
    genre character varying not null,
    CONSTRAINT genre_check CHECK (genre = 'fiction')
);

#############################
# books_nonfiction
#############################
CREATE DATABASE books;

\c books;

CREATE TABLE books (
    id bigint not null unique,
    title character varying not null,
    author character varying not null,
    genre character varying not null,
    CONSTRAINT genre_check CHECK (genre = 'nonfiction')
);

#############################
# users_male
#############################
CREATE DATABASE users;

\c users;

CREATE TABLE users (
    id bigint not null unique,
    login character varying not null unique,
    username character varying not null,
    gender character varying not null,
    CONSTRAINT gender_check CHECK (gender='male')
);

#############################
# users_female
#############################
CREATE DATABASE users;

\c users;

CREATE TABLE users (
    id bigint not null unique,
    login character varying not null unique,
    username character varying not null,
    gender character varying not null,
    CONSTRAINT gender_check CHECK (gender='female')
);

#############################
# stores_moscow
#############################
CREATE DATABASE stores;

\c stores;

CREATE TABLE stores (
    id bigint not null unique,
    name character varying not null unique,
    city character varying not null
    CONSTRAINT city_check CHECK (city='Moscow')
);

#############################
# stores_krasnodar
#############################
CREATE DATABASE stores;

\c stores;

CREATE TABLE stores (
    id bigint not null unique,
    name character varying not null unique,
    city character varying not null
    CONSTRAINT city_check CHECK (city='Krasnodar')
);

#############################
# bookshops
#############################
CREATE DATABASE bookshops;

\c bookshops;

CREATE EXTENSION postgres_fdw;

#############################
# bookshops.books
#############################

CREATE SERVER books_fiction
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host '172.1.0.11', port '5432', dbname 'books');

CREATE USER MAPPING FOR postgres
SERVER books_fiction
OPTIONS (user 'postgres', password 'postgres');

CREATE FOREIGN TABLE books_fiction (
    id bigint not null,
    title character varying not null,
    author character varying not null,
    genre character varying not null
)
SERVER books_fiction
OPTIONS (schema_name 'public', table_name 'books');


CREATE SERVER books_nonfiction
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host '172.1.0.12', port '5432', dbname 'books');

CREATE USER MAPPING FOR postgres
SERVER books_nonfiction
OPTIONS (user 'postgres', password 'postgres');

CREATE FOREIGN TABLE books_nonfiction (
    id bigint not null,
    title character varying not null,
    author character varying not null,
    genre character varying not null
)
SERVER books_nonfiction
OPTIONS (schema_name 'public', table_name 'books');


CREATE VIEW books AS 
SELECT * FROM books_fiction
UNION ALL
SELECT * FROM books_nonfiction;


CREATE SEQUENCE books_sequence;


CREATE RULE books_insert AS ON INSERT TO books
DO INSTEAD NOTHING;

CREATE RULE books_fiction_insert AS ON INSERT TO books
WHERE (genre='fiction')
DO INSTEAD INSERT INTO books_fiction VALUES (
    CASE WHEN NEW.id IS NULL THEN nextval('books_sequence') ELSE NEW.id END,
    NEW.title,
    NEW.author,
    NEW.genre
);

CREATE RULE books_nonfiction_insert AS ON INSERT TO books
WHERE (genre='nonfiction')
DO INSTEAD INSERT INTO books_nonfiction VALUES (
    CASE WHEN NEW.id IS NULL THEN nextval('books_sequence') ELSE NEW.id END,
    NEW.title,
    NEW.author,
    NEW.genre
);


CREATE RULE books_delete AS ON DELETE TO books
DO INSTEAD NOTHING;

CREATE RULE books_fiction_delete AS ON DELETE TO books
WHERE (genre='fiction')
DO INSTEAD DELETE FROM books_fiction WHERE id = OLD.id;

CREATE RULE books_nonfiction_delete AS ON DELETE TO books
WHERE (genre='nonfiction')
DO INSTEAD DELETE FROM books_nonfiction WHERE id = OLD.id;


CREATE RULE books_update AS ON UPDATE TO books
DO INSTEAD NOTHING;

CREATE RULE books_fiction_update AS ON UPDATE TO books
WHERE (OLD.genre='fiction' AND NEW.genre='fiction')
DO INSTEAD UPDATE books_fiction
       SET id = NEW.id,
           title = NEW.title,
           author = NEW.author,
           genre = NEW.genre
     WHERE id = OLD.id;

CREATE RULE books_fiction_update_genre AS ON UPDATE TO books
WHERE (OLD.genre='fiction' AND NEW.genre!='fiction')
DO INSTEAD (
    INSERT INTO books VALUES (NEW.id, NEW.title, NEW.author, NEW.genre);
    DELETE FROM books_fiction WHERE id = OLD.id;
);

CREATE RULE books_nonfiction_update AS ON UPDATE TO books
WHERE (OLD.genre='nonfiction' AND NEW.genre='nonfiction')
DO INSTEAD UPDATE books_nonfiction
       SET id = NEW.id,
           title = NEW.title,
           author = NEW.author,
           genre = NEW.genre
     WHERE id = OLD.id;

CREATE RULE books_nonfiction_update_genre AS ON UPDATE TO books
WHERE (OLD.genre='nonfiction' AND NEW.genre!='nonfiction')
DO INSTEAD (
    INSERT INTO books VALUES (NEW.id, NEW.title, NEW.author, NEW.genre);
    DELETE FROM books_nonfiction WHERE id = OLD.id;
);


INSERT INTO books (title, author, genre) VALUES ('Святой и страшный аромат', 'Роберт Курвиц', 'fiction');
INSERT INTO books (title, author, genre) VALUES ('Золотая ветвь. Исследование магии и религии', 'Джеймс Джордж Фрэзер', 'nonfiction');
INSERT INTO books (title, author, genre) VALUES ('Как изобрести все. Создай цивилизацию с нуля', 'Райан Норт', 'nonfiction');


#############################
# bookshops.users
#############################

CREATE SERVER users_male
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host '172.1.0.13', port '5432', dbname 'users');

CREATE USER MAPPING FOR postgres
SERVER users_male
OPTIONS (user 'postgres', password 'postgres');

CREATE FOREIGN TABLE users_male (
    id bigint not null,
    login character varying not null,
    username character varying not null,
    gender character varying not null
)
SERVER users_male
OPTIONS (schema_name 'public', table_name 'users');


CREATE SERVER users_female
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host '172.1.0.14', port '5432', dbname 'users');

CREATE USER MAPPING FOR postgres
SERVER users_female
OPTIONS (user 'postgres', password 'postgres');

CREATE FOREIGN TABLE users_female (
    id bigint not null,
    login character varying not null,
    username character varying not null,
    gender character varying not null
)
SERVER users_female
OPTIONS (schema_name 'public', table_name 'users');


CREATE VIEW users AS 
SELECT * FROM users_male
UNION ALL
SELECT * FROM users_female;


CREATE SEQUENCE users_sequence;


CREATE RULE users_insert AS ON INSERT TO users
DO INSTEAD NOTHING;

CREATE RULE users_male_insert AS ON INSERT TO users
WHERE (gender='male')
DO INSTEAD INSERT INTO users_male VALUES (
    CASE WHEN NEW.id IS NULL THEN nextval('users_sequence') ELSE NEW.id END,
    NEW.login,
    NEW.username,
    NEW.gender
);

CREATE RULE users_female_insert AS ON INSERT TO users
WHERE (gender='female')
DO INSTEAD INSERT INTO users_female VALUES (
    CASE WHEN NEW.id IS NULL THEN nextval('users_sequence') ELSE NEW.id END,
    NEW.login,
    NEW.username,
    NEW.gender
);


CREATE RULE users_delete AS ON DELETE TO users
DO INSTEAD NOTHING;

CREATE RULE users_male_delete AS ON DELETE TO users
WHERE (gender='male')
DO INSTEAD DELETE FROM users_male WHERE id = OLD.id;

CREATE RULE users_female_delete AS ON DELETE TO users
WHERE (gender='female')
DO INSTEAD DELETE FROM users_female WHERE id = OLD.id;


CREATE RULE users_update AS ON UPDATE TO users
DO INSTEAD NOTHING;

CREATE RULE users_male_update AS ON UPDATE TO users
WHERE (OLD.gender='male' AND NEW.gender='male')
DO INSTEAD UPDATE users_male
       SET id = NEW.id,
           login = NEW.login,
           username = NEW.username,
           gender = NEW.gender
     WHERE id = OLD.id;

CREATE RULE users_male_update_gender AS ON UPDATE TO users
WHERE (OLD.gender='male' AND NEW.gender!='male')
DO INSTEAD (
    INSERT INTO users VALUES (NEW.*);
    DELETE FROM users_male WHERE id = OLD.id;
);

CREATE RULE user_female_update AS ON UPDATE TO users
WHERE (OLD.gender='female' AND NEW.gender='female')
DO INSTEAD UPDATE users_female
       SET id = NEW.id,
           login = NEW.login,
           username = NEW.username,
           gender = NEW.gender
     WHERE id = OLD.id;

CREATE RULE users_female_update_gender AS ON UPDATE TO users
WHERE (OLD.gender='female' AND NEW.gender!='female')
DO INSTEAD (
    INSERT INTO users VALUES (NEW.*);
    DELETE FROM users_female WHERE id = OLD.id;
);


INSERT into users (login, username, gender) VALUES ('badarrow', 'Sera', 'female');
INSERT into users (login, username, gender) VALUES ('bigboss', 'The Iron Bull', 'male');
INSERT into users (login, username, gender) VALUES ('shieldman', 'Blackwall', 'male');


#############################
# bookshops.stores
#############################

CREATE SERVER stores_moscow
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host '172.1.0.15', port '5432', dbname 'stores');

CREATE USER MAPPING FOR postgres
SERVER stores_moscow
OPTIONS (user 'postgres', password 'postgres');

CREATE FOREIGN TABLE stores_moscow (
    id bigint not null,
    name character varying not null,
    city character varying not null
)
SERVER stores_moscow
OPTIONS (schema_name 'public', table_name 'stores');


CREATE SERVER stores_krasnodar
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host '172.1.0.16', port '5432', dbname 'stores');

CREATE USER MAPPING FOR postgres
SERVER stores_krasnodar
OPTIONS (user 'postgres', password 'postgres');

CREATE FOREIGN TABLE stores_krasnodar (
    id bigint not null,
    name character varying not null,
    city character varying not null
)
SERVER stores_krasnodar
OPTIONS (schema_name 'public', table_name 'stores');


CREATE VIEW stores AS 
SELECT * FROM stores_moscow
UNION ALL
SELECT * FROM stores_krasnodar;


CREATE SEQUENCE stores_sequence;


CREATE RULE stores_insert AS ON INSERT TO stores
DO INSTEAD NOTHING;

CREATE RULE stores_moscow_insert AS ON INSERT TO stores
WHERE (city='Moscow')
DO INSTEAD INSERT INTO stores_moscow VALUES (
    CASE WHEN NEW.id IS NULL THEN nextval('stores_sequence') ELSE NEW.id END,
    NEW.name,
    NEW.city
);

CREATE RULE stores_krasnodar_insert AS ON INSERT TO stores
WHERE (city='Krasnodar')
DO INSTEAD INSERT INTO stores_krasnodar VALUES (
    CASE WHEN NEW.id IS NULL THEN nextval('stores_sequence') ELSE NEW.id END,
    NEW.name,
    NEW.city
);


CREATE RULE stores_delete AS ON DELETE TO stores
DO INSTEAD NOTHING;

CREATE RULE stores_moscow_delete AS ON DELETE TO stores
WHERE (city='Moscow')
DO INSTEAD DELETE FROM stores_moscow WHERE id = OLD.id;

CREATE RULE stores_krasnodar_delete AS ON DELETE TO stores
WHERE (city='Krasnodar')
DO INSTEAD DELETE FROM stores_krasnodar WHERE id = OLD.id;


CREATE RULE stores_update AS ON UPDATE TO stores
DO INSTEAD NOTHING;

CREATE RULE stores_moscow_update AS ON UPDATE TO stores
WHERE (OLD.city='Moscow' AND NEW.city='Moscow')
DO INSTEAD UPDATE stores_moscow
       SET id = NEW.id,
           name = NEW.name,
           city = NEW.city
     WHERE id = OLD.id;

CREATE RULE stores_moscow_update_city AS ON UPDATE TO stores
WHERE (OLD.city='Moscow' AND NEW.city!='Moscow')
DO INSTEAD (
    INSERT INTO stores VALUES (NEW.*);
    DELETE FROM stores_moscow WHERE id = OLD.id;
);

CREATE RULE stores_krasnodar_update AS ON UPDATE TO stores
WHERE (OLD.city='Krasnodar' AND NEW.city='Krasnodar')
DO INSTEAD UPDATE stores_krasnodar
       SET id = NEW.id,
           name = NEW.name,
           city = NEW.city
     WHERE id = OLD.id;

CREATE RULE stores_krasnodar_update_city AS ON UPDATE TO stores
WHERE (OLD.city='Krasnodar' AND NEW.city!='Krasnodar')
DO INSTEAD (
    INSERT INTO stores VALUES (NEW.*);
    DELETE FROM stores_krasnodar WHERE id = OLD.id;
);

INSERT INTO stores (name, city) VALUES ('RedSquare', 'Moscow');
INSERT INTO stores (name, city) VALUES ('RedStreet', 'Krasnodar');
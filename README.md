# PostGRES Fun

My notes from [freecodecamp.org](https://www.freecodecamp.org/)'s sql course.

**Table of content:**

- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Run](#run)
  - [Note regarding PGCLI command](#note-regarding-pgcli-command)
- [Creating a database](#creating-a-database)
- [Connect to database](#connect-to-database)
- [Dropping a database](#dropping-a-database)
- [Create table](#create-table)
  - [without constraints](#without-constraints)
  - [with constraints](#with-constraints)
- [Drop table](#drop-table)
- [Insert into](#insert-into)
  - [Generate mock data from file](#generate-mock-data-from-file)

## Prerequisites

- [`docker`](https://www.docker.com/)
- [`docker-compose`](https://docs.docker.com/engine/reference/commandline/compose/)
- [`pgcli`](https://www.pgcli.com/) (optional, use `psql` or a GUI app of your choice)

## Setup

```bash
$ docker-compose up -d db
[+] Running 2/2
 ✔ Network postgres_default  Created                                         0.0s
 ✔ Container postgres-db-1   Started                                         0.2s
```

## Run

```bash
$ pgcli postgresql://postgres:1234@localhost:5432/postgres
Server: PostgreSQL 15.2 (Debian 15.2-1.pgdg110+1)
Version: 4.0.1
Home: http://pgcli.com
postgres@localhost:postgres>
```

### Note regarding PGCLI command

```bash
$ pgcli postgresql://postgres:PASSWORD@localhost:PORT/POSTGRES_USER
# or you can use
$ pgcli -h localhost -p PORT -U POSTGRES_USER

```

## Creating a database

```sql
CREATE DATABASE test;
```

Check it was created by running `\list`

## Connect to database

```bash
$ pgcli -h localhost -p PORT -U POSTGRES_USER TABLE_NAME
```

or run `\c TABLE_NAME`

## Dropping a database

```sql
DROP DATABASE test;
```

_This is very dangerous_

## Create table

```sql
CREATE TABLE table_name (
    column_name data_type constraints(if any)
)

```

Use `\d` (describe) to view a databases tables. Or `\d table_name` to see table.

See all [data types](https://www.postgresql.org/docs/current/datatype.html).

### without constraints

```sql
CREATE TABLE person (
  id INT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  gender VARCHAR(7),
  date_of_birth DATE
);

```

```shell
+---------------+-----------------------+-----------+
| Column        | Type                  | Modifiers |
|---------------+-----------------------+-----------|
| id            | integer               |           |
| first_name    | character varying(50) |           |
| last_name     | character varying(50) |           |
| gender        | character varying(7)  |           |
| date_of_birth | date                  |           |
+---------------+-----------------------+-----------+
```

### with constraints

```sql
CREATE TABLE person (
  id BIGSERIAL NOT NULL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  gender VARCHAR(7) NOT NULL,
  date_of_birth DATE NOT NULL
);

```

```shell
+---------------+------------------------+------------------------------------------------------+
| Column        | Type                   | Modifiers                                            |
|---------------+------------------------+------------------------------------------------------|
| id            | bigint                 |  not null default nextval('person_id_seq'::regclass) |
| first_name    | character varying(50)  |  not null                                            |
| last_name     | character varying(50)  |  not null                                            |
| gender        | character varying(7)   |  not null                                            |
| date_of_birth | date                   |  not null                                            |
| email         | character varying(150) |                                                      |
+---------------+------------------------+------------------------------------------------------+
```

## Drop table

```sql
DROP TABLE table_name;
```

_This is very dangerous_

## Insert into

```sql
INSERT INTO person (
  first_name,
  last_name,
  gender,
  date_of_birth
  -- email -- not needed as it is nullable
) VALUES ( 'Anne', 'Smith', 'FEMALE', '1988-01-09' );

INSERT INTO person (
  first_name,
  last_name,
  gender,
  date_of_birth,
  email
) VALUES ( 'Cornelius', 'Agrippa', 'MALE', '1990-01-10', 'cagrippa@mail.com' );

INSERT INTO person (
  first_name,
  last_name,
  gender,
  date_of_birth,
  email
) VALUES ( 'Elizabeth', 'Lavenza', 'FEMALE', '1985-08-10', 'lizzy_lav@mail.com' );

INSERT INTO person (
  first_name,
  last_name,
  gender,
  date_of_birth,
  email
) VALUES ( 'Henry', 'Clerval', 'MALE', '1989-03-21', 'hank_da_doc@mail.com' );

```

```shell
+----+------------+-----------+--------+---------------+----------------------+
| id | first_name | last_name | gender | date_of_birth | email                |
|----+------------+-----------+--------+---------------+----------------------|
| 1  | Anne       | Smith     | FEMALE | 1988-01-09    | <null>               |
| 2  | Cornelius  | Agrippa   | MALE   | 1990-01-10    | cagrippa@mail.com    |
| 3  | Elizabeth  | Lavenza   | FEMALE | 1985-08-10    | lizzy_lav@mail.com   |
| 4  | Henry      | Clerval   | MALE   | 1989-03-21    | hank_da_doc@mail.com |
+----+------------+-----------+--------+---------------+----------------------+
```

### Generate mock data from file

Using [mockaroo](https://www.mockaroo.com/) you can generate some data to play with.
View the downloaded file [here](./sql/person.sql)

Use this command to execute that file content.

```sql
\i /path/to/file.sql;
```

## Selecting from table

```sql
SELECT * FROM table;                                 -- select everything
SELECT col_a, col_b FROM table_name;                 -- select particular columns
SELECT * FROM table ORDER BY col_a ASC;              -- order by column (ascending)
SELECT * FROM table ORDER BY col_a DESC;             -- order by column (descending)
SELECT * FROM table ORDER BY col_a, col_b DESC;      -- order by multiple column (descending)
SELECT DISTINCT col_a FROM table ORDER BY col_a ASC; -- select distinct values
```

### Using cluases

```sql
SELECT *
    FROM table
    WHERE col_a = 'some_value'; -- select everything matching criteria

-- multiple criteria with `AND`
SELECT *
    FROM table
    WHERE col_a = 'some_value'  -- select everything matching criteria
    AND col_b = 'other_value';  -- and other column value

-- multiple criteria with `OR`
SELECT *
    FROM table
    WHERE col_a = 'some_value'  -- select everything matching criteria
    AND (
        col_b = 'other_value'
        OR
        col_b = 'another_value' -- or this column value
    );
```

### Comparison operators

```sql
SELECT 1 = 1;
-- +----------+
-- | ?column? |
-- |----------|
-- | True     |
-- +----------+

SELECT 1 = 2;
-- +----------+
-- | ?column? |
-- |----------|
-- | False    |
-- +----------+

SELECT 1 < 2;
-- +----------+
-- | ?column? |
-- |----------|
-- | True     |
-- +----------+

SELECT 1 <= 2;
-- +----------+
-- | ?column? |
-- |----------|
-- | True     |
-- +----------+

SELECT 1 <= 1;
-- +----------+
-- | ?column? |
-- |----------|
-- | True     |
-- +----------+

SELECT 1 >= 2;
-- +----------+
-- | ?column? |
-- |----------|
-- | False    |
-- +----------+

SELECT 1 >= 1;
-- +----------+
-- | ?column? |
-- |----------|
-- | True     |
-- +----------+

SELECT 1 <> 1; -- not equal operator
-- +----------+
-- | ?column? |
-- |----------|
-- | False    |
-- +----------+

SELECT 1 <> 2;
-- +----------+
-- | ?column? |
-- |----------|
-- | True     |
-- +----------+
```

### Limit, offset and fetch

```sql
-- LIMIT
SELECT * FROM person LIMIT 5;

-- +----+------------+-----------+--------+---------------+------------------+------------------+
-- | id | first_name | last_name | gender | date_of_birth | email            | country_of_birth |
-- |----+------------+-----------+--------+---------------+------------------+------------------|
-- | 1  | Eadmund    | Dorsey    | MALE   | 2022-12-12    | <null>           | China            |
-- | 2  | Benjamen   | Garnson   | MALE   | 2023-03-18    | bgn1@deviart.com | Slovenia         |
-- | 3  | Sven       | Philipsen | MALE   | 2023-11-18    | spn2@jiahis.com  | Norway           |
-- | 4  | Mordy      | Albasini  | MALE   | 2023-09-25    | mi3@bc.co.uk     | Belarus          |
-- | 5  | Arley      | Naish     | MALE   | 2023-10-13    | ash4@recross.org | Portugal         |
-- +----+------------+-----------+--------+---------------+------------------+------------------+

-- OFFSET
SELECT * FROM person OFFSET 5 LIMIT 5;

-- +----+------------+-----------+--------+---------------+------------------+------------------+
-- | id | first_name | last_name | gender | date_of_birth | email            | country_of_birth |
-- |----+------------+-----------+--------+---------------+------------------+------------------|
-- | 6  | Kim        | Enriques  | FEMALE | 2023-06-17    | keues5@tmall.com | Australia        |
-- | 7  | Amaleta    | Jamot     | FEMALE | 2023-09-02    | ajot6@huains.com | Jamaica          |
-- | 8  | Geoffrey   | Heasly    | MALE   | 2023-11-14    | ghesly7@est.com  | Guatemala        |
-- | 9  | Stavros    | Mapston   | MALE   | 2023-03-10    | saon8@st.tx.us   | Egypt            |
-- | 10 | Hebert     | Duckwith  | MALE   | 2023-02-27    | hith9@pla.or.jp  | Indonesia        |
-- +----+------------+-----------+--------+---------------+------------------+------------------+

-- FETCH
SELECT * FROM person OFFSET 5 FETCH FIRST 5 ROWS ONLY;

-- +----+------------+-----------+--------+---------------+------------------+------------------+
-- | id | first_name | last_name | gender | date_of_birth | email            | country_of_birth |
-- |----+------------+-----------+--------+---------------+------------------+------------------|
-- | 6  | Kim        | Enriques  | FEMALE | 2023-06-17    | keues5@tmall.com | Australia        |
-- | 7  | Amaleta    | Jamot     | FEMALE | 2023-09-02    | ajot6@huains.com | Jamaica          |
-- | 8  | Geoffrey   | Heasly    | MALE   | 2023-11-14    | ghesly7@est.com  | Guatemala        |
-- | 9  | Stavros    | Mapston   | MALE   | 2023-03-10    | saon8@st.tx.us   | Egypt            |
-- | 10 | Hebert     | Duckwith  | MALE   | 2023-02-27    | hith9@pla.or.jp  | Indonesia        |
-- +----+------------+-----------+--------+---------------+------------------+------------------+
```

### In

```sql
SELECT *
    FROM table_name
    WHERE column IN ('value_1', 'value_2', 'value_3');
```

### Between

```sql
SELECT *
    FROM table_name
    WHERE date_column
    BETWEEN '2000-01-01' AND '2020-01-01'
```

### Like and iLike

#### wildcard '%'

```sql
-- LIKE
SELECT *
    FROM person
    WHERE email LIKE '%.org'; -- anything that ends with '.org'
-- +-----+------------+------------+--------+---------------+----------------+------------------+
-- | id  | first_name | last_name  | gender | date_of_birth | email          | country_of_birth |
-- |-----+------------+------------+--------+---------------+----------------+------------------|
-- | 5   | Arley      | Naish      | MALE   | 2023-10-13    | anh4@rdss.org  | Portugal         |
-- | 79  | Abigael    | Blakesley  | FEMALE | 2023-04-17    | aby26@npr.org  | China            |
-- | 98  | Brock      | Axby       | MALE   | 2022-11-25    | yp@arhve.org   | Australia        |
-- | 111 | Daveta     | Bachelar   | FEMALE | 2023-07-17    | hela@pb.org    | Albania          |
-- | 120 | Malinde    | Stacey     | FEMALE | 2023-02-17    | syj@p.org      | Greece           |
-- | 123 | Lynn       | Brolechan  | FEMALE | 2023-08-29    | le@macin.org   | Japan            |
-- | 151 | Beryle     | Darbishire | FEMALE | 2023-05-26    | ire1e@pal.org  | China            |
-- +-----+------------+------------+--------+---------------+----------------+------------------+

SELECT * FROM person WHERE email LIKE '%google%'; -- use wildcard anywhere
-- +-----+------------+-----------+--------+---------------+-----------------+------------------+
-- | id  | first_name | last_name | gender | date_of_birth | email           | country_of_birth |
-- |-----+------------+-----------+--------+---------------+-----------------+------------------|
-- | 99  | Cynthy     | Kruger    | FEMALE | 2022-12-27    | ck2q@google.com | China            |
-- | 163 | Bendite    | Fowell    | FEMALE | 2023-08-18    | bf1q@google.com | China            |
-- | 191 | Vaughan    | Heasman   | MALE   | 2023-08-29    | vhn2i@google.ca | China            |
-- +-----+------------+-----------+--------+---------------+-----------------+------------------+
```

#### wildcard '\_'

The \_ character looks for a presence of (any) one single character.

```sql
SELECT *
    FROM person
    WHERE email LIKE '_______.org'; -- will return rows where email has 7 chars before '.org'
```

#### iLike (case insensitive)

```sql
-- ILIKE
SELECT *
    FROM person
    WHERE country_of_birth ILIKE 'i%'; -- will return rows where country_of_birth begins with i
```

### Group by

Lets say you wanted to find out how many people you have in from each country in the database...

```sql
SELECT country_of_birth, count(*)
    FROM person
    GROUP BY country_of_birth
    ORDER BY country_of_birth;

-- +-----------------------+-------+
-- | country_of_birth      | count |
-- |-----------------------+-------|
-- | Afghanistan           | 2     |
-- | Albania               | 2     |
-- | Argentina             | 2     |
-- | Armenia               | 1     |
-- | Australia             | 1     |
-- | Azerbaijan            | 1     |
-- ...
```

#### Having

Perform extra filtering after aggregation. e.g. find all countries that have at least 5 people...

```sql
SELECT country_of_birth, count(*)
    FROM person
    GROUP BY country_of_birth
    HAVING COUNT(*) > 5
    ORDER BY country_of_birth;

-- +------------------+-------+
-- | country_of_birth | count |
-- |------------------+-------|
-- | China            | 41    |
-- | France           | 6     |
-- | Indonesia        | 23    |
-- | Portugal         | 12    |
-- +------------------+-------+
```

## Adding new table

See the [car sql file](./sql/car.sql).

```sql
\i /path/to/file.sql;

-- CREATE TABLE car (
--   id BIGSERIAL NOT NULL PRIMARY KEY,
--   make VARCHAR(100) NOT NULL,
--   model VARCHAR(100) NOT NULL,
--   price NUMERIC(19, 2) NOT NULL
-- );
```

## Calculations

### Max

```sql
SELECT MAX(price) FROM car;
-- +----------+
-- | max      |
-- |----------|
-- | 99049.99 |
-- +----------+

-- select maximum price for each car make
SELECT make, model, MAX(price)
    FROM car
    GROUP BY make, model;
```

### Min

```sql
SELECT MIN(price) FROM car;
-- +----------+
-- | min      |
-- |----------|
-- | 10470.60 |
-- +----------+

-- select minimum price for each car make
SELECT make, model, MIN(price)
    FROM car
    GROUP BY make, model;
```

### Avg

```sql
SELECT AVG(price) FROM car;
-- +--------------------+
-- | avg                |
-- |--------------------|
-- | 57763.456700000000 |
-- +--------------------+

-- round the result
SELECT ROUND(AVG(price)) FROM car;
-- +-------+
-- | round |
-- |-------|
-- | 57763 |
-- +-------+

-- select minimum price for each car make
SELECT make, ROUND(AVG(price))
    FROM car
    GROUP BY make;
```

### Sum

```sql
-- sum total price for all cars
SELECT SUM(price) FROM car;
-- +------------+
-- | sum        |
-- |------------|
-- | 5776345.67 |
-- +------------+

-- sum total by car make
SELECT make, SUM(price) FROM car GROUP BY make;
```

## Arithmetic operators

```sql
SELECT 1 + 2;
-- +----------+
-- | ?column? |
-- |----------|
-- | 3        |
-- +----------+

 SELECT 1 - 2;
-- +----------+
-- | ?column? |
-- |----------|
-- | -1       |
-- +----------+

 SELECT 1 * 2;
-- +----------+
-- | ?column? |
-- |----------|
-- | 2        |
-- +----------+

 SELECT 1 / 2;
-- +----------+
-- | ?column? |
-- |----------|
-- | 0        |
-- +----------+

SELECT 10 ^ 2;
-- +----------+
-- | ?column? |
-- |----------|
-- | 100.0    |
-- +----------+

SELECT factorial(10);
-- +-----------+
-- | factorial |
-- |-----------|
-- | 3628800   |
-- +-----------+

SELECT 10 % 3;
-- +----------+
-- | ?column? |
-- |----------|
-- | 1        |
-- +----------+
```

### Round

Lets say there was a promotion and we wanted to display the price of all cars as well as their discounted price...

```sql
SELECT
    make,
    model,
    price AS original_price,                           -- alias original_price
    ROUND(price * 0.9, 2) AS discounted_price,         -- alias discounted_price
    ROUND((price - price * 0.9), 2) AS discount_amount -- alias discounted_price
FROM car
ORDER BY make;
```

### Coalesce

You can hanle `NULL` values

```sql
-- will return the very first value that is present
SELECT COALESCE(1) AS number;
-- +--------+
-- | number |
-- |--------|
-- | 1      |
-- +--------+
SELECT COALESCE(NULL, 1) AS number;
-- +--------+
-- | number |
-- |--------|
-- | 1      |
-- +--------+
SELECT COALESCE(NULL, NULL, 1) AS number;
-- +--------+
-- | number |
-- |--------|
-- | 1      |
-- +--------+
SELECT COALESCE(NULL, NULL, 1, 10) AS number;
-- +--------+
-- | number |
-- |--------|
-- | 1      |
-- +--------+

SELECT
    first_name,
    last_name,
    COALESCE(email, 'EMAIL NOT PROVIDED') AS email
FROM person;
-- +-------------+-----------------+-----------------------------------+
-- | first_name  | last_name       | email                             |
-- |-------------+-----------------+-----------------------------------|
-- | Eadmund     | Dorsey          | EMAIL NOT PROVIDED                |
-- | Benjamen    | Garnson         | bgarnson1@deviantart.com          |
-- | Sven        | Philipsen       | sphilipsen2@jiathis.com           |
-- | Geoffrey    | Heasly          | gheasly7@pinterest.com            |
-- | Stavros     | Mapston         | smapston8@state.tx.us             |
-- | Eolanda     | Kassman         | ekassmanb@furl.net                |
-- | Iolanthe    | Avramovsky      | EMAIL NOT PROVIDED                |
-- | Siana       | Woods           | EMAIL NOT PROVIDED                |
-- | Marina      | Crampton        | mcramptonc@bizjournals.com        |
-- | Domenico    | Kemston         | dkemstond@reference.com           |
-- | Putnam      | Pirot           | ppirote@goo.gl                    |
-- | Stern       | Oldacres        | EMAIL NOT PROVIDED                |
-- ...
```

### NULLIF

Handle division by zero...

```sql
-- NULLIF takes 2 args and return the first arg if provided args are not matching
SELECT 10 / 0;
-- ERROR: division by zero

SELECT NULLIF(10, 10);
-- +--------+
-- | nullif |
-- |--------|
-- | <null> |
-- +--------+
SELECT NULLIF(10, 1);
-- +--------+
-- | nullif |
-- |--------|
-- | 10     |
-- +--------+
SELECT NULLIF(10, 19);
-- +--------+
-- | nullif |
-- |--------|
-- | 10     |
-- +--------+
SELECT NULLIF(100, 1000);
-- +--------+
-- | nullif |
-- |--------|
-- | 100    |
-- +--------+
SELECT 10 / NULLIF(5, 0);
-- +----------+
-- | ?column? |
-- |----------|
-- | 2        |
-- +----------+
SELECT 10 / COALESCE(NULLIF(0, 0));
-- +----------+
-- | ?column? |
-- |----------|
-- | <null>   |
-- +----------+
SELECT COALESCE(10 / NULLIF(0, 0), 0);
-- +----------+
-- | coalesce |
-- |----------|
-- | 0        |
-- +----------+
```

## Timastamps and dates

```sql
SELECT NOW();
-- +-------------------------------+
-- | now                           |
-- |-------------------------------|
-- | 2023-11-26 17:29:40.635535+00 |
-- +-------------------------------+
SELECT NOW()::DATE AS current_date; -- cast to date
-- +--------------+
-- | current_date |
-- |--------------|
-- | 2023-11-26   |
-- +--------------+
SELECT NOW()::TIME AS current_time; -- cast to time
-- +-----------------+
-- | current_time    |
-- |-----------------|
-- | 17:29:40.645954 |
-- +-----------------+
```

Check out the [docs](https://www.postgresql.org/docs/16/datatype-datetime.html)
for more.

### Adding and subtracting with dates (INTERVAL)

```sql

 -- ADDING
SELECT NOW() + INTERVAL '1 day';     -- 1 day from now
-- +-------------------------------+
-- | ?column?                      |
-- |-------------------------------|
-- | 2023-11-27 21:59:42.626857+00 |
-- +-------------------------------+
SELECT NOW() + INTERVAL '10 days';   -- 10 days from now
-- +-------------------------------+
-- | ?column?                      |
-- |-------------------------------|
-- | 2023-12-06 21:59:42.632817+00 |
-- +-------------------------------+
SELECT NOW() + INTERVAL '1 month';   -- 1 month from now
-- +-------------------------------+
-- | ?column?                      |
-- |-------------------------------|
-- | 2023-12-26 21:59:42.635898+00 |
-- +-------------------------------+
SELECT NOW() + INTERVAL '10 months'; -- 10 months from now
-- +-------------------------------+
-- | ?column?                      |
-- |-------------------------------|
-- | 2024-09-26 21:59:42.639113+00 |
-- +-------------------------------+
SELECT NOW() + INTERVAL '1 year';    -- 1 year from now
-- +-------------------------------+
-- | ?column?                      |
-- |-------------------------------|
-- | 2024-11-26 21:59:42.642619+00 |
-- +-------------------------------+
SELECT NOW() + INTERVAL '10 years';  -- 10 years from now
-- +-------------------------------+
-- | ?column?                      |
-- |-------------------------------|
-- | 2033-11-26 21:59:42.645611+00 |
-- +-------------------------------+
-- SUBTRACTING
SELECT NOW() - INTERVAL '1 day';     -- 1 day ago
-- +-------------------------------+
-- | ?column?                      |
-- |-------------------------------|
-- | 2023-11-25 21:59:42.648543+00 |
-- +-------------------------------+
SELECT NOW() - INTERVAL '10 days';   -- 10 days ago
-- +-------------------------------+
-- | ?column?                      |
-- |-------------------------------|
-- | 2023-11-16 21:59:42.651517+00 |
-- +-------------------------------+
SELECT NOW() - INTERVAL '1 month';   -- 1 month ago
-- +-------------------------------+
-- | ?column?                      |
-- |-------------------------------|
-- | 2023-10-26 21:59:42.654834+00 |
-- +-------------------------------+
SELECT NOW() - INTERVAL '10 months'; -- 10 months ago
-- +-------------------------------+
-- | ?column?                      |
-- |-------------------------------|
-- | 2023-01-26 21:59:42.658143+00 |
-- +-------------------------------+
SELECT NOW() - INTERVAL '1 year';    -- 1 year ago
-- +-------------------------------+
-- | ?column?                      |
-- |-------------------------------|
-- | 2022-11-26 21:59:42.661703+00 |
-- +-------------------------------+
SELECT NOW() - INTERVAL '10 years';  -- 10 years ago
-- +-------------------------------+
-- | ?column?                      |
-- |-------------------------------|
-- | 2013-11-26 21:59:42.665242+00 |
-- +-------------------------------+
```

If you want just the date you can caste it like so...

```sql
SELECT (NOW() + INTERVAL '10 years')::DATE;  -- 10 years from now
-- +------------+
-- | date       |
-- |------------|
-- | 2033-11-26 |
-- +------------+
SELECT (NOW() - INTERVAL '10 years')::DATE;  -- 10 years ago
-- +------------+
-- | date       |
-- |------------|
-- | 2013-11-26 |
-- +------------+
```

### Extracting fields

```sql

-- just for reference for below table
SELECT NOw()::DATE;
-- +------------+
-- | now        |
-- |------------|
-- | 2023-11-26 |
-- +------------+

SELECT
    EXTRACT(YEAR FROM NOW()) AS year,
    EXTRACT(MONTH FROM NOW()) AS month,
    EXTRACT(DAY FROM NOW()) AS day,
    EXTRACT(DOW FROM NOW()) AS day_of_week,
    EXTRACT(HOUR FROM NOW()) AS hour,
    EXTRACT(MINUTE FROM NOW()) AS minute,
    EXTRACT(SECOND FROM NOW()) AS second,
    EXTRACT(MICROSECOND FROM NOW()) AS microsecond,
    EXTRACT(WEEK FROM NOW()) AS week;
-- +------+-------+-----+-------------+------+--------+-----------+-------------+------+
-- | year | month | day | day_of_week | hour | minute | second    | microsecond | week |
-- |------+-------+-----+-------------+------+--------+-----------+-------------+------|
-- | 2023 | 11    | 26  | 0           | 22   | 24     | 35.083122 | 35083122    | 47   |
-- +------+-------+-----+-------------+------+--------+-----------+-------------+------+
```

## Age function

```sql
SELECT
    first_name,
    last_name,
    gender,
    date_of_birth,
    AGE(NOW(),
    date_of_birth) AS age
FROM person LIMIT 10;;
-- +------------+-----------+--------+---------------+--------------------------+
-- | first_name | last_name | gender | date_of_birth | age                      |
-- |------------+-----------+--------+---------------+--------------------------|
-- | Eadmund    | Dorsey    | MALE   | 2022-12-12    | 345 days, 0:19:49.144054 |
-- | Benjamen   | Garnson   | MALE   | 2023-03-18    | 249 days, 0:19:49.144054 |
-- | Sven       | Philipsen | MALE   | 2023-11-18    | 9 days, 0:19:49.144054   |
-- | Mordy      | Albasini  | MALE   | 2023-09-25    | 62 days, 0:19:49.144054  |
-- | Arley      | Naish     | MALE   | 2023-10-13    | 44 days, 0:19:49.144054  |
-- | Kim        | Enriques  | FEMALE | 2023-06-17    | 160 days, 0:19:49.144054 |
-- | Amaleta    | Jamot     | FEMALE | 2023-09-02    | 85 days, 0:19:49.144054  |
-- | Geoffrey   | Heasly    | MALE   | 2023-11-14    | 13 days, 0:19:49.144054  |
-- | Stavros    | Mapston   | MALE   | 2023-03-10    | 257 days, 0:19:49.144054 |
-- | Hebert     | Duckwith  | MALE   | 2023-02-27    | 270 days, 0:19:49.144054 |
-- +------------+-----------+--------+---------------+--------------------------+
```

## Primary key

```sql
INSERT INTO
  person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth)
VALUES (1, 'EAdmund', 'Dorsey', NULL, 'MALE', '2022/12/12', 'China');

-- duplicate key value violates unique constraint "person_pkey"
-- DETAIL:  Key (id)=(1) already exists.
```

### Alter table

```sql
-- remove the primary key constraint
ALTER TABLE person
    DROP CONSTRAINT person_pkey;

-- now the insert statement from before should work
INSERT INTO
   person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth)
 VALUES (1, 'EAdmund', 'Dorsey', NULL, 'MALE', '2022/12/12', 'China');

--- INSERT 0 1

SELECT * FROM person WHERE id = 1;
-- +----+------------+-----------+--------+---------------+--------+------------------+
-- | id | first_name | last_name | gender | date_of_birth | email  | country_of_birth |
-- |----+------------+-----------+--------+---------------+--------+------------------|
-- | 1  | Eadmund    | Dorsey    | MALE   | 2022-12-12    | <null> | China            |
-- | 1  | EAdmund    | Dorsey    | MALE   | 2022-12-12    | <null> | China            |
-- +----+------------+-----------+--------+---------------+--------+------------------+
```

This should show the importance of primary key contraints as without it we can not distinguish between the 2 records returned.

### Adding primary key

```sql
 --- add back the primary key
ALTER TABLE person ADD PRIMARY KEY (id);
-- could not create unique index "person_pkey"
-- DETAIL:  Key (id)=(1) is duplicated.
```

We have to delete those records before adding back the constraint.

```sql
DELETE FROM person WHERE id = 1;

SELECT * FROM person WHERE id = 1;
-- +----+------------+-----------+--------+---------------+-------+------------------+
-- | id | first_name | last_name | gender | date_of_birth | email | country_of_birth |
-- |----+------------+-----------+--------+---------------+-------+------------------|
-- +----+------------+-----------+--------+---------------+-------+------------------+
```

Now that person can be added back...

```sql
INSERT INTO
   person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth)
VALUES (1, 'EAdmund', 'Dorsey', NULL, 'MALE', '2022/12/12', 'China');

-- INSERT 0 1

SELECT * FROM person WHERE id = 1;
-- +----+------------+-----------+--------+---------------+--------+------------------+
-- | id | first_name | last_name | gender | date_of_birth | email  | country_of_birth |
-- |----+------------+-----------+--------+---------------+--------+------------------|
-- | 1  | EAdmund    | Dorsey    | MALE   | 2022-12-12    | <null> | China            |
-- +----+------------+-----------+--------+---------------+--------+------------------+
```

Now we can add the primary key constraint...

```sql
ALTER TABLE person ADD PRIMARY KEY (id);
```

## Unique constraints

```sql
SELECT email, COUNT(*) FROM person GROUP BY email;
-- +-----------------------------------+-------+
-- | email                             | count |
-- |-----------------------------------+-------|
-- | telcox15@phoca.cz                 | 1     |
-- | sstoeck1p@amazon.co.uk            | 1     |
-- | <null>                            | 53    |
-- | etrundler1q@homestead.com         | 1     |
-- | cgranleesey@aboutads.info         | 1     |
-- | tpovele10@wsj.com                 | 1     |
-- ...

-- check for duplicate emails
SELECT email, COUNT(*) FROM person GROUP BY email HAVING COUNT(*) > 1;
-- +--------+-------+
-- | email  | count |
-- |--------+-------|
-- | <null> | 53    |
-- +--------+-------+
```

Lets add another record...

```sql
INSERT INTO
    person (first_name, last_name, email, gender, date_of_birth, country_of_birth)
VALUES ('Sammy', 'Albasini', 'sini3@bbc.co.uk', 'MALE', '2023/09/25', 'Belarus');

-- now we have a duplicate

SELECT email, COUNT(*) FROM person GROUP BY email HAVING COUNT(*) > 1;
-- +----------------------+-------+
-- | email                | count |
-- |----------------------+-------|
-- | <null>               | 53    |
-- | sini3@bbc.co.uk | 2     |
-- +----------------------+-------+

SELECT * FROM person WHERE email = 'sini3@bbc.co.uk';
-- +-----+------------+-----------+--------+---------------+-----------------+------------------+
-- | id  | first_name | last_name | gender | date_of_birth | email           | country_of_birth |
-- |-----+------------+-----------+--------+---------------+-----------------+------------------|
-- | 4   | Mordy      | Albasini  | MALE   | 2023-09-25    | sini3@bbc.co.uk | Belarus          |
-- | 201 | Sammy      | Albasini  | MALE   | 2023-09-25    | sini3@bbc.co.uk | Belarus          |
-- +-----+------------+-----------+--------+---------------+-----------------+------------------+
```

Lets add the unique constraint...

```sql
--- add unique email constraint to person table
ALTER TABLE person ADD CONSTRAINT unique_email_address UNIQUE (email);
-- could not create unique index "unique_email_address"
-- DETAIL:  Key (email)=(sini3@bbc.co.uk) is duplicated.

-- another way of adding constraint
ALTER TABLE person ADD UNIQUE (email); -- this way postgres adds the name of the constraint
```

Lets fix that

```sql
DELETE FROM person WHERE id = 201;

SELECT * FROM person WHERE email = 'sini3@bbc.co.uk';
-- +----+------------+-----------+--------+---------------+-------+------------------+
-- | id | first_name | last_name | gender | date_of_birth | email | country_of_birth |
-- |----+------------+-----------+--------+---------------+-------+------------------|
-- +----+------------+-----------+--------+---------------+-------+------------------+
ALTER TABLE person ADD CONSTRAINT unique_email_address UNIQUE (email);

\d person
-- ...
-- Indexes:
--     "person_pkey" PRIMARY KEY, btree (id)
--     "unique_email_address" UNIQUE CONSTRAINT, btree (email)

-- now we can not add that record again
INSERT INTO
    person (first_name, last_name, email, gender, date_of_birth, country_of_birth)
VALUES ('Sammy', 'Albasini', 'sini3@bbc.co.uk', 'MALE', '2023/09/25', 'Belarus');
-- duplicate key value violates unique constraint "unique_email_address"
-- DETAIL:  Key (email)=(sini3@bbc.co.uk) already exists.
```

## Primary key vs Unique constraint

`Primary ensures` unique rows and `Unique constraint` ensures unique values in column.

## Check constraint

```sql

ALTER TABLE
    person
ADD CONSTRAINT gender_constraint CHECK (gender = 'MALE' OR gender = 'FEMALE');

-- now gender can only be 'MALE' OR gender = 'FEMALE'

INSERT INTO
    person (first_name, last_name, email, gender, date_of_birth, country_of_birth)
VALUES ('Sammy', 'sini', 'sini3@bbc.co.uk', 'helloooooooo', '2023/09/25', 'Belarus');
-- check constraint "gender_constraint" of relation "person" is violated by some row
```

## Delete records

```sql
-- delete everyone
DELETE FROM person;

-- delete person with id 42
DELETE FROM person WHERE id = 42;

SELECT * FROM person WHERE id = 42;
-- +----+------------+-----------+--------+---------------+-------+------------------+
-- | id | first_name | last_name | gender | date_of_birth | email | country_of_birth |
-- |----+------------+-----------+--------+---------------+-------+------------------|
-- +----+------------+-----------+--------+---------------+-------+------------------+

-- can use multiple conditions in where clause

SELECT COUNT(*) FROM person WHERE gender = 'MALE' AND country_of_birth = 'Peru';
-- +-------+
-- | count |
-- |-------|
-- | 2     |
-- +-------+
DELETE FROM person WHERE gender = 'MALE' AND country_of_birth = 'Peru';

SELECT COUNT(*) FROM person WHERE gender = 'MALE' AND country_of_birth = 'Peru';
-- +-------+
-- | count |
-- |-------|
-- | 0     |
-- +-------+
```

## Update records

```sql
SELECT * FROM person WHERE id = 1;
-- +----+------------+-----------+--------+---------------+--------+------------------+
-- | id | first_name | last_name | gender | date_of_birth | email  | country_of_birth |
-- |----+------------+-----------+--------+---------------+--------+------------------|
-- | 1  | EAdmund    | Dorsey    | MALE   | 2022-12-12    | <null> | China            |
-- +----+------------+-----------+--------+---------------+--------+------------------+

-- add an email to this guy
UPDATE person SET email = 'edorsey@mail.com' WHERE id = 1;

SELECT id, email FROM person WHERE id = 1;
-- +----+------------------+
-- | id | email            |
-- |----+------------------|
-- | 1  | edorsey@mail.com |
-- +----+------------------+

-- you can update
UPDATE person SET first_name = 'Ed', last_name = 'Dorsy' WHERE id = 1;

SELECT id, first_name, last_name FROM person WHERE id = 1;
-- +----+------------+-----------+
-- | id | first*name | last*name |
-- |----+------------+-----------|
-- | 1  | Ed         | Dorsy     |
-- +----+------------+-----------+
```

### Note about updating

Make sure you specify a 'WHERE' clause as omitting it would update the entire table.

```sql
UPDATE person SET email = 'edorsey@mail.com' WHERE id = 1; -- only updates EAdmund

UPDATE person SET email = 'edorsey@mail.com';              -- updates all rows
```

## On conflict, do nothing

Lets handle things like exceptions or `duplicate key errors`.

```sql
SELECT * FROM person WHERE id = 31;
-- +----+------------+-----------+--------+---------------+-----------------+------------------+
-- | id | first_name | last_name | gender | date_of_birth | email           | country_of_birth |
-- |----+------------+-----------+--------+---------------+-----------------+------------------|
-- | 31 | Marietta   | Nadin     | MALE   | 2023-05-23    | mnadinu@psu.edu | China            |
-- +----+------------+-----------+--------+---------------+-----------------+------------------+

INSERT INTO
    person (first_name, last_name, email, gender, date_of_birth, country_of_birth)
VALUES ('Marietta', 'Nadin', 'mnadinu@psu.edu', 'MALE', '2023/05/23', 'China');
-- duplicate key value violates unique constraint "unique_email_address"
-- DETAIL:  Key (email)=(mnadinu@psu.edu) already exists.

-- we can handle exceptions with `ON CNFLICT`
INSERT INTO
    person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth)
VALUES (31, 'Marietta', 'Nadin', 'mnadinu@psu.edu', 'MALE', '2023/05/23', 'China')
ON CONFLICT (id) DO NOTHING;

-- INSERT 0 0                               -- Note no inserts
-- Time: 0.009sN CONFLICT (id) DO NOTHING;

-- ensure that ON CONFLICT takes a column that has a constraint
INSERT INTO
    person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth)
VALUES (31, 'Marietta', 'Nadin', 'mnadinu@psu.edu', 'MALE', '2023/05/23', 'China')
ON CONFLICT (first_name) DO NOTHING;

-- there is no unique or exclusion constraint matching the ON CONFLICT specification
```

## Upsert

Imagine 2 inserts happen consecutively but the user changes, for example, the email.
We can assume the latest submitted email is the correct one...

```sql
 SELECT * FROM person WHERE id = 15;
-- +----+------------+-----------+--------+---------------+----------------+------------------+
-- | id | first_name | last_name | gender | date_of_birth | email          | country_of_birth |
-- |----+------------+-----------+--------+---------------+----------------+------------------|
-- | 15 | Putnam     | Pirot     | MALE   | 2023-06-04    | ppirote@goo.gl | Indonesia        |
-- +----+------------+-----------+--------+---------------+----------------+------------------+

INSERT INTO
    person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth)
VALUES (15, 'Putnam', 'Pirot', 'pp@goo.gl', 'MALE', '2023/06/04', 'Indonesia');
ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email;
-- INSERT 0 1
-- Time: 0.021s

SELECT * FROM person WHERE id = 15;
-- +----+------------+-----------+--------+---------------+-----------+------------------+
-- | id | first_name | last_name | gender | date_of_birth | email     | country_of_birth |
-- |----+------------+-----------+--------+---------------+-----------+------------------|
-- | 15 | Putnam     | Pirot     | MALE   | 2023-06-04    | pp@goo.gl | Indonesia        |
-- +----+------------+-----------+--------+---------------+-----------+------------------+
```

## Foreign keys, joins and relationships

A foreign key in one table references a primary key in another table. This is a relationship.

We currently have two tables; `person` and `car` and we want to establish a relationship
between them as follows;

- A `person` has one `car` (can only have one car)
- A car `can` only belong to one `person`

### Adding relationships between tables

If we were to rewrite the `person` and `car` tables with respect to the reltionship described above...

```sql
CREATE TABLE car (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    make VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    price NUMERIC(19, 2) NOT NULL
);

CREATE TABLE person (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(7) NOT NULL,
    email VARCHAR(100),
    dob DATE NOT NULL,
    country VARCHAR(50) NOT NULL,
    car_id BIGINT REFERENCES car (id),
    UNIQUE (car_id)
);
```

See [person-car.sql file](./sql/person-car.sql).

```sql
DROP TABLE person;
-- You're about to run a destructive command.
-- Do you want to proceed? [y/N]: y
-- Your call!
-- DROP TABLE
-- Time: 0.030s

DROP TABLE car;
-- You're about to run a destructive command.
-- Do you want to proceed? [y/N]: y
-- Your call!
-- DROP TABLE
-- Time: 0.014s

\i sql/person-car.sql
-- CREATE TABLE
-- CREATE TABLE
-- INSERT 0 1
-- INSERT 0 1
-- INSERT 0 1
-- INSERT 0 1
-- INSERT 0 1
-- Time: 0.055s

SELECT * FROM person;
-- +----+------------+-----------+--------+----------------+------------+---------+--------+
-- | id | first_name | last_name | gender | email          | dob        | country | car_id |
-- |----+------------+-----------+--------+----------------+------------+---------+--------|
-- | 1  | Fernanda   | Beardon   | Female | nandab@is.gd   | 1953-10-28 | Comoros | <null> |
-- | 2  | Omar       | Colmore   | Male   | <null>         | 1921-04-03 | Finland | <null> |
-- | 3  | John       | Matuschek | Male   | jon@fdbrnr.com | 1965-02-28 | England | <null> |
-- +----+------------+-----------+--------+----------------+------------+---------+--------+
-- SELECT 3
-- Time: 0.017s

SELECT * FROM car;
-- +----+------------+----------+----------+
-- | id | make       | model    | price    |
-- |----+------------+----------+----------|
-- | 1  | Land Rover | Sterling | 87665.38 |
-- | 2  | GMC        | Acadia   | 17662.69 |
-- +----+------------+----------+----------+
-- SELECT 2
```

### Updating foreign keys columns

Lets assign two cars to two people...

```sql
UPDATE person
SET car_id = 2 -- GMC
WHERE id = 1;  -- Fernanda
-- UPDATE 1
-- Time: 0.035s

-- see the unique constraint work
UPDATE person
SET car_id = 2 -- GMC
WHERE id = 2;  -- Omar
-- duplicate key value violates unique constraint "person_car_id_key"
-- DETAIL:  Key (car_id)=(2) already exists.

UPDATE person
SET car_id = 1 -- GMC
WHERE id = 2;  -- Omar
-- UPDATE 1
-- Time: 0.021s

SELECT * FROM person;

-- +----+------------+-----------+--------+----------------+------------+---------+--------+
-- | id | first_name | last_name | gender | email          | dob        | country | car_id |
-- |----+------------+-----------+--------+----------------+------------+---------+--------|
-- | 3  | John       | Matuschek | Male   | jon@fdbrnr.com | 1965-02-28 | England | <null> |
-- | 1  | Fernanda   | Beardon   | Female | nandab@is.gd   | 1953-10-28 | Comoros | 2      |
-- | 2  | Omar       | Colmore   | Male   | <null>         | 1921-04-03 | Finland | 1      |
-- +----+------------+-----------+--------+----------------+------------+---------+--------+

SELECT * FROM car;
-- +----+------------+----------+----------+
-- | id | make       | model    | price    |
-- |----+------------+----------+----------|
-- | 1  | Land Rover | Sterling | 87665.38 |
-- | 2  | GMC        | Acadia   | 17662.69 |
-- +----+------------+----------+----------+
-- SELECT 2
```

## Inner joins

```sql
SELECT
    first_name, make, model, price
FROM person
JOIN car ON person.car_id = car.id;
-- INNER JOIN car ON person.car_id = car.id; -- same as above

-- +------------+------------+----------+----------+
-- | first_name | make       | model    | price    |
-- |------------+------------+----------+----------|
-- | Omar       | Land Rover | Sterling | 87665.38 |
-- | Fernanda   | GMC        | Acadia   | 17662.69 |
-- +------------+------------+----------+----------+
```

## Left joins

```sql
SELECT
    first_name, make, model, price
FROM person
LEFT JOIN car ON person.car_id = car.id;
-- +------------+------------+----------+----------+
-- | first_name | make       | model    | price    |
-- |------------+------------+----------+----------|
-- | Omar       | Land Rover | Sterling | 87665.38 |
-- | Fernanda   | GMC        | Acadia   | 17662.69 |
-- | John       | <null>     | <null>   | <null>   |
-- +------------+------------+----------+----------+
```

## Deleting records with foreingn keys

```sql
DELETE FROM car WHERE id = 2;
-- update or delete on table "car" violates foreign key constraint ,,,
-- DETAIL:  Key (id)=(2) is still referenced from table "person".
```

To achieve this you could first `DELETE` the `person` the car belongs to...

```sql
DELETE FROM person WHERE car_id = 2;
-- then
DELETE FROM car WHERE id = 2;
```

## Exporting query results to CSV

```sql
\copy (
     SELECT *
     FROM person
     LEFT JOIN car ON person.car_id = car.id
 ) TO '/path/to/file.csv' CSV HEADER; -- include headers
```


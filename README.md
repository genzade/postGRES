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


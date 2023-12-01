CREATE TABLE car (
    car_uid UUID NOT NULL PRIMARY KEY,
    make VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    price NUMERIC(19, 2) NOT NULL CHECK (price > 0)
);

CREATE TABLE person (
    person_uid UUID NOT NULL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(7) NOT NULL,
    email VARCHAR(100),
    dob DATE NOT NULL,
    country VARCHAR(50) NOT NULL,
    car_uid UUID REFERENCES car (car_uid),
    UNIQUE (car_uid),
    UNIQUE (email)
);

INSERT INTO person (person_uid, first_name, last_name, gender, email, dob, country) VALUES (uuid_generate_v4(), 'Fernanda', 'Beardon', 'Female', 'nandab@is.gd', '1953-10-28', 'Comoros');
INSERT INTO person (person_uid, first_name, last_name, gender, email, dob, country) VALUES (uuid_generate_v4(), 'Omar', 'Colmore', 'Male', null, '1921-04-03', 'Finland');
INSERT INTO person (person_uid, first_name, last_name, gender, email, dob, country) VALUES (uuid_generate_v4(), 'John', 'Matuschek', 'Male', 'jon@fdbrnr.com', '1965-02-28', 'England');

INSERT INTO car (car_uid, make, model, price) VALUES (uuid_generate_v4(), 'Land Rover', 'Sterling', '87665.38');
INSERT INTO car (car_uid, make, model, price) VALUES (uuid_generate_v4(), 'GMC', 'Acadia', '17662.69');

CREATE DATABASE `linkedin`;

USE `linkedin`;

CREATE TABLE user (
    id INT,
    first_name TEXT,
    last_name TEXT,
    user_name VARCHAR(20),
    password VARCHAR(20),
    PRIMARY KEY(id)
);

CREATE TABLE education (
    id INT,
    name TEXT,
    type ENUM('Elementary School', 'Middle School', 'High School', 'Lower School', 'Upper School', 'College', 'University'),
    location TEXT,
    year_founded INT,
    PRIMARY KEY(id)
);

CREATE TABLE companies (
    id INT,
    name TEXT,
    location TEXT,
    industry ENUM('Education', 'Technology', 'Finance'),
    PRIMARY KEY(id)
);

-- Connections with user

CREATE TABLE Connect_User (
    connection_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id_1 INT,
    user_id_2 INT,
    CONSTRAINT fk_user_id_1 FOREIGN KEY (user_id_1) REFERENCES user(id),
    CONSTRAINT fk_user_id_2 FOREIGN KEY (user_id_2) REFERENCES user(id),
    CONSTRAINT unique_people_connections UNIQUE (user_id_1, user_id_2)
);

-- Connections with education

CREATE TABLE Connect_Education (
    connection_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    education_id INT,
    start_date DATE,
    end_date DATE,
    type TEXT,
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES user(id),
    CONSTRAINT fk_education_id FOREIGN KEY (education_id) REFERENCES education(id),
    CONSTRAINT unique_education_connections UNIQUE (user_id, education_id)
);

-- Connections with companies

CREATE TABLE Connect_Companies (
    connection_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    company_id INT,
    start_date DATE,
    end_date DATE,
    title TEXT,
    CONSTRAINT fk_user_id_c FOREIGN KEY (user_id) REFERENCES user(id),
    CONSTRAINT fk_company_id FOREIGN KEY (company_id) REFERENCES companies(id),
    CONSTRAINT unique_company_connections UNIQUE (user_id, company_id)
);

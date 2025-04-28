--Create a table--
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR (50) NOT NULL,
    last_name VARCHAR (50) NOT NULL,
    email VARCHAR (100) UNIQUE NOT NULL,
    salary DECIMAL (10,2),
    hire_date DATE NOT NULL
);

--Add a New Column--
ALTER TABLE employees
ADD COLUMN department_id INT;

--Modify a Column--
ALTER TABLE employees
ALTER COLUMN first_name TYPE VARCHAR (100);

--Set a Default Value--
ALTER TABLE employees
ALTER COLUMN salary SET DEFAULT 3000;

--Rename a Column--
ALTER TABLE employees
RENAME COLUMN hire_date TO start_date;

--Remove a Column--
ALTER TABLE employees
DROP COLUMN department_id;

--Insert Data--
INSERT INTO employees (first_name, last_name, email, salary, start_date)
VALUES
('Bob', 'Smith', 'bob.smith@email.com', 62000.00, '2021-03-22'),
('Charlie', 'Garcia', 'charlie.garcia@email.com', 48000.00, '2022-09-10'),
('Dana', 'White', 'dana.white@email.com', 75000.00, '2019-12-05'),
('Ethan', 'Martinez', 'ethan.martinez@email.com', NULL, '2024-01-08');

--Delete Table--
DROP TABLE employees;
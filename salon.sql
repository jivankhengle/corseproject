CREATE DATABASE salon;

-- Connect to salon database and create tables
\c salon

-- Create services table
CREATE TABLE services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

-- Create customers table
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR(20) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL
);

-- Create appointments table
CREATE TABLE appointments (
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL,
  service_id INT NOT NULL,
  time VARCHAR(100) NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (service_id) REFERENCES services(service_id)
);

-- Insert services
INSERT INTO services (name) VALUES ('cut');
INSERT INTO services (name) VALUES ('color');
INSERT INTO services (name) VALUES ('perm');
INSERT INTO services (name) VALUES ('style');
INSERT INTO services (name) VALUES ('trim');

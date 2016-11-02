DROP SCHEMA IF EXISTS consult;
CREATE SCHEMA consult;
\c consult;

CREATE TABLE address (
	address_id serial  PRIMARY KEY,
	line1 VARCHAR(50) NOT NULL,
	line2 VARCHAR(50) NULL,
	city VARCHAR(50) NOT NULL,
	region VARCHAR(50) NOT NULL,
	country VARCHAR(50) NOT NULL,
	postal_code VARCHAR(50) NOT NULL
);

CREATE TABLE consultant_status (
	status_id CHAR  PRIMARY KEY ,
	description VARCHAR(50) NOT NULL
);

CREATE TABLE consultant (
	consultant_id serial PRIMARY KEY,
	status_id CHAR NOT NULL,
	email VARCHAR(50) NOT NULL,
	password VARCHAR(50) NOT NULL,
	hourly_rate MONEY,
	billable_hourly_rate MONEY,
	hire_date DATE NULL,
	recruiter_id INTEGER NULL,
	resume TEXT NULL
);

CREATE TABLE client (
	client_name VARCHAR(50) NOT NULL,
	client_department_number INTEGER NOT NULL,
	billing_address INTEGER NOT NULL,
	contact_email VARCHAR(50) NULL,
	contact_password VARCHAR(50) NULL,
	PRIMARY KEY ( client_name, client_department_number )
);

CREATE TABLE recruiter (
	recruiter_id serial PRIMARY KEY,
	email VARCHAR(50) NOT NULL,
	password VARCHAR(50) NOT NULL,
	client_name VARCHAR(50) NULL,
	client_department_number SMALLINT NULL
);

CREATE TABLE project (
	client_name VARCHAR(50) NOT NULL,
	client_department_number SMALLINT NOT NULL,
	project_name VARCHAR(50) NOT NULL,
	contact_email VARCHAR(50) NULL,
	contact_password VARCHAR(50) NULL,
	PRIMARY KEY ( client_name, client_department_number, project_name )
);

CREATE TABLE project_consultant (
	client_name VARCHAR(50) NOT NULL,
	client_department_number SMALLINT NOT NULL,
	project_name VARCHAR(50) NOT NULL,
	consultant_id INTEGER NOT NULL,
	PRIMARY KEY ( client_name, client_department_number, project_name, consultant_id )
);

CREATE TABLE billable (
	billable_id bigserial PRIMARY KEY,
	consultant_id INTEGER NOT NULL,
	client_name VARCHAR(50) NOT NULL,
	client_department_number SMALLINT NOT NULL,
	project_name VARCHAR(50) NOT NULL,
	start_date TIMESTAMP NULL,
	end_date TIMESTAMP NULL,
	hours SMALLINT NOT NULL,
	hourly_rate DECIMAL(6,2) NOT NULL,
	billable_hourly_rate MONEY,
	description VARCHAR(50) NULL,
	artifacts TEXT NULL
);

ALTER TABLE consultant ADD CONSTRAINT consultant_fk_consultant_status FOREIGN KEY ( status_id ) REFERENCES consultant_status ( status_id );
ALTER TABLE consultant ADD CONSTRAINT consultant_fk_recruiter FOREIGN KEY ( recruiter_id ) REFERENCES recruiter ( recruiter_id );

ALTER TABLE client ADD CONSTRAINT client_fk_address FOREIGN KEY ( billing_address ) REFERENCES address ( address_id );
ALTER TABLE client ADD CONSTRAINT client_uk_billing_address UNIQUE ( billing_address );

ALTER TABLE recruiter ADD CONSTRAINT recruiter_fk_client FOREIGN KEY ( client_name, client_department_number ) REFERENCES client ( client_name, client_department_number );

ALTER TABLE project ADD CONSTRAINT project_fk_client FOREIGN KEY ( client_name, client_department_number ) REFERENCES client ( client_name, client_department_number );

ALTER TABLE project_consultant ADD CONSTRAINT project_consultant_fk_project FOREIGN KEY ( client_name, client_department_number, project_name ) REFERENCES project ( client_name, client_department_number, project_name );
ALTER TABLE project_consultant ADD CONSTRAINT project_consultant_fk_consultant FOREIGN KEY ( consultant_id ) REFERENCES consultant ( consultant_id );

ALTER TABLE billable ADD CONSTRAINT billable_fk_consultant FOREIGN KEY ( consultant_id ) REFERENCES consultant ( consultant_id );
ALTER TABLE billable ADD CONSTRAINT billable_fk_project FOREIGN KEY ( client_name, client_department_number, project_name ) REFERENCES project ( client_name, client_department_number, project_name );

\set AUTOCOMMIT ON
INSERT INTO address (line1, line2, city, region, country, postal_code) VALUES ('100 Data Street', 'Suite 432', 'San Francisco', 'California', 'USA', '94103');
INSERT INTO client (client_name, client_department_number, billing_address, contact_email, contact_password) VALUES ('Big Data Corp.', 2000, 1, 'accounting@bigdatacorp.com', 'accounting');
INSERT INTO project (client_name, client_department_number, project_name, contact_email, contact_password) VALUES ('Big Data Corp.', 2000, 'Secret Project', 'project.manager@bigdatacorp.com', 'project.manager');
INSERT INTO recruiter (email, password, client_name, client_department_number) VALUES ('bob@jsfcrudconsultants.com', 'bob', 'Big Data Corp.', 2000);
INSERT INTO consultant_status (status_id, description) VALUES ('A', 'Active');
INSERT INTO consultant (status_id, email, password, hourly_rate, billable_hourly_rate, hire_date, recruiter_id) VALUES ('A', 'janet.smart@jsfcrudconsultants.com', 'janet.smart', 80, 120, '2007-2-15', 1);
INSERT INTO project_consultant (client_name, client_department_number, project_name, consultant_id) VALUES ('Big Data Corp.', 2000, 'Secret Project', 1);
INSERT INTO billable (consultant_id, client_name, client_department_number, project_name, start_date, end_date, hours, hourly_rate, billable_hourly_rate, description) VALUES (1, 'Big Data Corp.', 2000, 'Secret Project', '2008-10-13 00:00:00.0', '2008-10-17 00:00:00.0', 40, 80, 120, 'begin gathering requirements');
INSERT INTO billable (consultant_id, client_name, client_department_number, project_name, start_date, end_date, hours, hourly_rate, billable_hourly_rate, description) VALUES (1, 'Big Data Corp.', 2000, 'Secret Project', '2008-10-20 00:00:00.0', '2008-10-24 00:00:00.0', 40, 80, 120, 'finish gathering requirements');
COMMIT;

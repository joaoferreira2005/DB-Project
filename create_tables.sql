CREATE TABLE student_financial_account (
	student_number	VARCHAR(512) NOT NULL,
	balance	FLOAT(8) NOT NULL,
	staff_person_id	INTEGER NOT NULL,
	person_id	INTEGER,
	PRIMARY KEY(person_id)
);

CREATE TABLE person (
	id		 SERIAL,
	cc		 VARCHAR(512) NOT NULL,
	name		 VARCHAR(512) NOT NULL,
	birth_date	 DATE NOT NULL,
	email		 VARCHAR(512) NOT NULL,
	username	 VARCHAR(512) NOT NULL,
	password	 VARCHAR(512) NOT NULL,
	district	 VARCHAR(512) NOT NULL,
	staff_person_id INTEGER NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE instructor (
	person_id	 INTEGER,
	func_number VARCHAR(512) NOT NULL,
	PRIMARY KEY(person_id)
);

CREATE TABLE assistant_instructor (
	phd_student		 BOOL NOT NULL,
	instructor_person_id INTEGER,
	PRIMARY KEY(instructor_person_id)
);

CREATE TABLE coordinator_instructor (
	investigation	 BOOL NOT NULL,
	instructor_person_id INTEGER,
	PRIMARY KEY(instructor_person_id)
);

CREATE TABLE edition (
	edition_id					 SERIAL,
	ed_year					 INTEGER NOT NULL,
	ed_month					 INTEGER NOT NULL,
	capacity					 INTEGER NOT NULL,
	coordinator_id INTEGER NOT NULL,
	course_code				 INTEGER NOT NULL,
	PRIMARY KEY(edition_id)
);

CREATE TABLE course (
	course_code INTEGER,
	name	 VARCHAR(512) NOT NULL,
	description VARCHAR(512) NOT NULL,
	PRIMARY KEY(course_code)
);

CREATE TABLE grade_log (
	grade				 SMALLINT NOT NULL,
	degree_program_id			 INTEGER,
	edition_id			 INTEGER,
	student_id INTEGER,
	PRIMARY KEY(degree_program_id,edition_id,student_id)
);

CREATE TABLE class (
	class_id		 SERIAL,
	type		 VARCHAR(512) NOT NULL,
	instructor_person_id INTEGER NOT NULL,
	edition_id	 INTEGER NOT NULL,
	PRIMARY KEY(class_id)
);

CREATE TABLE classroom (
	id			 SERIAL,
	capacity		 INTEGER NOT NULL,
	schedule_id		 INTEGER,
	building_id BIGINT NOT NULL,
	PRIMARY KEY(id,schedule_id)
);

CREATE TABLE buildings (
	building_id BIGSERIAL,
	location	 VARCHAR(512) NOT NULL,
	dep_name	 VARCHAR(512) NOT NULL,
	PRIMARY KEY(building_id)
);

CREATE TABLE enrollment (
	enrollment_date			 DATE NOT NULL,
	status				 BOOL NOT NULL,
	degree_program_id			 INTEGER,
	edition_id			 INTEGER,
	student_id 					INTEGER,
	staff_id			 INTEGER NOT NULL,
	PRIMARY KEY(degree_program_id,edition_id,student_id)
);

CREATE TABLE degree_program (
	id		 SERIAL,
	type		 VARCHAR(512) NOT NULL,
	name		 VARCHAR(512) NOT NULL,
	tax		 FLOAT(8) NOT NULL,
	credits		 SMALLINT NOT NULL,
	slots		 INTEGER NOT NULL,
	course_code INTEGER NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE staff (
	role	 VARCHAR(512) NOT NULL,
	person_id INTEGER,
	PRIMARY KEY(person_id)
);

CREATE TABLE extra_activities (
	id	 SERIAL,
	name	 VARCHAR(512) NOT NULL,
	tax	 FLOAT(8) NOT NULL,
	slots INTEGER NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE payments (
	transaction_id			 SERIAL,
	amount				 FLOAT(8) NOT NULL,
	type				 VARCHAR(512) NOT NULL,
	description			 VARCHAR(512) NOT NULL,
	student_id INTEGER NOT NULL,
	PRIMARY KEY(transaction_id)
);

CREATE TABLE evaluation_period (
	name		 VARCHAR(512) NOT NULL,
	evaluation_date	 DATE NOT NULL,
	edition_id INTEGER,
	PRIMARY KEY(name,edition_id)
);

CREATE TABLE evaluation (
	grade					 INTEGER,
	evaluation_period_name			 VARCHAR(512),
	edition_id	 INTEGER,
	student_id	 INTEGER,
	coordinator_id INTEGER NOT NULL,
	PRIMARY KEY(grade,evaluation_period_name,edition_id,student_id)
);

CREATE TABLE schedule (
	id		 SERIAL,
	start_time	 TIMESTAMP NOT NULL,
	duration	 SMALLINT NOT NULL,
	class_id INTEGER NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE degree_program_payments (
	degree_program_id	 INTEGER NOT NULL,
	transaction_id INTEGER,
	PRIMARY KEY(transaction_id)
);

CREATE TABLE payments_extra_activities (
	transaction_id INTEGER,
	extra_activities_id	 INTEGER NOT NULL,
	PRIMARY KEY(transaction_id)
);

CREATE TABLE assistant_instructor_edition (
	assistant_instructor_id INTEGER,
	edition_id			 INTEGER,
	PRIMARY KEY(assistant_instructor_id, edition_id)
);

CREATE TABLE student_degree_program (
	student_id INTEGER,
	degree_program_id			 INTEGER,
	PRIMARY KEY(student_id,degree_program_id)
);

CREATE TABLE student_extra_activities (
	student_id INTEGER,
	extra_activities_id		 INTEGER,
	PRIMARY KEY(student_id,extra_activities_id)
);

CREATE TABLE student_class (
	student_id INTEGER,
	class_id			 INTEGER,
	PRIMARY KEY(student_id,class_id)
);

CREATE TABLE student_course (
	student_id INTEGER,
	course_code			 INTEGER,
	PRIMARY KEY(student_id,course_code)
);

CREATE TABLE course_pre_requisite (
	course_code	 INTEGER,
	course_code_prerequisite INTEGER,
	PRIMARY KEY(course_code,course_code_prerequisite)
);

INSERT INTO person (cc, name, birth_date, email, username, password, district, staff_person_id) VALUES ('123456789', 'João Ferreira', '2005-07-20', 'joao@gmail.com','joaoferreira', '$2b$12$luc8InMgziPpjfYbnn5HWu74HM7dgdF/1McITu/dF9bsHRTDbKuLO', 'Coimbra', 1);
INSERT INTO staff (role, person_id) VALUES ('Admin', 1);

ALTER TABLE student_financial_account ADD CONSTRAINT student_financial_account_fk1 FOREIGN KEY (staff_person_id) REFERENCES staff(person_id);
ALTER TABLE student_financial_account ADD CONSTRAINT student_financial_account_fk2 FOREIGN KEY (person_id) REFERENCES person(id);
ALTER TABLE person ADD UNIQUE (cc, username);
ALTER TABLE person ADD CONSTRAINT person_fk1 FOREIGN KEY (staff_person_id) REFERENCES staff(person_id);
ALTER TABLE instructor ADD CONSTRAINT instructor_fk1 FOREIGN KEY (person_id) REFERENCES person(id);
ALTER TABLE assistant_instructor ADD CONSTRAINT assistant_instructor_fk1 FOREIGN KEY (instructor_person_id) REFERENCES instructor(person_id);
ALTER TABLE coordinator_instructor ADD CONSTRAINT coordinator_instructor_fk1 FOREIGN KEY (instructor_person_id) REFERENCES instructor(person_id);
ALTER TABLE edition ADD CONSTRAINT edition_fk1 FOREIGN KEY (coordinator_id) REFERENCES coordinator_instructor(instructor_person_id);
ALTER TABLE edition ADD CONSTRAINT edition_fk2 FOREIGN KEY (course_code) REFERENCES course(course_code);
ALTER TABLE grade_log ADD CONSTRAINT grade_log_fk1 FOREIGN KEY (degree_program_id) REFERENCES degree_program(id);
ALTER TABLE grade_log ADD CONSTRAINT grade_log_fk2 FOREIGN KEY (edition_id) REFERENCES edition(edition_id);
ALTER TABLE grade_log ADD CONSTRAINT grade_log_fk3 FOREIGN KEY (student_id) REFERENCES student_financial_account(person_id);
ALTER TABLE class ADD CONSTRAINT class_fk1 FOREIGN KEY (instructor_person_id) REFERENCES instructor(person_id);
ALTER TABLE class ADD CONSTRAINT class_fk2 FOREIGN KEY (edition_id) REFERENCES edition(edition_id);
ALTER TABLE classroom ADD CONSTRAINT classroom_fk1 FOREIGN KEY (schedule_id) REFERENCES schedule(id);
ALTER TABLE classroom ADD CONSTRAINT classroom_fk2 FOREIGN KEY (building_id) REFERENCES buildings(building_id);
ALTER TABLE enrollment ADD CONSTRAINT enrollment_fk1 FOREIGN KEY (degree_program_id) REFERENCES degree_program(id);
ALTER TABLE enrollment ADD CONSTRAINT enrollment_fk2 FOREIGN KEY (edition_id) REFERENCES edition(edition_id);
ALTER TABLE enrollment ADD CONSTRAINT enrollment_fk3 FOREIGN KEY (student_id) REFERENCES student_financial_account(person_id);
ALTER TABLE enrollment ADD CONSTRAINT enrollment_fk4 FOREIGN KEY (staff_id) REFERENCES staff(person_id);
ALTER TABLE degree_program ADD CONSTRAINT degree_program_fk1 FOREIGN KEY (course_code) REFERENCES course(course_code);
ALTER TABLE staff ADD CONSTRAINT staff_fk1 FOREIGN KEY (person_id) REFERENCES person(id);
ALTER TABLE payments ADD CONSTRAINT payments_fk1 FOREIGN KEY (student_id) REFERENCES student_financial_account(person_id);
ALTER TABLE evaluation_period ADD CONSTRAINT evaluation_period_fk1 FOREIGN KEY (edition_id) REFERENCES edition(edition_id);
ALTER TABLE evaluation ADD CONSTRAINT evaluation_fk1 FOREIGN KEY (evaluation_period_name, edition_id) REFERENCES evaluation_period(name, edition_id);
ALTER TABLE evaluation ADD CONSTRAINT evaluation_fk2 FOREIGN KEY (student_id) REFERENCES student_financial_account(person_id);
ALTER TABLE evaluation ADD CONSTRAINT evaluation_fk3 FOREIGN KEY (coordinator_id) REFERENCES coordinator_instructor(instructor_person_id);
ALTER TABLE schedule ADD CONSTRAINT schedule_fk1 FOREIGN KEY (class_id) REFERENCES class(class_id);
ALTER TABLE degree_program_payments ADD CONSTRAINT degree_program_payments_fk1 FOREIGN KEY (degree_program_id) REFERENCES degree_program(id);
ALTER TABLE degree_program_payments ADD CONSTRAINT degree_program_payments_fk2 FOREIGN KEY (transaction_id) REFERENCES payments(transaction_id);
ALTER TABLE payments_extra_activities ADD CONSTRAINT payments_extra_activities_fk1 FOREIGN KEY (transaction_id) REFERENCES payments(transaction_id);
ALTER TABLE payments_extra_activities ADD CONSTRAINT payments_extra_activities_fk2 FOREIGN KEY (extra_activities_id) REFERENCES extra_activities(id);
ALTER TABLE assistant_instructor_edition ADD CONSTRAINT assistant_instructor_edition_fk1 FOREIGN KEY (assistant_instructor_id) REFERENCES assistant_instructor(instructor_person_id);
ALTER TABLE assistant_instructor_edition ADD CONSTRAINT assistant_instructor_edition_fk2 FOREIGN KEY (edition_id) REFERENCES edition(edition_id);
ALTER TABLE student_degree_program ADD CONSTRAINT student_degree_program_fk1 FOREIGN KEY (student_id) REFERENCES student_financial_account(person_id);
ALTER TABLE student_degree_program ADD CONSTRAINT student_degree_program_fk2 FOREIGN KEY (degree_program_id) REFERENCES degree_program(id);
ALTER TABLE student_extra_activities ADD CONSTRAINT student_extra_activities_fk1 FOREIGN KEY (student_id) REFERENCES student_financial_account(person_id);
ALTER TABLE student_extra_activities ADD CONSTRAINT student_extra_activities_fk2 FOREIGN KEY (extra_activities_id) REFERENCES extra_activities(id);
ALTER TABLE student_class ADD CONSTRAINT student_class_fk1 FOREIGN KEY (student_id) REFERENCES student_financial_account(person_id);
ALTER TABLE student_class ADD CONSTRAINT student_class_fk2 FOREIGN KEY (class_id) REFERENCES class(class_id);
ALTER TABLE student_course ADD CONSTRAINT student_course_fk1 FOREIGN KEY (student_id) REFERENCES student_financial_account(person_id);
ALTER TABLE student_course ADD CONSTRAINT student_course_fk2 FOREIGN KEY (course_code) REFERENCES course(course_code);
ALTER TABLE course_pre_requisite ADD CONSTRAINT course_pre_requisite_fk1 FOREIGN KEY (course_code) REFERENCES course(course_code);
ALTER TABLE course_pre_requisite ADD CONSTRAINT course_pre_requisite_fk2 FOREIGN KEY (course_code_prerequisite) REFERENCES course(course_code);
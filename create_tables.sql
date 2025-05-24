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
	PRIMARY KEY(degree_program_id,student_id, edition_id)
);


CREATE TABLE degree_program (
	id		 SERIAL,
	type		 VARCHAR(512) NOT NULL,
	name		 VARCHAR(512) NOT NULL,
	tax		 FLOAT(8) NOT NULL,
	credits		 SMALLINT NOT NULL,
	slots		 INTEGER NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE degree_program_course(
	degree_program_id INTEGER,
	course_code INTEGER,
	PRIMARY KEY(degree_program_id, course_code)
);

CREATE TABLE staff (
	role	 VARCHAR(512) NOT NULL,
	person_id INTEGER,
	PRIMARY KEY(person_id)
);

CREATE TABLE edition_course (
	edition_id INTEGER,
	course_code INTEGER,
	PRIMARY KEY(edition_id,course_code)
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


CREATE TABLE course_pre_requisite (
	course_code	 INTEGER,
	course_code_prerequisite INTEGER,
	PRIMARY KEY(course_code,course_code_prerequisite)
);

-- === Primeiro staff === --
INSERT INTO person (cc, name, birth_date, email, username, password, district, staff_person_id) VALUES ('123456789', 'João Ferreira', '2005-07-20', 'joao@gmail.com','joaoferreira', '$2b$12$luc8InMgziPpjfYbnn5HWu74HM7dgdF/1McITu/dF9bsHRTDbKuLO', 'Coimbra', 1);
INSERT INTO staff (role, person_id) VALUES ('Admin', 1);

-- === Instrutores (Person + Instructor + Coordinator) ===
-- pw1,pw2,pw3
INSERT INTO person (cc, name, birth_date, email, username, password, district, staff_person_id) VALUES
('812385869', 'Ana Costa', '1980-05-12', 'ana.costa@dei.uc.pt', 'ana_costa', '$2b$12$C8v0Kyxl.IGkoH4iUHu08uPVWN/1PL19MyNdLwQ91bCn.gtOBASfy', 'Lisboa', 1),
('283472732', 'Carlos Silva', '1975-11-30', 'carlos.silva@dei.uc.pt', 'carlos_silva', '$2b$12$B2ygSbhEi2kAUTRHkXIMs.TAlIOuuc4l4cdC0V/uGiO20aB4L/wBy', 'Porto', 1),
('012395345', 'Marta Ribeiro', '1983-09-18', 'marta.ribeiro@dei.uc.pt', 'marta_ribeiro', '$2b$12$NrNy1xeeGy92sSG5bqHNBOyqFm5sOhrrBnN1bcc/yhJZtv7H3cGxy', 'Coimbra', 1);

INSERT INTO instructor (person_id, func_number) VALUES
(3, '2005928395');

INSERT INTO coordinator_instructor (investigation, instructor_person_id) VALUES
(FALSE, 3);

-- === Cursos ===
INSERT INTO course (course_code, name, description) VALUES
(1001, 'Bases de Dados', 'Cadeira de introdução a bases de dados relacionais'),
(1002, 'Redes de Comunicação', 'Cadeira sobre protocolos, redes e sistemas distribuídos'),
(1003, 'Tecnologia da Informática', 'Cadeira de introdução à informática e programação');

-- === Degree Programs ===
INSERT INTO degree_program (id, type, name, tax, credits, slots) VALUES
(1, 'Licenciatura', 'Engenharia Informática', 697.5, 180, 60),
(2, 'Mestrado', 'Engenharia de Redes', 850.0, 120, 30),
(3, 'Licenciatura', 'Engenharia de Computadores', 697.5, 180, 50);


-- === Associa as cadeiras aos degree programs === --
INSERT INTO degree_program_course (degree_program_id, course_code) VALUES
(1, 1001),
(1, 1003),
(2, 1002),
(3, 1001),
(3, 1002),
(3, 1003);

INSERT INTO edition (ed_year, ed_month, capacity, coordinator_id) VALUES
(2024, 9, 30, 3),
(2024, 9, 25, 3);

-- === Edifícios ===
INSERT INTO buildings (location, dep_name) VALUES
('Polo II - UC', 'DEI'),
('Polo II - UC', 'DEEC');

-- === Aulas (class) ===
INSERT INTO class (type, instructor_person_id, edition_id) VALUES
('PL', 3, 1), -- Prática da edição 1, Carlos Silva
('T', 3, 2);  -- Teórica da edição 2 (Redes), Carlos Silva

-- === Horários (schedule) ===
INSERT INTO schedule (start_time, duration, class_id) VALUES
('2024-09-15 09:00:00', 90, 1),
('2024-09-16 14:00:00', 120, 2);

-- === Salas ===
-- Pode ser util adicionar o nome à sala, para ser tipo "A.5.1"
INSERT INTO classroom (capacity, schedule_id, building_id) VALUES
(40, 1, 1),  -- Bloco A
(30, 2, 1);

-- === Atividades Extra ===
INSERT INTO extra_activities (name, tax, slots) VALUES
('Workshop de Python', 50.0, 20),
('Seminário de IA', 30.0, 15),
('Visita a Data Center', 20.0, 10);

-- ==== Periodos de Avaliação ====
INSERT INTO evaluation_period (name, evaluation_date, edition_id) VALUES
('Spring', '2024-06-15', 1),
('Fall', '2024-12-15', 2);

-- === Contas Financeiras ===
INSERT INTO student_financial_account (student_number, balance, staff_person_id, person_id) VALUES
('20240002', 800.0, 1, 2), -- Ana Costa
('20240004', 500.0, 1, 4); -- Marta Ribeiro

-- ==== Grade Log ====
INSERT INTO grade_log (grade, degree_program_id, edition_id, student_id) VALUES
(18, 1, 1, 2), -- Ana Costa
(17, 3, 1, 4); -- Marta Ribeiro

-- === Associa cadeiras à edição === --
INSERT INTO edition_course (edition_id, course_code) VALUES
(1, 1001),
(2, 1002);

--- POPULAÇÃO A MAIS PARA TESTES ---

INSERT INTO person (id, cc, name, birth_date, email, username, password, district, staff_person_id)
VALUES (5, 'cc000000005', 'Estudante 5', '2000-12-09', 'estudante5@email.com', 'estudante5', '$2b$12$placeholder', 'Coimbra', 1);

INSERT INTO person (id, cc, name, birth_date, email, username, password, district, staff_person_id)
VALUES (6, 'cc000000006', 'Estudante 6', '2000-12-04', 'estudante6@email.com', 'estudante6', '$2b$12$placeholder', 'Lisboa', 1);

INSERT INTO person (id, cc, name, birth_date, email, username, password, district, staff_person_id)
VALUES (7, 'cc000000007', 'Estudante 7', '2000-10-14', 'estudante7@email.com', 'estudante7', '$2b$12$placeholder', 'Coimbra', 1);

INSERT INTO person (id, cc, name, birth_date, email, username, password, district, staff_person_id)
VALUES (8, 'cc000000008', 'Estudante 8', '2000-04-08', 'estudante8@email.com', 'estudante8', '$2b$12$placeholder', 'Coimbra', 1);

INSERT INTO person (id, cc, name, birth_date, email, username, password, district, staff_person_id)
VALUES (9, 'cc000000009', 'Estudante 9', '2000-09-07', 'estudante9@email.com', 'estudante9', '$2b$12$placeholder', 'Coimbra', 1);

INSERT INTO person (id, cc, name, birth_date, email, username, password, district, staff_person_id)
VALUES (10, 'cc000000010', 'Estudante 10', '2000-04-15', 'estudante10@email.com', 'estudante10', '$2b$12$placeholder', 'Aveiro', 1);

INSERT INTO person (id, cc, name, birth_date, email, username, password, district, staff_person_id)
VALUES (11, 'cc000000011', 'Estudante 11', '2000-03-23', 'estudante11@email.com', 'estudante11', '$2b$12$placeholder', 'Coimbra', 1);

INSERT INTO person (id, cc, name, birth_date, email, username, password, district, staff_person_id)
VALUES (12, 'cc000000012', 'Estudante 12', '2000-03-07', 'estudante12@email.com', 'estudante12', '$2b$12$placeholder', 'Porto', 1);

INSERT INTO person (id, cc, name, birth_date, email, username, password, district, staff_person_id)
VALUES (13, 'cc000000013', 'Estudante 13', '2000-02-03', 'estudante13@email.com', 'estudante13', '$2b$12$placeholder', 'Porto', 1);

INSERT INTO person (id, cc, name, birth_date, email, username, password, district, staff_person_id)
VALUES (14, 'cc000000014', 'Estudante 14', '2000-06-20', 'estudante14@email.com', 'estudante14', '$2b$12$placeholder', 'Porto', 1);

INSERT INTO student_financial_account (student_number, balance, staff_person_id, person_id)
VALUES ('20240005', 5000.0, 1, 5);

INSERT INTO student_financial_account (student_number, balance, staff_person_id, person_id)
VALUES ('20240006', 395.91, 1, 6);

INSERT INTO student_financial_account (student_number, balance, staff_person_id, person_id)
VALUES ('20240007', 741.36, 1, 7);

INSERT INTO student_financial_account (student_number, balance, staff_person_id, person_id)
VALUES ('20240008', 225.43, 1, 8);

INSERT INTO student_financial_account (student_number, balance, staff_person_id, person_id)
VALUES ('20240009', 604.28, 1, 9);

INSERT INTO student_financial_account (student_number, balance, staff_person_id, person_id)
VALUES ('20240010', 772.82, 1, 10);

INSERT INTO student_financial_account (student_number, balance, staff_person_id, person_id)
VALUES ('20240011', 671.41, 1, 11);

INSERT INTO student_financial_account (student_number, balance, staff_person_id, person_id)
VALUES ('20240012', 538.09, 1, 12);

INSERT INTO student_financial_account (student_number, balance, staff_person_id, person_id)
VALUES ('20240013', 965.77, 1, 13);

INSERT INTO student_financial_account (student_number, balance, staff_person_id, person_id)
VALUES ('20240014', 503.94, 1, 14);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (12, 'Spring', 1, 5, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (20, 'Fall', 2, 5, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (8, 'Spring', 1, 6, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (19, 'Fall', 2, 6, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (15, 'Spring', 1, 7, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (16, 'Fall', 2, 7, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (9, 'Spring', 1, 8, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (14, 'Fall', 2, 8, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (9, 'Spring', 1, 9, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (16, 'Fall', 2, 9, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (12, 'Spring', 1, 10, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (18, 'Fall', 2, 10, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (17, 'Spring', 1, 11, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (13, 'Fall', 2, 11, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (17, 'Spring', 1, 12, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (11, 'Fall', 2, 12, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (19, 'Spring', 1, 13, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (9, 'Fall', 2, 13, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (8, 'Spring', 1, 14, 3);

INSERT INTO evaluation (grade, evaluation_period_name, edition_id, student_id, coordinator_id)
VALUES (18, 'Fall', 2, 14, 3);

INSERT INTO student_degree_program (student_id, degree_program_id)
VALUES (5, 2);

INSERT INTO enrollment (enrollment_date, status, degree_program_id, edition_id, student_id)
VALUES ('2024-02-13', TRUE, 2, 1, 5);

INSERT INTO student_degree_program (student_id, degree_program_id)
VALUES (6, 2);

INSERT INTO enrollment (enrollment_date, status, degree_program_id, edition_id, student_id)
VALUES ('2024-03-12', FALSE, 2, 2, 6);

INSERT INTO student_degree_program (student_id, degree_program_id)
VALUES (7, 2);

INSERT INTO enrollment (enrollment_date, status, degree_program_id, edition_id, student_id)
VALUES ('2024-02-20', FALSE, 2, 1, 7);

INSERT INTO student_degree_program (student_id, degree_program_id)
VALUES (8, 3);

INSERT INTO enrollment (enrollment_date, status, degree_program_id, edition_id, student_id)
VALUES ('2024-03-15', TRUE, 3, 1, 8);

INSERT INTO student_degree_program (student_id, degree_program_id)
VALUES (9, 2);

INSERT INTO enrollment (enrollment_date, status, degree_program_id, edition_id, student_id)
VALUES ('2024-06-27', TRUE, 2, 2, 9);

INSERT INTO student_degree_program (student_id, degree_program_id)
VALUES (10, 1);

INSERT INTO enrollment (enrollment_date, status, degree_program_id, edition_id, student_id)
VALUES ('2024-06-13', TRUE, 1, 1, 10);

INSERT INTO student_degree_program (student_id, degree_program_id)
VALUES (11, 2);

INSERT INTO enrollment (enrollment_date, status, degree_program_id, edition_id, student_id)
VALUES ('2024-06-07', TRUE, 2, 1, 11);

INSERT INTO student_degree_program (student_id, degree_program_id)
VALUES (12, 3);

INSERT INTO enrollment (enrollment_date, status, degree_program_id, edition_id, student_id)
VALUES ('2024-08-05', FALSE, 3, 2, 12);

INSERT INTO student_degree_program (student_id, degree_program_id)
VALUES (13, 2);

INSERT INTO enrollment (enrollment_date, status, degree_program_id, edition_id, student_id)
VALUES ('2024-09-18', TRUE, 2, 1, 13);

INSERT INTO student_degree_program (student_id, degree_program_id)
VALUES (14, 2);

INSERT INTO enrollment (enrollment_date, status, degree_program_id, edition_id, student_id)
VALUES ('2024-06-08', FALSE, 2, 2, 14);

INSERT INTO student_class (student_id, class_id)
VALUES (5, 1);

INSERT INTO student_class (student_id, class_id)
VALUES (6, 1);

INSERT INTO student_class (student_id, class_id)
VALUES (6, 2);

INSERT INTO student_class (student_id, class_id)
VALUES (7, 1);

INSERT INTO student_class (student_id, class_id)
VALUES (7, 2);

INSERT INTO student_class (student_id, class_id)
VALUES (8, 1);

INSERT INTO student_class (student_id, class_id)
VALUES (9, 1);

INSERT INTO student_class (student_id, class_id)
VALUES (11, 2);

INSERT INTO student_class (student_id, class_id)
VALUES (12, 1);

INSERT INTO student_class (student_id, class_id)
VALUES (13, 2);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (5, 1);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (5, 3);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (6, 2);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (6, 3);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (7, 2);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (7, 3);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (8, 2);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (8, 3);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (9, 3);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (10, 1);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (11, 1);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (11, 2);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (11, 3);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (12, 1);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (12, 2);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (13, 1);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (13, 2);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (13, 3);

INSERT INTO student_extra_activities (student_id, extra_activities_id)
VALUES (14, 2);

INSERT INTO payments (transaction_id, amount, type, description, student_id)
VALUES (8187, 50.0, 'Activity Payment', 'Pagamento automático simulado', 6);

INSERT INTO payments_extra_activities (transaction_id, extra_activities_id)
VALUES (8187, 3);

INSERT INTO payments (transaction_id, amount, type, description, student_id)
VALUES (4553, 50.0, 'Activity Payment', 'Pagamento automático simulado', 7);

INSERT INTO payments_extra_activities (transaction_id, extra_activities_id)
VALUES (4553, 2);

INSERT INTO payments (transaction_id, amount, type, description, student_id)
VALUES (3840, 20.0, 'Activity Payment', 'Pagamento automático simulado', 11);

INSERT INTO payments_extra_activities (transaction_id, extra_activities_id)
VALUES (3840, 1);

INSERT INTO payments (transaction_id, amount, type, description, student_id)
VALUES (6537, 50.0, 'Activity Payment', 'Pagamento automático simulado', 13);

INSERT INTO payments_extra_activities (transaction_id, extra_activities_id)
VALUES (6537, 1);

INSERT INTO payments (transaction_id, amount, type, description, student_id)
VALUES (2581, 20.0, 'Activity Payment', 'Pagamento automático simulado', 14);

INSERT INTO payments_extra_activities (transaction_id, extra_activities_id)
VALUES (2581, 3);

INSERT INTO grade_log (grade, degree_program_id, edition_id, student_id)
VALUES (11, 1, 1, 5);

INSERT INTO grade_log (grade, degree_program_id, edition_id, student_id)
VALUES (11, 2, 1, 6);

INSERT INTO grade_log (grade, degree_program_id, edition_id, student_id)
VALUES (20, 2, 1, 7);

INSERT INTO grade_log (grade, degree_program_id, edition_id, student_id)
VALUES (18, 1, 2, 8);

INSERT INTO grade_log (grade, degree_program_id, edition_id, student_id)
VALUES (19, 3, 1, 9);

INSERT INTO grade_log (grade, degree_program_id, edition_id, student_id)
VALUES (17, 1, 2, 10);

INSERT INTO grade_log (grade, degree_program_id, edition_id, student_id)
VALUES (11, 1, 2, 11);

INSERT INTO grade_log (grade, degree_program_id, edition_id, student_id)
VALUES (16, 3, 1, 12);

INSERT INTO grade_log (grade, degree_program_id, edition_id, student_id)
VALUES (16, 2, 2, 13);

INSERT INTO grade_log (grade, degree_program_id, edition_id, student_id)
VALUES (10, 3, 2, 14);

ALTER TABLE student_financial_account ADD CONSTRAINT student_financial_account_fk1 FOREIGN KEY (staff_person_id) REFERENCES staff(person_id);
ALTER TABLE student_financial_account ADD CONSTRAINT student_financial_account_fk2 FOREIGN KEY (person_id) REFERENCES person(id);
ALTER TABLE person ADD UNIQUE (cc, username);
ALTER TABLE person ADD CONSTRAINT person_fk1 FOREIGN KEY (staff_person_id) REFERENCES staff(person_id);
ALTER TABLE instructor ADD CONSTRAINT instructor_fk1 FOREIGN KEY (person_id) REFERENCES person(id);
ALTER TABLE assistant_instructor ADD CONSTRAINT assistant_instructor_fk1 FOREIGN KEY (instructor_person_id) REFERENCES instructor(person_id);
ALTER TABLE coordinator_instructor ADD CONSTRAINT coordinator_instructor_fk1 FOREIGN KEY (instructor_person_id) REFERENCES instructor(person_id);
ALTER TABLE edition ADD CONSTRAINT edition_fk1 FOREIGN KEY (coordinator_id) REFERENCES coordinator_instructor(instructor_person_id);
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
ALTER TABLE edition_course ADD CONSTRAINT edition_course_fk1 FOREIGN KEY (edition_id) REFERENCES edition(edition_id);
ALTER TABLE edition_course ADD CONSTRAINT edition_course_fk2 FOREIGN KEY (course_code) REFERENCES course(course_code);
ALTER TABLE student_extra_activities ADD CONSTRAINT student_extra_activities_fk1 FOREIGN KEY (student_id) REFERENCES student_financial_account(person_id);
ALTER TABLE student_extra_activities ADD CONSTRAINT student_extra_activities_fk2 FOREIGN KEY (extra_activities_id) REFERENCES extra_activities(id);
ALTER TABLE student_class ADD CONSTRAINT student_class_fk1 FOREIGN KEY (student_id) REFERENCES student_financial_account(person_id);
ALTER TABLE student_class ADD CONSTRAINT student_class_fk2 FOREIGN KEY (class_id) REFERENCES class(class_id);
ALTER TABLE course_pre_requisite ADD CONSTRAINT course_pre_requisite_fk1 FOREIGN KEY (course_code) REFERENCES course(course_code);
ALTER TABLE course_pre_requisite ADD CONSTRAINT course_pre_requisite_fk2 FOREIGN KEY (course_code_prerequisite) REFERENCES course(course_code);

CREATE OR REPLACE FUNCTION trigger_payment_enroll() RETURNS TRIGGER
LANGUAGE plpgsql
as $$
DECLARE
    v_tax FLOAT;
	v_slots INTEGER;
	s_balance FLOAT;
	v_transaction_id INTEGER;
BEGIN
    -- Buscar o valor da taxa do degree program
    SELECT tax, slots INTO v_tax, v_slots
    FROM degree_program
    WHERE id = NEW.degree_program_id FOR UPDATE;

	-- Verificar se há vagas
	IF v_slots <= 0 THEN
		RAISE EXCEPTION 'Não há vagas disponíveis para este programa de grau';
	END IF;

	-- Verificar se o estudante tem saldo suficiente
	SELECT balance INTO s_balance
	FROM student_financial_account
	WHERE person_id = NEW.student_id
	FOR UPDATE;

	IF s_balance < v_tax THEN
		RAISE EXCEPTION 'Saldo insuficiente para se inscrever neste programa de grau';
	END IF;

    -- Inserir na tabela payments
    INSERT INTO payments (amount, type, description, student_id)
    VALUES (
        v_tax,
        'Degree Program Payment',
        'Enrollment in degree program',
        NEW.student_id
    )
	RETURNING transaction_id INTO v_transaction_id;

	 -- Associar pagamento ao degree
    INSERT INTO degree_program_payments (degree_program_id, transaction_id)
    VALUES (NEW.degree_program_id, v_transaction_id);

	-- Atualizar saldo do estudante
    UPDATE student_financial_account
    SET balance = balance - v_tax
    WHERE person_id = NEW.student_id;

	-- Atualizar o número de vagas disponíveis no degree program
	UPDATE degree_program
	SET slots = slots - 1
	WHERE id = NEW.degree_program_id;


    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_payment_enroll
AFTER INSERT ON student_degree_program
FOR EACH ROW
EXECUTE FUNCTION trigger_payment_enroll();


CREATE OR REPLACE FUNCTION process_activity_enrollment() RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_tax FLOAT;
    v_transaction_id INTEGER;
    v_balance FLOAT;
    v_slots INTEGER;
BEGIN
    -- Buscar o valor da taxa da atividade e número de vagas disponíveis
    SELECT tax, slots INTO v_tax, v_slots
    FROM extra_activities
    WHERE id = NEW.extra_activities_id
    FOR UPDATE;
    
    -- Verificar se há vagas disponíveis
    IF v_slots <= 0 THEN
        RAISE EXCEPTION 'Não há vagas disponíveis para esta atividade';
    END IF;
    
    -- Buscar o saldo atual do estudante 
    SELECT balance INTO v_balance
    FROM student_financial_account
    WHERE person_id = NEW.student_id
    FOR UPDATE;
    
    -- Verificar se o estudante tem saldo suficiente
    IF v_balance < v_tax THEN
        RAISE EXCEPTION 'Saldo insuficiente para se inscrever nesta atividade';
    END IF;
    
    
    -- Inserir na tabela payments
    INSERT INTO payments (amount, type, description, student_id)
    VALUES (
        v_tax,
        'Activity Payment',
        'Enrollment in extra activity',
        NEW.student_id
    )
    RETURNING transaction_id INTO v_transaction_id;
    
    -- Associar pagamento à atividade
    INSERT INTO payments_extra_activities (transaction_id, extra_activities_id)
    VALUES (v_transaction_id, NEW.extra_activities_id);
    
    -- Atualizar saldo do estudante
    UPDATE student_financial_account
    SET balance = balance - v_tax
    WHERE person_id = NEW.student_id;
    
    -- Atualizar o número de vagas disponíveis na atividade
    UPDATE extra_activities
    SET slots = slots - 1
    WHERE id = NEW.extra_activities_id;
    
    RETURN NEW;
END;
$$;

-- Criar o trigger que combina verificação de saldo e processamento de pagamento
CREATE OR REPLACE TRIGGER trg_process_activity_enrollment
BEFORE INSERT ON student_extra_activities
FOR EACH ROW
EXECUTE FUNCTION process_activity_enrollment();


CREATE OR REPLACE FUNCTION update_grade_log() RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    avg_grade FLOAT;
    deg_prog_id INTEGER;
	exists_grade INTEGER;
BEGIN
    -- Obter a média das notas do aluno
    SELECT AVG(e.grade)
    INTO avg_grade
    FROM evaluation e
    WHERE e.edition_id = NEW.edition_id AND e.student_id = NEW.student_id;

    -- Obter o degree do aluno
    SELECT sdp.degree_program_id
	INTO deg_prog_id
	FROM student_degree_program sdp
	WHERE sdp.student_id = NEW.student_id;

    -- Verifica se já existe entrada para o estudante na edição e degree program
	SELECT 1 INTO exists_grade
	FROM grade_log
	WHERE degree_program_id = deg_prog_id 
	AND edition_id = NEW.edition_id 
	AND student_id = NEW.student_id;

	IF exists_grade = 1 THEN
		-- Atualiza a nota
		UPDATE grade_log
		SET grade = ROUND(avg_grade)
		WHERE degree_program_id = deg_prog_id AND edition_id = NEW.edition_id AND student_id = NEW.student_id;
	ELSE
		-- Insere nova nota
		INSERT INTO grade_log (grade, degree_program_id, edition_id, student_id)
		VALUES (ROUND(avg_grade), deg_prog_id, NEW.edition_id, NEW.student_id);
	END IF;

    RETURN NULL;
END;
$$;

CREATE TRIGGER trg_update_grade_log
AFTER INSERT ON evaluation
FOR EACH ROW
EXECUTE FUNCTION update_grade_log();

CREATE OR REPLACE FUNCTION top3_students()
RETURNS TABLE (
    student_name VARCHAR,
    average_grade NUMERIC,
    course_edition_id INTEGER,
    course_name VARCHAR,
    grade INTEGER,
    evaluation_date DATE,
    activity_name VARCHAR
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.name,
        ROUND(avg_data.avg_grade::NUMERIC, 1),
        ed.edition_id,
        c.name,
        e.grade,
        ep.evaluation_date,
        ea.name
    FROM (
        SELECT e.student_id, AVG(e.grade)::FLOAT AS avg_grade
        FROM evaluation e
        JOIN edition ed ON ed.edition_id = e.edition_id
        WHERE ed.ed_year = 2024
        GROUP BY e.student_id
        ORDER BY avg_grade DESC
        LIMIT 3
    ) avg_data
    JOIN student_financial_account sfa ON sfa.person_id = avg_data.student_id
    JOIN person p ON p.id = sfa.person_id
    LEFT JOIN evaluation e ON e.student_id = sfa.person_id
    LEFT JOIN edition ed ON ed.edition_id = e.edition_id AND ed.ed_year = 2024
    LEFT JOIN edition_course ec ON ec.edition_id = ed.edition_id
    LEFT JOIN course c ON c.course_code = ec.course_code
    LEFT JOIN evaluation_period ep ON ep.name = e.evaluation_period_name AND ep.edition_id = e.edition_id
    LEFT JOIN student_extra_activities sea ON sea.student_id = sfa.person_id
    LEFT JOIN extra_activities ea ON ea.id = sea.extra_activities_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_best_students_by_district()
RETURNS TABLE (
    student_id INTEGER,
    district VARCHAR,
    average_grade NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        sfa.person_id,
        p.district,
        ROUND((
            SELECT AVG(e2.grade)
            FROM evaluation e2
            JOIN edition ed2 ON ed2.edition_id = e2.edition_id
            WHERE e2.student_id = sfa.person_id AND ed2.ed_year = 2024
        ), 0) AS average_grade
    FROM student_financial_account sfa
    JOIN person p ON sfa.person_id = p.id
    WHERE sfa.person_id = (
        SELECT e.student_id
        FROM evaluation e
        JOIN edition ed ON ed.edition_id = e.edition_id
        JOIN student_financial_account sfa2 ON e.student_id = sfa2.person_id
        JOIN person p2 ON sfa2.person_id = p2.id
        WHERE ed.ed_year = 2024 AND p2.district = p.district
        GROUP BY e.student_id
        ORDER BY AVG(e.grade) DESC
        LIMIT 1
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_monthly_report()
RETURNS TABLE (
    month TEXT,
    course_edition_id INTEGER,
    course_edition_name VARCHAR,
    approved BIGINT,
    evaluated BIGINT
) AS $$
BEGIN
    RETURN QUERY
	SELECT 
		CONCAT(
        EXTRACT(YEAR FROM ep.evaluation_date)::INT, '-', 
        EXTRACT(MONTH FROM ep.evaluation_date)::INT
    	) AS month,
		ed.edition_id AS course_edition_id,
		c.name AS course_edition_name,
		COUNT(CASE WHEN ev.grade >= 10 THEN 1 ELSE NULL END) AS approved,
		COUNT(*) AS evaluated
	FROM evaluation ev
	JOIN evaluation_period ep ON ep.name = ev.evaluation_period_name AND ep.edition_id = ev.edition_id
	JOIN edition ed ON ed.edition_id = ev.edition_id
	JOIN edition_course ec ON ec.edition_id = ed.edition_id
	JOIN course c ON c.course_code = ec.course_code
	WHERE ep.evaluation_date >= CURRENT_DATE - INTERVAL '12 months'
	-- Extrai ano/mês uma vez e usa alias
	GROUP BY 
		EXTRACT(YEAR FROM ep.evaluation_date)::INT,
		EXTRACT(MONTH FROM ep.evaluation_date)::INT,
		ed.edition_id,
		c.name
	HAVING COUNT(CASE WHEN ev.grade >= 10 THEN 1 ELSE NULL END) = (
		SELECT MAX(appr_count) FROM (
			SELECT 
				COUNT(CASE WHEN ev2.grade >= 10 THEN 1 ELSE NULL END) AS appr_count
			FROM evaluation ev2
			JOIN evaluation_period ep2 ON ep2.name = ev2.evaluation_period_name AND ep2.edition_id = ev2.edition_id
			JOIN edition ed2 ON ed2.edition_id = ev2.edition_id
			WHERE 
				EXTRACT(YEAR FROM ep2.evaluation_date)::INT = EXTRACT(YEAR FROM ep.evaluation_date)::INT
				AND EXTRACT(MONTH FROM ep2.evaluation_date)::INT = EXTRACT(MONTH FROM ep.evaluation_date)::INT
			GROUP BY ed2.edition_id
		) AS subquery
	)
	ORDER BY 
		EXTRACT(YEAR FROM ep.evaluation_date)::INT, 
		EXTRACT(MONTH FROM ep.evaluation_date)::INT;
END;
$$ LANGUAGE plpgsql;


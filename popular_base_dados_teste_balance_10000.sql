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

INSERT INTO student_financial_account (student_number, 10000.0, staff_person_id, person_id)
VALUES ('20240005', 711.54, 1, 5);

INSERT INTO student_financial_account (student_number, 10000.0, staff_person_id, person_id)
VALUES ('20240006', 395.91, 1, 6);

INSERT INTO student_financial_account (student_number, 10000.0, staff_person_id, person_id)
VALUES ('20240007', 741.36, 1, 7);

INSERT INTO student_financial_account (student_number, 10000.0, staff_person_id, person_id)
VALUES ('20240008', 225.43, 1, 8);

INSERT INTO student_financial_account (student_number, 10000.0, staff_person_id, person_id)
VALUES ('20240009', 604.28, 1, 9);

INSERT INTO student_financial_account (student_number, 10000.0, staff_person_id, person_id)
VALUES ('20240010', 772.82, 1, 10);

INSERT INTO student_financial_account (student_number, 10000.0, staff_person_id, person_id)
VALUES ('20240011', 671.41, 1, 11);

INSERT INTO student_financial_account (student_number, 10000.0, staff_person_id, person_id)
VALUES ('20240012', 538.09, 1, 12);

INSERT INTO student_financial_account (student_number, 10000.0, staff_person_id, person_id)
VALUES ('20240013', 965.77, 1, 13);

INSERT INTO student_financial_account (student_number, 10000.0, staff_person_id, person_id)
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
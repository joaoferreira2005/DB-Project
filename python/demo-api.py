##
## =============================================
## ============== Bases de Dados ===============
## ============== LEI  2024/2025 ===============
## =============================================
## =================== Demo ====================
## =============================================
## =============================================
## === Department of Informatics Engineering ===
## =========== University of Coimbra ===========
## =============================================
##
## Authors:
##   João R. Campos <jrcampos@dei.uc.pt>
##   Nuno Antunes <nmsa@dei.uc.pt>
##   University of Coimbra


import flask
import logging
import jwt.utils
import psycopg2
import time
import random
import datetime
import jwt # esta biblioteca é a pyjwt -> perguntar ao stor

import bcrypt #nao sei se pudemos utilizar ou nao
from decouple import config #pip install python-decouple

from functools import wraps

app = flask.Flask(__name__)
app.config['JWT_SECRET_KEY'] = config("SECRET_KEY")

StatusCodes = {
    'success': 200,
    'api_error': 400,
    'internal_error': 500,
    'unauthorized': 401
}

##########################################################
## DATABASE ACCESS
##########################################################

def db_connection():
    db = psycopg2.connect( #Use of decouple library to hide credentials in the .py file
        user=config("DB_USER"),
        password=config("DB_PASSWORD"),
        host=config("DB_HOST"),
        port=config("DB_PORT"),
        database=config("DB_NAME")
    )
    return db

##########################################################
## AUTHENTICATION HELPERS
##########################################################

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = flask.request.headers.get('Authorization') #Get the token, extracted from the header in the authorization field
        logger.info(f'token: {token}') #Displays the token to the console.

        if not token: #If no token received when this function is called, returns error.
            return flask.jsonify({'status': StatusCodes['unauthorized'], 'errors': 'Token is missing!', 'results': None})

        try:
            # Remove "Bearer " word if present
            if token.startswith('Bearer '): #Removes Bearer Word.
                token = token[7:]

            #Token decode
            payload = jwt.decode(token, app.config['JWT_SECRET_KEY'], algorithms=["HS256"]) 
            #Our token contains several informations about the user, like role, etc...
            #We decode it so we can use it during every function.

        except jwt.ExpiredSignatureError: #If token is expired, returns this exception
            return flask.jsonify({
                'status': StatusCodes['unauthorized'],
                'errors': 'Token expired',
                'results': None
            })

        except jwt.InvalidTokenError: #If token is invalid, return this exception
            return flask.jsonify({
                'status': StatusCodes['unauthorized'],
                'errors': 'Invalid token',
                'results': None
            })

        return f(user_info=payload, *args, **kwargs) #Returns original function, however with another argument, which is user_info, that contains
        #token informations.
    return decorated 

##########################################################
## ENDPOINTS
##########################################################

##################################################################### Login user ###########################################################      
@app.route('/dbproj/user', methods=['PUT'])
def login_user(): #Login endpoint
    data = flask.request.get_json() #Get's the response coming from postman
    username = data.get('username') #Get's the username sent by the user in Postman
    password = data.get('password') #Get's the password sent by the user in Postman (not hashed)
    conn = None #Sets conn to None, avoiding errors in finally.
    
    if not username or not password: #If no username or password in the postman body request.
        return flask.jsonify({
            'status': StatusCodes['unauthorized'],
            'errors': 'Username and password are required',
            'results': None
        })

    try:
        conn = db_connection() #Makes connection with database and creates a cursor
        cur = conn.cursor()

        # Buscar utilizador
        cur.execute("SELECT id, password FROM person WHERE username = %s", (username,)) #Try to get from the database and check if the username entered by the user
        #matches what is in the database
        person = cur.fetchone() #Returns the first line of the occurrence (always one, since username is unique) or None

        if not person: #if person not found:
            return flask.jsonify({
                'status': StatusCodes['unauthorized'],
                'errors': 'Invalid username or password',
                'results': None
            })

        person_id, hashed_password = person #Set the person_id and hash_password variables for better identification

        #Password verification with bcrypt (encodes the password given by user and verifies with the one in the database)
        if not bcrypt.checkpw(password.encode('utf-8'), hashed_password.encode('utf-8')):
            return flask.jsonify({
                'status': StatusCodes['unauthorized'],
                'errors': 'Invalid username or password',
                'results': None
            })

        # Verify user type
        cur.execute("""
            SELECT 'staff' from staff WHERE person_id=%s
            UNION
            SELECT 'student' from student_financial_account WHERE person_id=%s
            UNION
            SELECT 'instructor' from instructor WHERE person_id=%s
        """, (person_id, person_id, person_id))

        result = cur.fetchone() #Fetch only one result
        if not result:
            return flask.jsonify({
                'status': StatusCodes['unauthorized'],
                'errors': 'User with no role',
                'results': None
            })

        user_type = result[0]

        # Generates token using JWT
        token = jwt.encode({
            'person_id': person_id,
            'username': username,
            'user_type': user_type,
            'exp': datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(hours=2)
        }, key=app.config['JWT_SECRET_KEY'], algorithm="HS256")

        return flask.jsonify({
            'status': StatusCodes['success'],
            'results': token #Returns token to the user
        })

    except Exception as e:
        return flask.jsonify({
            'status': StatusCodes['internal_error'],
            'errors': str(e),
            'results': None
        })

    finally:
        if conn: #Closes the connection
            conn.close()
            
##################################################################### Register Staff, Student and Instructor ###########################################################        
@app.route('/dbproj/register/student', methods=['POST'])
@token_required
def register_student(user_info):
    if user_info["user_type"] != "staff": #If the logged user (token having user_type) is not a staff:
        return flask.jsonify({'status': StatusCodes['unauthorized'], 'errors': "You don't have permissions to perform this act.", 'results': None})

    data = flask.request.get_json() #Get's the response given by the user in postman 
    cc = str(data.get('cc')) #Transform cc camp to str so no problems with using numbers or string
    student_number = str(data.get('student_number'))  #Transform student_number camp to str so no problems with using numbers or string
    #Same to every other argument given
    email = str(data.get('email'))
    name = str(data.get('name'))
    birth_date = str(data.get('birth_date'))
    username = str(data.get('username'))
    password = str(data.get('password'))
    district = str(data.get('district'))
    staff_id = user_info['person_id']
    conn = None
    required = ["cc", "student_number", "name", "birth_date", "username", "email", "password", "district"] #Required camps
    missing = [field for field in required if not data.get(field)] #Had to use data.get again because using str() it converts to "None" string, so every time it enters
    #the verification
    if missing:   
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'CC, student_number, name, birth_date, username, email, password and district are required', 'results': None})
    
    try:
        conn = db_connection() #Makes db connection
        cur = conn.cursor()
        
        hashed_pw = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8') #Encrypt password to go into database

        datetime.datetime.strptime(birth_date, '%Y-%m-%d') #Verifies if date is in the right format, otherwise returns exception


        if verifyEmail(email) == False or verifyCC(cc) == False or verifyStudentNumber(student_number) == False or name.isdigit() == True:
            #Made some verifications in every camp given by the used. In the future it may have
            return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Invalid arguments. Try again', 'results': None})

        #Inserts into the database the current values
        cur.execute("""
            INSERT INTO person (cc, name, birth_date, username, email, password, district, staff_person_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            cc,
            name,
            birth_date,
            username,
            email,
            hashed_pw,
            district,
            staff_id
        ))

        cur.execute("SELECT id FROM person WHERE cc = %s", (cc,)) #Gets the id from the person using cc which is unique
        person_id = cur.fetchone()[0]

        #Insert into student table his student_number and other informations
        cur.execute("""
            INSERT INTO student_financial_account (person_id, student_number, balance, staff_person_id)
            VALUES (%s, %s, %s, %s)
        """, (person_id, student_number, 0.0, staff_id))

        conn.commit() #Commits the transaction

        return flask.jsonify({
            'status': StatusCodes['success'],
            'errors': None,
            'results': person_id
        })

    except ValueError: #In case of wrong date
        if conn:
            conn.rollback()
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Invalid arguments. Try again', 'results': None})
    except Exception as e: #Other exceptions
        if conn:
            conn.rollback()
        return flask.jsonify({
            'status': StatusCodes['internal_error'],
            'errors': str(e),
            'results': None
        })
    
    finally:
        if conn:
            conn.close()

@app.route('/dbproj/register/staff', methods=['POST'])
@token_required
def register_staff(user_info):
    if user_info["user_type"] != "staff":
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': "You don't have permissions to perform this act.", 'results': None})

    data = flask.request.get_json()
    cc = str(data.get('cc'))
    email = str(data.get('email'))
    name = str(data.get('name'))
    birth_date = str(data.get('birth_date'))
    username = str(data.get('username'))
    password = str(data.get('password'))
    district = str(data.get('district'))
    staff_id = user_info['person_id']
    role = str(data.get('role'))
    print(staff_id)
    required = ["cc", "role", "name", "birth_date", "username", "email", "password", "district"]
    missing = [field for field in required if not data.get(field)]
    if missing:   
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'CC, role, name, birth_date, username, email, password and district are required', 'results': None})
    
    try:
        conn = db_connection()
        cur = conn.cursor()
        
        hashed_pw = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

        datetime.datetime.strptime(birth_date, '%Y-%m-%d')

        if verifyEmail(email) == False or verifyCC(cc) == False or name.isdigit() == True or verifyRoles(role) == False:
            return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Invalid arguments. Try again', 'results': None})

        cur.execute("""
            INSERT INTO person (cc, name, birth_date, username, email, password, district, staff_person_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            cc,
            name,
            birth_date,
            username,
            email,
            hashed_pw,
            district,
            staff_id
        ))

        cur.execute("SELECT id FROM person WHERE cc = %s", (cc,))
        person_id = cur.fetchone()[0]

        cur.execute("""
            INSERT INTO staff (role, person_id)
            VALUES (%s, %s)
        """, (role, person_id))

        conn.commit()

        return flask.jsonify({
            'status': StatusCodes['success'],
            'errors': None,
            'results': person_id
        })

    except ValueError:
        if conn:
            conn.rollback()
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Invalid arguments. Try again', 'results': None})
    except Exception as e:
        if conn:
            conn.rollback()
        return flask.jsonify({
            'status': StatusCodes['internal_error'],
            'errors': str(e),
            'results': None
        })
    
    finally:
        if conn:
            conn.close()

@app.route('/dbproj/register/instructor', methods=['POST'])
@token_required
def register_instructor(user_info):
    if user_info["user_type"] != "staff":
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': "You don't have permissions to perform this act.", 'results': None})

    data = flask.request.get_json()
    cc = str(data.get('cc'))
    email = str(data.get('email'))
    name = str(data.get('name'))
    birth_date = str(data.get('birth_date'))
    username = str(data.get('username'))
    password = str(data.get('password'))
    district = str(data.get('district'))
    staff_id = user_info['person_id']
    instructor_type = str(data.get('instructor_type'))
    func_number = str(data.get('func_number'))
    phd_student = data.get('phd_student')
    investigation = data.get('investigator')
    
    required = ["cc", "name", "birth_date", "username", "email", "password", "district", "instructor_type", "func_number"]
    missing = [field for field in required if not data.get(field)]
    if missing:   
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'CC, name, birth_date, username, email, password, district, instructor_type and func_number are required', 'results': None})
    
    print(verifyInstructor(instructor_type, phd_student, investigation))
    if verifyInstructor(instructor_type, phd_student, investigation):
        if investigation and phd_student:
                return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'An assistant instructor can only have phd_student argument', 'results': None})
        
        elif instructor_type.lower() == 'coordinator':
            if not investigation:
                return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'For coordinator instructor there must be an investigator argument', 'results': None})

        elif instructor_type.lower() == 'assistant':
            if not phd_student:
                return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'For assistant instructor there must be an investigator argument', 'results': None})
        
    else:
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Invalid arguments. Try again', 'results': None})
    
    try:
        conn = db_connection()
        cur = conn.cursor()
        hashed_pw = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        datetime.datetime.strptime(birth_date, '%Y-%m-%d')
        responses = ["true", "false"]
        if verifyEmail(email) == False or verifyCC(cc) == False or name.isdigit() == True or verifyStudentNumber(func_number) == False:
            return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Invalid arguments. Try again', 'results': None})

        cur.execute("""
            INSERT INTO person (cc, name, birth_date, username, email, password, district, staff_person_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            cc,
            name,
            birth_date,
            username,
            email,
            hashed_pw,
            district,
            staff_id
        ))

        cur.execute("SELECT id FROM person WHERE cc = %s", (cc,))
        person_id = cur.fetchone()[0]

        cur.execute("""
            INSERT INTO instructor (person_id, func_number)
            VALUES (%s, %s)
            """, (person_id, func_number))

        if instructor_type == 'coordinator':
            cur.execute("""
            INSERT INTO coordinator_instructor (investigation, instructor_person_id)
            VALUES (%s, %s)
            """, (investigation, person_id))
        elif instructor_type == 'assistant':
            cur.execute("""
            INSERT INTO assistant_instructor (phd_student, instructor_person_id)
            VALUES (%s, %s)
            """, (phd_student, person_id))

        conn.commit()

        return flask.jsonify({
            'status': StatusCodes['success'],
            'errors': None,
            'results': person_id
        })

    except ValueError:
        if conn:
            conn.rollback()
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Invalid arguments. Try again', 'results': None})
    except Exception as e:
        if conn:
            conn.rollback()
        return flask.jsonify({
            'status': StatusCodes['internal_error'],
            'errors': str(e),
            'results': None
        })
    
    finally:
        if conn:
            conn.close()

##################################################################### Enroll in Degree Program ###########################################################
@app.route('/dbproj/enroll_degree/<degree_id>', methods=['POST'])
@token_required
def enroll_degree(degree_id, user_info): # Ver isto, eu criei um curso com code de 101, degree ID 2 
    if user_info["user_type"] != "staff":
        return flask.jsonify({'status': StatusCodes['unauthorized'], 'errors': "You don't have permissions to perform this act.", 'results': None})

    data = flask.request.get_json() # Get's the response given by the user in postman
    student_id = str(data.get('student_id')) # Get's the student_id sent by the user in Postman
    enrollment_date = str(data.get('date'))

    if not student_id or not enrollment_date:
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Student ID and enrollment date are required', 'results': None})
    
    try:
        conn = db_connection()
        conn.autocommit = False
        cur = conn.cursor()

        # Verifica se o degree program existe
        cur.execute("SELECT course_code FROM degree_program WHERE id = %s", (degree_id,))
        row = cur.fetchone()
        if not row:
            return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Degree program not found.', 'results': None})
        course_code = row[0]

        # Seleciona a próxima edição disponível do curso
        cur.execute("""
            SELECT edition_id, capacity
            FROM edition
            WHERE course_code = %s
            ORDER BY ed_year DESC, ed_month DESC
            LIMIT 1
            FOR UPDATE
        """, (course_code,))
        ed_row = cur.fetchone()
        if not ed_row:
            return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'No available edition for this course.', 'results': None})
        edition_id, capacity = ed_row

        # Verifica se já está inscrito
        cur.execute("""
            SELECT 1 FROM enrollment
            WHERE degree_program_id = %s AND edition_id = %s AND student_id = %s
        """, (degree_id, edition_id, student_id))
        if cur.fetchone():
            return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Student already enrolled in this program and edition.', 'results': None})

        # Verifica a capacidade da edição
        cur.execute("""
            SELECT COUNT(*) FROM enrollment
            WHERE degree_program_id = %s AND edition_id = %s
        """, (degree_id, edition_id))
        current_enrollments = cur.fetchone()[0]

        if current_enrollments >= capacity:
            return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'No available slots in this edition.', 'results': None})

        # Stores the student enrolled in the degree program
        cur.execute("""
            INSERT INTO student_degree_program (student_id, degree_program_id) 
                    values (%s, %s)
                    """, (student_id, degree_id))
        
        # Enroll student
        cur.execute("""
            INSERT INTO enrollment (enrollment_date, status, degree_program_id, edition_id, student_id, staff_id)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (enrollment_date, True, degree_id, edition_id, student_id, user_info['person_id']))

        cur.execute("""
            SELECT transaction_id
            FROM payments
            WHERE student_id = %s
            ORDER BY transaction_id DESC
            LIMIT 1
        """, (student_id,))
        row = cur.fetchone()
        
        if not row:
            conn.rollback()
            return flask.jsonify({'status': StatusCodes['internal_error'], 'errors': 'Problem registering payment. Aborting.', 'results': None})
        transaction_id = row[0]

        conn.commit()

        return flask.jsonify({
            'status': StatusCodes['success'],
            'errors': None,
            'results': {'student_id': student_id, 'edition_id': edition_id, 'transaction_id': transaction_id}
        })

    except Exception as e:
        if conn:
            conn.rollback()
        return flask.jsonify({
            'status': StatusCodes['internal_error'],
            'errors': str(e),
            'results': None
        })

    finally:
        if conn:
            conn.close()


##################################################################### Enroll in Activity ###########################################################
@app.route('/dbproj/enroll_activity/<activity_id>', methods=['POST'])
@token_required
def enroll_activity(activity_id, user_info):
    # Verificar se o usuário é um estudante
    if user_info["user_type"] != "student":
        return flask.jsonify({
            'status': StatusCodes['unauthorized'], 
            'errors': "You don't have permissions to perform this act.", 
            'results': None
        })
    
    data = flask.request.get_json() # Get's the response given by the user in postman
    student_id = str(data.get('student_id')) # Get's the student_id sent by the user in Postman
    
    try:
        conn = db_connection()
        conn.autocommit = False
        cur = conn.cursor()
        
        # Verificar se a atividade existe
        cur.execute(
            "SELECT id, slots FROM extra_activities WHERE id = %s",
            (activity_id,) 
        )
        activity = cur.fetchone()
        
        if not activity:
            return flask.jsonify({
                'status': StatusCodes['api_error'], 
                'errors': 'Activity not found', 
                'results': None
            })
        
        # Verificar vagas disponíveis
        cur.execute("SELECT COUNT(*) FROM student_extra_activities WHERE extra_activities_id = %s", (activity_id,))
        current_enrolled = cur.fetchone()[0]
        
        if current_enrolled >= activity[1]:
            return flask.jsonify({
                'status': StatusCodes['api_error'], 
                'errors': 'No available slots for this activity', 
                'results': None
            })
        
        # Verificar se o estudante já está inscrito nesta atividade
        cur.execute(
            "SELECT * FROM student_extra_activities WHERE student_id = %s AND extra_activities_id = %s",
            (student_id, activity_id)
        )
        existing_enrollment = cur.fetchone()
        
        if existing_enrollment:
            return flask.jsonify({
                'status': StatusCodes['api_error'], 
                'errors': 'Student already enrolled in this activity', 
                'results': None
            })
        
        # Inserir a relação estudante-atividade
        # O trigger process_activity_enrollment será executado automaticamente aqui
        cur.execute(
            "INSERT INTO student_extra_activities (student_id, extra_activities_id) VALUES (%s, %s)",
            (student_id, activity_id)
        )
        
        
        # Buscar a transação gerada para retornar ao usuário
        cur.execute("""
            SELECT transaction_id 
            FROM payments p
            JOIN payments_extra_activities pea ON p.transaction_id = pea.transaction_id
            WHERE p.student_id = %s AND pea.extra_activities_id = %s
            ORDER BY p.transaction_id DESC
            LIMIT 1
        """, (student_id, activity_id))
        
        transaction_result = cur.fetchone()
        transaction_id = transaction_result[0] if transaction_result else None
        
        # Confirmar a transação
        conn.commit()
        
        return flask.jsonify({
            'status': StatusCodes['success'],
            'errors': None,
            'results': {
                'student_id': student_id,
                'activity_id': activity_id,
                'transaction_id': transaction_id
            }
        })
        
    except psycopg2.DatabaseError as e:
        if conn:
            conn.rollback()
            
        # Verificar se é uma exceção lançada pelo nosso trigger
        error_message = str(e)
        if "Saldo insuficiente" in error_message:
            return flask.jsonify({
                'status': StatusCodes['api_error'],
                'errors': 'Saldo insuficiente para se inscrever nesta atividade',
                'results': None
            })
        elif "Não há vagas disponíveis" in error_message:
            return flask.jsonify({
                'status': StatusCodes['api_error'],
                'errors': 'Não há vagas disponíveis para esta atividade',
                'results': None
            })
        else:
            return flask.jsonify({
                'status': StatusCodes['internal_error'],
                'errors': error_message,
                'results': None
            })
    except Exception as e:
        if conn:
            conn.rollback()
        return flask.jsonify({
            'status': StatusCodes['internal_error'],
            'errors': str(e),
            'results': None
        })
    
    finally:
        if conn:
            conn.close()

##################################################################### Enroll in Course Edition ###########################################################
@app.route('/dbproj/enroll_course_edition/<course_edition_id>', methods=['POST'])
@token_required
def enroll_course_edition(course_edition_id, user_info):
    if user_info["user_type"] != "staff":
        return flask.jsonify({'status': StatusCodes['unauthorized'], 'errors': "You don't have permissions to perform this act.", 'results': None})

    data = flask.request.get_json()
    student_id = data.get('student_id')
    classes = data.get('classes', [])

    if not classes:
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'At least one class ID is required', 'results': None})
    
    try:
        conn = db_connection()
        conn.autocommit = False
        cur = conn.cursor()

        # Verifica se a edição existe
        cur.execute("SELECT course_code, capacity FROM edition WHERE edition_id = %s", (course_edition_id,))
        edition = cur.fetchone()
        if not edition:
            conn.rollback()
            return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Edition not found.', 'results': None})

        course_code, capacity = edition

        # Verifica se o aluno já está inscrito nesta edição
        cur.execute("SELECT 1 FROM enrollment WHERE edition_id = %s AND student_id = %s", (course_edition_id, student_id))
        if cur.fetchone():
            conn.rollback()
            return flask.jsonify({'status': StatusCodes['conflict'], 'errors': 'Student already enrolled in this course edition.', 'results': None})
            
        # Verifica se a edição ainda tem capacidade
        cur.execute("SELECT COUNT(*) FROM enrollment WHERE edition_id = %s", (course_edition_id,))
        current_enrollment = cur.fetchone()[0]

        if current_enrollment >= capacity:
            conn.rollback()
            return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Course edition is full.', 'results': None})
        
        # Verifica cada turma indicada
        for class_id in classes:
            # Verifica se a turma pertence à edição
            cur.execute("SELECT 1 FROM class WHERE class_id = %s AND edition_id = %s", (class_id, course_edition_id))
            if not cur.fetchone():
                conn.rollback()
                return flask.jsonify({'status': StatusCodes['api_error'], 'errors': f'Class {class_id} does not belong to the specified edition.', 'results': None})
        
        # Obter a capacidade da sala da turma
        cur.execute("SELECT cr.capacity FROM classroom cr JOIN schedule s ON cr.schedule_id = s.id WHERE s.class_id = %s AND cr.id = %s", (class_id, class_id))
        classroom_row = cur.fetchone()
        if not classroom_row:
            conn.rollback()
            return flask.jsonify({'status': StatusCodes['api_error'], 'errors': f'No classroom assigned to class {class_id}.', 'results': None})

        classroom_capacity = classroom_row[0]

        # Contar número de alunos inscritos nesta turma
        cur.execute("SELECT COUNT(*) FROM class_enrollment WHERE class_id = %s", (class_id,))
        enrolled_in_class = cur.fetchone()[0]

        if enrolled_in_class >= classroom_capacity:
            conn.rollback()
            return flask.jsonify({'status': StatusCodes['api_error'], 'errors': f'Class {class_id} is full.', 'results': None})
        
        response = {'status': StatusCodes['success'], 'errors': None}
        conn.rollback()  # rollback temporário mudar para commit quando acabar!
        return flask.jsonify(response)

    except Exception as e:
        if conn:
            conn.rollback()
        return flask.jsonify({'status': StatusCodes['server_error'], 'errors': str(e), 'results': None})
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()
        
        

####################################################################### Submit Grades ####################################################################
@app.route('/dbproj/submit_grades/<course_edition_id>', methods=['POST'])
@token_required
def submit_grades(course_edition_id):
    data = flask.request.get_json()
    period = data.get('period')
    grades = data.get('grades', [])

    if not period or not grades:
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Evaluation period and grades are required', 'results': None})
    
    response = {'status': StatusCodes['success'], 'errors': None}
    return flask.jsonify(response)

################################################################## Get Student Details ##############################################################
@app.route('/dbproj/student_details/<student_id>', methods=['GET'])
@token_required
def student_details(student_id):

    resultStudentDetails = [ # TODO
        {
            'course_edition_id': random.randint(1, 200),
            'course_name': "some course",
            'course_edition_year': 2024,
            'grade': 12
        },
        {
            'course_edition_id': random.randint(1, 200),
            'course_name': "another course",
            'course_edition_year': 2025,
            'grade': 17
        }
    ]

    response = {'status': StatusCodes['success'], 'errors': None, 'results': resultStudentDetails}
    return flask.jsonify(response)

############################################################# Get Degree Details ##############################################################
@app.route('/dbproj/degree_details/<degree_id>', methods=['GET'])
@token_required
def degree_details(degree_id):

    resultDegreeDetails = [ # TODO
        {
            'course_id': random.randint(1, 200),
            'course_name': "some coure",
            'course_edition_id': random.randint(1, 200),
            'course_edition_year': 2023,
            'capacity': 30,
            'enrolled_count': 27,
            'approved_count': 20,
            'coordinator_id': random.randint(1, 200),
            'instructors': [random.randint(1, 200), random.randint(1, 200)]
        }
    ]

    response = {'status': StatusCodes['success'], 'errors': None, 'results': resultDegreeDetails}
    return flask.jsonify(response)

############################################################## Get Top 3 Students ##############################################################
@app.route('/dbproj/top3', methods=['GET'])
@token_required
def top3_students():

    resultTop3 = [ # TODO
        {
            'student_name': "John Doe",
            'average_grade': 15.1,
            'grades': [
                {
                    'course_edition_id': random.randint(1, 200),
                    'course_edition_name': "some course",
                    'grade': 15.1,
                    'date': datetime.datetime(2024, 5, 12)
                }
            ],
            'activities': [random.randint(1, 200), random.randint(1, 200)]
        },
        {
            'student_name': "Jane Doe",
            'average_grade': 16.3,
            'grades': [
                {
                    'course_edition_id': random.randint(1, 200),
                    'course_edition_name': "another course",
                    'grade': 15.1,
                    'date': datetime.datetime(2023, 5, 11)
                }
            ],
            'activities': [random.randint(1, 200)]
        }
    ]

    response = {'status': StatusCodes['success'], 'errors': None, 'results': resultTop3}
    return flask.jsonify(response)

@app.route('/dbproj/top_by_district', methods=['GET'])
@token_required
def top_by_district():

    resultTopByDistrict = [ # TODO
        {
            'student_id': random.randint(1, 200),
            'district': "Coimbra",
            'average_grade': 15.2
        },
        {
            'student_id': random.randint(1, 200),
            'district': "Coimbra",
            'average_grade': 13.6
        }
    ]

    response = {'status': StatusCodes['success'], 'errors': None, 'results': resultTopByDistrict}
    return flask.jsonify(response)

@app.route('/dbproj/report', methods=['GET'])
@token_required
def monthly_report():

    resultReport = [ # TODO
        {
            'month': "month_0",
            'course_edition_id': random.randint(1, 200),
            'course_edition_name': "Some course",
            'approved': 20,
            'evaluated': 23
        },
        {
            'month': "month_1",
            'course_edition_id': random.randint(1, 200),
            'course_edition_name': "Another course",
            'approved': 200,
            'evaluated': 123
        }
    ]

    response = {'status': StatusCodes['success'], 'errors': None, 'results': resultReport}
    return flask.jsonify(response)

@app.route('/dbproj/delete_details/<student_id>', methods=['DELETE'])
@token_required
def delete_student(student_id):
    response = {'status': StatusCodes['success'], 'errors': None}
    return flask.jsonify(response)

##########################################################
## UTIL FUNCTIONS
##########################################################

def verifyEmail(email):
    if '@' not in email and '.' not in email:
        return False

def verifyCC(cc_number):
    if (type(cc_number) == str and cc_number.isdigit() and len(cc_number) == 9):
        return True
    return False

def verifyStudentNumber(studentnumber):
    if (type(studentnumber) == str and studentnumber.isdigit() and len(studentnumber) == 10):
        return True
    return False

def verifyRoles(role):
    roles = ["admin", "helpdesk"]
    if role.lower() in roles:
        return True
    return False

def verifyInstructor(instructor_type, phd_student, investigator):
    types = ['coordinator', 'assistant']
    responses = ['true', 'false']
    if instructor_type.lower() in types:
        if instructor_type.lower() == "coordinator":
            if str(investigator).lower() in responses:
                return True
        elif instructor_type.lower() == "assistant":
            if str(phd_student).lower() in responses:
                return True
    return False

##########################################################
## MAIN
##########################################################

if __name__ == '__main__':
    # set up logging
    logging.basicConfig(filename='log_file.log')
    logger = logging.getLogger('logger')
    logger.setLevel(logging.DEBUG)
    ch = logging.StreamHandler()
    ch.setLevel(logging.DEBUG)

    # create formatter
    formatter = logging.Formatter('%(asctime)s [%(levelname)s]:  %(message)s', '%H:%M:%S')
    ch.setFormatter(formatter)
    logger.addHandler(ch)

    host = '127.0.0.1'
    port = 8080
    app.run(host=host, debug=True, threaded=True, port=port)
    logger.info(f'API stubs online: http://{host}:{port}')

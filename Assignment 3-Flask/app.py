from database import get_db, query_db, make_dicts, close_db, convert_dict, weighted_avg_calc
from flask import Flask, render_template,  request, g, current_app, flash, redirect, url_for
import sqlite3 as sql



app = Flask(__name__)
instructor = False
user = ''

db_check = {
    "Assignments": "SELECT s.description FROM Assignments s WHERE s.description='{}';", 
    "Syllabus":"SELECT s.topic FROM Syllabus s WHERE s.topic='{}';", 
    "Labs":"SELECT s.topic FROM Labs s WHERE s.topic='{}';", 
    "InstructorUsers":"SELECT s.username FROM InstructorUsers s WHERE s.username='{}';", 
    "StudentUsers":"SELECT s.username FROM StudentUsers s WHERE s.username='{}';",
    "Regrade":"SELECT s.id FROM Regrade s WHERE s.id='{}';"
    }

db_insert_vals = {
    "Assignments":"INSERT INTO Assignments VALUES(?,?,?,?,?,?);", 
    "Syllabus":"INSERT INTO Syllabus VALUES(?,?,?,?,?,?,?,?,?,?);", 
    "Labs":"INSERT INTO Labs VALUES(?,?,?,?,?,?);", 
    "InstructorUsers":"INSERT INTO InstructorUsers VALUES(?,?,?,?,?,?);", 
    "StudentUsers":"INSERT INTO StudentUsers VALUES(?,?,?,?,?,?);", 
    "AssignmentGrades":"(?,?,?,?)", 
    "Feedback":"(?,?,?,?,?,?,?)" ,
    "Regrade":"INSERT INTO Regrade VALUES(?,?,?,?)"
    }

db_update_commands = {
    "Assignments": "UPDATE Assignments SET pdf=?,tex=?,due_date=?,weight=?,description=? WHERE id=?",
    "Syllabus": "UPDATE Syllabus SET topic=?, wed_pre_lec=?, wed_pre_lec_labels=?, thurs_pre_lec=?, thurs_pre_lec_labels=?, wed_lec=?, wed_lec_labels=?, thurs_lec=?, thurs_lec_labels=? WHERE id=?",
    "Labs":"UPDATE Labs SET topic=?, handout=?, handout_label=?, solutions=?, solutions_label=? WHERE id=?"
}
db_key_index = {
    "Assignments":-1
}
'''
Page Rendering: 
The code below this (but above the backend) will handle the rendering of pages that students and teachers interact with. 
These pages will be connected to the backend where the backend does the SQL queries as well as adding new values etc.
'''
@app.route('/')
def hello():
    return render_template('index.html')

@app.route('/new_student_acct')
def create_student_page():
    return render_template('student_creation.html')

@app.route('/student_log_in_page')
def log_in_student():
    return render_template('student_log_in.html')

@app.route('/new_instructor_acct')
def create_instructor_page():
    return render_template('instructor_creation.html')

@app.route('/instructor_log_in')
def log_in_instructor():
    return render_template('instructor_log_in.html')

@app.route('/syllabus')
def syllabus():
    global instructor
    global user
    syllabus = query_db('SELECT * FROM Syllabus;')
    info = convert_dict(syllabus, 0)
    for key in info:
       for i in range(len(info[key][0])):
           info[key][0][i] = info[key][0][i].split(",")
    
    return render_template('syllabus.html', user=user, instructor=instructor, info=info)

@app.route('/labs')
def labs():
    global instructor
    global user
    syllabus = query_db('SELECT * FROM Labs;')
    info = convert_dict(syllabus, 0)
    for key in info:
       for i in range(len(info[key][0])):
           info[key][0][i] = info[key][0][i].split(",")
    
    return render_template('labs.html', user=user, instructor=instructor, info=info)

@app.route('/assignments')
def assignments():
    global instructor
    global user 
    assignments = query_db('SELECT * FROM Assignments;')
    info = convert_dict(assignments, 0)
    return render_template('assignments.html', user=user, instructor=instructor, info=info)

@app.route('/home')
def home():
    global instructor
    global user
    return render_template('home.html', user=user, instructor=instructor)

@app.route('/calendar')
def calendar():
    global instructor
    global user
    return render_template('calendar.html', user=user, instructor=instructor)

@app.route('/dashboard')
def admin():
    global instructor
    global user
    assignment_grades = query_db('SELECT * FROM AssignmentGrades;')
    info = convert_dict(assignment_grades, 1)
    assignments = query_db('SELECT * FROM Assignments;')
    assignments = convert_dict(assignments, 5)
    regrades = query_db('SELECT * FROM Regrade;')
    regrades = convert_dict(regrades, 0)

    total = weighted_avg_calc(assignment_grades)

    if not instructor:
        student_grades = query_db("SELECT * FROM AssignmentGrades a WHERE a.username=?",([user]))
        total = weighted_avg_calc(student_grades) if student_grades else {"No current Grade":"No current Grade"}
        info = {user : info[user]} if user in info else {"No current Grade":["No current Grade", "No current Grade"]}

    
    return render_template('dashboard.html', user=user, instructor=instructor, grade_info=info, assignments=assignments, regrades=regrades, total=total)

@app.route('/feedback')
def feedback():
    global instructor
    global user
    all_instructors = query_db('SELECT *FROM InstructorUsers')
    all_instructors = convert_dict(all_instructors,1)
    all_feedback = query_db('SELECT * FROM Feedback')
    all_feedback = convert_dict(all_feedback,1)
    if instructor and user and user in all_feedback:
        all_feedback = {user : all_feedback[user]}
    return render_template('feedback.html', user=user, instructor=instructor, all_instructors = all_instructors, all_feedback = all_feedback)


@app.route('/regrade')
def regrade():
    global instructor
    global user
    return render_template('regrade.html', user=user,  instructor=instructor)

@app.route('/edit_entry')
def edit_entry():
    global instructor
    global user
    global db_col_num
    entry = (request.args.get('edit'))
    db_name = entry[5:len(entry)-1]
    info = query_db("SELECT * FROM {} a WHERE a.id={};".format(db_name, int(entry[-1])))
    info = convert_dict(info, 0)
    
    return render_template('edit_form.html', info=info, type=db_name, id=int(entry[-1]), instructor=instructor, user=user)

@app.route('/logout')
def log_out():
    global user
    global instructor
    user = ''
    instructor = False
    return redirect('/')
    
'''
Back End:
Front end uses this for data processing
'''

@app.route('/verify_student_user')
def verify_student_user():
    global user
    username = request.args.get('username')
    password = request.args.get('password')

    if query_db("SELECT s.username FROM StudentUsers s WHERE s.username='{}';".format(username)):
        if query_db("SELECT s.password FROM StudentUsers s WHERE s.username='{}';".format(username))[0][0] == password:
            flash('Log In Sucessful')
            user = username
            return redirect(url_for('home'))
    flash('Invalid Credentials, please try again or create new account')
    return redirect('/student_log_in_page')

@app.route('/verify_instructor_user')
def verify_instructor_user():
    global user
    global instructor
    username = request.args.get('username')
    password = request.args.get('password')

    if query_db("SELECT s.username FROM InstructorUsers s WHERE s.username='{}';".format(username)):
        if query_db("SELECT s.password FROM InstructorUsers s WHERE s.username='{}';".format(username))[0][0] == password:
            flash('Log In Sucessful')
            user = username
            instructor = True 
            return redirect('/home')
    flash('Invalid Credentials, please try again or create new account')
    return redirect('/instructor_log_in')

@app.route('/add_item')
def create():
    global db_check 
    global db_key_index
    global db_insert_vals
    args = request.args 
    info = []
    for key in args:
        info.append(args[key])
    db_name = info.pop(0)
    
    item_id = query_db('SELECT MAX(s.id) FROM {} s;'.format(db_name))[0][0] + 1
    info = [item_id] + info[:-1]

    if not query_db(db_check[db_name].format(info[-1 if db_name in db_key_index else 1])):
        with sql.connect("assignment3.db") as con:
            cur = con.cursor()
            cur.execute(db_insert_vals[db_name], tuple(info))
        flash("Sucessfully added!")
        return redirect('/dashboard')
    flash("There is already an item with that description!")
    return redirect("/dashboard")


@app.route('/submit_edits')
def submit_edits():
    global db_update_commands
    db_name = request.args
    info = []
    for key in db_name:
        info.append(db_name[key])
    db_name = info.pop(0)
    item_id = info.pop(0)
    info.pop(-1)
    info.append(item_id)
    info = tuple(info)
    with sql.connect("assignment3.db") as con: 
        cur = con.cursor()
        cur.execute(db_update_commands[db_name[:-1]], info)
    return redirect("/home")

@app.route('/remove_entry')
def remove_item():
    global db_check 
    global db_key_index
    global db_insert_vals
    args = request.args.get("delete") 
    info = []
    db_name = args[7:-2]
    item_id = int(args[-1])
    with sql.connect("assignment3.db") as con: 
        cur = con.cursor()
        cur.execute("DELETE FROM {} WHERE id=(?);".format(db_name), (item_id,))
    return redirect("/home")

@app.route('/update_student_grade')
def update_student_grade():
    aid = request.args.get('aid')
    username = request.args.get('username')
    grade = request.args.get('grade')

    if query_db("SELECT s.username FROM StudentUsers s WHERE s.username='{}';".format(username)) and query_db('SELECT a.id FROM Assignments a WHERE a.id={};'.format(aid)):
        if not query_db("SELECT g.username, g.aid FROM AssignmentGrades g WHERE g.username='{}' AND g.aid={};".format(username, aid)):            
            weight = query_db("SELECT a.weight FROM Assignments a WHERE a.id='{}';".format(aid))[0][0]
            with sql.connect('assignment3.db') as con:
                cur = con.cursor()
                cur.execute('INSERT INTO assignmentGrades VALUES(?,?,?,?)', (aid, username, grade, weight))
            flash("Sucessfully updated Grade!")
            return redirect('/dashboard')
        with sql.connect('assignment3.db') as con: 
            cur = con.cursor()
            cur.execute("UPDATE assignmentGrades SET grade=? WHERE aid=? AND username=?", (grade, aid, username))
        flash("Grade changed!")
        return redirect('/dashboard')
    flash("User not registered!")
    return redirect('/dashboard')


@app.route('/add_to_feedback')
def addToFeedback():
    instructor = request.args.get('instructor')
    rating = request.args.get('rating')
    likeTeach = request.args.get('likeTeach')
    impTeach = request.args.get('impTeach')
    likeLab = request.args.get('likeLab')
    impLab = request.args.get('impLab')

    fid = query_db('SELECT MAX(f.id) FROM Feedback f;')[0][0] + 1

    with sql.connect("assignment3.db") as con:
            cur = con.cursor()
            cur.execute("Insert INTO Feedback VALUES (?,?,?,?,?,?,?);", (fid, instructor, rating, likeTeach, impTeach, likeLab, impLab))
    
    return redirect('/feedback')

'''
Database closing
'''
@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

if __name__ == "__main__":
    app.secret_key = 'VyC74LX3hb'
    app.run(debug=True)
from flask import Flask, render_template, redirect, url_for, jsonify,request, flash
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from werkzeug.security import generate_password_hash, check_password_hash
from sqlalchemy import text

# ---------------- App Setup ----------------
app = Flask(__name__)
app.secret_key = 'your_secret_key'

# ---------------- Database Setup ----------------
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@localhost/flask_login_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# ---------------- Flask-Login Setup ----------------
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

# ---------------- User Model ----------------
class User(UserMixin, db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(150), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)
    email = db.Column(db.String(255), nullable=True)
    program = db.Column(db.String(255), nullable=True)
    faculty = db.Column(db.String(255), nullable=True)
    learning_style = db.Column(db.String(255), nullable=True)
    work_preference = db.Column(db.String(255), nullable=True)
    career_goal = db.Column(db.String(255), nullable=True)
    industry = db.Column(db.String(255), nullable=True)
    gpa = db.Column(db.Float, nullable=True)
    credit_hours = db.Column(db.Integer, nullable=True)
    semester = db.Column(db.Integer, nullable=True)
    questionnaires = db.relationship('Questionnaire', backref='user', lazy=True)
class StudyPlan(db.Model):
    __tablename__ = 'study_plan'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    field_id = db.Column(db.Integer, nullable=False)  # reference to the field added
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())

    user = db.relationship('User', backref='study_plan')

# ---------------- Questionnaire Model ----------------
class Questionnaire(db.Model):
    __tablename__ = 'questionnaires'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    interests = db.Column(db.Text)
    tasks = db.Column(db.Text)
    confidence = db.Column(db.Integer)
    work_preference = db.Column(db.String(50))
    suggested_major = db.Column(db.String(100))
class Track(db.Model):
    __tablename__ = 'tracks'

    id = db.Column(db.Integer, primary_key=True)
    track_name = db.Column(db.String(255), unique=True, nullable=False)
    relevant_fields = db.Column(db.JSON)  # Stores relevant field names as a JSON list

    courses = db.relationship('Course', backref='track', lazy=True)
class RelevantFieldDetail(db.Model):
    __tablename__ = 'relevant_field_details'

    id = db.Column(db.BigInteger, primary_key=True, autoincrement=True)
    track_id = db.Column(db.BigInteger, db.ForeignKey('tracks.id'), nullable=False)
    field_name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text, nullable=False)
    difficulty = db.Column(db.Enum('Beginner', 'Intermediate', 'Advanced'), default='Beginner')
    category = db.Column(db.String(255))
    why_recommended = db.Column(db.Text)

    # Relationship to Track
    track = db.relationship("Track", backref=db.backref("field_details", lazy=True))

    def __repr__(self):
        return f"<RelevantFieldDetail {self.field_name} (Track ID: {self.track_id})>"

class Course(db.Model):
    __tablename__ = 'courses'

    id = db.Column(db.Integer, primary_key=True)
    course_name = db.Column(db.String(255), nullable=False)
    learning_outcome = db.Column(db.Text)
    track_id = db.Column(db.Integer, db.ForeignKey('tracks.id'), nullable=False)
# ---------------- Login Manager ----------------
@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

# ---------------- Routes ----------------
@app.route('/')
def home():
    return redirect(url_for('login'))

# -------- Register --------
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = generate_password_hash(request.form['password'])

        if User.query.filter_by(username=username).first():
            flash('Username already exists', 'danger')
            return redirect(url_for('register'))

        new_user = User(username=username, password=password)
        db.session.add(new_user)
        db.session.commit()
        flash('Registration successful! You can now log in.', 'success')
        return redirect(url_for('login'))

    return render_template('register.html')

# -------- Login --------
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        user = User.query.filter_by(username=username).first()
        if user and check_password_hash(user.password, password):
            login_user(user)
            return redirect(url_for('dashboard'))
        else:
            flash('Invalid credentials', 'danger')

    return render_template('login.html')

# -------- Dashboard --------
@app.route('/dashboard')
@login_required
def dashboard():
    student = {
        "name": current_user.username,
        "gpa": 3.78,
        "credit_hours": 92,
        "semester": 6
    }
    # Show latest suggestion if exists
    latest_q = Questionnaire.query.filter_by(user_id=current_user.id).order_by(Questionnaire.id.desc()).first()
    suggestion = latest_q.suggested_major if latest_q else None

    return render_template('dashboard.html', student=student, suggestion=suggestion)

# -------- Analyze & Save Questionnaire --------
@app.route('/analyze', methods=['POST'])
@login_required
def analyze():
    data = request.form.to_dict(flat=False)

    # Extract interests/tasks/etc.
    interests = data.get('interests', [])
    confidence = int(data.get('confidence_math', [3])[0])
    tasks = data.get('tasks', [])
    work_preference = data.get('work_preference', [''])[0]

    # Major suggestion logic
    suggested_major = "General Studies"
    if "Artificial Intelligence" in interests or "Data Analytics" in interests:
        suggested_major = "Data Analytics" if confidence >= 4 else "Information Technology"
    elif "Cybersecurity" in interests:
        suggested_major = "Cybersecurity"
    elif "Software Engineering" in interests or "Logical problem-solving" in tasks:
        suggested_major = "Software Engineering"
    elif "Business Analytics" in interests or "Analyzing data" in tasks:
        suggested_major = "Business Analytics"
    elif "Networking" in interests:
        suggested_major = "Network Engineering"
    elif "Creative design" in tasks:
        suggested_major = "Multimedia / UI-UX Design"
    elif work_preference == "Team-based":
        suggested_major = "Project Management / Information Systems"

    # Save questionnaire
    q = Questionnaire(
        user_id=current_user.id,
        interests=",".join(interests),
        tasks=",".join(tasks),
        confidence=confidence,
        work_preference=work_preference,
        suggested_major=suggested_major
    )
    db.session.add(q)
    db.session.commit()

    # Query the Track table for suggested subjects
    track = Track.query.filter(Track.relevant_fields.contains([suggested_major])).first()

    suggested_subjects = []
    why_recommand = ""
    track_name = suggested_major
    if track:
        track_name = track.track_name
        suggested_subjects = track.relevant_fields  # Or map to more detailed subject names if needed


    student = {
        "name": current_user.username,
        "gpa": 3.78,
        "credit_hours": 92,
        "semester": 6
    }

    return render_template(
        'dashboard.html',
        student=student,
        suggestion=track_name,
        suggested_subjects=suggested_subjects,
        why_recommand=why_recommand
    )

# -------- Elective Recommendations --------
@app.route('/electives')
@login_required
def electives():
    # Get the latest questionnaire for the current user
    latest_q = (
        Questionnaire.query
        .filter_by(user_id=current_user.id)
        .order_by(Questionnaire.id.desc())
        .first()
    )

    suggestion = latest_q.suggested_major if latest_q else None
    print("Latest questionnaire:", latest_q)
    print("Suggested major:", suggestion)

    track = None
    field_details = []

    if suggestion:
        # Fetch the Track object for the suggested major
        track = Track.query.filter_by(track_name=suggestion).first()

        if track:
            # Fetch all relevant field details linked to this track
            field_details = RelevantFieldDetail.query.filter_by(track_id=track.id).all()

    # Fetch the IDs of fields the user has already added to their study plan
    user_plan_ids = [entry.field_id for entry in StudyPlan.query.filter_by(user_id=current_user.id).all()]

    print("Track:", track)
    print("Field details:", field_details)
    print("User plan IDs:", user_plan_ids)
    user_plan_ids = [
        entry.field_id for entry in StudyPlan.query.filter_by(user_id=current_user.id).all()
    ]
    # ⬆⬆ THIS LIST HOLDS ALL FIELD IDs USER HAS ADDED ⬆⬆

    return render_template(
        'elective_recommendations.html',
        track=track,
        field_details=field_details,
        suggestion=suggestion,
        user_plan_ids=user_plan_ids   # <-- pass it to the template
    )
# -------- Input Preferences --------
@app.route('/preferences', methods=['GET', 'POST'])
@login_required
def preferences():
    student_data = {
        "gpa": "3.78",
        "credit_hours": "92",
        "semester": "6"
    }
    return render_template(
        "input_preferences.html",
        gpa=student_data["gpa"],
        credit_hours=student_data["credit_hours"],
        semester=student_data["semester"]
    )
   
@app.route("/save_preferences", methods=["POST"])
def save_preferences():
    # Get checkbox list (returns list)
    interests = request.form.getlist("interests")

    # Get dropdown
    career_aspiration = request.form.get("career_aspiration")

    # Debug print (or save to DB)
    print("Selected Interests:", interests)
    print("Career Aspiration:", career_aspiration)

    # Example: show success message
    flash("Preferences saved successfully!", "success")

    return redirect(url_for("dashboard"))


# -------- Academic Summary --------
@app.route('/summary')
@login_required
def summary():
    strengths = ["Programming", "DBMS", "Algorithms"]
    improve = ["Networking", "Discrete Math"]
    progress = 76
    return render_template('academic_summary.html', strengths=strengths, improve=improve, progress=progress)


# -------- Feedback --------
@app.route("/feedback")
def feedback():
    return render_template("feedback.html")


@app.route("/submit_feedback", methods=["POST"])
def submit_feedback():
    feedback_data = {
        "accuracy": request.form.get("Q1_ACCURACY"),
        "adjust_prefs": request.form.get("Q2_ADJUST_PREFS"),
        "explanation_satisfaction": request.form.get("Q3_EXPLANATION_SATISFACTION"),
        "comments": request.form.get("Q4_COMMENTS"),
        "timestamp": datetime.now().isoformat()
    }

    print("Feedback Received:", feedback_data)  # For debugging / DB storage

    flash("Thank you for your feedback!", "success")
    return redirect(url_for("feedback"))
# -------- Logout --------
@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash('You have been logged out.', 'info')
    return redirect(url_for('login'))

@app.route('/profile')
def profile():
    # Fetch student info (from current_user)
    student = {
        "name": current_user.username,
        "email": current_user.email,
        "program": current_user.program,
        "faculty": current_user.faculty,
        "learning_style": current_user.learning_style,
        "work_preference": current_user.work_preference,
        "career_goal": current_user.career_goal,
        "industry": current_user.industry,
        "gpa": current_user.gpa,
        "credit_hours": current_user.credit_hours,
        "semester": current_user.semester
    }

    # Fetch semester-wise GPA from student_gpa_trend
    gpa_trend = db.session.execute(
        text("SELECT semester, gpa FROM student_gpa_trend WHERE student_id = :sid ORDER BY id"),
        {"sid": current_user.id}
    ).mappings().all()  # <--- use mappings()

    # Convert result to a dictionary for easy template rendering
    gpa_dict = {row['semester']: row['gpa'] for row in gpa_trend}

    return render_template('profile.html', student=student, gpa_trend=gpa_dict)

@app.route('/edit_profile', methods=['GET', 'POST'])
@login_required
def edit_profile():
    student = User.query.get(current_user.id)
    print(student)
    if request.method == "POST":
        student.name = request.form.get("name")
        student.email = request.form.get("email")
        student.program = request.form.get("program")
        student.faculty = request.form.get("faculty")
        student.gpa = request.form.get("gpa")
        student.credit_hours = request.form.get("credit_hours")
        student.semester = request.form.get("semester")
        student.learning_style = request.form.get("learning_style")
        student.work_preference = request.form.get("work_preference")
        student.career_goal = request.form.get("career_goal")
        student.industry = request.form.get("industry")

        db.session.commit()
        flash("Profile updated successfully!", "success")
        return redirect(url_for("profile"))

    return render_template("editprofile.html", student=student)

# -------- Main --------

@app.route('/add_to_plan/<int:field_id>', methods=['POST'])
@login_required
def add_to_plan(field_id):
    exists = StudyPlan.query.filter_by(
        user_id=current_user.id,
        field_id=field_id
    ).first()

    if not exists:
        entry = StudyPlan(user_id=current_user.id, field_id=field_id)
        db.session.add(entry)
        db.session.commit()

    return ("OK", 200)


@app.route('/remove_from_plan/<int:field_id>', methods=['POST'])
@login_required
def remove_from_plan(field_id):
    entry = StudyPlan.query.filter_by(
        user_id=current_user.id,
        field_id=field_id
    ).first()

    if entry:
        db.session.delete(entry)
        db.session.commit()

    return ("OK", 200)

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)

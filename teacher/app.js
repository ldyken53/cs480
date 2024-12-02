const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const path = require('path');

const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Serve static files from the 'public' directory
app.use(express.static(path.join(__dirname, 'public')));

// Serve index.html on the root URL
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Serve index.html on the root URL
app.get('/teacher', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'teacher.html'));
});

// MySQL connection setup
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '353353',
    database: 'cs480_project'
});

db.connect((err) => {
    if (err) throw err;
    console.log('Connected to MySQL');
});

// Login user
app.post('/login', (req, res) => {
    const { t_uin, password } = req.body;

    const query = 'SELECT * FROM Teachers WHERE t_uin = ?';
    db.query(query, [t_uin], (err, results) => {
        if (err) throw err;

        if (results.length === 0) {
            return res.status(400).send('User not found');
        }

        const user = results[0];

        // Check if password matches
        if (password == user.password) {
            res.json({ message: 'Login successful!', redirect: `/teacher?t_uin=${t_uin}`});
        } else {
            res.status(400).send('Incorrect password');
        }
    });
});

// API to query the MySQL database
app.post('/query', (req, res) => {
    const { t_uin, query_params } = req.body;

    const query = `
        SELECT Courses.name as course_name, crn, s_uin, Students.name as student_name, grade, semester, ClassListings.year
        FROM Enrollments
        JOIN ClassListings USING (crn)
        JOIN Courses USING (course_number)
        JOIN Teachers USING (t_uin)
        JOIN Students USING (s_uin)
        WHERE t_uin = "${t_uin}"
        ${query_params ? `AND ${query_params}` : ""}
        ;
    `;
    console.log(query);
    
    db.query(query, (err, results) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      res.json(results);
    });
});

// Update grade for a student's enrollment
app.post('/update-grade', (req, res) => {
    const { s_uin, crn, grade } = req.body;

    if (!s_uin || !crn || !grade) {
        return res.status(400).send('Missing required fields');
    }

    const query = `
        UPDATE enrollments
        SET grade = ?
        WHERE s_uin = ? AND crn = ?;
    `;

    db.query(query, [grade, s_uin, crn], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).send('Error updating grade');
        }

        if (results.affectedRows === 0) {
            return res.status(404).send('Enrollment not found');
        }

        res.json({ message: 'Grade updated successfully' });
    });
});


// Start the server
app.listen(3000, () => {
    console.log('Server is running on http://localhost:3000');
});

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
app.get('/student', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'student.html'));
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
    const { s_uin, password } = req.body;

    const query = 'SELECT * FROM Students WHERE s_uin = ?';
    db.query(query, [s_uin], (err, results) => {
        if (err) throw err;

        if (results.length === 0) {
            return res.status(400).send('User not found');
        }

        const user = results[0];

        // Check if password matches
        if (password == user.password) {
            res.json({ message: 'Login successful!', redirect: '/student' });
        } else {
            res.status(400).send('Incorrect password');
        }
    });
});

// API to query the MySQL database
app.post('/query', (req, res) => {
    const { query } = req.body;
    
    db.query(query, (err, results) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      res.json(results);
    });
});

// Start the server
app.listen(3000, () => {
    console.log('Server is running on http://localhost:3000');
});

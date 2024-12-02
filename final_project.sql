DROP DATABASE IF EXISTS cs480_project;
CREATE DATABASE cs480_project;
USE cs480_project;
CREATE TABLE Students (
    s_uin INT PRIMARY KEY,
    name VARCHAR(128),
    email VARCHAR(128),
    password VARCHAR(128),
    major VARCHAR(32),
    year INT
);

CREATE TABLE Courses (
    course_number INT NOT NULL PRIMARY KEY,
    name VARCHAR(32),
    subject VARCHAR(32)
);

CREATE TABLE Teachers (
    t_uin INT NOT NULL PRIMARY KEY,
    name VARCHAR(128),
    email VARCHAR(128),
    password VARCHAR(128),
    department VARCHAR(128),
    start_date DATE
);


CREATE TABLE ClassListings (
    crn INT NOT NULL PRIMARY KEY,
    semester VARCHAR(8) CHECK (semester IN ('Fall', 'Spring', 'Summer', 'Winter')),
    year INT,
    course_number INT NOT NULL,
    t_uin INT NOT NULL,
    FOREIGN KEY (t_uin) REFERENCES Teachers(t_uin) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_number) REFERENCES Courses(course_number) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Enrollments(
    crn INT NOT NULL,
    s_uin INT NOT NULL,
    grade INT,
    PRIMARY KEY (crn, s_uin),
    FOREIGN KEY (s_uin) REFERENCES Students(s_uin) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (crn) REFERENCES ClassListings(crn) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Insert more students
INSERT INTO Students (s_uin, name, email, password, major, year) VALUES
(334455667, 'Oliver James', 'oliver.james@example.com', 'oliverpass123', 'Computer Science', 2),
(445566778, 'Penny Williams', 'penny.williams@example.com', 'pennysecurepass', 'Electrical Engineering', 1),
(556677889, 'Quinn Harris', 'quinn.harris@example.com', 'quinn123pass', 'Mechanical Engineering', 4),
(667788990, 'Rachel Turner', 'rachel.turner@example.com', 'rachelpass456', 'Biotechnology', 3),
(778899001, 'Sophie Green', 'sophie.green@example.com', 'sophie789pass', 'Computer Science', 3),
(889900112, 'Thomas Lee', 'thomas.lee@example.com', 'thomaspassword', 'Electrical Engineering', 2);

-- Insert more courses
INSERT INTO Courses (course_number, name, subject) VALUES
(114, 'Database Management Systems', 'Computer Science'),
(115, 'Power Systems', 'Electrical Engineering'),
(116, 'Kinematics', 'Mechanical Engineering'),
(117, 'Bioinformatics', 'Biotechnology'),
(118, 'Artificial Intelligence', 'Computer Science'),
(119, 'Electromagnetic Fields', 'Electrical Engineering');

-- Insert more teachers (no "Dr.")
INSERT INTO Teachers (t_uin, name, email, password, department, start_date) VALUES
(707070707, 'William Harris', 'william.harris@university.com', 'williampass321', 'Computer Science', '2020-02-20'),
(808080808, 'James King', 'emma.taylor@university.com', 'emma1234', 'Electrical Engineering', '2015-07-17'),
(909090909, 'Lucas Carter', 'lucas.carter@university.com', 'lucaspass789', 'Mechanical Engineering', '2013-11-25'),
(101010101, 'Olivia Brooks', 'olivia.brooks@university.com', 'olivia321pass', 'Biotechnology', '2016-06-10');

-- Insert more class listings with varied semesters
INSERT INTO ClassListings (crn, semester, year, course_number, t_uin) VALUES
(1014, 'Winter', 2024, 114, 707070707),
(1015, 'Summer', 2024, 115, 808080808),
(1016, 'Fall', 2024, 116, 909090909),
(1017, 'Spring', 2024, 117, 101010101),
(1018, 'Winter', 2024, 118, 707070707),
(1019, 'Summer', 2024, 119, 808080808);

-- Insert more enrollments (with INT grades)
INSERT INTO Enrollments (crn, s_uin, grade) VALUES
(1014, 334455667, 82),
(1015, 445566778, 91),
(1016, 556677889, 76),
(1017, 667788990, 95),
(1018, 778899001, 88),
(1019, 889900112, 90),
(1014, 778899001, 85),
(1015, 334455667, 79),
(1016, 889900112, 93),
(1017, 445566778, 87),
(1018, 556677889, 91),
(1019, 667788990, 83);


CREATE INDEX idx_enrollments_crn ON Enrollments(crn);
CREATE INDEX idx_s_uin ON Enrollments(s_uin);
CREATE INDEX idx_grade ON Enrollments(grade);


-------------------------- STUDENT USE CASES -----------------------

-- Filter enrollments information based on subject
SELECT en.crn, cl.semester, cl.year, cr.subject, tc.name as teacher_name, en.grade
FROM Enrollments en
JOIN ClassListings cl ON en.crn = cl.crn
JOIN Courses cr ON cl.course_number = cr.course_number
JOIN Teachers tc ON tc.t_uin = cl.t_uin
WHERE en.s_uin = "112233445" AND cr.subject = "Computer Science";

-- Filter enrollments information based on teacher's initial name
SELECT en.crn, cl.semester, cl.year, cr.subject, tc.name as teacher_name, en.grade
FROM Enrollments en
JOIN ClassListings cl ON en.crn = cl.crn
JOIN Courses cr ON cl.course_number = cr.course_number
JOIN Teachers tc ON tc.t_uin = cl.t_uin
WHERE en.s_uin = "112233445" AND tc.name LIKE 'J%';


-- Filter enrollments information based on grade
SELECT en.crn, cl.semester, cl.year, cr.subject, tc.name as teacher_name, en.grade
FROM Enrollments en
JOIN ClassListings cl ON en.crn = cl.crn
JOIN Courses cr ON cl.course_number = cr.course_number
JOIN Teachers tc ON tc.t_uin = cl.t_uin
WHERE en.s_uin = "112233445" AND grade >= 90;

-- Filter enrollments information based on semester
SELECT en.crn, cl.semester, cl.year, cr.subject, tc.name as teacher_name, en.grade
FROM Enrollments en
JOIN ClassListings cl ON en.crn = cl.crn
JOIN Courses cr ON cl.course_number = cr.course_number
JOIN Teachers tc ON tc.t_uin = cl.t_uin
WHERE en.s_uin = "112233445" AND cl.semester = "Fall";

-- Filter enrollments information of 2 semesters
SELECT en.crn, cl.semester, cl.year, cr.subject, tc.name as teacher_name, en.grade
FROM Enrollments en
JOIN ClassListings cl ON en.crn = cl.crn
JOIN Courses cr ON cl.course_number = cr.course_number
JOIN Teachers tc ON tc.t_uin = cl.t_uin
WHERE cl.semester = "Fall" OR cl.semester = "Spring";

-- Delete enrollment
DELETE FROM Enrollments en
WHERE en.s_uin = "112233445" AND en.crn = "1003"

-------------------------- TEACHER USE CASES -----------------------
-- Teacher: Update student's grade
UPDATE Enrollments en
SET grade = 80
WHERE en.s_uin = "112233445" and en.crn = "1003"


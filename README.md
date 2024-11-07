## Overview

The goal is to build a student grade portal application. There will be two roles for the application: students and teachers. Teachers can manage listings of classes they teach, view present and past student enrollments in their listings, and assign and review enrolled students’ grades for classes they teach currently. Students can manage (drop and add) their own enrollments in upcoming class listings, along with.view their enrollments and grades for past and present class listings.

## Data Requirements

### Teachers

* For each teacher we record their name, their UIN, their email, their password, and their department. Teachers are identified by their UIN. A teacher can teach any number of classes, and we also record all of these, along with what semester and year they taught (see below). 

### Students

* For each student we record their name, their UIN, their email, their password, and their major. Students are identified by their UIN. A student can be enrolled in any number of classes, and we also record all of these, along with the student’s grade, the semester and year they were enrolled, and the teacher they had (see below).

### Classes

The database should record information about classes that exist in the course catalog. For each class, we record its course number, name, and subject. Each class may be taught by any number of teachers, and each teacher may teach any number of classes. For each listing of a class by a given teacher, we need to record the semester and year that that listing occurred, the course number of the class, the teacher's UIN, and a unique CRN for that listing. Each class listing may be taken by any number of students, and each student may be enrolled in any number of class listings. For each enrollment, we need to record the CRN of the class listing the student was enrolled in, along with the student’s grade.

## Application Requirements

The application should support the following actions for teachers and students. Both teachers and students have to log into the system with their UIN and a password that is chosen for them when they log in.

### Teachers

#### Managing Class Listings

Teachers can register and unregister upcoming class listings:

* insert new listings of classes that will be taught by them in an upcoming semester  
* delete listings of classes they were going to teach in an upcoming semester

Teachers can also review their listings history:

* view all listings of classes they are teaching or taught previously

Teachers can have any number of class listings, including 0\. 

#### Grading and Viewing Student Enrollments

Teachers can view student enrollments in their listings and change current students’ grades:

* view all student enrollments in class listings they are teaching or taught previously  
* update the grades for student enrollments in ongoing class listings

### Students

#### Enrollment and Grade Viewing

Students should be able to view all of their past and present enrollments with their grades. A student should be able to search for any of their enrollments based on any of their attributes. Search should support comparisons based on equality (i.e. subject \= “CS”), inequalities (i.e. grade \> 85), and string comparisons with contains and placeholders (i.e. teacher LIKE “K%”), and should allow for combining conditions with "OR" and "AND". The interface should also support sorting the results by any attribute and limiting to any number of results.

#### Managing Present Enrollments

Students should be able to register and unregister themselves from upcoming class listings:

* insert new enrollments for themselves for classes in an upcoming semester  
* delete enrollments for themselves for classes in an upcoming semester

Students can have any number of enrollments, including 0\. 

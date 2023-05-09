# 1. How many students are enrolled in each course?

SELECT courses.name, count(student_id) as Number_Of_Students
from grades
JOIN courses 
On courses.course_id = grades.course_id
GROUP BY courses.name
ORDER BY Number_Of_Students DESC

# 2. What is the name of each course being offered, and who is teaching it?

SELECT courses.name as Course_name, teachers.name as Professor_name
FROM courses
JOIN offering 
ON courses.course_id = offering.course_id
JOIN teachers
ON teachers.teacher_id = offering.teacher_id
ORDER BY Course_name ASC


# 3. How many courses does each teacher offer?

SELECT teachers.name, count(offering.course_id) as Nb_courses_teached
from courses
JOIN offering 
ON courses.course_id = offering.course_id
JOIN teachers
ON teachers.teacher_id = offering.teacher_id
GROUP BY teachers.name

 
# 4. What percentage of courses can a teacher teach ?

SELECT teachers.name, count(courses.course_id) as Nb_courses_teached, 
(SELECT COUNT(courses.course_id) from courses) as Total_courses,
ROUND((SELECT count(courses.course_id)/(SELECT COUNT(courses.course_id) from courses) * 100 ),2) as Percentage_of_available_courses_teached
from courses
JOIN offering
ON courses.course_id = offering.course_id
JOIN teachers
ON teachers.teacher_id = offering.teacher_id
GROUP BY teachers.name
ORDER bY Percentage_of_available_courses_teached DESC

	#Professor Wilson and Professor Moore would actually be able to cover for the absence of most of their colleagues since they can teach 60% of the courses 

# 5. What is the name and major of each student enrolled in Economics I ?
	# I need to know the course id associated with Economics I

SELECT DISTINCT(name), course_id
FROM courses
	# It is 21. I will now join students with grades and filter on students enrolled a course whose id is 21 : Economics I

SELECT student.name, student.major
from student
JOIN grades 
on grades.student_id = student.student_id
WHERE course_id = 21


#6. Which students are enrolled in at least one course taught by a teacher with 'Smith' in their name?

SELECT student.name, teachers.name
from student
JOIN grades
ON grades.student_id = student.student_id
JOIN offering 
ON grades.course_id =offering.course_id
JOIN teachers
ON teachers.teacher_id = offering.teacher_id
WHERE teachers.name LIKE '%Smith'


#7. Which courses are being offered in the 'Science' building?

SELECT courses.name AS Courses_taught_in_SB
FROM classroom
JOIN offering on classroom.classroom_id = offering.classroom_id
JOIn courses ON courses.course_id = offering.course_id
WHERE classroom.building = "Science Building"
ORDER BY courses.name ASC

#8. For each student, retrieve the student's name, major, and the number of courses they are enrolled in.

SELECT s.name, s.major, count(g.course_id) as nb_of_courses_enrolled
FROM student s
JOIN grades g On g.student_id = s.student_id
GROUP by s.name
ORDER BY nb_of_courses_enrolled DESC

#9. Which courses have the most failing students ? (grade under 50)

SELECT c.name, COUNT(g.grade) as Nb_of_grades_under_50
FROM grades g
JOIN courses c on g.course_id = c.course_id
WHERE g.grade < 50
group by c.name
ORDER BY Nb_of_grades_under_50 DESC
	#The harder course seems to be Politics I 
    
#10. Among all the students who have chosen Politics I, how many succeeded ?

	#Students who have chosen Politics I

SELECT  
ROUND((SELECT COUNT(g.grade) as nb_succes
from courses c
JOIn grades g ON c.course_id = g.course_id
JOIN student s On s.student_id = g.student_id
WHERE c.name = "Politics I" and g.grade > 50)

 /
		
 (SELECT COUNT(g.grade) as nb_total
  from courses c
  JOIn grades g ON c.course_id = g.course_id
  JOIN student s On s.student_id = g.student_id
  WHERE c.name = "Politics I") * 100 , 2) as percentage_succeding_students

	#Although Politics I is the harder course, it seems that 88% percent of students who try the course pass it.
    
#11. Which courses have the most failing students in the last semester of 2021? (grade under 50)

SELECT c.name, COUNT(g.grade) as Nb_of_grades_under_50
FROM grades g
JOIN courses c on g.course_id = c.course_id
WHERE (g.grade < 50) and (date BETWEEN "2021-09-01" and "2021-12-01")
group by c.name
ORDER BY Nb_of_grades_under_50 DESC


--5.1. Show Students of class ID = "C02"	
SELECT *
FROM Student
WHERE ClassID='C02'

--5.2. Show Students of class name = "Computer Science".
SELECT *
FROM Student s
JOIN Class c ON (s.ClassID=c.ClassID)
WHERE c.ClassName='Computer Science'

--5.3. Show Students (All information) of class year = "2020-2024".
SELECT *
FROM Student s
JOIN Class c ON (s.ClassID=c.ClassID)
WHERE c.ClassYear='2020-2024'

--5.4. Show Subject name and units of the Subject ID = “S01”.
SELECT SubjectName,Units
FROM Subject
WHERE SubjectID='S01'

--5.5. Grades of Subject ID = "S02" of Student ID = "T02".
SELECT *
FROM StudentGrades
WHERE SubjectID='S02' AND StudentID='T02'

--5.6. Find Subject (ID, Name and Grades) that Student ID = "T02" fail.
SELECT sg.SubjectID,s.SubjectName,sg.Grades
FROM StudentGrades sg
JOIN Subject s ON (sg.SubjectID=s.SubjectID)
WHERE sg.Grades<5 AND sg.StudentID='T02'

--5.7. Show all the Subject (*) that Student ID = "T03" never took the exam.
SELECT DISTINCT *
FROM Subject 
WHERE SubjectID NOT IN
(
	SELECT SubjectID
	FROM StudentGrades
	WHERE StudentID='T02'
)

--5.8. Number of Students for each class.
SELECT ClassID,COUNT(StudentID) AS 'Number of students'
FROM Student
GROUP BY ClassID

--5.9.1. Find the classes with the largest number of students.
SELECT *
FROM (
	SELECT ClassID,COUNT(StudentID),dense_rank() over (order by COUNT(StudentID) desc) as ss
	FROM Student
	GROUP BY ClassID)
WHERE ss=1
--5.9.2. Find the classes with the largest number of students.
SELECT ClassID, COUNT(*) AS SS
FROM Student
GROUP BY ClassID
HAVING SS=(SELECT MAX(SS)
			FROM (SELECT COUNT(*) AS SS
					FROM Student
					GROUP BY ClassID)
			)

--5.10. GPA (grade point average) of student ID = "T02".
SELECT StudentID, AVG(Grades)
FROM StudentGrades
WHERE StudentID='T02'
GROUP BY StudentID

--5.11. GPA for each student.
SELECT StudentID, AVG(Grades)
FROM StudentGrades
GROUP BY StudentID

--5.12. GPA of class ID = "C02".
SELECT ClassID,AVG(Grades)
FROM StudentGrades sg
JOIN Student s ON (sg.StudentID=s.StudentID)
WHERE ClassID='C02'
Group BY ClassID

--5.13. GPA for each class.
SELECT ClassID,AVG(Grades)
FROM StudentGrades sg
JOIN Student s ON (sg.StudentID=s.StudentID)
Group BY ClassID

--5.14.1. Find students have the largest GPA.
SELECT *
FROM (
	SELECT StudentID,avgrades,dense_rank() over (order by avgrades desc) as sp
	FROM (SELECT StudentID, AVG(Grades) as avgrades
			FROM StudentGrades
			GROUP BY StudentID)
	)
WHERE sp=1
--5.14.2. Find students have the largest GPA.
SELECT StudentID, AVG(Grades) as SP
FROM StudentGrades
GROUP BY StudentID
HAVING SP=(SELECT MAX(SS) as SP
			FROM (SELECT AVG(Grades) AS SS
					FROM StudentGrades
					GROUP BY StudentID)
			)
			
--5.15. Find students (ID and Name) have the largest GPA.
SELECT sg.StudentID,s.StudentName, AVG(sg.Grades) as SP
FROM StudentGrades sg
JOIN Student s ON (sg.StudentID=s.StudentID)
GROUP BY sg.StudentID
HAVING SP=(SELECT MAX(SS) as SP
			FROM (SELECT AVG(Grades) AS SS
					FROM StudentGrades
					GROUP BY StudentID)
			)
--5.16. Find classes (ID and Name) have the largest GPA.
SELECT s.ClassID,c.ClassName, AVG(sg.Grades) as SP
FROM Student s
JOIN StudentGrades sg ON (sg.StudentID=s.StudentID)
JOIN Class c ON (s.ClassID=c.ClassID)
GROUP BY s.ClassID
HAVING SP=(SELECT MAX(SS) as SP
			FROM (SELECT AVG(Grades) AS SS
					FROM StudentGrades sg
					JOIN Student s ON (sg.StudentID=s.StudentID)
					GROUP BY ClassID)
			)

--5.17. GPA with weight for each student.
SELECT sg.StudentID,sd.StudentName,SUM(sg.Grades*sj.Units)/SUM(Units) as 'GPA with weight'
FROM StudentGrades sg
JOIN Student sd ON(sg.StudentID=sd.StudentID)
JOIN Subject sj ON(sg.SubjectID=sj.SubjectID)
GROUP BY sg.StudentID

--5.18. GPA with weight for each student (ID and name).
SELECT sg.StudentID,sd.StudentName,SUM(sg.Grades*sj.Units)/SUM(Units) as 'GPA with weight'
FROM StudentGrades sg
JOIN Student sd ON(sg.StudentID=sd.StudentID)
JOIN Subject sj ON(sg.SubjectID=sj.SubjectID)
GROUP BY sg.StudentID

--5.19. GPA with weight for each class.
SELECT sd.ClassID,SUM(sg.Grades*sj.Units)/SUM(Units) as 'GPA with weight'
FROM StudentGrades sg
JOIN Student sd ON(sg.StudentID=sd.StudentID)
JOIN Subject sj ON(sg.SubjectID=sj.SubjectID)
GROUP BY sd.ClassID



/*
Loo andmebaas nimega „edu“ ja järgnevad
tabelid oma andmebaasi*/

CREATE TABLE Institutes(
Id INTEGER NOT NULL DEFAULT
AUTOINCREMENT PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
Address VARCHAR(30),
DeanId INTEGER,
ViceDeanId INTEGER,
UNIQUE(Name));

CREATE TABLE Persons(
Id INTEGER NOT NULL DEFAULT
AUTOINCREMENT PRIMARY KEY,
FirstName VARCHAR(30) NOT NULL,
LastName VARCHAR(30) NOT NULL,
InstituteId INTEGER NOT NULL,
SSN VARCHAR(11),
UNIQUE(FirstName,LastName));

CREATE TABLE Registrations(
Id INTEGER NOT NULL DEFAULT
AUTOINCREMENT PRIMARY KEY,
CourseId INTEGER NOT NULL,
PersonId INTEGER NOT NULL,
FinalGrade VARCHAR(1));

CREATE TABLE Lecturers(
Id INTEGER NOT NULL DEFAULT
AUTOINCREMENT PRIMARY KEY,
CourseId INTEGER,
PersonId INTEGER NOT NULL,
Responsible SMALLINT);

CREATE TABLE Courses(
Id INTEGER NOT NULL DEFAULT
AUTOINCREMENT PRIMARY KEY,
InstituteId INTEGER NOT NULL,
Name VARCHAR(50) NOT NULL,
Code VARCHAR(20),
EAP INTEGER,
GradeType VARCHAR(8));

/*failist andmete lisamine baasi*/

INPUT INTO Courses FROM 'Users/roosalu/Documents/OneDrive/KOOL/ANDMEBAASID/edu/course.txt' FORMAT
ASCII DELIMITED BY '\x09';

INPUT INTO Lecturers FROM 'Users/roosalu/Documents/OneDrive/KOOL/ANDMEBAASID/edu/lecturers.txt' FORMAT
ASCII DELIMITED BY '\x09';

INPUT INTO Persons FROM 'Users/roosalu/Documents/OneDrive/KOOL/ANDMEBAASID/edu/person.txt' FORMAT
ASCII DELIMITED BY '\x09';

INPUT INTO Registrations FROM 'Users/roosalu/Documents/OneDrive/KOOL/ANDMEBAASID/edu/registrations.txt' FORMAT
ASCII DELIMITED BY '\x09';

INPUT INTO Institutes FROM 'Users/roosalu/Documents/OneDrive/KOOL/ANDMEBAASID/edu/faculty.txt' FORMAT
ASCII DELIMITED BY '\x09';

/*Person tabeli kirje kustutamisel kustutatakse tema registreeringud
ainetele*/

ALTER TABLE Registrations ADD CONSTRAINT
fk_registration_person FOREIGN KEY (PersonId)
REFERENCES Persons (Id) ON DELETE
CASCADE ON UPDATE CASCADE; 

/*Dekaani kirje kustutamisel ei kustutata tema teaduskonda */

ALTER TABLE Institutes ADD CONSTRAINT
fk_institute_person_dean FOREIGN KEY (DeanId)
REFERENCES Persons (Id) ON DELETE
SET NULL ON UPDATE CASCADE;

/*Luua lisaks näidetele kuus välisvõtit nii, et
ülemtabeli kirje kustutamisel kustutatakse ka
alamtabeli vastavad kirjed, va kahel
erandjuhul, kui seos tühistatakse:*/

ALTER TABLE Registrations ADD CONSTRAINT
fk_registration_course FOREIGN KEY (CourseId)
REFERENCES Courses (Id) ON DELETE
CASCADE ON UPDATE CASCADE;

ALTER TABLE Lecturers ADD CONSTRAINT
fk_lecturer_person FOREIGN KEY (CourseId)
REFERENCES Courses (Id) ON DELETE
SET NULL ON UPDATE CASCADE;
                  
ALTER TABLE Lecturers ADD CONSTRAINT
fk_lecturer_course FOREIGN KEY (CourseId)
REFERENCES Courses (Id) ON DELETE 
SET NULL ON UPDATE CASCADE
                  
ALTER TABLE Courses ADD CONSTRAINT
fk_course_institute FOREIGN KEY (InstituteId)
REFERENCES Institutes (Id) ON DELETE
CASCADE ON UPDATE CASCADE;
                  
ALTER TABLE Institutes ADD CONSTRAINT
fk_institute_person_vice_dean FOREIGN KEY (ViceDeanId)
REFERENCES Persons (Id) ON DELETE 
SET NULL ON UPDATE CASCADE;
                  
ALTER TABLE Persons ADD CONSTRAINT
fk_person_institute FOREIGN KEY (InstituteId)
REFERENCES Institutes (Id) ON DELETE
CASCADE ON UPDATE CASCADE;
                  
/*vaadete loomine*/
CREATE VIEW v_oigusteaduskonna_inimesed AS
SELECT * FROM persons WHERE InstituteId = 2
                  
CREATE VIEW v_oigusteaduskonna_inimesed_mini
(eesnimi,perenimi) AS
SELECT FirstName, LastName
FROM persons WHERE InstituteId = 2
                  
CREATE VIEW v_persons_institute AS
SELECT p.FirstName, p.LastName, i.Name as InstituteName,
i.Address as InstituteAddress
FROM persons as p JOIN Institutes as i ON (p. InstituteId = i.id)
                  
CREATE VIEW v_Institute_deans (InstituteName,
DeanName, ViceDeanName) AS
SELECT i.Name, d.FirstName+' '+d.LastName as
deanName, v.FirstName+' '+v.LastName as
ViceDeanName
FROM Institutes as i
JOIN Persons as d ON (i.deanId = d.id)
JOIN Persons as v ON (i.viceDeanId = v.id)
ORDER BY i.Name;
                  
/*Lisame uue kursuse "Sissejuhatus informaatikasse"*/
                  
INSERT INTO Courses VALUES (101,9,'Sissejuhatus
informaatikasse','MTAT.05.074',3,'Arvestus')
                  
/*Lisame kursusele samad inimesed kes osalevad kursusel
Sissejuhatus ettevõtte majandusse*/
                  
insert into Registrations (CourseId, PersonId, FinalGrade)
select 101, p.id, NULL from Courses as c
join Registrations as r on c.id = r.courseid
join Persons as p on r.PersonId = p.id
where c.name = 'Sissejuhatus ettevõttemajandusse';
                  
/*Kuvame mõlemal kursusel õppivad õpilased*/
                  
SELECT p.FirstName+' '+p.LastName as
PersonName, c.Name as CourseName
FROM Courses as c
JOIN Registrations as r ON (r.CourseId = c.Id)
JOIN Persons as p ON (r.PersonId = p.Id)
WHERE c.Id = 101 OR c.Id = 75
ORDER BY PersonName
                  
/*Luua vaade v_persons_atleast_4eap (FirstName,
LastName) õpilastest, kes õpivad Matemaatikainformaatikateaduskonna ainetel, mis annavad
vähemalt 4 EAP-d*/

CREATE VIEW v_persons_atleast_4eap (FirstName, LastName) AS
SELECT DISTINCT FirstName, LastName from Persons, Courses, Institutes, Registrations 
WHERE Persons.InstituteId = Institutes.id
AND Registrations.courseid = Courses.id
AND PersonId = Persons.id
AND Courses.InstituteId = Institutes.id 
AND Institutes.name = 'Matemaatika-informaatikateaduskond'
AND Courses.eap > 3;

/*KONTROLL: Päring õpilased, kes õpivad Matemaatikainformaatikateaduskonna ainetel, mis annavad vähemalt 4 EAP-d*/
                  
SELECT * FROM v_persons_atleast_4eap
                  
/*Luua vaade v_mostA(FirstName, LastName, NrOfA)
õpilastest, kes on saanud A-sid (eristuv hindamine)
Matemaatika-informaatikateaduskonna ainetest.*/

CREATE VIEW v_mostA(FirstName, LastName, NrOfA) AS
SELECT DISTINCT FirstName, LastName, count(*) as NrOfA
from Persons join Institutes on Persons.InstituteId = Institutes.id
JOIN Courses on Courses.InstituteId = Institutes.id
JOIN Registrations on Registrations.CourseId = Courses.id
WHERE finalGrade = 'A'
AND Registrations.PersonId = Persons.id
AND Institutes.Name = 'Matemaatika-informaatikateaduskond'
AND Courses.GradeType = 'Eksam'
GROUP BY FirstName, LastName;
                  
/*Luua uus kursus "Andmebaaside teooria".
Matemaatika-informaatikateaduskond,
MTAT.03.998, 6EAP, Arvestus
Lisada sinna kõik õpilased, kes said aines
Andmebaasid arvestuse (A).*/
                  
INSERT INTO Courses (InstituteId, Name, Code, EAP, GradeType)
VALUES (9, 'Andmebaaside teooria', 'MTAT.03.998', 6, 'Arvestus');
                  
INSERT INTO registrations (CourseId, PersonId, FinalGrade)
SELECT 105, persons.id, NULL 
FROM courses JOIN registrations ON courses.id=registrations.courseId
JOIN persons ON registrations.personId=persons.id
WHERE courses.name='Andmebaasid' AND registrations.finalGrade='A';
                  
/*Luua vaade v_andmebaasideTeooria õpilastest,
kes õpivad ainet andmebaaside teooria.
(PersonId, FirstName, LastName).
                  
                  
NB! EI OLE KINDEL, ET SEE ÕIGE ON*/

CREATE VIEW v_andmebaasideTeooria (PersonId, FirstName, LastName) AS
SELECT DISTINCT persons.id, FirstName, LastName 
FROM persons JOIN registrations ON persons.id=registrations.personId 
JOIN courses ON registrations.courseId=courses.id
WHERE courses.name = 'Andmebaaside teooria';

SELECT * FROM v_andmebaasideTeooria
                  
/*Luua vaade v_top40A (FirstName, LastName,
nrOfA) päringule TOP 40 õpilastest, kes on
saanud kõige rohkem A-sid (hinne või arvestus)
järjestamisel arvestada ka veergudega
LastName, FirstName).*/

CREATE VIEW v_top40A(FirstName, LastName, nrOfA) AS
SELECT TOP 40 FirstName, LastName, count(*) AS NrOfA FROM Persons
KEY JOIN Registrations
WHERE FinalGrade = 'A'
GROUP BY FirstName, LastName
ORDER BY NrOfA DESC;
                  
/*Luua vaade v_top30Students(FirstName,
LastName, AverageGrade) päringule TOP 30
õpilastest, kelle keskmine eksami hinne (on
kõige kõrgem (võrdse keskmise hinde korral
vaadata ka veerge LastName, FirstName).*/

CREATE VIEW v_top30Students (FirstName, LastName, AverageGrade) AS
SELECT TOP 30 FirstName, LastName, 
avg(CASE FinalGrade 
    WHEN 'A' THEN 5
    WHEN 'B' THEN 4
    WHEN 'C' THEN 3
    WHEN 'D' THEN 2
    WHEN 'E' THEN 1
END) AS AverageGrade FROM Persons
JOIN Registrations ON Persons.id = Registrations.PersonId
JOIN Courses ON Courses.id = Registrations.courseId
WHERE Courses.GradeType = 'Eksam'
GROUP BY FirstName, LastName
ORDER BY AverageGrade DESC, Firstname ASC, Lastname ASC;

SELECT * FROM v_top30Students

                  
                  
                  


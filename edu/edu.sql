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
                  
                  

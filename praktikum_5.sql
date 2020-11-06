/*
1. aLuua tabel Asulad (id integer, nimi varchar(100))
ID on primaarvõti, automaatselt tuleneva väärtusega
Nimi on unikaalne
Mõlemad väljad on kohustuslikud.
*/

CREATE TABLE asulad (
    id integer not null,
    nimi varchar (100) UNIQUE,
    PRIMARY KEY (id)
);


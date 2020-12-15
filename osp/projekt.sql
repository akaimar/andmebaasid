/*Loon tabelid*/

CREATE TABLE Haldurid (
Id INTEGER NOT NULL DEFAULT
AUTOINCREMENT PRIMARY KEY,
Eesnimi VARCHAR(50) NOT NULL,
Perenimi VARCHAR(30) NOT NULL,
);

CREATE TABLE Kliendid (
Id INTEGER NOT NULL DEFAULT AUTOINCREMENT PRIMARY KEY,
Nimi VARCHAR(50),
Reg_nr INTEGER,
Limiidi_kinnituse_kp DATE,
Haldur INTEGER,
Kes_on_ema INTEGER,
);

CREATE TABLE Monitooringud (
Id INTEGER NOT NULL DEFAULT
AUTOINCREMENT PRIMARY KEY,
Tyyp integer NOT NULL,
Klient integer NOT NULL,
Teostaja integer NOT NULL,
Edasi_lykatud_kp DATE,
Eelmise_mon_kp DATE,
Jargmise_mon_kp DATE
);

CREATE TABLE Tyybid (
Id INTEGER NOT NULL DEFAULT
AUTOINCREMENT PRIMARY KEY,
nimetus VARCHAR(255) NOT NULL,
);

/*sisestan väärtused tabelisse haldurid */

INSERT INTO Haldurid (Eesnimi, Perenimi)
VALUES ('Maris', 'Häma');

INSERT INTO Haldurid (Eesnimi, Perenimi)
VALUES ('Aimar', 'Roos');

INSERT INTO Haldurid (Eesnimi, Perenimi)
VALUES ('Margit', 'Kiip');

INSERT INTO Haldurid (Eesnimi, Perenimi)
VALUES ('Marko', 'Pidu');

/*sisestan väärtused tabelisse Tyybid */

INSERT INTO Tyybid (nimetus)
VALUES ('lihtsustatud');

INSERT INTO Tyybid (nimetus)
VALUES ('detailne');

INSERT INTO Tyybid (nimetus)
VALUES ('probleemne');

/*sisestan väärtused tabelisse Kliendid*/
INSERT INTO Kliendid (Nimi, Reg_nr, Limiidi_kinnituse_kp, Haldur, Kes_on_ema)
VALUES ('Sepakoda OÜ', '582759', '2019-12-01', 1, 0);

INSERT INTO Kliendid (Nimi, Reg_nr, Limiidi_kinnituse_kp, Haldur, Kes_on_ema)
VALUES ('Trepikoda OÜ', '582999', '2018-10-13', 1, 0);

INSERT INTO Kliendid (Nimi, Reg_nr, Limiidi_kinnituse_kp, Haldur, Kes_on_ema)
VALUES ('Makaronivabrik OÜ', '597759', '2020-03-06', 1, 0);

INSERT INTO Kliendid (Nimi, Reg_nr, Limiidi_kinnituse_kp, Haldur, Kes_on_ema)
VALUES ('Vihamägi OÜ', '522759', '2020-04-15', 1, 0);

INSERT INTO Kliendid (Nimi, Reg_nr, Limiidi_kinnituse_kp, Haldur, Kes_on_ema)
VALUES ('Jahuveski OÜ', '142759', '2019-06-01', 1, 0);

INSERT INTO Kliendid (Nimi, Reg_nr, Limiidi_kinnituse_kp, Haldur, Kes_on_ema)
VALUES ('Mõttekoda OÜ', '944759', '2020-06-22', 1, 0);

INSERT INTO Kliendid (Nimi, Reg_nr, Limiidi_kinnituse_kp, Haldur, Kes_on_ema)
VALUES ('Kõlakoda OÜ', '581119', '2020-11-01', 1, 0);


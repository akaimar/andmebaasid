/*1. Luua tabel Asulad (id integer, nimi varchar(100))
ID on primaarvõti, automaatselt tuleneva väärtusega
Nimi on unikaalne
Mõlemad väljad on kohustuslikud
*/

CREATE TABLE Asulad (
id integer not null default autoincrement primary key,
nimi varchar(100) not null,
Unique (nimi)
)

/*2. Lisada uude tabelisse kõik asukohad tabelist Klubid ja toimumiskohad tabelist
Turniirid.
*/

insert into asulad (nimi)
select DISTINCT asukoht from klubid
union
select DISTINCT toimumiskoht from turniirid

/*3. Lisada tabelisse Klubid veerg Asula (integer).*/
alter table asulad
add asula integer

/*4.Väärtustada korraga kõigil Klubi kirjetel veerg Asula sobiliku ID’ga tabelist Asulad:
update klubid set asula = (select id from asulad where asulad.nimi = klubid.asukoht).*/

update klubid set Asula = (select id from asulad
where asulad.nimi = klubid.asukoht)

/*5. Lisada tabelile Klubid välisvõti tabelisse Asulad (fk_klubi_2_asula).
Kontrollida andmeid (võrrelda tekstiveerge):
select klubid.asukoht, asulad.nimi from klubid 
join asulad on klubid.asula = asulad.id.*/

ALTER TABLE klubid ADD CONSTRAINT fk_klubid_2_asula 
FOREIGN KEY (Asula) 
REFERENCES asulad(id) 
ON DELETE CASCADE ON UPDATE CASCADE;

/*6. Lisada tabelisse Turniirid veerg Asula (integer).*/

alter table turniirid
add Asula INTEGER

/*7. Väärtustada korraga kõigil Turniiri kirjetel 
veerg Asula sobiliku ID’ga tabelist Asulad.*/

update turniirid set Asula = (select id from asulad
where asulad.nimi = turniirid.toimumiskoht)







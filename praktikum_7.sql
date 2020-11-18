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

/*8.Lisada tabelile Turniirid välisvõti tabelisse Asulad (fk_turniir_2_asula)
Kontrollida andmeid (võrrelda tekstiveerge).*/

ALTER TABLE turniirid ADD CONSTRAINT fk_turniir_2_asula 
FOREIGN KEY (Asula) 
REFERENCES asulad(id) 
ON DELETE CASCADE ON UPDATE CASCADE;

/*9. Luua vaade v_asulaklubisid (asula_id, asula_nimi, klubisid), 
mis annaks asulate
klubide arvud e kui palju on igal asulal klubisid.*/

create view v_asulaklubisid (asula_id, asula_nimi, klubisid)
as select asula, asukoht, count(*)
from klubid group by asula, asukoht

/*10. Luua vaade v_asulasuurus (asula_id, asula_nimi, mangijaid), mis annaks
asulate mängijate arvud e kui palju on igal asulal mängijaid.
Kontrollküsimus: kas võib tekkida kirje, kus mangijaid = 0?
*/

create view v_asulasuurus (asula_id, asula_nimi, mangijaid)
as
select klubid.Asula, klubid.asukoht, count(*)
from isikud join klubid on isikud.klubi = klubid.id
group by klubid.Asula, klubid.asukoht

/*11. Lisada lihtne protseduur klubi 
kustutamiseks sp_kustuta_klubi(klubinimi).*/

CREATE PROCEDURE sp_kustuta_klubi(IN klubinimi VARCHAR (100))
BEGIN
DELETE FROM klubi
WHERE nimi=klubinimi;
END;

/*12. Luua triger, mis klubi lisamise järel lisaks
 asukoha tabelisse asulad, kui seda
seal pole, ning väärtustaks tabelis klubid asula välja vastava asula
ID’ga, tg_lisa_klubi.
*/

create trigger tg_lisa_klubi after insert, update on klubid
referencing new as uusklubi
for each row
when ((select COUNT(*) from asula where nimi = uusklubi.asukoht) = 0)
begin 
declare uusklubi_id integer;
insert into asulad(nimi) values (uusklubi.asukoht);
select @@identity into uusklubi_id;
update klubid set Asula = uusklubi_id where id = uusklubi.id;
end;

/*
13. Luua triger, mis klubi kustutamisel kontrollib, kas klubi asula on kuskil
kasutuses (teiste klubide juures või turniiride juures), ja kui pole, siis kustutab
ka asula maha. tg_kustuta_klubi.
OK!
*/

create trigger tg_kustuta_klubi after delete on klubid
referencing old as vana
for each row
begin
declare yks integer;
declare kaks integer;

select COUNT(*) into yks from klubid where Asula = vana.Asula;
select COUNT(*) into kaks from turniirid where Asula = vana.Asula;
IF (yks = 0 AND kaks = 0) then
delete from asulad where id = vana.Asula;
END IF; 
END

/* EI TÖÖTA 14. Lisada klubi “Kiire Aju” asukohaga Viljandi. */
insert into klubid (nimi, asukoht)
values ('Kiire Aju', 'Viljandi')

/* EI TÖÖTA 15. Lisada klubi “Kambja Kibe” asukohaga Kambja.*/
insert into klubid (nimi, asukoht)
values ('Kambja Kibe', 'Kambja')

/*16. Teha päring tabelisse asulad, et veenduda, mis asulad on olemas.*/
SELECT * FROM ASULAD

/*17. Kustutada klubid maha:
call sp_kustuta_klubi(‘Kiire Aju’)
call sp_kustuta_klubi(‘Kambja Kibe’).*/

/*19. Lisada uus klubi “SQL klubi” asukohaga Tartu.
20. Lisada tabelisse Isikud iseennast. Klubiks panna “SQL klubi”.
21. Proovida kustutada klubi sp_kustuta_klubi(‘SQL klubi’) - ei tohi õnnestuda
(miks?)
22. Luua klubi kustutamisele triger (tg_kustuta_klubi_isikutega), mis kustutaks
maha klubi isikud. NB! Kui isikul on partiisid, siis isikut ei õnnestu kustutada ja
seega ei õnnestu ka klubi kustutada. Nii peabki olema!
call sp_kustuta_klubi(“Laudnikud”) - ei tohi midagi halba teha (kui kõik seosed on
varem õigesti loodud).
Aga call sp_kustuta_klubi(“SQL klubi”) peab kustutama nii klubi kui ka selle ühe
liikme.
23. Kustutage kõik kirjed tabelist Inimesed ja lisada ennast tabelisse Inimesed.
24. Luua vaated ülesande 4 päringutele 1 kuni 12.
Vaate nimeks panna V_<päringu number>. Näiteks V_1, V_2, … , V_12.*/









-- Leiame klubiliikmete arvu klubi id põhjal

ALTER FUNCTION f_klubisuurus(klubi_id INTEGER)
    RETURNS INTEGER
BEGIN
    DECLARE tulemus INTEGER;
    SELECT COUNT(*) INTO tulemus
    FROM isikud 
    WHERE klubi = klubi_id;
    RETURN tulemus;
END

SELECT f_klubisuurus(55)

/* funktsioon ees ja perenime kokku liitmiseks eesti ametlikul viisil ("perenimi, eesnimi') 
f_nimi('Eesnimi', 'Perenimi')
*/

ALTER FUNCTION f_nimi(eesnimi VARCHAR(100),perenimi VARCHAR(100))
    RETURNS VARCHAR(200) 
BEGIN
    DECLARE tulemus VARCHAR;
    SELECT perenimi + ', ' + eesnimi
    INTO tulemus;
    RETURN tulemus;
END
                                                            
SELECT f_nimi('Aimar','Roosalu')
                                                            
/* Luua funktsioon ühe mängija partiide koguarv f_mangija_koormus(id) */

CREATE FUNCTION f_mangija_koormus(mangija_id INTEGER)
    RETURNS INTEGER
BEGIN
    DECLARE tulemus INTEGER;
        SELECT count(*) INTO tulemus
        FROM partiid 
        WHERE partiid.valge = mangija_id OR must = mangija_id;
        RETURN tulemus;
END 

SELECT f_mangija_koormus(80)

/* Funktsioon ühe mängija võitude arv turniiril f_mangija_voite_turniiril(isikud.id, turniirid.id)
*/

ALTER FUNCTION f_mangija_voite_turniiril(isikud_id INTEGER, turniirid_id INTEGER)
    RETURNS INTEGER
BEGIN
    DECLARE tulemus INTEGER;
        SELECT COUNT(*) INTO tulemus
        FROM v_punktid
        WHERE mangija = isikud_id AND punkt > 0 AND turniir = turniirid_id;
    RETURN tulemus;

END 

SELECT f_mangija_voite_turniiril(71,41)
                                                            
/* Funktsioon ühe mängija punktisumma turniiril f_mangija_punktid_turniiril(isikud.id, turniirid.id)
*/

ALTER FUNCTION f_mangija_punktid_turniiril(isikud_id INTEGER, turniirid_id INTEGER)
    RETURNS INTEGER
BEGIN
    DECLARE tulemus INTEGER;
    SELECT SUM(punkt) INTO tulemus
    FROM v_punktid
    WHERE mangija = isikud_id AND turniir = turniirid_id;
    RETURN tulemus;
END;

SELECT f_mangija_punktid_turniiril(80,41)

/* protseduur sp_uus_isik, mis lisab eesnime ja perenimega määratud isiku etteantud numbriga klubisse ning paneb
neljandasse parameetrisse uue isiku ID väärtuse. Praktikumi näide on analoogne.
*/

ALTER PROCEDURE sp_uus_isik(IN eesnimi1 VARCHAR(50), IN perenimi1 VARCHAR(50), IN klubi1 INTEGER, OUT id1 INTEGER)
BEGIN
    declare i_id INTEGER;
    insert into isikud(eesnimi, perenimi, klubi)
    values(eesnimi1, perenimi1, klubi1);
    select @@identity INTO i_id;
    message 'Isik klubisse lisatud: ' || i_id TO CLIENT;
    SET id1 = i_id
END;

CALL sp_uus_isik('Maka', 'Ron', 51)
                                                            
/* Luua tabelit väljastav protseduur sp_infopump()
See peab andma välja unioniga kokku panduna järgmised asjad (kasutades
varemdefineeritud võimalusi):
1) klubi nimi ja tema mängijate arv (kasutada funktsiooni f_klubisuurus)
2) turniiri nimi ja tema jooksul tehtud mängude arv (kasutada group by)
3) mängija nimi ja tema poolt mängitud partiide arv (kasutada f_nimi ja
f_mangija_koormus) ning tulemus sorteerida nii, et klubide info oleks kõige
ees, siis turniiride oma ja siis alles isikud. Iga grupi sees sorteerida nime järgi.
*/
                                                            
--PUUDUB
                                                            
/*
Luua tabelit väljastav protseduur sp_top10, millel on üks parameeter -
turniiri id, ja mis kasutab vaadet v_edetabelid ja annab tulemuseks kümme
parimat etteantud turniiril.
 */

ALTER PROCEDURE sp_top10(IN turniir_id INTEGER)
    RESULT(mangija VARCHAR(50))
BEGIN
    SELECT TOP 10 mangija
    FROM v_edetabelid
    WHERE turniir = turniir_id
    ORDER by punkte DESC;
END;

CALL sp_top10(42)
                           
/*Luua tabelit väljastav protseduur sp_voit_viik_kaotus, mis väljastab kõigi
osalenud mängijate võitude, viikide ja kaotuste arvu etteantud turniiril. Tabeli
struktuur: id, eesnimi, perenimi, võite, viike, kaotusi
(f_mangija_voite_turniiril jt sarnased funktsioonid oleksid abiks ...)
*/

--PUUDUB
                           
 /*
Luua indeks turniiride algusaegade peale.
*/

CREATE INDEX turniir_start ON turniirid(alguskuupaev)
                           
/*Luua indeksid partiidele kahanevalt valge ja musta tulemuse peale.*/

CREATE INDEX index_valge_must_tulemus ON partiid(valge_tulemus DESC, musta_tulemus DESC)
                                                            

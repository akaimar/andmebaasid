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


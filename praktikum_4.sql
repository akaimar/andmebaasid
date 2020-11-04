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

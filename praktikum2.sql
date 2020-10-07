/* Klubi Laudnikud liikmete nimekiri eesnimi ja perenimi tähest järjekorras 
*/
SELECT eesnimi,perenimi FROM isikud KEY JOIN klubid 
WHERE nimi ='Laudnikud' ORDER BY eesnimi,perenimi

/* Klubi Laudnikud liikmete arv 
*/
SELECT COUNT(*) FROM isikud KEY JOIN klubid
WHERE nimi='Laudnikud'

/* V tähega algavate klubide M tähega algavate eesnimedega prekonnanimed 
*/
SELECT perenimi FROM isikud WHERE eesnimi LIKE 'M%' AND klubi IN (SELECT id FROM klubid WHERE nimi LIKE 'V%')

/* kõige esimesena alanud partii algusaeg
*/
SELECT algushetk FROM partiid WHERE id = 1

/* Leida partiide mängijad (viited mängijatele (väljad: valge ja must)) 
mis algasid 04. märtsil 2005 aastal ajavahemikus 9:00 kuni 11:00
*/
SELECT valge, must FROM partiid WHERE algushetk BETWEEN '2005-03-04 09:00:00' AND '2005-03-04 11:00:00'

/* Leida valgetega võitnute (valge_tulemus=2) isikute nimed (eesnimi, perenimi), kus partii
kestis 9 kuni 11 minutit (vt funktsiooni Datediff(); Datediff(minute, <algus>, <lõpp>)).
*/

SELECT eesnimi, perenimi FROM isikud 
JOIN partiid ON isikud.id = partiid.valge 
WHERE valge_tulemus = 2 
AND datediff(minute, algushetk, lopphetk) BETWEEN 9 AND 11

/* Leida tabelis Isikud rohkem kui 1 kord esinevad perekonnanimed (ja ei muud)
*/
SELECT perenimi FROM isikud
GROUP BY perenimi
HAVING COUNT (perenimi) > 1

/* Leida klubid (nimi ja liikmete arv), kus on alla 4 liikme.
*/
SELECT nimi, count(*) AS liikmeid
FROM isikud JOIN klubid ON isikud.klubi = klubid.id
GROUP BY nimi HAVING liikmeid < 4

/*  Leida kõigi Arvode poolt kokku valgetega mängitud partiide arv.
*/
SELECT COUNT(*) AS partiide_arv FROM partiid
JOIN isikud ON partiid.valge = isikud.id

/*  Leida kõigi Arvode poolt kokku valgetega mängitud partiide arv.
*/
SELECT COUNT(*) FROM partiid
JOIN isikud ON partiid.valge = isikud.id 
GROUP BY eesnimi HAVING eesnimi = 'Arvo'

/*
Leida kõigi Arvode poolt kokku valgetega mängitud partiide arv turniiride lõikes
(turniiri id ja partiide arv).
*/
SELECT turniirid.Id, count(*)
FROM turniirid JOIN partiid
ON partiid.turniir = turniirid.id JOIN isikud
ON isikud.id = partiid.valge WHERE eesnimi = 'Arvo' GROUP BY turniirid.Id  ORDER BY turniirid.Id

/*
Leida kõigi Mariade poolt kokku mustadega mängitud partiidest saadud punktide arv
(tulemus = 2 on võit ja annab ühe punkti, tulemus = 1 on viik ja annab pool punkti)
*/

-- Leida Mariad from ISIKUD
-- Leida partiidest mustad kus mustad = Maria.id
-- leida SUM(musta_tulemus)

SELECT SUM(musta_tulemus) FROM partiid
JOIN isikud ON isikud.id = partiid.mustad



/*
Leida partiide keskmine kestvus turniiride kaupa (tulemuseks on tabel 2 veeruga:
turniiri nimi, keskmine partii pikkus).
*/

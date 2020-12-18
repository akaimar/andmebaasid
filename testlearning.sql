

/*protseduur*/

create procedure testime @id integer
AS
SELECT * FROM TURNIIRID WHERE id = @id
GO;

exec testime @id = 41

/*funktsioon*/

CREATE FUNCTION teemidagi(sisend1 integer) 
RETURNS VARCHAR(100)
NOT DETERMINISTIC 
BEGIN
    DECLARE väljund VARCHAR(100);
    SELECT nimi INTO väljund FROM klubid WHERE id = sisend1;
    RETURN väljund;
END;


/*group by having - kus tabelis tuleb mängijad, kes on võitnud ainult ühe mängu*/

SELECT must, count(*) FROM partiid 
WHERE musta_tulemus = 2
GROUP BY must
HAVING count(musta_tulemus) = 1

/*maksimaalseid punkte edetabelis*/

select mangija, max(punkte) from v_edetabelid
where turniir = 42 group by mangija



--1. Obtener los nombres y salarios de los empleados con m�s de 1000 euros de salario por orden alfab�tico.
SELECT nombre, ape1, ape2, salario
FROM empleado
WHERE salario > 1000
ORDER BY nombre ASC;

--2. Obtener el nombre de los empleados cuya comisi�n es superior 
-- al 20% de su salario.
SELECT nombre, ape1, comision, salario
FROM empleado
WHERE comision > salario * 0.1; -- PROBAMOS 10% POR QUE CON 20 NO HAY

SELECT nombre, ape1, nvl(comision, 0), salario  -- Para ver los valores si comision es null sacamos 0 en el listado
FROM empleado
WHERE nvl(comision, 0) > salario * 0.1;
--3. Obtener el c�digo de empleado, c�digo de departamento, nombre y sueldo 
--total en pesetas de aquellos empleados cuyo sueldo total (salario m�s 
--comisi�n) supera los 1800 euros. Presentarlos ordenados por c�digo de 
--departamento y dentro de �stos por orden alfab�tico.
select codemple, coddpto, nombre, 
       round((salario + nvl(comision, 0)) / 0.006, 2) AS sueldoTotalPesetas, -- mil pesetas 6 euros
       round((salario+nvl(comision,0))*166.386,2) SueldoTotalPesetas --1 euro, equivale a 166,386 pesetas
FROM empleado
WHERE salario + nvl(comision, 0) > 1800
ORDER BY coddpto, 
         nombre ASC;

--4. Obtener por orden alfab�tico los nombres de empleados cuyo salario 
--igualen o superen en m�s de un 5% al salario de la empleada �MARIA JAZMIN�.
SELECT nombre, ape1, salario
FROM empleado
WHERE salario >= ( SELECT salario * 1.05
                   FROM empleado
                   WHERE ape1 = 'JAZMIN'
                         AND nombre = 'MARIA'
                 )
ORDER BY 2, 1;
--5. Obtener un listado ordenado por a�os en la empresa con los nombres, y 
--apellidos de los empleados y los a�os de antig�edad en la empresa
SELECT nombre, ape1, ape2, round((sysdate - fechaingreso) / 365.20, 2)       AS "Antigüedad",
trunc(months_between(sysdate, fechaingreso) / 12) "Antiguedad"
FROM empleado
ORDER BY 5;

--6. Obtener el nombre de los empleados que trabajan en un departamento con 
--presupuesto superior a 50.000 euros. Hay que usar predicado cuantificado:
SELECT nombre,ape1
FROM empleado 
WHERE coddpto IN ( SELECT coddpto
                   FROM dpto
                   WHERE presupuesto > 50000
                 );
SELECT nombre,ape1
FROM empleado
WHERE coddpto = SOME ( SELECT coddpto
                       FROM dpto
                       WHERE presupuesto > 50000
                     );


--7. Obtener los nombres y apellidos de empleados que m�s cobran en la 
--empresa. Considerar el salario m�s la comisi�n
select
FROM empleado
WHERE nvl(comision, 0) + salario >= ALL ( SELECT nvl(comision, 0) + salario
                                          FROM empleado
                                        );
SELECT nombre, ape1, ape2
FROM empleado
WHERE salario + nvl(comision, 0) = ( SELECT MAX(salario + nvl(comision, 0))
                                     FROM empleado
                                   );

--8. Obtener en orden alfab�tico los nombres de empleado cuyo salario es 
--inferior al m�nimo de los empleados del departamento 1.
SELECT ape1, nombre
FROM empleado
WHERE salario < ( SELECT MIN(salario)
                  FROM empleado
                  WHERE coddpto = 1
                )
ORDER BY ape1, nombre;

SELECT ape1, nombre, salario
FROM empleado
WHERE salario < all ( SELECT salario
                  FROM empleado
                  WHERE coddpto = 1
                )
ORDER BY ape1, nombre;


SELECT ape1, nombre, nvl(comision, 0) + salario -- si condideramos sueldo total
FROM empleado
WHERE nvl(comision, 0) + salario <  ( SELECT min(nvl(comision, 0) + salario)
                                          FROM empleado
                                        );

--9. Obtener los nombre de empleados que trabajan en el departamento del 
--cu�l es jefe el empleado con c�digo 1.
SELECT nombre, ape1
FROM empleado
WHERE coddpto = ( SELECT coddpto
                  FROM dpto
                  WHERE codemplejefe = 1
                );

--10. Obtener los nombres de los empleados cuyo primer apellido empiece por 
--las letras p, q, r, s.
SELECT nombre, ape1
FROM empleado
WHERE lower(substr(ape1, 1, 1)) IN ( 'p', 'q', 'r', 's' ); -- tambi�n lower(ape1) like 'p%' or ... or lower(ape1) like 's%', aunque perdiese un poco de legibilidad

SELECT nombre,
       ape1
FROM empleado
WHERE substr(ape1, 1, 1) BETWEEN 'P' AND 'S'; -- esta a m� no se me hubiese ocurrido, obviamente vale porque son letras correlativas, mejor pasarle un lower o un apper para asegurar que no distinguimos entre minusculas y may�sculas

--11. Obtener los empleados cuyo nombre de pila contenga el nombre JUAN.


SELECT nombre,
       ape1
FROM empleado
WHERE nombre LIKE 'JUAN%' or nombre LIKE ' %JUAN% ' or nombre LIKE '% JUAN'  ; 
-- empiece por, contenga o termine en, para que no tenga en cuenta JUANIN

SELECT *
FROM empleado
WHERE instr(nombre, 'JUAN') <> 0; -- otra opci�n 


--12. Obtener los nombres de los empleados que viven en ciudades en las que 
--hay alg�n centro de trabajo
SELECT nombre, ape1
FROM empleado
WHERE upper(localidad) IN ( SELECT upper(localidad)
                     FROM centro
                   );

--13. Obtener el nombre del jefe de departamento que tiene mayor salario de 
--entre los jefes de departamento.
SELECT nombre,ape1, salario
FROM empleado
WHERE codemple IN ( SELECT codemplejefe
                    FROM dpto
                  )
      AND salario >= ALL ( SELECT salario --salarios de todos los jefes de departamento
                     FROM empleado
                     WHERE codemple IN ( SELECT codemplejefe
                                         FROM dpto
                                       )
                         );

--14. Obtener en orden alfab�tico los salarios y nombres de los empleados cuyo 
--salario sea superior al 60% del m�ximo salario de la empresa.
SELECT nombre, ape1, salario
FROM empleado
WHERE salario > ( SELECT MAX(salario) * 0.6
                  FROM empleado
                )
ORDER BY 2, 1;
SELECT nombre, ape1, salario
FROM empleado
WHERE salario > 0.6*( SELECT MAX(salario) -- m�s eficiente
                  FROM empleado
                )
ORDER BY 2, 1;
--15. Obtener en cu�ntas ciudades distintas viven los empleados
SELECT COUNT(DISTINCT localidad)
FROM empleado;

-- 16 El nombre y apellidos del empleado que m�s salario cobra
SELECT nombre, ape1, ape2
FROM empleado
WHERE salario = ( SELECT MAX(salario)
                  FROM empleado
                );


--17. Obtener las localidades y n�mero de empleados de aquellas en las que viven m�s 
--de 3 empleados
SELECT localidad, count(*)
FROM empleado
HAVING count(*) > 3;


--18. Obtener para cada departamento cu�ntos empleados trabajan, la suma de sus 
--salarios y la suma de sus comisiones para aquellos departamentoS en los que hay 
--alg�n empleado cuyo salario es superior a 1700 euros.
SELECT coddpto, SUM(salario), SUM(comision), COUNT(codemple)
FROM empleado
GROUP BY coddpto
HAVING coddpto = SOME ( SELECT coddpto
                        FROM empleado
                        WHERE salario > 1700
                      );
SELECT * FROM DPTO;

-- si queremos listar el nombre del departamento combinamos con dpto
SELECT e1.coddpto,denominacion,  SUM(e1.salario), SUM(e1.comision), COUNT(e1.codemple)
FROM empleado e1 join dpto on e1.coddpto=dpto.coddpto
GROUP BY e1.coddpto, denominacion
HAVING e1.coddpto = SOME ( SELECT distinct e2.coddpto
                        FROM empleado e2
                        WHERE salario > 1700
                      ) order by 3 desc;

--19. Obtener el departamento que m�s empleados tiene

SELECT denominacion
FROM dpto, empleado
WHERE empleado.coddpto = dpto.coddpto
GROUP BY dpto.coddpto, denominacion
HAVING COUNT(empleado.codemple) = ( select max (conteo) from
                                        (SELECT COUNT(codemple)as conteo
                                         FROM empleado
                                         GROUP BY coddpto
                                       )
                                    );
SELECT denominacion, count(empleado.codemple)
FROM dpto, empleado
WHERE empleado.coddpto = dpto.coddpto
GROUP BY dpto.coddpto, denominacion
HAVING COUNT(empleado.codemple) >= ALL ( SELECT COUNT(codemple) -- si es mayor o igual que todos es mayor o igual que el m�ximo, yo prefiero la anterior pues es m�s legible y comparas s�lo conun valor (eficiencia)
                                         FROM empleado
                                         GROUP BY coddpto
                                       );
SELECT dpto.coddpto,denominacion, count(*) NumEmpleados  -- Para comprobar la anterior
FROM empleado join dpto on empleado.coddpto=dpto.coddpto
GROUP BY dpto.coddpto, denominacion
order by 3 desc;
--20. Obtener los nombres de todos los centros y los departamentos que se ubican en 
--cada uno,as� como aquellos centros que no tienen departamentos.
insert into centro values (04,'Gran Via','Vigo'); -- insertamos un nuevo centro para que se observe la diferencia entre outer e inner join
select * from dpto;
select * from centro;

SELECT c.codcentro, c.direccion, c.localidad, d.coddpto, d.denominacion
FROM centro c
LEFT JOIN dpto   d ON c.codcentro = d.codcentro; -- sintaxis del est�ndar

SELECT direccion, denominacion
FROM centro tc, dpto   td
WHERE tc.codcentro = td.codcentro (+)  -- sintaxis alternativa en oracle
ORDER BY 1, 2;

--21. Obtener el nombre del departamento de m�s alto nivel, es decir, aquel que no 
--depende de ning�n otro.
select * from dpto;

select denominacion from dpto where coddptodepende is null;

--22. Obtener todos los departamentos existentes en la empresa y los empleados (si 
--los tiene) que pertenecen a �l.
 insert into dpto values (08,'PRUEBAS',03,05,04,'F',40000);

SELECT denominacion, nombre, ape1, ape2
FROM dpto     td
LEFT JOIN empleado te ON td.coddpto = te.coddpto
ORDER BY 1;

--23. Obtener un listado en el que aparezcan todos los departamentos existentes y el 
--departamento del cual depende,si depende de alguno.
SELECT d1.coddpto, d1.denominacion, 
   d2.coddpto DependeDe, d2.denominacion nombredpto
FROM dpto d1  left JOIN dpto d2 ON d1.coddptodepende = d2.coddpto;
select * from dpto;

SELECT td.denominacion, a.denominacion
FROM dpto td, dpto a
WHERE a.coddpto (+) = td.coddptodepende;

--24. Obtener un listado ordenado alfab�ticamente donde aparezcan los nombres de 
--los empleados y a continuaci�n el literal "tiene comisi�n" si la tiene,y "no tiene 
--comisi�n" si no la tiene.
select nombre,ape1,ape2,nvl2(comision,'tiene comisión','no tiene comisión') as comision -- la m�s sencilla con nvl2
from empleado
order by 1,2,3;

SELECT nombre, comision, decode(nvl(comision, 0), 0, 'No Tiene comisi�n', 'Tiene comisi�n') tieneComision
FROM empleado
ORDER BY nombre ASC;

SELECT nombre, ape1, ape2, 'tiene comision'
FROM empleado
WHERE comision IS NOT NULL
UNION
SELECT nombre, ape1, ape2, 'no tiene comision'
FROM empleado
WHERE comision IS NULL
ORDER BY 4, 2;



SELECT     -- esta tambi�n es sencilla y legible (legibilidad=facilidad para "leer" o entender el c�digo)
    nombre,
    CASE
    WHEN comision IS NULL THEN
    'no tiene comision'
    ELSE
    'tiene comision'
    END comision
FROM
    empleado
ORDER BY
    nombre ASC;


--25. Obtener un listado de las localidades en las que hay centros 
--y no vive ning�n  empleado, ordenado alfab�ticamente.
SELECT localidad 
FROM centro c
WHERE upper(localidad) NOT IN ( SELECT DISTINCT localidad
                                FROM empleado
                              )
ORDER BY localidad ASC;

SELECT upper(tc.localidad)
FROM centro tc
MINUS
SELECT upper(te.localidad)
FROM empleado te
ORDER BY 1;


 SELECT   -- opci�n de alumnado,  no me chista, poco eficiente, menos legible, no la dar�a por buena 
    upper(
        centro.localidad
    ) "localidad del centro"
FROM
    centro
    LEFT JOIN empleado ON upper(
        empleado.localidad
    ) = upper(
        centro.localidad
    )
GROUP BY
    centro.localidad
HAVING
    COUNT(empleado.localidad) < 1
ORDER BY
    centro.localidad ASC;



--26. Obtener un listado de las localidades en las que hay centros 
-- y adem�s vive al menos un empleado ordenado alfab�ticamente.
SELECT localidad
FROM centro c
WHERE upper(localidad) IN ( SELECT DISTINCT localidad
                            FROM empleado
                          )
ORDER BY localidad ASC;

SELECT DISTINCT upper(localidad)
FROM centro
INTERSECT
SELECT DISTINCT upper(localidad)
FROM empleado
ORDER BY 1 ASC;

-- no me chista la siguiente
SELECT localidad
FROM centro c
WHERE upper(localidad) NOT IN ( SELECT DISTINCT localidad
                                FROM empleado
                              )
ORDER BY localidad ASC;

SELECT upper(tc.localidad)
FROM centro tc
MINUS
SELECT upper(te.localidad)
FROM empleado te
ORDER BY 1;

--27. Esta cuesti�n punt�a por 2. Se desea dar una gratificaci�n por navidades en 
--funci�n de la antig�edad en la empresa siguiendo estas pautas:
--1. Si lleva entre 1 y 5 a�os, se le dar� 100 euros
--2. Si lleva entre 6 y 10 a�os, se le dar� 50 euros por a�o
--3. Si lleva entre 11 y 20 a�os, se le dar� 70 euros por a�o
--4. Si lleva m�s de 21 a�os, se le dar� 100 euros por a�o
--28. Obtener un listado de los empleados,ordenado alfab�ticamente,indicando 
--cu�nto le corresponde de gratificaci�n.
select nombre, ape1, ape2,TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) antiguedad from empleado; -- veamos la antiguedad

--28. Obtener un listado de los empleados,ordenado alfab�ticamente,indicando 
--cu�nto le corresponde de gratificaci�n.
SELECT nombre, ape1, ape2, a�os_antiguedad, CASE
    WHEN a�os_antiguedad BETWEEN 1 AND 5   THEN
        100
    WHEN a�os_antiguedad BETWEEN 6 AND 10  THEN
        50 * a�os_antiguedad
    WHEN a�os_antiguedad BETWEEN 11 AND 20 THEN
        70 * a�os_antiguedad
    WHEN a�os_antiguedad >= 21             THEN
        100 * a�os_antiguedad
                                            END gratificacion
FROM ( SELECT nombre, ape1, ape2, trunc(months_between(sysdate, fechaingreso) / 12) a�os_antiguedad 
-- una subselect en la cl�usula from me permite simplificar la expresi�n de la select externa, poniendo antiguedad en lugar de la expresi�n MONTHS_BETWEEN...

       FROM empleado
     )
ORDER BY nombre, ape2, ape2 ASC;


-- la union de consultas es otra opci�n, menos bonita que tampoco gana en eficiencia, pero arroja el mismo resultado
SELECT nombre, ape1, ape2,TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) antiguedad, 100 AS gratificacion
FROM empleado
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) BETWEEN 1 AND 5

UNION

SELECT nombre, ape1, ape2, TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) antiguedad, 50 * TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12)
FROM empleado
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) BETWEEN 6 AND 10

UNION

SELECT nombre, ape1, ape2, TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) antiguedad,70 * TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12)
FROM empleado
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) BETWEEN 11 AND 20

UNION

SELECT nombre, ape1, ape2,TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) antiguedad, 100 * TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12)
FROM empleado
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,FECHAINGRESO)/12) >= 21
ORDER BY 2, 3, 1;


/*28 Obtener un listado de los empleados,ordenado alfab�ticamente,indicando cu�nto le corresponde de gratificaci�n.*/
SELECT
    nombre,
    ape1,
    ape2,fechaingreso,
    round(months_between( -- aqu� pod�is observar c�mo se reptite la expresi�n round(months_between..... ,por eso lo de la subselect en la cl�usula from me parece mejor opci�n
        sysdate, fechaingreso
    ) / 12) AS "a�os de antig�edad",
    CASE
    WHEN round(months_between(
        sysdate, fechaingreso
    ) / 12) BETWEEN 1 AND 5   THEN
    100
    WHEN round(months_between(
        sysdate, fechaingreso
    ) / 12) BETWEEN 6 AND 10  THEN
    ( round(months_between(
        sysdate, fechaingreso
    ) / 12) ) * 50
    WHEN round(months_between(
        sysdate, fechaingreso
    ) / 12) BETWEEN 11 AND 20 THEN
    ( round(months_between(
        sysdate, fechaingreso
    ) / 12) ) * 70
    ELSE
    round(months_between(
        sysdate, fechaingreso
    ) / 12) * 100
    END     gratificacion
FROM
    empleado
;



--29. Obtener a los nombres, apellidos de los empleados que no son jefes de 
--departamento.
SELECT nombre, ape1, ape2
FROM empleado
WHERE codemple NOT IN ( SELECT DISTINCT codemplejefe
                        FROM dpto
                      );
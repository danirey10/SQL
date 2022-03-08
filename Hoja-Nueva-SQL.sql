--1. Obtener los nombres y salarios de los empleados con m�s de 1000 euros de salario por orden alfab�tico.
SELECT NOMBRE, APE1, APE2, SALARIO FROM EMPLEADO WHERE SALARIO > 1000;

--2. Obtener el nombre de los empleados cuya comisi�n es superior 
-- al 20% de su salario.
SELECT NOMBRE, SALARIO, COMISION FROM EMPLEADO WHERE NVL(COMISION, 0) > SALARIO*0.2;

--3. Obtener el c�digo de empleado, c�digo de departamento, nombre y sueldo 
--total en pesetas de aquellos empleados cuyo sueldo total (salario m�s 
--comisi�n) supera los 1800 euros. Presentarlos ordenados por c�digo de 
--departamento y dentro de �stos por orden alfab�tico.
SELECT CODEMPLE, CODDPTO, NOMBRE,
ROUND((SALARIO+NVL(COMISION,0))*166.386,2) AS SUELDOTOTAL -- mil pesetas 6 euros
FROM EMPLEADO
ORDER BY CODDPTO, NOMBRE ASC;


--4. Obtener por orden alfab�tico los nombres de empleados cuyo salario 
--igualen o superen en m�s de un 5% al salario de la empleada �MARIA JAZMIN�.
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS, SALARIO FROM EMPLEADO
WHERE (SALARIO >= (SELECT SALARIO FROM EMPLEADO WHERE NOMBRE='MARIA' AND APE1='JAZMIN')*1.05)
ORDER BY NOMBRE ASC;

--5. Obtener un listado ordenado por a�os en la empresa con los nombres, y 
--apellidos de los empleados y los a�os de antig�edad en la empresa
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS, ROUND((sysdate - FECHAINGRESO) / 365.20) AS ANTIGUEDAD FROM EMPLEADO
ORDER BY ANTIGUEDAD;

--6. Obtener el nombre de los empleados que trabajan en un departamento con 
--presupuesto superior a 50.000 euros. Hay que usar predicado cuantificado:
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS FROM EMPLEADO
WHERE CODDPTO IN (SELECT CODDPTO FROM DPTO WHERE PRESUPUESTO > 50000);

--7. Obtener los nombres y apellidos de empleados que m�s cobran en la 
--empresa. Considerar el salario m�s la comisi�n
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS FROM EMPLEADO
WHERE SALARIO + NVL(COMISION, 0) = (SELECT MAX (SALARIO + NVL(COMISION,0)) FROM EMPLEADO);

--8. Obtener en orden alfab�tico los nombres de empleado cuyo salario es 
--inferior al m�nimo de los empleados del departamento 1.
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS FROM EMPLEADO
WHERE SALARIO < (SELECT MIN(SALARIO) FROM EMPLEADO WHERE CODDPTO = 1)
ORDER BY NOMBRE ASC;


--9. Obtener los nombre de empleados que trabajan en el departamento del 
--cu�l es jefe el empleado con c�digo 1.
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS FROM EMPLEADO
WHERE CODDPTO = (SELECT CODEMPLEJEFE FROM DPTO WHERE CODDPTO = 1);


--10. Obtener los nombres de los empleados cuyo primer apellido empiece por 
--las letras p, q, r, s.



--11. Obtener los empleados cuyo nombre de pila contenga el nombre JUAN.
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS FROM EMPLEADO
WHERE NOMBRE LIKE 'JUAN%' or NOMBRE LIKE ' %JUAN% ' or NOMBRE LIKE '% JUAN'  ;

--12. Obtener los nombres de los empleados que viven en ciudades en las que 
--hay alg�n centro de trabajo
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS, LOCALIDAD FROM EMPLEADO
WHERE UPPER(LOCALIDAD) IN (SELECT UPPER(LOCALIDAD) FROM CENTRO);

--13. Obtener el nombre del jefe de departamento que tiene mayor salario de 
--entre los jefes de departamento.
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS, SALARIO FROM EMPLEADO
WHERE CODEMPLE IN (SELECT CODEMPLEJEFE FROM DPTO) AND SALARIO >= ALL (SELECT SALARIO FROM EMPLEADO WHERE CODEMPLE IN (SELECT CODEMPLEJEFE FROM DPTO));


--14. Obtener en orden alfab�tico los salarios y nombres de los empleados cuyo 
--salario sea superior al 60% del m�ximo salario de la empresa.
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS, SALARIO FROM EMPLEADO
WHERE SALARIO > (SELECT MAX(SALARIO)*0.6 FROM EMPLEADO)
ORDER BY APELLIDOS, NOMBRE ASC;

--15. Obtener en cu�ntas ciudades distintas viven los empleados
SELECT COUNT(DISTINCT LOCALIDAD) AS LOCALIDADES FROM EMPLEADO;

-- 16 El nombre y apellidos del empleado que m�s salario cobra
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS, SALARIO FROM EMPLEADO
WHERE SALARIO = (SELECT MAX(SALARIO) FROM EMPLEADO);

--17. Obtener las localidades y n�mero de empleados de aquellas en las que viven m�s 
--de 3 empleados
SELECT LOCALIDAD, COUNT(*) AS TOTAL FROM EMPLEADO GROUP BY LOCALIDAD HAVING COUNT(LOCALIDAD)>3;

--18. Obtener para cada departamento cu�ntos empleados trabajan, la suma de sus 
--salarios y la suma de sus comisiones para aquellos departamentoS en los que hay 
--alg�n empleado cuyo salario es superior a 1700 euros.
SELECT CODDPTO, SUM(SALARIO+NVL(COMISION, 0)) AS SALCOM, COUNT(*) EMPLEADOS FROM EMPLEADO
WHERE SALARIO > 1700
GROUP BY CODDPTO
ORDER BY CODDPTO ASC;

--19. Obtener el departamento que m�s empleados tiene
SELECT DENOMINACION FROM DPTO, EMPLEADO
WHERE EMPLEADO.CODDPTO = DPTO.CODDPTO
GROUP BY DPTO.CODDPTO, DENOMINACION
HAVING COUNT(EMPLEADO.CODEMPLE) = (SELECT MAX(NUMEMPLEADOS) FROM
                                        (SELECT COUNT(CODEMPLE)as NUMEMPLEADOS
                                         FROM EMPLEADO
                                         GROUP BY CODDPTO
                                       )
                                    );

--20. Obtener los nombres de todos los centros y los departamentos que se ubican en 
--cada uno,as� como aquellos centros que no tienen departamentos.
SELECT C.CODCENTRO, C.DIRECCION, C.LOCALIDAD, D.CODDPTO, D.DENOMINACION
FROM CENTRO C
LEFT JOIN DPTO D ON C.CODCENTRO = D.CODCENTRO;


--21. Obtener el nombre del departamento de m�s alto nivel, es decir, aquel que no 
--depende de ning�n otro.
SELECT DENOMINACION, CODCENTRO FROM DPTO
WHERE CODDPTODEPENDE IS NULL;

--22. Obtener todos los departamentos existentes en la empresa y los empleados (si 
--los tiene) que pertenecen a �l.
SELECT denominacion, nombre, ape1, ape2
FROM dpto td
LEFT JOIN empleado te ON td.coddpto = te.coddpto
ORDER BY 1;

--23. Obtener un listado en el que aparezcan todos los departamentos existentes y el 
--departamento del cual depende,si depende de alguno.
SELECT d1.coddpto, d1.denominacion, 
   d2.coddpto DependeDe, d2.denominacion nombredpto
FROM dpto d1  left JOIN dpto d2 ON d1.coddptodepende = d2.coddpto;


--24. Obtener un listado ordenado alfab�ticamente donde aparezcan los nombres de 
--los empleados y a continuaci�n el literal "tiene comisi�n" si la tiene,y "no tiene 
--comisi�n" si no la tiene.
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS, NVL2(COMISION, 'TIENE COMISI�N', 'NO TIENE COMISI�N') AS COMISION FROM EMPLEADO
ORDER BY 1,2 ASC;

--25. Obtener un listado de las localidades en las que hay centros 
--y no vive ning�n  empleado, ordenado alfab�ticamente.
SELECT LOCALIDAD FROM CENTRO C
WHERE upper(LOCALIDAD) NOT IN ( SELECT DISTINCT LOCALIDAD
                                FROM EMPLEADO
                              )
ORDER BY LOCALIDAD ASC;

--26. Obtener un listado de las localidades en las que hay centros 
-- y adem�s vive al menos un empleado ordenado alfab�ticamente.
SELECT CENTRO.LOCALIDAD FROM CENTRO WHERE CENTRO.LOCALIDAD NOT IN(SELECT EMPLEADO.LOCALIDAD FROM EMPLEADO,CENTRO WHERE EMPLEADO.LOCALIDAD = CENTRO.LOCALIDAD) ORDER BY LOCALIDAD ASC;

--27. Esta cuesti�n punt�a por 2. Se desea dar una gratificaci�n por navidades en 
--funci�n de la antig�edad en la empresa siguiendo estas pautas:
--1. Si lleva entre 1 y 5 a�os, se le dar� 100 euros
--2. Si lleva entre 6 y 10 a�os, se le dar� 50 euros por a�o
--3. Si lleva entre 11 y 20 a�os, se le dar� 70 euros por a�o
--4. Si lleva m�s de 21 a�os, se le dar� 100 euros por a�o
SELECT
    nombre,
    ape1,
    ape2,fechaingreso,
    round(months_between(
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

/*28 Obtener un listado de los empleados,ordenado alfab�ticamente,indicando cu�nto le corresponde de gratificaci�n.*/
SELECT
    nombre,
    ape1,
    ape2,fechaingreso,
    round(months_between(
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
ORDER BY NOMBRE,APE1,APE2 ASC
;

--29. Obtener a los nombres, apellidos de los empleados que no son jefes de 
--departamento.
SELECT nombre, ape1, ape2 FROM empleado WHERE codemple NOT IN ( SELECT codemplejefe FROM dpto );
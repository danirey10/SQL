--1. Obtener los nombres y salarios de los empleados con más de 1000 euros de salario por orden alfabético.
SELECT NOMBRE, APE1, APE2, SALARIO FROM EMPLEADO WHERE SALARIO > 1000;

--2. Obtener el nombre de los empleados cuya comisión es superior 
-- al 20% de su salario.
SELECT NOMBRE, SALARIO, COMISION FROM EMPLEADO WHERE NVL(COMISION, 0) > SALARIO*0.2;

--3. Obtener el código de empleado, código de departamento, nombre y sueldo 
--total en pesetas de aquellos empleados cuyo sueldo total (salario más 
--comisión) supera los 1800 euros. Presentarlos ordenados por código de 
--departamento y dentro de éstos por orden alfabético.
SELECT CODEMPLE, CODDPTO, NOMBRE,
ROUND((SALARIO+NVL(COMISION,0))*166.386,2) AS SUELDOTOTAL -- mil pesetas 6 euros
FROM EMPLEADO
ORDER BY CODDPTO, NOMBRE ASC;


--4. Obtener por orden alfabético los nombres de empleados cuyo salario 
--igualen o superen en más de un 5% al salario de la empleada ‘MARIA JAZMIN’.
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS, SALARIO FROM EMPLEADO
WHERE (SALARIO >= (SELECT SALARIO FROM EMPLEADO WHERE NOMBRE='MARIA' AND APE1='JAZMIN')*1.05)
ORDER BY NOMBRE ASC;

--5. Obtener un listado ordenado por años en la empresa con los nombres, y 
--apellidos de los empleados y los años de antigüedad en la empresa
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS, ROUND((sysdate - FECHAINGRESO) / 365.20) AS ANTIGUEDAD FROM EMPLEADO
ORDER BY ANTIGUEDAD;

--6. Obtener el nombre de los empleados que trabajan en un departamento con 
--presupuesto superior a 50.000 euros. Hay que usar predicado cuantificado:
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS FROM EMPLEADO
WHERE CODDPTO IN (SELECT CODDPTO FROM DPTO WHERE PRESUPUESTO > 50000);

--7. Obtener los nombres y apellidos de empleados que más cobran en la 
--empresa. Considerar el salario más la comisión
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS FROM EMPLEADO
WHERE SALARIO + NVL(COMISION, 0) = (SELECT MAX (SALARIO + NVL(COMISION,0)) FROM EMPLEADO);

--8. Obtener en orden alfabético los nombres de empleado cuyo salario es 
--inferior al mínimo de los empleados del departamento 1.
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS FROM EMPLEADO
WHERE SALARIO < (SELECT MIN(SALARIO) FROM EMPLEADO WHERE CODDPTO = 1)
ORDER BY NOMBRE ASC;


--9. Obtener los nombre de empleados que trabajan en el departamento del 
--cuál es jefe el empleado con código 1.
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS FROM EMPLEADO
WHERE CODDPTO = (SELECT CODEMPLEJEFE FROM DPTO WHERE CODDPTO = 1);


--10. Obtener los nombres de los empleados cuyo primer apellido empiece por 
--las letras p, q, r, s.



--11. Obtener los empleados cuyo nombre de pila contenga el nombre JUAN.
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS FROM EMPLEADO
WHERE NOMBRE LIKE 'JUAN%' or NOMBRE LIKE ' %JUAN% ' or NOMBRE LIKE '% JUAN'  ;

--12. Obtener los nombres de los empleados que viven en ciudades en las que 
--hay algún centro de trabajo
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS, LOCALIDAD FROM EMPLEADO
WHERE UPPER(LOCALIDAD) IN (SELECT UPPER(LOCALIDAD) FROM CENTRO);

--13. Obtener el nombre del jefe de departamento que tiene mayor salario de 
--entre los jefes de departamento.
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS, SALARIO FROM EMPLEADO
WHERE CODEMPLE IN (SELECT CODEMPLEJEFE FROM DPTO) AND SALARIO >= ALL (SELECT SALARIO FROM EMPLEADO WHERE CODEMPLE IN (SELECT CODEMPLEJEFE FROM DPTO));


--14. Obtener en orden alfabético los salarios y nombres de los empleados cuyo 
--salario sea superior al 60% del máximo salario de la empresa.
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS, SALARIO FROM EMPLEADO
WHERE SALARIO > (SELECT MAX(SALARIO)*0.6 FROM EMPLEADO)
ORDER BY APELLIDOS, NOMBRE ASC;

--15. Obtener en cuántas ciudades distintas viven los empleados
SELECT COUNT(DISTINCT LOCALIDAD) AS LOCALIDADES FROM EMPLEADO;

-- 16 El nombre y apellidos del empleado que más salario cobra
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS, SALARIO FROM EMPLEADO
WHERE SALARIO = (SELECT MAX(SALARIO) FROM EMPLEADO);

--17. Obtener las localidades y número de empleados de aquellas en las que viven más 
--de 3 empleados
SELECT LOCALIDAD, COUNT(*) AS TOTAL FROM EMPLEADO GROUP BY LOCALIDAD HAVING COUNT(LOCALIDAD)>3;

--18. Obtener para cada departamento cuántos empleados trabajan, la suma de sus 
--salarios y la suma de sus comisiones para aquellos departamentoS en los que hay 
--algún empleado cuyo salario es superior a 1700 euros.
SELECT CODDPTO, SUM(SALARIO+NVL(COMISION, 0)) AS SALCOM, COUNT(*) EMPLEADOS FROM EMPLEADO
WHERE SALARIO > 1700
GROUP BY CODDPTO
ORDER BY CODDPTO ASC;

--19. Obtener el departamento que más empleados tiene
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
--cada uno,así como aquellos centros que no tienen departamentos.
SELECT C.CODCENTRO, C.DIRECCION, C.LOCALIDAD, D.CODDPTO, D.DENOMINACION
FROM CENTRO C
LEFT JOIN DPTO D ON C.CODCENTRO = D.CODCENTRO;


--21. Obtener el nombre del departamento de más alto nivel, es decir, aquel que no 
--depende de ningún otro.
SELECT DENOMINACION, CODCENTRO FROM DPTO
WHERE CODDPTODEPENDE IS NULL;

--22. Obtener todos los departamentos existentes en la empresa y los empleados (si 
--los tiene) que pertenecen a él.
SELECT denominacion, nombre, ape1, ape2
FROM dpto td
LEFT JOIN empleado te ON td.coddpto = te.coddpto
ORDER BY 1;

--23. Obtener un listado en el que aparezcan todos los departamentos existentes y el 
--departamento del cual depende,si depende de alguno.
SELECT d1.coddpto, d1.denominacion, 
   d2.coddpto DependeDe, d2.denominacion nombredpto
FROM dpto d1  left JOIN dpto d2 ON d1.coddptodepende = d2.coddpto;


--24. Obtener un listado ordenado alfabéticamente donde aparezcan los nombres de 
--los empleados y a continuación el literal "tiene comisión" si la tiene,y "no tiene 
--comisión" si no la tiene.
SELECT NOMBRE, APE1 || ' ' || APE2 AS APELLIDOS, NVL2(COMISION, 'TIENE COMISIÓN', 'NO TIENE COMISIÓN') AS COMISION FROM EMPLEADO
ORDER BY 1,2 ASC;

--25. Obtener un listado de las localidades en las que hay centros 
--y no vive ningún  empleado, ordenado alfabéticamente.
SELECT LOCALIDAD FROM CENTRO C
WHERE upper(LOCALIDAD) NOT IN ( SELECT DISTINCT LOCALIDAD
                                FROM EMPLEADO
                              )
ORDER BY LOCALIDAD ASC;

--26. Obtener un listado de las localidades en las que hay centros 
-- y además vive al menos un empleado ordenado alfabéticamente.
SELECT CENTRO.LOCALIDAD FROM CENTRO WHERE CENTRO.LOCALIDAD NOT IN(SELECT EMPLEADO.LOCALIDAD FROM EMPLEADO,CENTRO WHERE EMPLEADO.LOCALIDAD = CENTRO.LOCALIDAD) ORDER BY LOCALIDAD ASC;

--27. Esta cuestión puntúa por 2. Se desea dar una gratificación por navidades en 
--función de la antigüedad en la empresa siguiendo estas pautas:
--1. Si lleva entre 1 y 5 años, se le dará 100 euros
--2. Si lleva entre 6 y 10 años, se le dará 50 euros por año
--3. Si lleva entre 11 y 20 años, se le dará 70 euros por año
--4. Si lleva más de 21 años, se le dará 100 euros por año
SELECT
    nombre,
    ape1,
    ape2,fechaingreso,
    round(months_between(
        sysdate, fechaingreso
    ) / 12) AS "años de antigüedad",
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

/*28 Obtener un listado de los empleados,ordenado alfabéticamente,indicando cuánto le corresponde de gratificación.*/
SELECT
    nombre,
    ape1,
    ape2,fechaingreso,
    round(months_between(
        sysdate, fechaingreso
    ) / 12) AS "años de antigüedad",
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
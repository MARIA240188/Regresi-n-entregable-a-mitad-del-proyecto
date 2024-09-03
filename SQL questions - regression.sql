-- Quito el modo seguro
SET SQL_SAFE_UPDATES = 0;

-- Creo la bbdd
CREATE DATABASE house_price_regression2;

-- Creo la tabla con las columnas del dataframe limpio
USE house_price_regression2;

CREATE TABLE house_price_data (
    id BIGINT PRIMARY KEY,
    date DATE,
    bedrooms INT,
    bathrooms FLOAT,
    sqm_living FLOAT,
    sqm_lot FLOAT,
    floors FLOAT,
    waterfront INT,
    view INT,
    `condition` INT,
    grade INT,
    sqm_basement FLOAT,
    yr_built INT,
    yr_renovated INT,
    zipcode INT,
    lat FLOAT,
    `long` FLOAT,
    sqm_living15 FLOAT,
    sqm_lot15 FLOAT,
    price FLOAT
);

-- Seleccione todos los datos de la tabla house_price_data para verificar si los datos se importaron correctamente
SELECT * FROM house_price_regression2.house_price_data;

-- Utilice el comando alterar tabla para eliminar la columna date de la base de datos, ya que no la usaríamos en el análisis con SQL. Seleccione todos los datos de la tabla para verificar si el comando funcionó. Limite los resultados devueltos a 10.
-- Eliminar la columna date
ALTER TABLE house_price_data
DROP COLUMN date;

-- Verificar la eliminación de la columna
SELECT * FROM house_price_data
LIMIT 10;

-- cuántas filas de datos tiene
SELECT COUNT(*) AS total_filas
FROM house_price_data;

-- Encontrar los valores únicos de las columnas categóricas: bedrooms, bathrooms, floors, condition y grade:
SELECT DISTINCT bedrooms
FROM house_price_data;

SELECT DISTINCT bathrooms
FROM house_price_data;

SELECT DISTINCT floors
FROM house_price_data;

SELECT DISTINCT `condition`
FROM house_price_data;

SELECT DISTINCT grade
FROM house_price_data;

-- Ordene los datos en orden decreciente según el precio de la casa. Devuelva solo los ID de las 10 casas más caras de sus datos.
SELECT id
FROM house_price_data
ORDER BY price DESC
LIMIT 10;

-- ¿Cuál es el precio medio de todas las propiedades de tus datos?
SELECT AVG(price) AS precio_medio
FROM house_price_data;

-- ¿Cuál es el precio medio de las casas agrupadas por dormitorios? El resultado devuelto debe tener sólo dos columnas, dormitorios y Promedio de los precios. Utilice un alias para cambiar el nombre de la segunda columna.
SELECT bedrooms AS dormitorios, AVG(price) AS precio_promedio
FROM house_price_data
GROUP BY bedrooms;

-- ¿Cuál es el promedio sqft_livingde las casas agrupadas por dormitorios? El resultado devuelto debe tener solo dos columnas, dormitorios y Promedio del sqft_living. Utilice un alias para cambiar el nombre de la segunda columna.
SELECT bedrooms AS dormitorios, AVG(sqm_living) AS promedio_m2
FROM house_price_data
GROUP BY bedrooms;

-- ¿Cuál es el precio promedio de las casas con frente a mar y sin frente a mar? El resultado devuelto debe tener solo dos columnas, frente al mar y Averagede precios. Utilice un alias para cambiar el nombre de la segunda columna.
SELECT 
    waterfront AS frente_al_mar, 
    AVG(price) AS Average_de_precios
FROM 
    house_price_data
GROUP BY 
    waterfront;

-- ¿Existe alguna correlación entre las columnas condition y grade? Puedes analizar esto agrupando los datos por una de las variables y luego agregando los resultados de la otra columna. Verifique visualmente si existe una correlación positiva, una correlación negativa o ninguna correlación entre las variables.
SELECT 
    `condition` AS condicion, 
    AVG(grade) AS Promedio_de_grade
FROM 
    house_price_data
GROUP BY 
    `condition`;
    
-- Uno de los clientes sólo está interesado en las siguientes casas:
-- Número de dormitorios 3 o 4, Baños más de 3, Un piso, Sin paseo marítimo, La condición debe ser 3 al menos, La nota debe ser al menos 5, Precio inferior a 300000. Por el resto de cosas no les preocupa demasiado. Escriba una consulta sencilla para saber cuáles son las opciones disponibles para ellos.
SELECT *
FROM house_price_data
WHERE 
    bedrooms IN (3, 4) AND
    bathrooms > 3 AND
    floors = 1 AND
    waterfront = 0 AND
    `condition` >= 3 AND
    grade >= 5 AND
    price < 300000;
-- no hay ninguna casa que cumpla sus características

-- Su gerente quiere conocer la lista de propiedades cuyos precios son el doble que el promedio de todas las propiedades en la base de datos. Escriba una consulta para mostrarles la lista de dichas propiedades. Es posible que necesite utilizar una subconsulta para este problema.
SELECT *
FROM house_price_data
WHERE price >= 2 * (SELECT AVG(price) FROM house_price_data);

-- Dado que esto es algo que interesa habitualmente a la alta dirección, cree una vista de la misma consulta.
CREATE VIEW propiedades_doble_promedio AS
SELECT *
FROM house_price_data
WHERE price >= 2 * (SELECT AVG(price) FROM house_price_data);

-- La mayoría de los clientes están interesados ​​en propiedades de tres o cuatro dormitorios. ¿Cuál es la diferencia en los precios medios de las propiedades de tres y cuatro dormitorios?
SELECT 
    ABS((
        SELECT AVG(price) 
        FROM house_price_data 
        WHERE bedrooms = 3
    ) - (
        SELECT AVG(price) 
        FROM house_price_data 
        WHERE bedrooms = 4
    )) AS diferencia_precio_medio;

-- Cuáles son las diferentes ubicaciones donde las propiedades están disponibles en su base de datos? (códigos postales distintos)
SELECT DISTINCT zipcode
FROM house_price_data;

-- Muestra la lista de todas las propiedades que fueron renovadas.
SELECT *
FROM house_price_data
WHERE yr_renovated > 0;

-- Proporcione los detalles de la propiedad que ocupa el puesto 11 entre las más caras de su base de datos.
SELECT *
FROM house_price_data
ORDER BY price DESC
LIMIT 1 OFFSET 10;

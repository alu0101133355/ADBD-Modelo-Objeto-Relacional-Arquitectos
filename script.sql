DROP TABLE IF EXISTS T_Jefe_Proyecto;
DROP TYPE IF EXISTS JefeProyecto;
DROP TYPE IF EXISTS Tipo_Direccion;


CREATE TYPE Tipo_Direccion AS (
Tipo_via	text,
Nombre_via  text,
Poblacion	text,
CP			text,
Provincia 	text);

CREATE TYPE JefeProyecto AS (
ID_Jefe_Proyecto	INT,
Nombre  text,
Direccion	text,
Telefono			text
-- Dirige 	REFERENCES Proyecto
);


CREATE TABLE IF NOT EXISTS T_Jefe_Proyecto OF JefeProyecto(
PRIMARY KEY (ID_Jefe_Proyecto),
UNIQUE (Nombre)
);

INSERT INTO T_Jefe_Proyecto (ID_Jefe_Proyecto, Nombre, Direccion, Telefono) VALUES (651, 'Pedro', 'Calle de los palotes', '968716871');

SELECT * FROM T_Jefe_Proyecto;

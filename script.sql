/*
* @Authors:
*           Jorge Acevedo
*           Javier Martín
*           Sergio Tabares
*
* @Date:   2021-01-22
*/

DROP TABLE IF EXISTS Director;
DROP TABLE IF EXISTS Proyecto;
DROP TABLE IF EXISTS Jefe_Proyecto;
DROP TABLE IF EXISTS Plano;
DROP TABLE IF EXISTS Poligono;
DROP TABLE IF EXISTS Linea;
DROP TABLE IF EXISTS Punto;
DROP TABLE IF EXISTS Figura;

DROP TYPE IF EXISTS T_Jefe_Proyecto;
DROP TYPE IF EXISTS T_Proyecto;
DROP TYPE IF EXISTS T_Direccion;
DROP TYPE IF EXISTS T_Plano;
DROP TYPE IF EXISTS T_Poligono;
DROP TYPE IF EXISTS T_Linea;
DROP TYPE IF EXISTS T_Punto;
DROP TYPE IF EXISTS T_Figura;



CREATE TYPE T_Punto AS (
  Coord_X int,
  Coord_Y int
);

CREATE TABLE IF NOT EXISTS Punto OF T_Punto (
  PRIMARY KEY (Coord_X, Coord_Y)
);

CREATE TYPE T_Linea AS (
  ID_Linea int,
  Puntos T_Punto[2]
);

CREATE TABLE IF NOT EXISTS Linea OF T_Linea (
  PRIMARY KEY (ID_Linea)
);

CREATE TYPE T_Figura AS (
  ID_Figura int,
  Nombre text,
  Color text,
  ID_Plano_Pert int
);

CREATE TABLE IF NOT EXISTS Figura OF T_Figura (
  PRIMARY KEY (ID_Figura),
  ID_Plano_Pert NOT NULL
);

DROP TRIGGER IF EXISTS Trigger_Actualizar_Num_Figuras ON Figura;
DROP FUNCTION IF EXISTS actualizar_num_figuras;

CREATE OR REPLACE FUNCTION actualizar_num_figuras() RETURNS TRIGGER AS $actualizar_num_figuras$
  BEGIN
    IF EXISTS(SELECT * FROM Plano
              WHERE (Plano.ID_Plano = new.ID_Plano_Pert)
             ) THEN
      raise notice 'is here';
      UPDATE Plano
        SET N_Figuras = N_Figuras + 1,
        ID_Figuras = ID_Figuras || new.ID_Figura
        WHERE (ID_Plano = new.ID_Plano_Pert);
    END IF;

    RETURN NEW;
  END;
$actualizar_num_figuras$ LANGUAGE plpgsql;

CREATE TRIGGER Trigger_Actualizar_Num_Figuras
  BEFORE INSERT ON Figura
      FOR EACH ROW EXECUTE PROCEDURE actualizar_num_figuras();

CREATE TYPE T_Poligono AS (
  N_Lineas int,
  ID_Lineas int[],
  ID_Figura int
);

CREATE TABLE IF NOT EXISTS Poligono OF T_Poligono (
  PRIMARY KEY (ID_Figura)
);

CREATE TYPE T_Plano AS (
  ID_Plano int,
  Fecha_Entrega date,
  Arquitectos text[],
  Dibujo_Plano bytea,
  N_Figuras int ,
  ID_Figuras int[]
);

CREATE TABLE IF NOT EXISTS Plano OF T_Plano(
  PRIMARY KEY (ID_Plano),
  N_Figuras DEFAULT 0,
  ID_Figuras DEFAULT array[]::integer[]
);

CREATE TYPE T_Proyecto AS (
  ID_Proyecto int,
  Nombre text,
  ID_Planos int[]
);

CREATE TABLE IF NOT EXISTS Proyecto OF T_Proyecto(
  PRIMARY KEY (ID_Proyecto)
);

CREATE TYPE T_Direccion AS (
  Tipo_via text,
  Nombre_via text,
  Poblacion	text,
  CP text,
  Provincia text
);

CREATE TYPE T_Jefe_Proyecto AS (
  ID_Jefe_Proyecto int,
  Nombre text,
  Direccion	T_Direccion,
  Telefono text
);

CREATE TABLE IF NOT EXISTS Jefe_Proyecto OF T_Jefe_Proyecto(
  PRIMARY KEY (ID_Jefe_Proyecto),
  UNIQUE (Nombre)
);

CREATE TABLE IF NOT EXISTS Director (
  ID_Jefe_Proyecto_Director int,
  ID_Proyecto_Dirigido int,
  PRIMARY KEY (ID_Proyecto_Dirigido),
  UNIQUE (ID_Jefe_Proyecto_Director)
);


INSERT INTO Linea (ID_Linea, Puntos) VALUES (1, array[ROW(1, 1)::T_Punto, ROW(1, 2)::T_Punto]);
INSERT INTO Linea (ID_Linea, Puntos) VALUES (2, array[ROW(1, 2)::T_Punto, ROW(2, 2)::T_Punto]);
INSERT INTO Linea (ID_Linea, Puntos) VALUES (3, array[ROW(2, 2)::T_Punto, ROW(1, 1)::T_Punto]);
SELECT * FROM Linea;

INSERT INTO Plano (ID_Plano, Fecha_Entrega, Arquitectos) VALUES (1234, '02/03/2022', array['Marleoni', 'Acevedoni', 'Serjoeni']);
INSERT INTO Figura (ID_Figura, Nombre, Color, ID_Plano_Pert) VALUES (46, 'Triangulo', 'Verde', 1234);
INSERT INTO Figura (ID_Figura, Nombre, Color, ID_Plano_Pert) VALUES (47, 'Triangulo', 'Rojo', 1234);
INSERT INTO Figura (ID_Figura, Nombre, Color, ID_Plano_Pert) VALUES (57, 'Cuadrado', 'Rojo', 1234);
INSERT INTO Figura (ID_Figura, Nombre, Color, ID_Plano_Pert) VALUES (58, 'Cuadrado', 'Azul', 1234);
SELECT * FROM Figura;
SELECT * FROM Plano;

INSERT INTO Poligono (N_Lineas, ID_Lineas, ID_Figura) VALUES (3, array[1, 2, 3], 46);
INSERT INTO Poligono (N_Lineas, ID_Lineas, ID_Figura) VALUES (3, array[1, 3, 2], 47);
SELECT * FROM Poligono;

INSERT INTO Proyecto (ID_Proyecto, Nombre, ID_Planos) VALUES (500, 'Auditorio ULL', array[1234]);
SELECT * FROM Proyecto;

INSERT INTO Jefe_Proyecto (ID_Jefe_Proyecto, Nombre, Direccion, Telefono) VALUES (6541, 'Pedro', ROW('Calle', 'Los palotes', 'La Laguna', '68861', 'Santa Cruz de Tenerife'), '968716871');
SELECT * FROM Jefe_Proyecto;

INSERT INTO Director (ID_Jefe_Proyecto_Director, ID_Proyecto_Dirigido) VALUES (6541, 500);
SELECT * FROM Director;

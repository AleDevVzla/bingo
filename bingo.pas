program Bingo;

uses crt, sysutils;

const
  NUM_BOLAS = 75;
  FILAS = 5;
  COLUMNAS = 5;

type
  TLinea = array[1..FILAS] of integer;
  TCarton = array[1..FILAS, 1..COLUMNAS] of integer;
  TMarcado = array[1..FILAS, 1..COLUMNAS] of boolean;

var
  NUM_JUGADORES: integer;
  CARTONES_POR_JUGADOR: array of integer;
  Cartones: array of array of TCarton;
  MarcadosAux: array of array of TMarcado;
  Marcados: array of array of TMarcado;
  BolasExtraidas: array[1..NUM_BOLAS] of integer;
  Ganador: integer;

// ejecución del programa
begin
  NUM_JUGADORES := LeerNumero('Ingrese el número de jugadores: ');
  SetLength(CARTONES_POR_JUGADOR, NUM_JUGADORES);
end.
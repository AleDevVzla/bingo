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

function LeerNumero(mensaje: string): integer;
var
  numero: integer;
  error: integer;
  entrada: string;
begin
  repeat
    write(mensaje);
    readln(entrada);
    val(entrada, numero, error);
    
    if error <> 0 then
      writeln('Error: Debe ingresar un número válido');
      
  until error = 0;

  LeerNumero := numero;
end;

function ExisteEnArreglo(var arreglo: array of integer; valor: integer): boolean;
var
  existe: boolean;
  i: integer;
begin
    existe := False;

    for i := Low(arreglo) to High(arreglo) do
        if (arreglo[i] = valor) then
        begin
            existe := True;
            Break;
        end;
    
    ExisteEnArreglo := existe;
end;

function GenerarNumeroAleatorio(min, max: integer): integer;
begin
  GenerarNumeroAleatorio := Random(max - min + 1) + min;
end;

function GenerarNumeroUnico(var arreglo: array of integer; min, max: integer): integer;
var
  num: integer;
begin
  repeat
    num := GenerarNumeroAleatorio(min, max);
  until not ExisteEnArreglo(arreglo, num);

  GenerarNumeroUnico := num;
end;

function GenerarLinea(numeroDeLinea: integer): TLinea;
var
  linea: TLinea;
  i: integer;
begin
  for i := 1 to FILAS do
    linea[i] := -1;

  for i := 1 to FILAS do
  begin
    linea[i] := GenerarNumeroUnico(linea, (numeroDeLinea - 1) * 15 + 1, numeroDeLinea * 15);
  end;

  GenerarLinea := linea;
end;

procedure GenerarCarton(var carton: TCarton);
var
  linea: TLinea;
  i, j: integer;
begin
  for i := 1 to COLUMNAS do
  begin
    linea := GenerarLinea(i);
    for j := 1 to FILAS do
    begin
      if not ((i = 3) and (j = 3)) then // casilla libre
        carton[j][i] := linea[j]
      else
        carton[j][i] := -1; // valor arbitrario para la casilla libre
    end;
  end;
end;

// ejecución del programa
begin
  NUM_JUGADORES := LeerNumero('Ingrese el número de jugadores: ');
  SetLength(CARTONES_POR_JUGADOR, NUM_JUGADORES);
end.
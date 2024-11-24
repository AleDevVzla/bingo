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

procedure MostrarCarton(carton: TCarton; marcado: TMarcado);
var
  i, j: integer;
begin
  for i := 1 to FILAS do
  begin
    for j := 1 to COLUMNAS do
    begin
      if (carton[i][j] = -1) or marcado[i][j] then
        Write('|--|')
      else
        Write(Format('|%2d|', [carton[i][j]]));
    end;
    Writeln;
  end;
end;

function SacarBola(): integer;
var
  bola, i: integer;
begin
  bola := GenerarNumeroUnico(BolasExtraidas, 1, NUM_BOLAS);
  for i := Low(BolasExtraidas) to High(BolasExtraidas) do
    if (BolasExtraidas[i] = -1) then
    begin
      BolasExtraidas[i] := bola;
      Break;
    end;
  SacarBola := bola;
end;

procedure MarcarNumero(var carton: TCarton; var marcado: TMarcado; var marcadoAux: TMarcado; bola: integer);
var
  i, j: integer;
begin
  for i := 1 to FILAS do
    for j := 1 to COLUMNAS do
      if carton[i][j] = bola then
      begin
        marcadoAux[i][j] := True;
        marcado[i][j] := True;
      end;
end;

function RevisarLinea(var marcadoAux: TMarcado; const marcado: TMarcado): integer;
var
  i, j, contadorLineas: integer;
  lineaProcesada: boolean;
begin
  contadorLineas := 0;

  // Revisar filas
  for i := 1 to FILAS do
  begin
    if (marcado[i][1]) and (marcado[i][2]) and (marcado[i][3]) and (marcado[i][4]) and (marcado[i][5]) then
    begin
      lineaProcesada := True;
      for j := 1 to COLUMNAS do
        if marcadoAux[i][j] then
        begin
          lineaProcesada := False;
        end;

      if not lineaProcesada then
      begin
        contadorLineas := contadorLineas + 1;
        for j := 1 to COLUMNAS do
          marcadoAux[i][j] := False;
      end;
    end;
  end;

  // Revisar columnas
  for i := 1 to FILAS do
  begin
    if (marcado[1][i]) and (marcado[2][i]) and (marcado[3][i]) and (marcado[4][i]) and (marcado[5][i]) then
    begin
      lineaProcesada := True;
      for j := 1 to COLUMNAS do
        if marcadoAux[j][i] then
        begin
          lineaProcesada := False;
        end;

      if not lineaProcesada then
      begin
        contadorLineas := contadorLineas + 1;
        for j := 1 to COLUMNAS do
          marcadoAux[j][i] := False;
      end;
    end;
  end;

  // Revisar diagonal 1
  if (marcado[1][1]) and (marcado[2][2]) and (marcado[3][3]) and (marcado[4][4]) and (marcado[5][5]) then
  begin
    lineaProcesada := True;
    if marcadoAux[5][1] or marcadoAux[4][2] or marcadoAux[3][3] or marcadoAux[2][4] or marcadoAux[1][5] then
      lineaProcesada := False;

    if not lineaProcesada then
    begin
      contadorLineas := contadorLineas + 1;
      marcadoAux[1][1] := False;
      marcadoAux[2][2] := False;
      marcadoAux[3][3] := False;
      marcadoAux[4][4] := False;
      marcadoAux[5][5] := False;
    end;
  end;

  // Revisar diagonal 2
  if (marcado[5][1]) and (marcado[4][2]) and (marcado[3][3]) and (marcado[2][4]) and (marcado[1][5]) then
  begin
    lineaProcesada := True;
    if marcadoAux[5][1] or marcadoAux[4][2] or marcadoAux[3][3] or marcadoAux[2][4] or marcadoAux[1][5] then
      lineaProcesada := False;

    if not lineaProcesada then
    begin
      contadorLineas := contadorLineas + 1;
      marcadoAux[5][1] := False;
      marcadoAux[4][2] := False;
      marcadoAux[3][3] := False;
      marcadoAux[2][4] := False;
      marcadoAux[1][5] := False;
    end;
  end;

  RevisarLinea := contadorLineas;
end;

function RevisarBingo(marcado: TMarcado): boolean;
var
  i, j: integer;
  hayBingo: boolean;
begin
  hayBingo := True;
  for i := 1 to FILAS do
    for j := 1 to COLUMNAS do
      if not marcado[i][j] then 
        hayBingo := False;
    
  RevisarBingo := hayBingo;
end;

procedure InicializarJuego();
var 
  i, j, k, l: integer;
begin
  Ganador := -1;
  
  for i := Low(CARTONES_POR_JUGADOR) to High(CARTONES_POR_JUGADOR) do
    CARTONES_POR_JUGADOR[i] := LeerNumero(Format('Ingrese el número de cartones para el jugador %d: ', [i + 1]));

  SetLength(Cartones, NUM_JUGADORES);
  SetLength(MarcadosAux, NUM_JUGADORES);
  SetLength(Marcados, NUM_JUGADORES);
  
  for i := Low(Cartones) to High(Cartones) do begin
    SetLength(Cartones[i], CARTONES_POR_JUGADOR[i]);
    SetLength(MarcadosAux[i], CARTONES_POR_JUGADOR[i]);
    SetLength(Marcados[i], CARTONES_POR_JUGADOR[i]);
  end;

  Randomize;
  
  for i := Low(BolasExtraidas) to High(BolasExtraidas) do 
    BolasExtraidas[i] := -1;
    
  for i := 0 to NUM_JUGADORES-1 do 
    for j := 0 to CARTONES_POR_JUGADOR[i]-1 do begin
      GenerarCarton(Cartones[i][j]);
      for k := 1 to FILAS do 
        for l := 1 to COLUMNAS do begin
          if (k = 3) and (l = 3) then begin
            MarcadosAux[i][j][k,l] := False;
            Marcados[i][j][k,l] := True;
          end else begin
            MarcadosAux[i][j][k,l] := False;
            Marcados[i][j][k,l] := False;
          end;
        end;
    end;
end;

procedure Jugar();
var 
  bola, i, j, lineas: integer;
begin
  repeat
    ClrScr;
    Writeln('===== Bingo =====');
    Writeln;
    
    for i := 0 to NUM_JUGADORES-1 do begin
      Writeln('Cartones del Jugador ', i+1, ':');
      for j := 0 to CARTONES_POR_JUGADOR[i]-1 do begin
        MostrarCarton(Cartones[i][j], Marcados[i][j]);
        Writeln;
      end;
    end;
    
    if Ganador <> -1 then Break;
    
    bola := SacarBola();
    Writeln('Bola numero: ', bola);
    Writeln;
    
    for i := 0 to NUM_JUGADORES-1 do begin
      for j := 0 to CARTONES_POR_JUGADOR[i]-1 do begin
        MarcarNumero(Cartones[i][j], Marcados[i][j], MarcadosAux[i][j], bola);
        if RevisarBingo(Marcados[i][j]) then begin
          Ganador := i+1;
          Writeln('Jugador ', i+1, ' ha llenado el carton ', j+1, '. Bingo!');
          Break;
        end;
        lineas := RevisarLinea(MarcadosAux[i][j], Marcados[i][j]);
        if (lineas > 0) then 
          Writeln('Jugador ', i+1, ' ha llenado ', lineas,' lineas en el carton ', j+1);
      end;
    end;
    
    Writeln('Presione cualquier tecla para continuar...');
    ReadKey;
  until False;
  
  Writeln('El ganador es el Jugador ', Ganador, '... Felicidades!.');
end;

// ejecución del programa
begin
  NUM_JUGADORES := LeerNumero('Ingrese el número de jugadores: ');
  SetLength(CARTONES_POR_JUGADOR, NUM_JUGADORES);
  InicializarJuego();
  Jugar();
end.
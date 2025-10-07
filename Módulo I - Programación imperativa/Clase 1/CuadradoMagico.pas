program CuadradoMagico;
const
    N = 4;
type
    mSquare = array [1..N, 1..N] of integer;

{Implemente un módulo que devuelva la suma de todos los valores de 
una fila F. F es pasado por parámetro}
function sumaFila(ms : mSquare; F : integer) : integer;
var
    col, sum : integer;
begin
    sum := 0;
    for col:=1 to N do
        sum := sum + ms[F, col];
    sumaFila := sum;
end;

{Implemente un módulo que devuelva la suma de todos los valores de 
una columna C. C es pasado por parámetro}
function sumaColumna(ms : mSquare; C : integer) : integer;
var
    fil, sum : integer;
begin
    sum := 0;
    for fil:=1 to N do
        sum := sum + ms[fil, C];
    sumaColumna := sum;
end;

{Implemente un módulo que devuelva la suma de todos los valores de 
la diagonal principal.}
function sumaDiagP(ms : mSquare) : integer;
var
    i, sum : integer;
begin
    sum := 0;
    for i:=1 to N do
        sum := sum + ms[i,i];
    sumaDiagP := sum;
end;

{Implemente un módulo que devuelva la suma de todos los valores de 
la diagonal secundaria.}
function sumaDiagS(ms : mSquare) : integer;
var
    i, sum : integer;
begin
    sum := 0;
    for i:=N downto 1 do
        sum := sum + ms[i,N-i+1];
    sumaDiagS := sum;
end;

{Implemente un módulo que, dada una matriz cuadrada, determine si la 
misma es un cuadrado mágico. Use los módulos ya implementados.}
function isMagic(ms : mSquare) : boolean;
var 
    i, diagonal : integer;
    isM : boolean;
begin
    diagonal := sumaDiagP(ms);
    isM := true;
    for i:=1 to N do begin
        if (diagonal <> sumaFila(ms, i)) OR (diagonal <> sumaColumna(ms, i)) then
            isM := false; 
    end;
    isMagic := isM;
end;

var
    matriz : mSquare;
    i, j : integer;
begin
    writeln('INGRESA LOS VALORES DE LA MATRIZ ',N,'x',N,':');
    for i := 1 to N do begin
        for j := 1 to N do begin
            write('Ingrese valor para [', i, ',', j, ']: ');
            readln(matriz[i,j]);
        end;
    end;

    writeln('');
    writeln('MATRIZ INGRESADA:');
    
    for i := 1 to N do begin
        for j := 1 to N do
            write(matriz[i,j]:4);
        writeln('');
    end;
    
    writeln('');
    if isMagic(matriz) then
        writeln('La matriz ingresada, es un cuadrado mágico');
end.
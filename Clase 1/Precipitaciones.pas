program  Precipitaciones;
const
    MESES = 12;
    AINI = 2000;
    AFIN = 2020;
type
    mPrec = array [1..MESES, AINI..AFIN] of integer;

{Implemente un módulo que almacene en una matriz las 
precipitaciones acumuladas de cada uno de los meses de los años 2000 
a 2020. La lectura de los datos se realiza pidiendo el año, el número de 
mes y la precipitación acumulada. Si un determinado mes-año no se 
ingresa, se supone que en ese mes-año no hubo precipitaciones. La 
lectura de datos finaliza con un valor de año fuera del rango de análisis.}
procedure cargarMatriz(var m : mPrec);
var
    i, j : integer;
    valAct, mesAct, anioAct : integer;
begin
    writeln('INGRESA EL ANIO DEL DATO (0 PARA FINALIZAR):');
    readln(anioAct);
    for i:=1 to MESES do
        for j:=AINI to AFIN do
            m[i,j] := 0;
    while ((anioAct >= 2000) AND (anioAct <= 2020)) do begin
        writeln('INGRESA EL MES DEL DATO:');
        readln(mesAct);
        writeln('INGRESA LA PRECIPITACION ACUMULADA:');
        readln(valAct);
        m[mesAct,anioAct] := valAct;
        writeln('INGRESA EL ANIO DEL DATO (0 PARA FINALIZAR):');
        readln(anioAct);
    end;
end;

{Escriba un programa que invoque al módulo de carga y luego imprima 
los datos usando los meses como columnas.}
procedure printMatrizAM(m : mPrec);
var
    i, j : integer;
begin
    for j:=AINI to AFIN do begin
        for i:=1 to MESES do
            writeln(m[i,j]);
        writeln;
    end;
end;

{Implemente un módulo que reciba una matriz, un rango de años y un 
rango de meses y devuelva la suma de todas las precipitaciones 
acumuladas de los meses y años en los rangos recibidos.}
function sumatoria(m : mPrec; anioIni, anioFin, mesIni, mesFin : integer) : integer;
var 
    i, j, sum : integer;
begin
    sum := 0;
    for i:=mesIni to mesFin do
        for j:=anioIni to anioFin do
            sum := sum + m[i,j];
    sumatoria := sum;
end;

{Implemente un módulo que reciba la matriz y devuelva el acumulado 
de precipitaciones de cada uno de los meses}
procedure sumMeses(m : mPrec);
var
    i, j, acc : integer;
begin
    for i:=1 to MESES do begin
        acc := 0;
        for j:=AINI to AFIN do
            acc := acc + m[i,j];
        writeln('MES ',i,': ACUMULA ',acc);
    end;
end;

{Implemente un módulo que reciba la matriz y devuelva el acumulado 
de precipitaciones de cada uno de los años.}
procedure sumAnios(m : mPrec);
var
    i, j, acc : integer;
begin
    for j:=AINI to AFIN do begin
        acc := 0;
        for i:=1 to MESES do
            acc := acc + m[i,j];
        writeln('ANIO ',j,': ACUMULA ',acc);
    end;
end;

var
    matriz : mPrec;
    anioInf, anioSup, mesInf, mesSup : integer;
begin
    cargarMatriz(matriz);
    printMatrizAM(matriz);
    sumMeses(matriz);
    sumAnios(matriz);
    writeln('Inserta el rango de anios a sumar, en lineas separadas:');
    readln(anioInf);
    readln(anioSup);
    writeln('Inserta el rango de meses a sumar, en lineas separadas:');
    readln(mesInf);
    readln(mesSup);
    sumatoria(matriz, anioInf, anioSup, mesInf, mesSup);
end.
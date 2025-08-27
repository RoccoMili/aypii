program Temperaturas;
const
    MESES = 12;
    AINI = 2000;
    AFIN = 2020;
type
    mTemp = array [1..MESES, AINI..AFIN] of real;

{Implemente un módulo que almacene en una matriz las temperaturas 
promedio de cada uno de los meses de los años 2000 a 2020.}
procedure cargarRandom(var m : mTemp);
var
    i, j : integer;
begin
    randomize;
    for i:=1 to MESES do
        for j:=AINI to AFIN do
            m[i,j] := (random () * 56) - 15;
end;

{Implemente un módulo que imprima el contenido de la matriz (los 
años como filas y los meses como columnas).}
procedure printMatrizAM(m : mTemp);
var
    i, j : integer;
begin
    for j := AINI to AFIN do begin
        for i := 1 to MESES do
            write(m[i,j]:8:2);
    writeln('');
    writeln('==============================================================================================');
    end;
end;

{Implemente un módulo que imprima el contenido de la matriz (los 
meses como filas y los años como columnas).}
procedure printMatrizMA(m : mTemp);
var
    i, j : integer;
begin
    for i := 1 to MESES do begin
        for j := AINI to AFIN do
            write(m[i,j]:7:2);
    writeln('');
    writeln('==============================================================================================');
    end;
end;

{Implemente un módulo que imprima el promedio anual de 
temperatura para cada año.}
procedure promedioAnual(m : mTemp);
var
    i, j : integer;
    sum : real;
begin
    for j:=AINI to AFIN do begin
        sum := 0;
        for i:=1 to MESES do
            sum := sum + m[i,j];
        writeln('PROMEDIO TEMP. DEL AÑO ',j,':',(sum/MESES):6:2);
    end;
end;

{Implemente un módulo que imprima la temperatura máxima en cada 
mes entre todos los años, junto con el año en que sucedió.}
procedure mesesMaximos(m : mTemp);
var
    i, j, mesMax : integer;
    max : real;
begin
    for i:=1 to MESES do begin
        max := 0; mesMax := 0;
        for j:=AINI to AFIN do
            if (m[i,j] > max) then begin
                max := m[i,j];
                mesMax := j;
            end;
        writeln('MÁX. TEMP. DEL MES ',i,':',max:6:2,' (',mesMax,')');
    end;
end;

{Implemente un módulo que devuelva el mes y el año en el que se 
registró la temperatura más baja}
procedure minimoTotal(m : mTemp);
var
    i, j, mesMin, anioMin : integer;
    min : real;
begin
    min := 9999; anioMin := -1;
    for i:=1 to MESES do begin
        for j:=AINI to AFIN do
            if (m[i,j] < min) then begin
                min := m[i,j];
                mesMin := i;
                anioMin := j;
            end;
    end;
    writeln('SE REGISTRARON ',min:6:2,'°C EN EL MES ',mesMin,' DEL ',anioMin);
end;
var
    matriz : mTemp;
begin
    cargarRandom(matriz);
    printMatrizAM(matriz);
    printMatrizMA(matriz);
    promedioAnual(matriz);
    mesesMaximos(matriz);
    minimoTotal(matriz);
end.
{Se propone simular un juego que consiste en contar la cantidad de veces 
que se “adivina” la tirada de un dado. Para eso el programa deberá leer un 
valor por teclado, luego generar al azar un número de 1 a 6 y ver si ambos 
valores coinciden. El juego continúa leyendo un nuevo número por teclado 
y generando uno nuevo al azar, hasta ingresar por teclado el valor  0 (cero). 
Al finalizar con el juego se debe imprimir la cantidad de intentos realizados 
y la cantidad de números “adivinados”}
program ProgramaJuego;
var 
  ale, adivinados, n, intentos : integer;
begin
  intentos := 0; adivinados := 0;
  randomize;
  writeln('NUMERO A ADIVINAR (0 para terminar):');
  readln(n);
  while (n <> 0) do begin 
    ale := random(6)+1;
    intentos := intentos+1;
    if (ale = n) then
      adivinados := adivinados+1;
    readln(n);
  end;
  writeln('INTENTOS: ',intentos);
  writeln('ACIERTOS: ',adivinados);
end.

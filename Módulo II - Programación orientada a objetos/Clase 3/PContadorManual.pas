program PContadorManual;
uses
	UContadorManual;
var
	contPar, contImpar : ContadorManual;
	i, num : integer;
begin
{Escriba un programa que lea de teclado 10 números enteros y cuente 
cuántos números pares e impares se leyeron e imprima las cantidades. 
Utilice al objeto contador para llevar ambas contabilidades.}
	contPar := contadorManual.create();
	contImpar := contadorManual.create();
	for i:=1 to 10 do begin
		writeln('Ingresa un numero');
		readln(num);
		if (num mod 2 = 0) then
			contPar.incrementar()
		else
			contImpar.incrementar();
	end;
	writeln('[PARES]: ',contPar.getCantidad(),' | [IMPARES]: ',contImpar.getCantidad());
end.


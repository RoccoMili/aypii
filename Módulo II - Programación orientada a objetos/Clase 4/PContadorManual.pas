program PContadorManual;
uses
	UContadorManual;
var
	contPar, contImpar : ContadorManual;
	i, num : integer;
begin
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


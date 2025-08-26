program ProgramaNumAleatorio;
var 
	ale, a, b, f: integer;
	found : boolean;

begin
    randomize;
    writeln('Decime el rango inferior:');
    readln(a);
    writeln('Decime el rango superior');
    readln(b);
    writeln('Num. de corte');
	readln(f);
	{Modifique el programa para que imprima números 
	aleatorios en el rango (A,B) hasta que se genere un 
	valor igual a F, el cual no debe imprimirse. F, A y B 
	son números enteros que se leen por teclado.}
	found := false;
    while (not found) do begin
		ale := random (b-a) + a + 1;
		if (ale = f) then begin
			writeln('El número coincide con f');
			found := true;
		end
		else begin
			writeln ('El numero aleatorio generado es: ', ale);
		end;
	end;
	 writeln ('Presione cualquier tecla para finalizar');
     readln;
end.

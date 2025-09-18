program ejercicioSiete;
uses
	GenericABB;
type
	ABBInt = specialize ABB<integer>;

procedure agregarNodo(a : ABBInt; i : integer);
begin
	if (a.isEmpty()) then
		a.insertCurrent(i)
	else if (i < a.current()) then
		agregarNodo(a.getLeftChild(), i)
	else
		agregarNodo(a.getRightChild(), i);
end;

function buscarNodo(a : ABBInt; i : integer) : boolean;
begin
	if (a.isEmpty()) then
		buscarNodo := false
	else if (a.current() = i) then
		buscarNodo := true
	else if (i < a.current()) then
		buscarNodo := buscarNodo(a.getLeftChild(), i)
	else
		buscarNodo := buscarNodo(a.getRightChild(), i);
end;

procedure imprimirAcotado(a : ABBInt; min, max : integer);
begin
	if (not a.isEmpty()) then begin
		if ((a.current() >= min) AND (a.current() <= max)) then begin
			imprimirAcotado(a.getLeftChild(), min, max);
			writeln(a.current());
			imprimirAcotado(a.getRightChild(), min, max);
		end
		else if (a.current() < min) then
			imprimirAcotado(a.getRightChild(), min, max)
		else 
			imprimirAcotado(a.getLeftChild(), min, max);
	end;
end;

var
	arbol : ABBInt;
	buscMin, buscMax, num, cont : integer;
begin
	arbol := ABBInt.create();
	randomize;
	num := random(31);
	cont := 0;
	while (num <> 0) do begin
		agregarNodo(arbol, num);
		cont := cont + 1;	
		writeln('ELEMENTO NUM. ',cont);
		num := random(31);
	end;

	writeln('Ingresa un numero minimo para buscar');
	readln(buscMin);
	writeln('Ingresa un numero maximo para buscar');
	readln(buscMax);
	imprimirAcotado(arbol, buscMin, buscMax);
end.

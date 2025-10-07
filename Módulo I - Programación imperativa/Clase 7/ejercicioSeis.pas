program ejercicioSeis;
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

procedure printMenores(a : ABBInt; num : integer);
begin
	if (not a.isEmpty()) then begin
		if (a.current <= num) then begin
			printMenores(a.getLeftChild(), num);
			writeln(a.current());
			printMenores(a.getRightChild(), num);
		end
		else
			printMenores(a.getLeftChild, num);
	end;
end;

procedure printMayores(a : ABBInt; num : integer);
begin
	if (not a.isEmpty()) then begin
		if (a.current >= num) then begin
			printMayores(a.getLeftChild(), num);
			writeln(a.current());
			printMayores(a.getRightChild(), num);
		end
		else
			printMayores(a.getRightChild, num);
	end;
end;

var
	arbol : ABBInt;
	buscar, num, cont : integer;
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

	writeln('Ingresa un numero para buscar todos sus valores menores');
	readln(buscar);
	printMenores(arbol, buscar);
	writeln('Ingresa un numero para buscar todos sus valores mayores');
	readln(buscar);
	printMayores(arbol, buscar);
end.

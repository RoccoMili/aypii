program ejercicioUno;
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

procedure printPreOrden(a : ABBInt);
begin
	if (not a.isEmpty()) then begin
		writeln(a.current());
		printPreOrden(a.getLeftChild());
		printPreOrden(a.getRightChild());
	end;
end;

procedure printPostOrden(a : ABBInt);
begin
	if (not a.isEmpty()) then begin
		printPostOrden(a.getLeftChild());
		printPostOrden(a.getRightChild());
		writeln(a.current());
	end;
end;

var
	arbol : ABBInt;
	num, cont : integer;
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
	printPreOrden(arbol);
	writeln('======== NUEVA IMPRESION ========');
	printPostOrden(arbol);
end.

program ejercicioCinco;
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

function minimo(a : ABBInt) : integer;
begin
	if (a.hasLeftChild()) then
		minimo := minimo(a.getLeftChild)
	else
		minimo := a.current();
end;

function maximo(a : ABBInt) : integer;
begin
	if (a.hasRightChild()) then
		maximo := maximo(a.getRightChild())
	else
		maximo := a.current();
end;

var
	arbol : ABBInt;
	num, cont : integer;
begin
	arbol := ABBInt.create();
	randomize;
	num := random(301);
	cont := 0;
	while (num <> 0) do begin
		agregarNodo(arbol, num);
		cont := cont + 1;	
		writeln('ELEMENTO NUM. ',cont);
		num := random(301);
	end;

	if (not arbol.isEmpty()) then begin
		writeln('El elemento minimo del arbol es el ',minimo(arbol));
		writeln('El elemento maximo del arbol es el ',maximo(arbol));
	end
	else
		writeln('El arbol esta vacio');
end.

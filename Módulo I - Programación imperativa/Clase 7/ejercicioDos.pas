program ejercicioDos;
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

function contarElementos(a: ABBInt): integer;
begin	
	if (a.isEmpty()) then
		contarElementos:= 0
	else begin
		contarElementos:= contarElementos(a.getLeftChild()) + contarElementos(a.getRightChild()) + 1;
	end
end;

var
	arbol : ABBInt;
	i, num, cont : integer;
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
	writeln('LA CANTIDAD DE ELEMENTOS DEL ARBOL ES DE: ', contarElementos(arbol));
end.

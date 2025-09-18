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

var
	arbol : ABBInt;
	i, num : integer;
begin
	arbol := ABBInt.create();
	randomize;
	for i:=1 to 20 do begin
		num := random(30)+1;
		writeln('AGREGANDO: ',num);
		agregarNodo(arbol, num);
	end;
	
	i:=1;
	for i:=1 to 30 do begin
		if (buscarNodo(arbol, i)) then
			writeln('El valor ',i,' esta en el arbol')
		else 
			writeln('El valor ',i,' NO esta en el arbol');
	end;	
	
end.

program ContarValores;
uses
	GenericLinkedList;
type
	listaEnteros = specialize LinkedList<integer>;

procedure CargarLista(var l : listaEnteros; cant : integer);
var
	i, act : integer;
begin
	for i:=1 to cant do begin
		act := random(21) + (-10);
		l.add(act);
	end;
end;

procedure imprimirLista(l:listaEnteros);
begin
  l.reset();
  while not (l.eol()) do begin
    writeln(l.current());
    l.next();
  end;
end;

procedure eliminarElemento (var l : listaEnteros; valor:integer);
var
  eliminado:boolean;
begin
	eliminado := false;
  l.reset();
  while not (l.eol()) AND not eliminado do begin
    if (l.current() = valor) then begin
      l.removeCurrent();
      eliminado := true;
      writeln('se elimino el elemento correctamente');
    end
    else
      l.next();
  end;
end;

procedure EliminarTodosLosElementos(var l : listaEnteros; valor : integer);
begin
	l.reset();
	while (not l.eol()) do begin
		if (l.current() = valor) then begin
			l.removeCurrent();
			writeln('Elemento eliminado correctamente');
		end
		else
			l.next();
	end;
end;

procedure CargarListaOrdenada(var l : listaEnteros; cant, min, max : integer);
var
	i, act : integer;
begin
	for i:=1 to cant do begin
		act := random(max-min) + min + 1;
		l.reset();
		while ((not l.eol()) AND (l.current() < act)) do
			l.next();
		l.insertCurrent(act);
	end;
end;

function BuscarElemento(l:listaEnteros; valor:integer):boolean;
var
  encontrado : boolean;
begin
  encontrado := false;
  l.reset();
  while ((not l.eol()) AND (not encontrado)) do begin
    if (l.current() = valor ) then
      encontrado := true
    else
      l.next();
   end;
   BuscarElemento := encontrado;
end;

procedure EliminarElementoConOrden(var l : listaEnteros; valor : integer);
var
  encontrado:boolean;
begin
    encontrado:=false;
	l.reset();
	while ((not l.eol()) AND (l.current() <= valor)) AND not encontrado do begin
		if (l.current() = valor) then begin
			l.removeCurrent();
			encontrado:=true;
			writeln('se elimino el elemento');
		end
		else
			l.next();
	end;
end;

procedure EliminarTodosLosElementosConOrden(var l : listaEnteros; valor : integer);
 begin
	l.reset();
	while ((not l.eol()) AND (l.current() <= valor)) do begin
		if (l.current() = valor) then
			l.removeCurrent()
		else
			l.next();
	end;
end;

procedure ContarValores(l : listaEnteros);
var
    aux : listaEnteros;
    actual : integer;
begin
    aux := listaEnteros.create();
    while (not l.eol()) do begin
        actual := l.current();
        
    end;
end;

begin
    randomize;
end.
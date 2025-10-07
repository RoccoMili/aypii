program ProgramaListas;
uses
	GenericLinkedList;
type
	listaEnteros = specialize LinkedList<integer>;

{Implemente un módulo CargarLista que cree una lista de enteros vacía 
y luego le agregue N valores aleatorios, donde N es recibido por 
parámetro. Los valores, generados aleatoriamente entre un mínimo y 
máximo recibidos por parámetro, deben ser almacenados en la lista en 
el mismo orden que se generaron.}
procedure CargarLista(var l : listaEnteros; cant, min, max : integer);
var
	i, act : integer;
begin
	for i:=1 to cant do begin
		act := random(max-min) + min + 1;
		l.add(act);
	end;
end;

{Implemente un módulo ImprimirLista que reciba una lista de enteros e 
imprima todos los valores de la lista en el mismo orden que están 
almacenados}
procedure imprimirLista(l:listaEnteros);
begin
  l.reset();
  while not (l.eol()) do begin
    writeln(l.current());
    l.next();
  end;
end;

{Implemente un módulo EliminarElemento para eliminar un valor de 
una lista de enteros. El módulo debe recibir la lista y el valor a eliminar 
(que puede no existir en la lista).}
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

{Implemente un módulo EliminarTodosLosElementos para eliminar 
todas las ocurrencias de un valor de una lista de enteros. El módulo 
debe recibir la lista y el valor a eliminar (que puede no existir en la 
lista).}
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

{Implemente un módulo CargarListaOrdenada que genere una nueva 
lista con N (recibido por parámetro) valores aleatorios entre un mínimo 
y un máximo (también recibidos por parámetro). Los valores dentro de 
la lista deben quedar ordenados de menor a mayor.}
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

{Implemente un módulo BuscarElemento que reciba una lista de 
enteros y un valor entero y retorne true si el valor se encuentra en la 
lista y false en caso contrario.}
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

{Implemente un módulo EliminarElementoConOrden para eliminar un 
valor de una lista ordenada de enteros. El módulo debe recibir la lista y 
el valor a eliminar (que puede no existir en la lista).}
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

{ Implemente un módulo EliminarTodosLosElementosConOrden para 
eliminar todas las ocurrencias de un valor de una lista de enteros. El 
módulo debe recibir la lista y el valor a eliminar (que puede no existir 
en la lista).}
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

{Invocar desde el programa principal a los módulos implementados  con 
la lista generada y valores leídos por teclado. Luego mostrar la lista 
resultante}
var
	lista, lista2 : listaEnteros;
	n, rMin, rMax, borrar, buscar: integer;
	encontrado: boolean;
begin
	lista := listaEnteros.create();
	randomize;
	writeln('Ingresá cuántos números');
	readln(n);
	writeln('Ingresá el rango mínimo');
	readln(rMin);
	writeln('Ingresá el rango máximo');
	readln(rMax);
	cargarLista(lista, n, rMin, rMax);
    writeln('Lista original:');
    imprimirLista(lista);
    
    writeln('Decime un valor para borrar:');
    readln(borrar);
    eliminarElemento(lista, borrar);
    writeln('Lista después de eliminar un elemento:');
    imprimirLista(lista);
    
    writeln('Decime otro valor para borrar todas sus ocurrencias:');
    readln(borrar);
    eliminarTodosLosElementos(lista, borrar);
    writeln('Lista después de eliminar todas las ocurrencias:');
    imprimirLista(lista);
    
    lista2 := listaEnteros.create();
    writeln('Decime cuántos elementos tiene la lista ordenada');
    readln(n);
	writeln('Ingresá el rango mínimo');
	readln(rMin);
	writeln('Ingresá el rango máximo');
	readln(rMax);
	cargarListaOrdenada(lista2, n, rMin, rMax);
	writeln('Lista ordenada:');
	imprimirLista(lista2);
	
	writeln('Decime un valor para buscar:');
	readln(buscar);
	encontrado := BuscarElemento(lista2, buscar);  // Corregido: BuscarElemento_ -> BuscarElemento
	if encontrado then
		writeln('El valor ', buscar, ' se encuentra en la lista')
	else
		writeln('El valor ', buscar, ' NO se encuentra en la lista');
	
	writeln('Decime un valor para borrar de la lista ordenada:');
    readln(borrar);
    eliminarElementoConOrden(lista2, borrar);
    writeln('Lista ordenada después de eliminar un elemento:');
    imprimirLista(lista2);
    
    writeln('Decime otro valor para borrar todas sus ocurrencias de la lista ordenada:');
    readln(borrar);
    eliminarTodosLosElementosConOrden(lista2, borrar);
    writeln('Lista ordenada final:');
    imprimirLista(lista2);
end.

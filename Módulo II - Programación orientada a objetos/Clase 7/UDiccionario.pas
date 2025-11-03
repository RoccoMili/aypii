unit UDiccionario;
{$mode objfpc}
interface
uses GenericABB, GenericLinkedList;
	type
		Nodo = class
			private
				key : string;
				value : real;
			public
				constructor create(k : string; v : real);
				procedure setKey(k : string);
				procedure setValue(v : real);
				function getKey() : string;
				function getValue() : real;
		end;
		stringList = specialize LinkedList<string>;
		ABB = specialize ABB<Nodo>;
		Diccionario = class
			private
				key_values : ABB;
				procedure agregarNodo(arbol : ABB; nuevoNodo : Nodo);
				function buscar(arbol : ABB; key : string) : real;
				procedure recolectar(arbol : ABB; keys : stringList);
				function contar(arbol : ABB) : integer;
				function existe(arbol : ABB; key : string) : boolean;
			public
				constructor create();
				procedure addKeyValue(key : string; value : real);
				function getValue(key : string) : real;
				function size() : integer;
				function getKeys() : stringList;
				function exists(key : string) : boolean;
		end;
implementation
	constructor Nodo.create(k : string; v : real);
		begin
			key := k;
			value := v;
		end;
	procedure Nodo.setKey(k : string);
		begin
			key := k;
		end;
	procedure Nodo.setValue(v : real);
		begin
			value := v;
		end;
	function Nodo.getKey() : string;
		begin
			getKey := key;
		end;
	function Nodo.getValue() : real;
		begin
			getValue := value;
		end;
	procedure Diccionario.agregarNodo(arbol : ABB; nuevoNodo : Nodo);
		begin
			if (arbol.isEmpty()) then
				arbol.insertCurrent(nuevoNodo)
			else if (arbol.current().getKey = nuevoNodo.getKey()) then
				arbol.current().setValue(nuevoNodo.getValue())
			else if (arbol.current().getKey() > nuevoNodo.getKey()) then 
				self.agregarNodo(arbol.getLeftChild(), nuevoNodo)
			else
				self.agregarNodo(arbol.getRightChild(), nuevoNodo);
		end;
	function Diccionario.buscar(arbol : ABB; key : string) : real;
		begin
			if (arbol.isEmpty()) then
				buscar := -1 // valor al azar para asegurarnos de manejar errores
			else if (arbol.current().getKey() = key) then
				buscar := arbol.current().getValue()
			else if (arbol.current.getKey() > key) then
				buscar := buscar(arbol.getLeftChild(), key)
			else
				buscar := buscar(arbol.getRightChild(), key);
		end;
	procedure Diccionario.recolectar(arbol : ABB; keys : stringList);
		begin
			if (not arbol.isEmpty()) then begin
				self.recolectar(arbol.getLeftChild(), keys);
				keys.add(arbol.current().getKey());
				self.recolectar(arbol.getRightChild(), keys);
			end;
		end;
	function Diccionario.contar(arbol : ABB) : integer;
		begin
			if (arbol.isEmpty()) then
				contar := 0
			else
				contar := contar(arbol.getLeftChild()) + contar(arbol.getRightChild());
		end;
	function Diccionario.existe(arbol : ABB; key : string) : boolean;
		begin
			if (arbol.isEmpty()) then
				existe := false
			else if (arbol.current().getKey() = key) then
				existe := true
			else if (arbol.current.getKey() > key) then
				existe := existe(arbol.getLeftChild(), key)
			else
				existe := existe(arbol.getRightChild(), key);
		end;
	constructor Diccionario.create();
		begin
			key_values := ABB.create();
		end;
	procedure Diccionario.addKeyValue(key : string; value : real);
		var
			newNodo : Nodo;
		begin
			newNodo := Nodo.create(key, value);
			self.agregarNodo(key_values, newNodo);
		end;
	function Diccionario.getValue(key : string) : real;
		begin
			if (self.existe(key_values, key)) then
				getValue := self.buscar(key_values, key);
			// podría mejorarse llamando una sola vez a self.buscar, aprovechando el retorno de -1
		end;
	function Diccionario.size() : integer;
		begin
			size := self.contar(key_values);
		end;
	function Diccionario.getKeys() : stringList;
		var
			keys : stringList;
		begin
			keys := stringList.create();
			self.recolectar(key_values, keys);
			getKeys := keys;
		end;
	function Diccionario.exists(key : string) : boolean;
		begin
			exists := self.existe(key_values, key);
		end;
end.

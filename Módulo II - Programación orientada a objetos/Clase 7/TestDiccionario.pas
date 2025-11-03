program TestDiccionario;
uses SysUtils, UDiccionario, GenericLinkedList;

const CANT_PAISES = 10;

var d: Diccionario;
	i: integer;
	l: stringList;
	paises: array[1..CANT_PAISES] of string = ('India', 'China', 'Estados unidos', 'Indonesia', 'Pakistan',
											   'Nigeria', 'Brasil', 'Bangladesh', 'Rusia', 'Etiopia');
	superficies: array[1..CANT_PAISES] of real = (1463.9, 1416.1, 347.8, 285.8, 255.2,
												  23.75, 21.28, 17.57, 14.4, 13.55);
begin 
d:= Diccionario.create;

writeln('Agregando pares clave-valor');
for i:= 1 to CANT_PAISES do
	d.addKeyValue(paises[i], superficies[i]);

writeln('Actualizando (corrigiendo) algunos pares clave-valor');
for i:= 6 to CANT_PAISES do
	d.addKeyValue(paises[i], superficies[i] * 10);
	
writeln('Pidiendo claves');
l:= d.getKeys();

writeln('Imprimiendo pares clave-valor');
l.reset();
writeln('Pais' + chr(9) + chr(9) + 'Poblacion (millones)');
while not l.eol() do
	begin
	write(l.current + chr(9));
	if length(l.current) < 8 then
		write(chr(9));
	writeln(d.getValue(l.current):2:1);
	l.next;
	end;
	
writeln('Pidiendo la poblacion de un pais que no esta almacenado en el diccionario');
writeln('Deberia dar error de ejecucion');
writeln(d.getValue('Argentina'));
end.

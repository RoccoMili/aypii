program TorneoGimnasia;
uses SysUtils, GenericLinkedList, URandomGenerator, USerie, UTorneo;

type 		
	RSerie = record
		numeroGimnasta: integer;
		puntajes: array[1..3] of real;
	end;
	
	ListaRSerie = specialize LinkedList<RSerie>;
	
// Use esta función para obtener la lista con los puntajes de cada juez de cada serie realizada por las gimnastas
procedure ObtenerInfoSeries(var lista: ListaRSerie);
var i, nSeries: integer;
	ser: RSerie;
	rg: RAndomGenerator;
begin
lista:= ListaRSerie.create();
rg:= RandomGenerator.create;

nSeries:= random(300) + 100;	//Nos aseguramos un mínimo de 100 pasadas

for i:= 1 to nSeries do
	begin
	ser.numeroGimnasta:= rg.getInteger(101, 150);	// 50 gimnastas
	ser.puntajes[1]:= rg.getInteger(0, 100) / 10;
	ser.puntajes[2]:= rg.getInteger(0, 100) / 10;
	ser.puntajes[3]:= rg.getInteger(0, 100) / 10;
	
	lista.add(ser);
	end;
end;
//--------------------------------------------------------


var 
	lista : ListaRSerie;
	datosTorneo : Torneo;
	i, cont : integer;
	serieActual : Serie;
begin
	randomize;

	writeln('Obteniendo lista');
	ObtenerInfoSeries(lista);

	datosTorneo := Torneo.create();

	cont := 0;

	lista.reset();
	while (not lista.eol()) do begin
		serieActual := Serie.create();
		for i:=1 to 3 do
		  	serieActual.agregarPuntaje(lista.current().puntajes[i]);
		datosTorneo.agregarSerieGimnasta(lista.current().numeroGimnasta, serieActual);
		cont := cont + 1;

		if (cont mod 20 = 0) then begin
		  	writeln('===== PODIO ACTUAL =====');
			writeln('[1] ',datosTorneo.getPrimerPuesto());
			writeln('[2] ',datosTorneo.getSegundoPuesto());
			writeln('[3] ',datosTorneo.getTercerPuesto());
		end;

		lista.next();
	end;

	writeln('========= PODIO FINAL =========');
	writeln('[1] ',datosTorneo.getPrimerPuesto());
	writeln('[2] ',datosTorneo.getSegundoPuesto());
	writeln('[3] ',datosTorneo.getTercerPuesto());
end.

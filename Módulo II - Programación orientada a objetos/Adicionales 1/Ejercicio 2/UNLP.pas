program UNLP;
{$mode objfpc}

// ATENCION. Este código tiene partes a COMPLETAR por el estudiante.

uses URandomGenerator, UDateTime, GenericLinkedList, UProyectos;    

procedure armarProyecto(var p: Proyecto);
var rg: RandomGenerator;
	cantInv: integer;
	i, j, cantSub, codigoUnico: integer;
	nombreInvestigador: string;
	nombres: array[1..12] of string = ('Emmet Brown', 'Henry Jekyll', 'Cosima Niehaus', 'Walter White', 
									   'Leslie Winkle', 'Henry Wu', 'Indiana Jones', 'Victor Frankenstein',
									   'Dana Scully', 'Bernadette Rostenkowski', 'Amy Farrah Fowler', 'Temperance Brennan');
	inv : Investigador;
	subsEquipamiento : SubsidioEquipamiento;
	subsViaje : SubsidioViaje;
	fechaMin, fechaMax : Date;
	viajeOSubsidio : boolean;
begin
// Crear el proyecto con código y nombre del director.
p:= Proyecto.create(2710, 'Waldo');
//////////////////////////////////////////////////////

rg:= RandomGenerator.create();
cantInv:= rg.getInteger(5, 10);
for i:= 1 to cantInv do
	begin
	nombreInvestigador:= nombres[i];
	// Crear un investigador con el nombre dado y la categoría y especialidad elegidas al azar
	// Agregarlo al proyecto
	inv := Investigador.create(nombreInvestigador, rg.getInteger(1, 5), rg.getString(5));
	p.agregarInvestigador(inv);
	//-------------------------------------------------------------------------
	end;
	
cantSub:= rg.getInteger(25, 50);
fechaMin := Date.create(1, 1, 2000);
fechaMax := Date.create(31, 12, 2025);
for i:= 1 to cantSub do
	begin
	codigoUnico:= i * 100;
	nombreInvestigador:= nombres[rg.getInteger(1,12)];
	// Elija al azar si crear un subsidio de viajes o un subsidio de equipamiento
	// genere los datos necesarios para crear cada uno de ellos. Use el código único dado y 
	// elija un monto al azar.
	// En el caso de crear un subsidio de equipamientos, agregue al azar hasta tres equipos más.
	// Agregarlo al investigador con el nombre dado (OJO: el investigador podría no existir)
	viajeOSubsidio := rg.getBoolean();
	if (viajeOSubsidio) then begin
		subsViaje := SubsidioViaje.create(rg.getDate(fechaMin, fechaMax), rg.getString(6), rg.getInteger(1, 30), codigoUnico, rg.getReal(20000, 100000));
		p.agregarSubsidioAInvestigador(subsViaje, nombreInvestigador);
	end
	else begin
		subsEquipamiento := SubsidioEquipamiento.create(rg.getString(5),codigoUnico, rg.getReal(20000, 100000));
		for j:=1 to 3 do
			subsEquipamiento.agregarEquipo(rg.getReal(20000, 100000), rg.getString(6));
		p.agregarSubsidioAInvestigador(subsEquipamiento, nombreInvestigador);
	///////////////////////////////////////////////////////////////////////////
	end;
	end;
end;

procedure otorgarSubsidios(proy: Proyecto);
var i, codigoUnico, cantSubT, cantSub: integer;
	rg: RandomGenerator;
	exito : boolean;
begin
rg:= RandomGenerator.create();

// Obtener la cantidad de subsidios totales del proyecto
cantSubT:= proy.cantidadDeSubsidios();
/////////////////////////////////////////////////////////////////////

cantSub:= rg.getInteger(1, cantSubT);
for i:= 1 to cantSub do
	begin
	codigoUnico:= rg.getInteger(1, cantSubT) * 100;
	// Otorgar el subsidio con codigoUnico dado (Ojo, podría no existir)
	proy.otorgarSubsidio(codigoUnico);
	///////////////////////////////////////////////////////////////////////////
	end;
end;

var proy: Proyecto;
begin 
armarProyecto(proy);
otorgarSubsidios(proy);
writeln('Datos del proyecto');
writeln(proy.toString());
end.

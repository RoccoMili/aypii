program Presupuestos;
{$mode objfpc}

uses URandomGenerator, UInmobiliaria, UDateTime;

procedure armarInmobiliaria(var inmo: Inmobiliaria);
var
	unPintor : Pintor;
	unPlomero : Plomero;
	unElectricista : Electricista;
	unJardinero : Jardinero;
begin
	inmo := Inmobiliaria.create();
    unPintor := Pintor.create('Juan Pintor', 5000);
    inmo.agregarContratado(unPintor);
    
    unPlomero := Plomero.create('Pedro Plomero', 6000);
    inmo.agregarContratado(unPlomero);
    
    unElectricista := Electricista.create('Carlos Electricista', 5500);
    inmo.agregarContratado(unElectricista);
    
    unJardinero := Jardinero.create('Luis Jardinero', 4000);
    inmo.agregarContratado(unJardinero);
end;

procedure presupuestarAlquileres(inmo: Inmobiliaria);
var i, supTot, supCub, cantBan, cantHab, canGas: integer;
	p: Propiedad;
	mm: real;
	rg: RandomGenerator;
	cantPres: integer;
	fechaMin, fechaMax : Date;
begin
rg:= RandomGenerator.create();
cantPres:= rg.getInteger(5, 10);

for i:= 1 to cantPres do
	begin
	supTot:= random(500) + 100;
	supCub:= supTot - random (300);
	cantBan:= random(3) + 1;
	cantHab:= random (6) + 2;
	canGas:= random (5) + 1;

	fechaMin := Date.create(1, 1, 2025);
	fechaMax := Date.create(31, 12, 2025);


	p:= Propiedad.create(supTot, supCub, cantBan, cantHAb, canGas);
	// Pida a la inmobiliaria el presupuesto de alquiler de la propiedad
	mm:= inmo.presupuestarPropiedad(p, rg.getDate(fechaMin, fechaMax));
	//---------------------------------------------------------------------
	
	writeln('La propiedad ' + p.toString() + ' tiene un costo de ', mm:0:2, ' pesos mensuales');
	end;
	
writeln('El resumen del día es ' + inmo.resumen());
end;

var inmo: Inmobiliaria;
begin 
armarInmobiliaria(inmo);

presupuestarAlquileres(inmo);
end.

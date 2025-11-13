program CentroImpresion;
{$mode objfpc}

// ATENCION. Este código tiene partes a COMPLETAR por el estudiante.

// NO IMPLEMENTE LAS CLASES EN ESTE ARCHIVO. IMPLEMÉNTELAS EN UNA O MAS UNIDADES
// E INCLUYA EN LA CLÁUSULA uses LAS UNIDADES IMPLEMENTADAS;

uses SysUtils, URandomGenerator, GenericLinkedList, UImpresiones;

const
	CANT_IMPRESORAS = 3;

type
	
	VectorImpresoras = array[1..CANT_IMPRESORAS] of Impresoras;

procedure armarImpresoras(var imps: VectorImpresoras);
var
	rg : RandomGenerator;
begin
rg := RandomGenerator.create();
imps[1]:= ImpresoraComun.create(rg.getInteger(40, 80), rg.getInteger(10, 20)); // Instancie una ImpresoraComun
imps[2]:= ImpresoraAvanzada.create(rg.getInteger(200, 350)); // Instancie una ImpresoraAvanzada
imps[3]:= ImpresoraABateria.create(rg.getInteger(200, 350), rg.getInteger(12, 24)); // Instancie una ImpresoraABateria
end;

function crearDocumento(paginas: integer): Documento;
begin
// Instancie un documento con la cantidad de paginas recibida por parámetro
crearDocumento:= Documento.create(paginas);
//////////////////////////////////////////////////////////////////////
end;

procedure imprimirDocumentos(impresoras: VectorImpresoras);
var i, h, cantDocs, cantOn, indiceImp: integer;
	rg: RandomGenerator;
	estado: array[1..CANT_IMPRESORAS] of integer;
		// 1: enchufada y encendida
		// 2: enchufada y apagada
		// 3: desenchufada
	doc: Documento;
	imp: Impresoras;
	pags : integer;
begin
rg:= RandomGenerator.create();

impresoras[1].enchufar();
impresoras[1].encender();
estado[1] := 1;

impresoras[2].enchufar();
estado[2] := 2;

estado[3] := 3;

cantOn := 1; 
	
cantDocs:= rg.getInteger(10, 20);
indiceImp:= 1;
i:= 1;
while i <= cantDocs do
	begin
	pags:= rg.getInteger(1, 5);
	doc:= crearDocumento(pags);
	
	imp:= impresoras[indiceImp];
	
	// Complete la condición del if
	if imp.podesImprimir(doc) then
	////////////////////////////////////////////////////////////////////
		begin
		writeln('-------------------------------------------------------');
		writeln('Imprimiendo documento ', i, ' de ', pags, ' paginas en impresora ', indiceImp);
		writeln('');
		
		// Imprima el documento "doc" usando la impresora "imp"
		imp.imprimir(doc);
		////////////////////////////////////////////////////////////////
		
		writeln('');	
		writeln('-------------------------------------------------------');
		
		i:= i + 1;		
		end
	else
	if estado[indiceImp] = 2 then
		begin
		writeln('Encendiendo impresora ', indiceImp);
		
		// Encienda la impresora "imp"
		imp.encender();
		////////////////////////////////////////////////////////////////
		
		estado[indiceImp]:= 1;
		cantOn:= cantOn + 1;
		end
	else
	if estado[indiceImp] = 3 then
		begin
		writeln('Enchufando impresora ', indiceImp);
		
		// Enchufe la impresora "imp"
		imp.enchufar();
		////////////////////////////////////////////////////////////////
		
		estado[indiceImp]:= 2;
		end;
	
	// Apagando y desenchufando al azar
	if cantOn > 1 then
		begin
		if random() < 0.2 then
			begin
			writeln('Desenchufando impresora ', indiceImp);
			
			// Desenchufe la impresora "imp"
			imp.desenchufar();
			////////////////////////////////////////////////////////////////
		
			estado[indiceImp]:= 3;
			cantOn:= cantOn - 1;
			end
		else
		if random() < 0.3 then
			begin
			writeln('Apagando impresora ', indiceImp);
			
			// Apague la impresora "imp"
			imp.apagar();
			////////////////////////////////////////////////////////////////
		
			estado[indiceImp]:= 2;
			cantOn:= cantOn - 1;
			end;
		end;
		
	// Cargando hojas al azar
	if random < 0.3 then
		begin
		h:= random(10)+1;
		writeln('Cargando ', h , ' hojas en la impresora ', indiceImp);
		
		// Cargue la impresora "imp" con "h" hojas
		imp.cargarHojas(h);
		////////////////////////////////////////////////////////////////
		
		end;
			
	indiceImp:= (indiceImp mod CANT_IMPRESORAS) + 1;
	end;
end;

var imps: VectorImpresoras;
begin 
armarImpresoras(imps);

imprimirDocumentos(imps);
end.

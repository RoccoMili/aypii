{
Rutinas para cargar inmuebles con informacion aleatoria;
}
Program ProgramInmueble;
const dimf=5;

Type

inmueble = record
   tipo: string;
   cantHab: integer;
   cantBanos:integer;
   precio: real;
   localidad: string;
end;
Inmuebles = array[1..DIMF] of inmueble; 

    procedure cargarInmueble(var inmu1:inmueble);
    var 
    vTipos:array[1..4] of string= ('Casa', 'Departamento', 'Duplex', 'Local Comercial');
    vLocal:array[1..10] of string= ('La Plata', 'Berisso', 'Ensenada', 'Quilmes','Avellaneda','Bernal','Berazategui','Azul','Tandil','Dolores');
    begin
             
     inmu1.tipo:= vTipos[random(4)+1];
     inmu1.cantHab:=random(5);
     inmu1.cantBanos:=random(3)+1;
     inmu1.precio:=random(50000)/2+10000;
     inmu1.localidad:= vLocal[random(10)+1];
      
    end;
    		
	procedure ImprimirVector( vc:inmuebles);//se dispone
    var 
    i : integer;
    
    begin
     for i:=1 to DIMF do
	   begin
	     writeln('Tipo Inmueble: ' , vc[i].Tipo);
	     writeln('Cantidad de Habitaciones: ' , vc[i].CantHab);
	     writeln('Cantidad de Baños: ' , vc[i].cantBanos);
	     writeln('Precio: ' , vc[i].Precio:10:2);  
	     writeln('Localidad: ' , vc[i].localidad);
	     writeln();
	   end
      
    end;
var
    inmu1: inmueble;
    vector:Inmuebles;
    i:integer;
	        	
begin
	randomize; 
	for i:=1 to DIMF do
	begin
	  CargarInmueble(inmu1);
	  vector[i]:=inmu1;
	end;
	ImprimirVector(vector); 
	
end.

program Catedra;
const
	COM = 4;
	ALU = 5;
type
	estudiante = record
		nombre, apellido : string;
		nota : integer;
	end;
	mCat = array [1..COM, 1..ALU] of estudiante;
	
procedure leerEstudiante(var e : estudiante);
begin
	writeln('NOMBRE:');
	readln(e.nombre);
	writeln('APELLIDO:');
	readln(e.apellido);
	writeln('NOTA:');
	readln(e.nota);
end;

{Implemente un módulo que almacene la información de los 20
 estudiantes.}
procedure cargarCatedra(var m : mCat);
var
	fil, col : integer;
	estAct : estudiante;
begin
	for fil:=1 to COM do
		for col:=1 to ALU do begin
			writeln('====== ALUMNO ',col,' (COM. ', fil,') ======');
			leerEstudiante(estAct);
			m[fil,col] := estAct;
		end;
end;

{Implemente un módulo que reciba la información de los estudiantes y
 devuelva el estudiante con la nota máxima.}
function estudianteMax(m : mCat) : estudiante;
var
	fil, col : integer;
	estMax : estudiante;
begin
	estMax := m[1,1];
	for fil:=1 to COM do
		for col:=1 to ALU do
			if (estMax.nota < m[fil,col].nota) then
				estMax := m[fil,col];
	estudianteMax := estMax;
end;

{Implemente un módulo que reciba la información de los estudiantes y
 una nota numérica y devuelva true si al menos un estudiante tiene
 dicha nota, y false en caso contrario.}
function existeNota(m : mCat; valor : integer) : boolean;
var
	fil, col : integer;
begin
	existeNota := false;
	for fil:=1 to COM do
		for col:=1 to ALU do
			if (valor = m[fil,col].nota) then
				existeNota := true;
end;

var
	matriz : mCat;
	estudMax : estudiante;
	buscar : integer;
BEGIN
	cargarCatedra(matriz);
	estudMax := estudianteMax(matriz);
	writeln('El estudiante ', estudMax.nombre, ' ', estudMax.apellido, ' tiene la nota máxima: ', estudMax.nota);
	writeln('Inserta una nota para buscar:');
	readln(buscar);
	if existeNota(matriz, buscar) then
		writeln('Existe')
	else
		writeln('No existe');
END.




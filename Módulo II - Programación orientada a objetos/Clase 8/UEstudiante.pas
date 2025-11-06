unit UEstudiante;
{$mode objfpc}
interface
uses UPersona, URandomGenerator, UDateTime, GenericLinkedList;
	type
		materia = record
			asignatura : string;
			nota : real;
		end;
		listaMaterias = specialize LinkedList<materia>;
		Estudiante = class(Persona)
			private
				conocimiento : RandomGenerator;
				analitico : listaMaterias;
			public
				constructor create(newNombre, newDNI : string; newFecha : Date);
				function responderPregunta(pregunta : string) : string;
				procedure recibirCalificacion(materiaConNota : materia);
				function toString() : ansistring; override;
		end;
implementation
uses SysUtils;
	constructor Estudiante.create(newNombre, newDNI : string; newFecha : Date);
	begin
		inherited create(newNombre, newDNI, newFecha);
		conocimiento := RandomGenerator.create();
		analitico := listaMaterias.create();
	end;
	function Estudiante.responderPregunta(pregunta : string) : string;
	begin
		responderPregunta := conocimiento.getString(conocimiento.getInteger(3, 15));
	end;
	procedure Estudiante.recibirCalificacion(materiaConNota : materia);
	begin
		analitico.add(materiaConNota);
	end;
	function Estudiante.toString() : ansistring;
	var
		tempString : ansistring;
		separador : string;
	begin
		tempString := (inherited toString() + ' | [ANALITICO]:  ');
		analitico.reset();
		while (not analitico.eol()) do begin
			separador := ' - ';
			tempString := (tempString + separador + analitico.current().asignatura + '[' + FloatToStr(analitico.current().nota) + ']');
			analitico.next();
		end;
		toString := tempString;
	end;
end.

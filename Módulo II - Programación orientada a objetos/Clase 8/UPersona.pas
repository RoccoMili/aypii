unit UPersona;
{$mode objfpc}
interface
uses UDateTime;
	type
		Persona = class
			private
				nombre : string;
				DNI : string;
				fechaNacimiento : Date;
			public
				constructor create(newNombre, newDNI : string; newFecha : Date);
				function toString() : ansistring; override;
		end;
implementation
	constructor Persona.create(newNombre, newDNI : string; newFecha : Date);
	begin
		nombre := newNombre;
		DNI := newDNI;
		fechaNacimiento := newFecha;
	end;
	function Persona.toString() : ansistring;
	begin
		toString := ('[NOMBRE]: '+nombre+' | [DNI]: '+DNI+' | [FECHA]: '+ fechaNacimiento.toString());
	end;
end.

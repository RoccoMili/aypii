unit OBJPrestamo;
{$mode objfpc}
interface
uses UDateTime;
	type
		Prestamo = class
			private
				socio : integer;
				fecha : Date;
				ISBN : string;
			public
				constructor create(cod : integer; fec : Date; isbnC : string);
				function getSocio() : integer;
				function getFecha() : Date;
				function getISBN() : string;
				function greaterThan(prest : Prestamo) : boolean; 
		end;
implementation
	constructor Prestamo.create(cod : integer; fec : Date; isbnC : string);
		begin
			socio := cod;
			fecha := fec;
			isbn := isbnC;
		end;
	function Prestamo.getSocio() : integer;
		begin
			getSocio := socio;
		end;
	function Prestamo.getFecha() : Date;
		begin
			getFecha := fecha;
		end;
	function Prestamo.getISBN() : string;
		begin
			getISBN := isbn;
		end;
	function Prestamo.greaterThan(prest : Prestamo) : boolean;
		begin
			greaterThan := false;
			if (self.getISBN() > prest.getISBN()) then
				greaterThan := true;
		end;
end.

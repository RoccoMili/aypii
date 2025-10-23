unit UContadorManual;
{$mode objfpc}
interface
	type
		ContadorManual = class
			private
				cantidad : integer;
			public 
				constructor create();
				procedure incrementar();
				procedure reset();
				function getCantidad() : integer;
		end;
implementation
	constructor ContadorManual.create();
	begin
		cantidad := 0;
	end;
	procedure ContadorManual.incrementar();
	begin
		cantidad := cantidad + 1;
	end;
	procedure ContadorManual.reset();
	begin
		cantidad := 0;
	end;
	function ContadorManual.getCantidad() : integer;
	begin
		getCantidad := cantidad;
	end;
end.

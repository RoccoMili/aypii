program Animales3.pas;
{$mode objfpc}
type
	// todo esto está copiado del ejercicio previo Animales1 a excepción de Ballena
	Animal = class
		private
			vivo : boolean;
			altura, peso : real;
		public
			constructor create(height, weight : real);
			procedure morir();
	end;
	
	Mamifero = class(Animal)
		private
			cantidadMamas : integer;
		public
			constructor create(cantMamas : integer; height, weight : real);
			procedure lactar();
	end;
	
	Perro = class(Mamifero)
		private
			colorPelaje : string;
		public
			constructor create(color : string; cantMamas : integer; height, weight : real);
			procedure ladrar();
	end;
	
	Ballena = class(Mamifero)
		private
			profundidadInmersion : real;
		public
			constructor create(depth : real; cantMamas : integer; height, weight : real);
			procedure sumergirse();
	end;
	
	constructor Animal.create(height, weight : real);
		begin
			vivo := true;
			altura := height;
			peso := weight;
		end;
	procedure Animal.morir();
		begin
			vivo := false;
			writeln('Descansando en paz');
		end;
	
	constructor Mamifero.create(cantMamas : integer; height, weight : real);
		begin
			inherited create(height, weight);
			cantidadMamas := cantMamas;
		end;
	procedure Mamifero.lactar();
		begin
			writeln('Alimentandome');
		end;
	
	constructor Perro.create(color : string; cantMamas : integer; height, weight : real);
		begin
			inherited create(cantMamas, height, weight);
			colorPelaje := color;
		end;
	procedure Perro.ladrar();
		begin
			writeln('Woof woof');
		end;

	constructor Ballena.create(depth : real; cantMamas : integer; height, weight : real);
		begin
			inherited create(cantMamas, height, weight);
			profundidadInmersion := depth;
		end;
	procedure Ballena.sumergirse();
		begin
			writeln('Sumergiendome unos ',profundidadInmersion:0:2,'m');
		end;
	
	
var
	testBallena1 : Ballena;
BEGIN
	testBallena1 := Ballena.create(50, 4, 7, 1250);
	testBallena1.sumergirse();
END.

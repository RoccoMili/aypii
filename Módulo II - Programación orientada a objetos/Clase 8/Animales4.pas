program Animales4.pas;
{$mode objfpc}
uses SysUtils;
type
	Animal = class
		private
			vivo : boolean;
			altura, peso : real;
		public
			constructor create(height, weight : real);
			procedure morir();
			function toString() : ansistring; override;
	end;
	
	Mamifero = class(Animal)
		private
			cantidadMamas : integer;
		public
			constructor create(cantMamas : integer; height, weight : real);
			procedure lactar();
			function toString() : ansistring; override;
			procedure crecer(); virtual;
	end;

	Ave = class(Animal)
		private
			periodoIncubacion : integer; // supongo que está medido en días (?
		protected // en teoría no vimos esto todavía, pero me parece la mejor manera
			puedeVolar : boolean;
		public
			constructor create(diasIncubacion : integer; height, weight : real);
			procedure volar();
	end;

	Perro = class(Mamifero)
		private
			colorPelaje : string;
		public
			constructor create(color : string; cantMamas : integer; height, weight : real);
			procedure ladrar();
			function toString() : ansistring; override;
			procedure crecer(); override;
	end;
	
	Pato = class(Ave)
		private
			noVuela : boolean;
		public
			constructor create(vuela : boolean; diasIncubacion : integer; height, weight : real);
			procedure nadar();
	end;
		
	Loro = class(Ave)
		private
			cantidadColores : integer;
		public
			constructor create(cantColores : integer; diasIncubacion : integer; height, weight : real);
			procedure hablar();
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
	function Animal.toString() : ansistring;
		begin
			if vivo then
				toString := 'Estoy vivo.'
			else
				toString := 'Descanso en paz.';
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
	function Mamifero.toString() : ansistring;
		begin
			toString := 'Soy un mamifero con ' + intToStr(cantidadMamas) + '  glandulas mamarias. ' + inherited toString();
		end;
	procedure Mamifero.crecer(); 
		begin
			writeln('Soy un mamifero que crece');
		end;
		
	constructor Ave.create(diasIncubacion : integer ; height, weight : real);
		begin
			inherited create(height, weight);
			periodoIncubacion := diasIncubacion;
			puedeVolar := true;
		end;
	procedure Ave.volar();
		begin
			if (puedeVolar) then
				writeln('Volando')
			else
				writeln('No se volar');
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
	function Perro.toString() : ansistring;
		begin
			toString := 'Soy un perro de color ' + colorPelaje + '. ' + inherited toString(); 
		end;
	procedure Perro.crecer();
		begin
			writeln('Soy un perro que crece');
		end;

	constructor Pato.create(vuela : boolean; diasIncubacion : integer; height, weight : real);
		begin
			inherited create(diasIncubacion, height, weight);
			noVuela := (not vuela);
			puedeVolar := vuela;
		end;
	procedure Pato.nadar();
		begin
			writeln('Nadando');
		end;

	constructor Loro.create(cantColores : integer; diasIncubacion : integer; height, weight : real);
		begin
			inherited create(diasIncubacion, height, weight);
			cantidadColores := cantColores;
		end;
	procedure Loro.hablar();
		begin
			writeln('Ponete a laburar Mikeke');
		end;

	procedure imprimir(anim : Animal);
		begin
			writeln(anim.toString());
		end;
	procedure crecer(mamif : Mamifero);
		begin
			mamif.crecer();
		end;
	
var
	testPato : Pato;
	testLoro : Loro;
	anim : Animal;
	mamif : Mamifero;
	perr : Perro;
begin
	testPato := Pato.create(false, 14, 0.35, 250);
	testPato.nadar();
	testPato.volar();
	testPato.morir();
	testLoro := Loro.create(3, 10, 0.40, 300);
	testLoro.hablar();
	testLoro.morir();
	
	anim := Animal.create(5.3, 43.2);
	mamif := Mamifero.create(6, 5.3, 43.2);
	perr := Perro.create('Blanco', 6, 5.3, 43.2);
	imprimir(anim);
	imprimir(mamif);
	imprimir(perr);
	
	mamif.crecer();
	perr.crecer();
	
	crecer(mamif);
	crecer(perr);
end.
	

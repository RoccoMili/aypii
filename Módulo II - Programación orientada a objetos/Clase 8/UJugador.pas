unit UJugador;
{$mode objfpc}
interface
uses UDateTime, UCajaDeAhorro, UTrabajador;
    type
        Jugador = class(Trabajador)
            private
                goles, amarillas, rojas : integer;
            protected
                function calcularSalario() : real; override;
            public
                constructor create(newNombre, newDNI : string; fechaNacimiento : Date; caja : CajaDeAhorro; salario : real);
                procedure golConvertido();
                procedure amarillaRecibida();
                procedure expulsado();
        end;
implementation
    constructor Jugador.create(newNombre, newDNI : string; fechaNacimiento : Date; caja : CajaDeAhorro; salario : real);
    begin
        inherited create(newNombre, newDNI, fechaNacimiento, caja, salario);
        goles := 0; amarillas := 0; rojas := 0;
    end;
    function Jugador.calcularSalario() : real;
    begin
        calcularSalario := inherited calcularSalario() + (goles * 250) - (amarillas * 10) - (rojas * 100);
    end;
    procedure Jugador.golConvertido(); 
    begin
        goles := goles + 1;
    end;
    procedure Jugador.amarillaRecibida();
    begin
        amarillas := amarillas + 1;
    end;
    procedure Jugador.expulsado();
    begin
        rojas := rojas + 1;
    end;
end.
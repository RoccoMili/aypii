unit UEntrenador;
{$mode objfpc}
interface
uses UTrabajador, UDateTime, UCajaDeAhorro;
    type
        Entrenador = class(Trabajador)
            private
                campeonatosGanados : integer;
            protected
                function calcularSalario() : real; override;
            public
                constructor create(newNombre, newDNI : string; fechaNacimiento : Date; caja : CajaDeAhorro; salario : real);
                procedure campeonatoGanado();
        end;
implementation
    constructor Entrenador.create(newNombre, newDNI : string; fechaNacimiento : Date; caja : CajaDeAhorro; salario : real);
    begin
        inherited create(newNombre, newDNI, fechaNacimiento, caja, salario);
        campeonatosGanados := 0;
    end;
    procedure Entrenador.campeonatoGanado();
    begin
        campeonatosGanados := campeonatosGanados + 1;
    end;
    function Entrenador.calcularSalario() : real;
    begin
        calcularSalario := inherited calcularSalario() + (campeonatosGanados * 5000);
    end;
end.

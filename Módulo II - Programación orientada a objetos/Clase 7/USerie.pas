unit USerie;
{$mode objfpc}
interface
uses GenericLinkedList;
    type
        listaReal = specialize LinkedList<real>;
        Serie = class
            private
                puntajes : listaReal;
            public
                constructor create();
                procedure agregarPuntaje(puntaje : real);
                function getPuntaje() : real;
        end;
implementation
    constructor Serie.create();
        begin
            puntajes := listaReal.create();
        end;
    procedure Serie.agregarPuntaje(puntaje : real);
        begin
            puntajes.add(puntaje);
        end;
    function Serie.getPuntaje() : real;
        var
            cant : integer;
            total : real;
        begin
            cant := 0;
            total := 0;
            puntajes.reset();
            while (not puntajes.eol()) do begin
                cant := cant + 1;
                total := total + puntajes.current();
                puntajes.next();
            end;
            getPuntaje := (total/cant);
        end;
end.
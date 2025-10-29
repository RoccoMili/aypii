unit UNaipe;
{$mode objfpc}
interface
    type
        OBJNaipe = class
            private
                numero : integer;
                palo : string;
            public
                constructor create(numCrear : integer; paloCrear : string);
                function getNumero() : integer;
                function getPalo() : string;
                function toString() : string;
        end;
implementation
uses sysutils;
    constructor OBJNaipe.create(numCrear : integer; paloCrear : string);
        begin
            numero := numCrear;
            palo := paloCrear;
        end;
    function OBJNaipe.getNumero() : integer;
        begin
            getNumero := numero;
        end;
    function OBJNaipe.getPalo() : string;
        begin
            getPalo := palo;
        end;
    function OBJNaipe.toString() : string;
        begin
            toString := format('%d de %s', [numero, palo]);
        end;
end.
unit UMazo;
{$mode objfpc}
interface
uses GenericLinkedList, UNaipe;
    type
        listaNaipes = specialize LinkedList<OBJNaipe>;
        OBJMazo = class
            private
                naipes : listaNaipes;
            public
                constructor create();
                procedure agregarNaipe(naipeNuevo : OBJNaipe);
                function sacarNaipe() : OBJNaipe;
                function isVacio() : boolean;
                procedure mezclar();
        end;
implementation
    constructor OBJMazo.create();
        begin
            naipes := listaNaipes.create();
        end;
    procedure OBJMazo.agregarNaipe(naipeNuevo : OBJNaipe);
        begin
            naipes.add(naipeNuevo);
        end;
    function OBJMazo.sacarNaipe() : OBJNaipe;
        var
            naipeAct : OBJNaipe;
        begin
            naipes.reset();
            // Asumimos que NO se va a sacar un naipe si no hay más
           naipeAct := naipes.current();
           naipes.removeCurrent();
           sacarNaipe := naipeAct;
        end;
    function OBJMazo.isVacio() : boolean;
        begin
            if (naipes.eol()) then
                isVacio := true
            else // añadimos este else para prevenir errores
                isVacio := false; 
        end;
    procedure OBJMazo.mezclar();
        var
            cant, i, n : integer;
            nuevos : listaNaipes;
        begin
            // acá contamos cuántos naipes. ineficiente, pero el ejercicio no establece
            // otro estado en el private
            cant := 0;
            naipes.reset();
            while (not naipes.eol()) do begin
                cant := cant + 1;
                naipes.next();
            end;

            nuevos := listaNaipes.create();
            naipes.reset();
            while (not naipes.eol()) do begin
                n := random(cant);
                naipes.reset();
                for i:=1 to n do
                    naipes.next();
                nuevos.add(naipes.current());
                naipes.removeCurrent();
                cant := cant - 1;
            end;
            naipes := nuevos;
        end;
end.
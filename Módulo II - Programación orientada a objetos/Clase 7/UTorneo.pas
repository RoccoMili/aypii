unit UTorneo;
{$mode objfpc}
interface
uses GenericABB, GenericLinkedList, USerie;
    type
        listaSeries = specialize LinkedList<Serie>;
        Gimnasta = class
            private
                codigo : integer;
                cantidadSeries : integer;
                acumuladoPuntajes : real;
            public
                constructor create(cod : integer);
                procedure agregarSerie(nuevaSerie : Serie);
                function getCodigo() : integer;
                function getCantidadSeries() : integer;
                function getAcumuladoPuntajes() : real;
        end;
        ABBPuntajes = specialize ABB<Gimnasta>;
        Torneo = class
            private
                puntajesGimnastas : ABBPuntajes;
                procedure insertarGimnasta(arbol : ABBPuntajes; codigo : integer; unaSerie : Serie);
                procedure buscarTop3(arbol : ABBPuntajes; var cod1, cod2, cod3 : integer; var prom1, prom2, prom3 : real);
            public
                constructor create();
                procedure agregarSerieGimnasta(numGimnasta : integer; unaSerie : Serie);
                function getPrimerPuesto() : integer;
                function getSegundoPuesto() : integer;
                function getTercerPuesto() : integer;
        end;
implementation
    constructor Gimnasta.create(cod : integer);
        begin
            codigo := cod;
            cantidadSeries := 0;
            acumuladoPuntajes := 0;
        end;
    procedure Gimnasta.agregarSerie(nuevaSerie : Serie);
        begin
            cantidadSeries := cantidadSeries + 1;
            acumuladoPuntajes := acumuladoPuntajes + nuevaSerie.getPuntaje();
        end;
    function Gimnasta.getCodigo() : integer;
        begin
            getCodigo := codigo;
        end;
    function Gimnasta.getCantidadSeries() : integer;
        begin
            getCantidadSeries := cantidadSeries;
        end;
    function Gimnasta.getAcumuladoPuntajes() : real;
        begin
            getAcumuladoPuntajes := acumuladoPuntajes;
        end;
    constructor Torneo.create();
        begin
            puntajesGimnastas := ABBPuntajes.create();
        end;
    procedure Torneo.insertarGimnasta(arbol : ABBPuntajes; codigo : integer; unaSerie : Serie);
        begin
            if (arbol.isEmpty()) then begin
                arbol.insertCurrent(Gimnasta.create(codigo));
                arbol.current().agregarSerie(unaSerie);
            end
            else if (arbol.current().getCodigo() = codigo) then
                arbol.current().agregarSerie(unaSerie)
            else if (arbol.current().getCodigo() > codigo) then
                insertarGimnasta(arbol.getLeftChild(), codigo, unaSerie)
            else
                insertarGimnasta(arbol.getRightChild(), codigo, unaSerie);
        end;
    {El código a continuación es la PEOR cosa que escribí en mi vida.
    Busqué mil soluciones, me senté varias horas a pensarlo, y lo mejor
    que pudo haber salido de mi es esta aberración.
    Pido perdón a todas las personas que tengan que lidiar con esto,
    y muchas gracias por entender. Ojalá no codear nunca más algo como esto}
    procedure Torneo.buscarTop3(arbol : ABBPuntajes; var cod1, cod2, cod3 : integer; var prom1, prom2, prom3 : real);
        begin
            if (not arbol.isEmpty()) then begin
                buscarTop3(arbol.getLeftChild(), cod1, cod2, cod3, prom1, prom2, prom3);

                if ((arbol.current().getAcumuladoPuntajes()/arbol.current().getCantidadSeries()) > prom1) then begin
                    prom3 := prom2;
                    cod3 := cod2;
                    prom2 := prom1;
                    cod2 := cod1;
                    prom1 := (arbol.current().getAcumuladoPuntajes()/arbol.current().getCantidadSeries());
                    cod1 := arbol.current().getCodigo();
                end
                else if ((arbol.current().getAcumuladoPuntajes()/arbol.current().getCantidadSeries()) > prom2) then begin
                    prom3 := prom2;
                    cod3 := cod2;
                    prom2 := (arbol.current().getAcumuladoPuntajes()/arbol.current().getCantidadSeries());
                    cod2 := arbol.current().getCodigo();
                end
                else if ((arbol.current().getAcumuladoPuntajes()/arbol.current().getCantidadSeries()) > prom3) then begin
                    prom3 := (arbol.current().getAcumuladoPuntajes()/arbol.current().getCantidadSeries());
                    cod3 := arbol.current().getCodigo();
                end;

                buscarTop3(arbol.getRightChild(), cod1, cod2, cod3, prom1, prom2, prom3);
            end;
        end;
    procedure Torneo.agregarSerieGimnasta(numGimnasta : integer; unaSerie : Serie);
        begin
            insertarGimnasta(puntajesGimnastas, numGimnasta, unaSerie);
        end;
    function Torneo.getPrimerPuesto() : integer;
        var
            cod1, cod2, cod3 : integer;
            prom1, prom2, prom3 : real;
        begin
            cod1 := 0; cod2 := 0; cod3 := 0; prom1 := -1; prom2 := -1; prom3 := -1;
            self.buscarTop3(puntajesGimnastas, cod1, cod2, cod3, prom1, prom2, prom3);
            getPrimerPuesto := cod1;
        end;
    function Torneo.getSegundoPuesto() : integer;
        var
            cod1, cod2, cod3 : integer;
            prom1, prom2, prom3 : real;
        begin
            cod1 := 0; cod2 := 0; cod3 := 0; prom1 := -1; prom2 := -1; prom3 := -1;
            self.buscarTop3(puntajesGimnastas, cod1, cod2, cod3, prom1, prom2, prom3);
            getSegundoPuesto := cod2;
        end;
    function Torneo.getTercerPuesto() : integer;
        var
            cod1, cod2, cod3 : integer;
            prom1, prom2, prom3 : real;
        begin
            cod1 := 0; cod2 := 0; cod3 := 0; prom1 := -1; prom2 := -1; prom3 := -1;
            self.buscarTop3(puntajesGimnastas, cod1, cod2, cod3, prom1, prom2, prom3);
            getTercerPuesto := cod3;
        end; 
end.
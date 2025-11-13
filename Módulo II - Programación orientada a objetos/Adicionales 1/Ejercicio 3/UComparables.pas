unit UComparables;
{$mode objfpc}
interface
uses UDateTime, URandomGenerator, GenericLinkedList;
    type
        Comparable = class

        end;
        Comparador = class
            public
                function esMayor(unComparable, otroComparable : Comparable) : boolean; virtual; abstract;
        end;
        ComparadorPorPrecio = class(Comparador)
            public
                constructor create();
                function esMayor(unComparable, otroComparable : Comparable) : boolean; override;
        end;
        ComparadorPorStock = class(Comparador)
            public
                constructor create();
                function esMayor(unComparable, otroComparable : Comparable) : boolean; override;
        end;
        ComparadorPorFechaDeVencimiento = class(Comparador)
            public
                constructor create();
                function esMayor(unComparable, otroComparable : Comparable) : boolean; override;
        end;

        Producto = class(Comparable)
            private
                descripcion : string;
                precio : real;
                stock : integer;
                fechaVencimiento : Date;
            public
                constructor create(unaDescripcion : string; unPrecio : real; unStock : integer; unaFecha : Date);
                function getDescripcion() : string;
                function getPrecio() : real;
                function getStock() : integer;
                function getFechaDeVencimiento() : Date;
        end;

        Criterio = class
            public
                function vaAntes(unComparable, otroComparable: Comparable; unComparador: Comparador): boolean; virtual; abstract;
        end;
        OrdenAscendente = class(Criterio)
            public
                constructor create();
                function vaAntes(unComparable, otroComparable: Comparable; unComparador: Comparador): boolean; override;
        end;
        OrdenDescendente = class(Criterio)
            public
                constructor create();
                function vaAntes(unComparable, otroComparable: Comparable; unComparador: Comparador): boolean; override;
        end;

        listaComparables = specialize LinkedList<Comparable>;
        Ordenador = class
            private
                comp : Comparador;
                orden : Criterio;
                comparables : listaComparables;
            public
                constructor create(unComparador : Comparador; unCriterio : Criterio);
                procedure agregarObjeto(unComparable : Comparable);
                procedure setComparador(unComparador : Comparador);
                procedure setCriterio(unCriterio : Criterio);
                function getLista() : listaComparables;
        end;
implementation
    constructor ComparadorPorPrecio.create();
    begin
        // nada
    end;
    function ComparadorPorPrecio.esMayor(unComparable, otroComparable : Comparable) : boolean;
    begin
        if ((unComparable as Producto).getPrecio() > (otroComparable as Producto).getPrecio()) then
            esMayor := true
        else
            esMayor := false;
    end;
    constructor ComparadorPorStock.create();
    begin
        // nada
    end;
    function ComparadorPorStock.esMayor(unComparable, otroComparable : Comparable) : boolean;
    begin
        if ((unComparable as Producto).getStock() > (otroComparable as Producto).getStock()) then
            esMayor := true
        else
            esMayor := false;
    end;
    constructor ComparadorPorFechaDeVencimiento.create();
    begin
        // nada
    end;
    function ComparadorPorFechaDeVencimiento.esMayor(unComparable, otroComparable : Comparable) : boolean;
    begin
        if ((unComparable as Producto).getFechaDeVencimiento().greaterThan((otroComparable as Producto).getFechaDeVencimiento())) then
            esMayor := true
        else
            esMayor := false;
    end;
    constructor Producto.create(unaDescripcion : string; unPrecio : real; unStock : integer; unaFecha : Date);
    begin
        descripcion := unaDescripcion;
        precio := unPrecio;
        stock := unStock;
        fechaVencimiento := unaFecha;
    end;
    function Producto.getDescripcion() : string;
    begin
        getDescripcion := descripcion;
    end;
    function Producto.getPrecio() : real;
    begin
        getPrecio := precio;
    end;
    function Producto.getStock() : integer;
    begin
        getStock := stock;
    end;
    function Producto.getFechaDeVencimiento() : Date;
    begin
        getFechaDeVencimiento := fechaVencimiento;
    end;
    constructor OrdenAscendente.create();
    begin
        // nada
    end;
    function OrdenAscendente.vaAntes(unComparable, otroComparable: Comparable; unComparador: Comparador): boolean;
    begin
        if (not unComparador.esMayor(unComparable, otroComparable)) then
            vaAntes := true
        else
            vaAntes := false;
    end;
    constructor OrdenDescendente.create();
    begin
        // nada
    end;
    function OrdenDescendente.vaAntes(unComparable, otroComparable: Comparable; unComparador: Comparador): boolean;
    begin
        if (unComparador.esMayor(unComparable, otroComparable)) then
            vaAntes := true
        else
            vaAntes := false;
    end; 

    constructor Ordenador.create(unComparador : Comparador; unCriterio : Criterio);
    begin
        comp := unComparador;
        orden := unCriterio;
        comparables := listaComparables.create();
    end;
    procedure Ordenador.agregarObjeto(unComparable : Comparable);
    begin
        comparables.reset();
        while ((not comparables.eol()) AND (not orden.vaAntes(unComparable, comparables.current(), comp))) do
            comparables.next();
        comparables.insertCurrent(unComparable);
    end;
    procedure Ordenador.setComparador(unComparador : Comparador);
    begin
        comp := unComparador;
    end;
    procedure Ordenador.setCriterio(unCriterio : Criterio);
    begin
        orden := unCriterio;
    end;
    function Ordenador.getLista() : listaComparables;
    var
        listaOrdenada : listaComparables;
        elem : Comparable;
    begin
        listaOrdenada := listaComparables.create();

        comparables.reset();
        while (not comparables.eol()) do begin
            elem := comparables.current();
            listaOrdenada.reset();
            while ((not listaOrdenada.eol()) AND (not orden.vaAntes(elem, listaOrdenada.current(), comp))) do
                listaOrdenada.next();
            listaOrdenada.insertCurrent(elem);

            comparables.next();
        end;
        getLista := listaOrdenada;
    end;
end.
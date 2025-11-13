unit UImpresiones;
{$mode objfpc}
interface
uses GenericLinkedList, URandomGenerator;
    type
        listaTextos = specialize LinkedList<string>;
        Documento = class
            private
                textos : listaTextos;
            public
                constructor create(unaCantidadPaginas : integer);
                procedure agregarPagina(unString : string);
                function getCantidadDePaginas() : integer;
                procedure imprimir();
        end;
        
        Impresoras = class
            private
                cantBandeja, limite : integer;
                enchufada, prendida : boolean;
            protected
                function getCantBandeja() : integer;
                function getLimite() : integer;
                function getEnchufada() : boolean;
                function getPrendida() : boolean;
                procedure setCantBandeja(nuevaCant : integer);
            public
                constructor create(unaCantidadHojasDeBandejaDeEntrada: integer);
                procedure encender(); virtual;
                procedure apagar(); virtual;
                procedure enchufar(); virtual;
                procedure desenchufar(); virtual;
                procedure cargarHojas(unaCantidad : integer);
                procedure imprimir(unDocumento : Documento); virtual;
                function podesImprimir(unDocumento : Documento) : boolean; virtual;
        end;

        ImpresoraComun = class(Impresoras)
            private
                cantSalida : integer;
                capacidadSalida : integer;
            protected
                function getCantSalida() : integer;
            public
                constructor create(unaCantidadHojasDeBandejaDeEntrada, unaCantidadHojasDeBandejaDeSalida: integer);
                procedure imprimir(unDocumento: Documento); override;
                function podesImprimir(unDocumento: Documento): boolean; override;
                procedure vaciarBandejaDeSalida();
        end;

        listaDocumentos = specialize LinkedList<Documento>;
        ImpresoraAvanzada = class(Impresoras)
            private
                historial : listaDocumentos;
            public
                constructor create(unaCantidadHojasDeBandejaDeEntrada : integer);
                procedure imprimir(unDocumento: Documento); override;
        end;

        ImpresoraABateria = class(Impresoras)
            private
                capacidadTotal : integer;
                capacidadActual : real;
            public
                constructor create(unaCantidadHojasDeBandejaDeEntrada, unaCapacidadDeBateria: integer);
                procedure encender(); override;
                procedure enchufar(); override;
                procedure desenchufar(); override;
                procedure imprimir(unDocumento: Documento); override;
                function podesImprimir(unDocumento: Documento): boolean; override;
        end;
implementation
    constructor Documento.create(unaCantidadPaginas : integer);
    var
        i : integer;
    begin
        textos := listaTextos.create();
        for i := 1 to unaCantidadPaginas do
            textos.add('');  // Agregar páginas vacías
    end;
    procedure Documento.agregarPagina(unString : string);
    begin
        textos.add(unString);
    end;
    function Documento.getCantidadDePaginas() : integer;
    var
        cont : integer;
    begin
        cont := 0;
        textos.reset();
        while (not textos.eol()) do begin
            cont := cont + 1;
            textos.next();
        end;
        getCantidadDePaginas := cont;
    end;
    procedure Documento.imprimir();
    begin
        textos.reset();
        while (not textos.eol()) do begin
            write(textos.current());
            textos.next();
        end;
    end;

    constructor Impresoras.create(unaCantidadHojasDeBandejaDeEntrada: integer);
    var
        rg : RandomGenerator;
    begin
        rg := RandomGenerator.create();
        cantBandeja := unaCantidadHojasDeBandejaDeEntrada;
        limite := rg.getInteger(30, 60);
        enchufada := false;
        prendida := false;
    end;
    function Impresoras.getCantBandeja() : integer;
    begin
        getCantBandeja := cantBandeja;
    end;
    function Impresoras.getLimite() : integer;
    begin
        getLimite := limite;
    end;
    function Impresoras.getEnchufada() : boolean;
    begin
        getEnchufada := enchufada;
    end;
    function Impresoras.getPrendida() : boolean;
    begin
        getPrendida := prendida;
    end;
    procedure Impresoras.setCantBandeja(nuevaCant : integer);
    begin
        cantBandeja := nuevaCant;
    end;
    procedure Impresoras.encender();
    begin
        if (enchufada) then
            prendida := true;
    end;
    procedure Impresoras.apagar();
    begin
        prendida := false;
    end;
    procedure Impresoras.enchufar();
    begin
        enchufada := true;
    end;
    procedure Impresoras.desenchufar();
    begin
        enchufada := false;
    end;
    procedure Impresoras.cargarHojas(unaCantidad : integer);
    begin
        cantBandeja := cantBandeja + unaCantidad;
        if (cantBandeja > limite) then
            cantBandeja := limite;
    end;
    procedure Impresoras.imprimir(unDocumento : Documento);
    begin
        unDocumento.imprimir();
        cantBandeja := cantBandeja - unDocumento.getCantidadDePaginas();
    end;
    function Impresoras.podesImprimir(unDocumento : Documento) : boolean;
    begin
        podesImprimir := (prendida AND enchufada AND (unDocumento.getCantidadDePaginas() <= cantBandeja)); 
    end;

    constructor ImpresoraComun.create(unaCantidadHojasDeBandejaDeEntrada, unaCantidadHojasDeBandejaDeSalida: integer);
    begin
        inherited create(unaCantidadHojasDeBandejaDeEntrada);
        capacidadSalida := unaCantidadHojasDeBandejaDeSalida;
        cantSalida := 0;
    end;
    procedure ImpresoraComun.imprimir(unDocumento: Documento);
    begin
        inherited imprimir(unDocumento);
        cantSalida := cantSalida + unDocumento.getCantidadDePaginas();
    end;
    function ImpresoraComun.getCantSalida() : integer;
    begin
        getCantSalida := cantSalida;
    end;
    function ImpresoraComun.podesImprimir(unDocumento: Documento): boolean;
    begin
        podesImprimir := ((prendida AND enchufada) AND (unDocumento.getCantidadDePaginas() <= cantBandeja) AND ((cantSalida + unDocumento.getCantidadDePaginas()) <= capacidadSalida)); 
    end;
    procedure ImpresoraComun.vaciarBandejaDeSalida();
    begin
        cantSalida := 0;
    end;

    constructor ImpresoraAvanzada.create(unaCantidadHojasDeBandejaDeEntrada : integer);
    begin
        inherited create(unaCantidadHojasDeBandejaDeEntrada);
        historial := listaDocumentos.create();
    end;
    procedure ImpresoraAvanzada.imprimir(unDocumento: Documento);
    begin
        inherited imprimir(unDocumento);
        historial.add(unDocumento);
    end;

    constructor ImpresoraABateria.create(unaCantidadHojasDeBandejaDeEntrada, unaCapacidadDeBateria: integer);
    begin
        inherited create(unaCantidadHojasDeBandejaDeEntrada);
        capacidadTotal := unaCapacidadDeBateria;
        capacidadActual := 100;
    end;
    procedure ImpresoraABateria.encender();
    begin
        if (capacidadActual > 5) then
            inherited encender();
    end;
    procedure ImpresoraABateria.enchufar();
    begin
        inherited enchufar();
        capacidadActual := 100;
    end;
    procedure ImpresoraABateria.desenchufar();
    begin
        inherited desenchufar();
        if ((self.getPrendida()) AND (capacidadActual > 5)) then
            inherited encender();
    end;
    procedure ImpresoraABateria.imprimir(unDocumento: Documento);
    begin
        inherited imprimir(unDocumento);
        capacidadActual := capacidadActual - (2.0 * unDocumento.getCantidadDePaginas());
    end;
    function ImpresoraABateria.podesImprimir(unDocumento: Documento): boolean;
    var
        batNecesaria : real;
    begin
        if (self.getEnchufada()) then
            podesImprimir := (self.getPrendida() AND (unDocumento.getCantidadDePaginas() <= self.getCantBandeja()))
        else begin
            batNecesaria := 2 * unDocumento.getCantidadDePaginas();
            podesImprimir := (self.getPrendida() AND (capacidadActual >= batNecesaria) AND (unDocumento.getCantidadDePaginas() <= self.getCantBandeja()));
        end;
    end;
end.
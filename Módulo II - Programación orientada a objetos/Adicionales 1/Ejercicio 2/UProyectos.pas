unit UProyectos;
{$mode objfpc}
interface
uses UDateTime, GenericLinkedList;
    type
        Subsidio = class
            private
                codigo : integer;
                monto : real;
                otorgado : boolean;
            protected
                procedure sumarMonto(unMonto : real);
            public
                constructor create(codigoUnico : integer; montoSolicitado : real);
                function getCodigo() : integer;
                function getMonto() : real;
                function getOtorgado() : boolean;
                procedure otorgar();
        end;
        SubsidioViaje = class(Subsidio)
            private
                fecha : Date;
                destino : string;
                duracion : integer;
            public
                constructor create(fechaViaje : date; lugarDestino : string; dias, codigoUnico : integer; montoSolicitado : real);
                function getFecha() : Date;
                function getDestino() : string;
                function getDuracion() : integer;
        end;
        listaString = specialize LinkedList<string>;
        SubsidioEquipamiento = class(Subsidio)
            private
                descripciones : listaString;
            public
                constructor create(primerEquipo : string; codigoUnico : integer; montoSolicitado : real);
                procedure agregarEquipo(unMonto : real; unaDescripcion : string);
        end;

        listaSubsidios = specialize LinkedList<Subsidio>;
        Investigador = class
            private
                nombre : string;
                categoria : integer;
                especialidad : string;
                subsidios : listaSubsidios;
            public
                constructor create(unNombre : string; unaCategoria : integer; unaEspecialidad : string);
                function getNombre() : string;
                function getCategoria() : integer;
                function getEspecialidad() : string;
                procedure agregarSubsidio(unSubsidio : Subsidio);
                function montoTotal() : real;
                procedure otorgarSubsidio(unCodigoSubsidio : integer; var ok : boolean);
                function toString() : ansistring; override;
                function getCantSubsidios() : integer;
        end;

        listaInvestigadores = specialize LinkedList<Investigador>;
        Proyecto = class
            private
                codigo : integer;
                nombreDirector : string;
                investigadores : listaInvestigadores;
            public
                constructor create(unCodigo : integer; unNombre : string);
                procedure agregarInvestigador(unInvestigador : Investigador);
                procedure agregarSubsidioAInvestigador(unSubsidio : Subsidio; unNombreInvestigador : string);
                function cantidadDeSubsidios() : integer;
                function montoTotal() : real;
                procedure otorgarSubsidio(unCodigoSubsidio : integer);
                function toString() : ansistring; override;
        end;

implementation
uses SysUtils;
    constructor Subsidio.create(codigoUnico : integer; montoSolicitado : real);
    begin
        codigo := codigoUnico;
        monto := montoSolicitado;
        otorgado := false;
    end;
    procedure Subsidio.sumarMonto(unMonto : real);
    begin
        monto := monto + unMonto;
    end;
    procedure Subsidio.otorgar();
    begin
        otorgado := true;
    end;
    function Subsidio.getCodigo() : integer;
    begin
        getCodigo := codigo;
    end;
    function Subsidio.getMonto() : real;
    begin
        getMonto := monto;
    end;
    function Subsidio.getOtorgado() : boolean;
    begin
        getOtorgado := otorgado;
    end;
    constructor SubsidioViaje.create(fechaViaje : date; lugarDestino : string; dias, codigoUnico : integer; montoSolicitado : real);
    begin
        inherited create(codigoUnico, montoSolicitado);
        fecha := fechaViaje;
        destino := lugarDestino;
        duracion := dias;
    end;
    function SubsidioViaje.getFecha() : Date;
    begin
        getFecha := fecha;
    end;
    function SubsidioViaje.getDestino() : string;
    begin
        getDestino := destino;
    end;
    function SubsidioViaje.getDuracion() : integer;
    begin
        getDuracion := duracion;
    end;
    constructor SubsidioEquipamiento.create(primerEquipo : string; codigoUnico : integer; montoSolicitado : real);
    begin
        inherited create(codigoUnico, montoSolicitado);
        descripciones := listaString.create();
        descripciones.add(primerEquipo);
    end;
    procedure SubsidioEquipamiento.agregarEquipo(unMonto : real; unaDescripcion : string);
    begin
        descripciones.add(unaDescripcion);
        self.sumarMonto(unMonto);
    end;

    constructor Investigador.create(unNombre : string; unaCategoria : integer; unaEspecialidad : string);
    begin
        nombre := unNombre;
        categoria := unaCategoria;
        especialidad := unaEspecialidad;
        subsidios := listaSubsidios.create();
    end;
    function Investigador.getNombre() : string;
    begin
        getNombre := nombre;
    end;
    function Investigador.getCategoria() : integer;
    begin
        getCategoria := categoria;
    end;
    function Investigador.getEspecialidad() : string;
    begin
        getEspecialidad := especialidad;
    end;
    procedure Investigador.agregarSubsidio(unSubsidio : Subsidio);
    begin
        subsidios.add(unSubsidio);
    end;
    function Investigador.montoTotal() : real;
    var
        acc : real;
    begin
        acc := 0;
        subsidios.reset();
        while (not subsidios.eol()) do begin
            if (subsidios.current().getOtorgado()) then
                acc := acc + subsidios.current().getMonto();
            subsidios.next();
        end;
        montoTotal := acc;
    end;
    procedure Investigador.otorgarSubsidio(unCodigoSubsidio : integer; var ok : boolean);
    begin
        subsidios.reset();
        ok := false;
        while ((not subsidios.eol()) AND (not ok)) do begin
            if (subsidios.current().getCodigo() = unCodigoSubsidio) then begin
                subsidios.current().otorgar();
                ok := true;
            end;
            subsidios.next();
        end;
    end;
    function Investigador.toString() : ansistring;
    var
        acc : real;
    begin
        subsidios.reset();
        acc := 0;
        while (not subsidios.eol()) do begin
            if (subsidios.current().getOtorgado()) then
                    acc := acc + subsidios.current().getMonto();
            subsidios.next();
        end;
        toString := ('[NOMBRE]: '+nombre+' | [CATEGORIA]: '+IntToStr(categoria)+' | [ESPECIALIDAD]: '+especialidad+' | [TOTAL OTORGADOS]: '+Format('%.2f', [acc]));
    end;
    function Investigador.getCantSubsidios() : integer;
    var
        cont : integer;
    begin
        cont := 0;
        subsidios.reset();
        while (not subsidios.eol()) do begin
            cont := cont + 1;
            subsidios.next();
        end;
        getCantSubsidios := cont;
    end;

    constructor Proyecto.create(unCodigo : integer; unNombre : string);
    begin
        codigo := unCodigo;
        nombreDirector := unNombre;
        investigadores := listaInvestigadores.create();
    end;
    procedure Proyecto.agregarInvestigador(unInvestigador : Investigador);
    begin
        investigadores.add(unInvestigador);
    end;
    procedure Proyecto.agregarSubsidioAInvestigador(unSubsidio : Subsidio; unNombreInvestigador : string);
    var
        success : boolean;
    begin
        success := false;
        investigadores.reset();
        while (not investigadores.eol()) do begin
            if (investigadores.current().getNombre() = unNombreInvestigador) then begin
                investigadores.current().agregarSubsidio(unSubsidio);
                success := true;
            end;
            investigadores.next();
        end;
        if (not success) then
            writeln('ERROR! No se encontro el investigador');
    end;
    function Proyecto.cantidadDeSubsidios() : integer;
    var
        cant : integer;
    begin
        cant := 0;
        investigadores.reset();
        while (not investigadores.eol()) do begin
            cant := cant + investigadores.current().getCantSubsidios();
            investigadores.next();
        end;
        cantidadDeSubsidios := cant;
    end;
    function Proyecto.montoTotal() : real;
    var
        acc : real;
    begin
        acc := 0;
        investigadores.reset();
        while (not investigadores.eol()) do begin
            acc := acc + investigadores.current().montoTotal();
            investigadores.next();
        end;
        montoTotal := acc;
    end;
    procedure Proyecto.otorgarSubsidio(unCodigoSubsidio : integer);
    var
        exito : boolean;
    begin
        exito := false;
        investigadores.reset();
        while (not investigadores.eol() AND (not exito)) do begin
            investigadores.current().otorgarSubsidio(unCodigoSubsidio, exito);
            investigadores.next();
        end;
        if (not exito) then
            writeln('ERROR! No se encontro el subsidio');
    end;
    function Proyecto.toString() : ansistring;
    var
        temp : ansistring;
        sep : string;
    begin
        temp := ('[CODIGO]: '+IntToStr(codigo)+' | [NOMBRE DIRECTOR]: '+nombreDirector+' | [TOTAL OTORGADO]: '+Format('%.2f', [self.montoTotal()])+'| [INVESTIGADORES]: ');
        sep := ' - ';
        investigadores.reset();
        while not (investigadores.eol()) do begin
            temp := temp + sep + ('[NOMBRE]: '+investigadores.current().getNombre()+' | [CATEGORIA]: '+IntToStr(investigadores.current().getCategoria())+' | [ESPECIALIDAD]: '+investigadores.current().getEspecialidad()+' | [TOTAL OTORGADOS]: '+Format('%.2f', [investigadores.current().montoTotal()]));
            investigadores.next();
        end;
        toString := temp;
    end;
end.
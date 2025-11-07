unit UServiciosBanco;
{$mode objfpc}
interface
uses GenericLinkedList, SysUtils;
    type
        listaReal = specialize LinkedList<real>;
        Servicio = class
            private
                numeroDeCuenta : integer;
                DNIPropietario : string;
                saldo : real;
                estado : boolean;
                historial : listaReal;
            protected
                function getSaldo() : real;
                function getMontoMantenimiento() : real; virtual; abstract;
            public
                constructor create(unNumeroDeCuenta : integer; unDNI : string);
                function getNumeroDeCuenta() : integer;
                procedure depositar(unMonto : real);
                function extraer(unMonto : real) : boolean; virtual;
                procedure cobrarMantenimiento();
                function esPosibleExtraer(unMonto : real) : boolean; virtual; abstract;
                function resumen() : ansistring; virtual;
        end;
        CajaDeAhorro = class(Servicio)
            private
                tarjetaAsociada : boolean;
            protected
                function esPosibleExtraer(unMonto : real) : boolean; override;
                function getMontoMantenimiento() : real; override;
            public
                constructor create(unaTarjetaAsociada : boolean; unNumeroDeCuenta : integer; unDNI : string);
                function resumen() : ansistring; override;
        end;
        CuentaCorriente = class(Servicio)
            private
                acuerdo : real;
            protected
                function esPosibleExtraer(unMonto : real) : boolean; override;
                function getMontoMantenimiento() : real; override;
            public
                constructor create(unAcuerdo : real; unNumeroDeCuenta : integer; unDNI : string);
                function resumen() : ansistring; override;
        end;
implementation
    constructor Servicio.create(unNumeroDeCuenta : integer; unDNI : string);
    begin
        numeroDeCuenta := unNumeroDeCuenta;
        DNIPropietario := unDNI;
        saldo := 0;
        estado := true;
        historial := listaReal.create();
    end;
    function Servicio.getNumeroDeCuenta() : integer;
    begin
        getNumeroDeCuenta := numeroDeCuenta;
    end;
    function Servicio.getSaldo() : real;
    begin
        getSaldo := saldo;
    end;
    procedure Servicio.depositar(unMonto : real);
    begin
        saldo := saldo + unMonto;
        historial.add(unMonto);
    end;
    function Servicio.extraer(unMonto : real) : boolean;
    begin
        if ((estado) AND (self.esPosibleExtraer(unMonto))) then begin
            saldo := saldo - unMonto;
            historial.add(-unMonto);
            extraer := true;
        end
        else
            extraer := false;
    end;
    procedure Servicio.cobrarMantenimiento();
    var
        monto : real;
    begin
        monto := self.getMontoMantenimiento();
        if (self.esPosibleExtraer(monto)) then begin
            saldo := saldo - monto;
            historial.add(-monto);
            if (not estado) then
                estado := true;
        end
        else
            estado := false;
    end;
    function Servicio.resumen() : ansistring;
    var
        tempString, separador : string;
    begin
        tempString := ('[NRO. CUENTA]: '+ IntToStr(numeroDeCuenta) + ' | [DNI]: ' + DNIPropietario + ' | [ULT. MOVIMIENTOS]: ');
        separador := ' - ';
        historial.reset();
        while (not historial.eol()) do begin
            tempString := tempString + separador + FormatFloat('0.00', historial.current());
            historial.next();
        end;
        if (estado) then
            tempString := tempString + '| [ESTADO]: ACTIVO'
        else
            tempString := tempString + '| [ESTADO]: INACTIVO';
        tempString := tempString + ' |  [SALDO]: ' + FormatFloat('0.00', saldo);
        resumen := tempString;
    end;

    constructor CajaDeAhorro.create(unaTarjetaAsociada : boolean; unNumeroDeCuenta : integer; unDNI : string);
    begin
        inherited create(unNumeroDeCuenta, unDNI);
        tarjetaAsociada := unaTarjetaAsociada;
    end;
    function CajaDeAhorro.esPosibleExtraer(unMonto : real) : boolean;
    begin
        if (self.getSaldo() >= unMonto) then
            esPosibleExtraer := true
        else
            esPosibleExtraer := false;
    end;
    function CajaDeAhorro.getMontoMantenimiento() : real;
    var
        base : real;
    begin
        if (tarjetaAsociada) then
            base := 2000
        else
            base := 1000;
        getMontoMantenimiento := (base + (1/(self.getSaldo() + 1)));
    end;
    function CajaDeAhorro.resumen() : ansistring;
    begin
        if (tarjetaAsociada) then
            resumen := inherited resumen() + (' | [TARJETA]: TIENE')
        else
            resumen := inherited resumen() + (' | [TARJETA]: NO TIENE');
    end;

    constructor CuentaCorriente.create(unAcuerdo : real; unNumeroDeCuenta : integer; unDNI : string);
    begin
        inherited create(unNumeroDeCuenta, unDNI);
        acuerdo := unAcuerdo;
    end;
    function CuentaCorriente.esPosibleExtraer(unMonto : real) : boolean;
    begin
        if ((self.getSaldo() + acuerdo) >= unMonto) then
            esPosibleExtraer := true
        else
            esPosibleExtraer := false;
    end;
    function CuentaCorriente.getMontoMantenimiento() : real;
    begin
        getMontoMantenimiento := (50 * acuerdo);
    end;
    function CuentaCorriente.resumen() : ansistring;
    begin
        resumen := inherited resumen() + '| [ACUERDO]: ' + FormatFloat('0.00', acuerdo);
    end;
end.
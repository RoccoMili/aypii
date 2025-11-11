unit UInmobiliaria;
{$mode objfpc}
interface
uses URandomGenerator, UDateTime, GenericLinkedList;
    type
        Propiedad = class
            private
                metrosTotales : integer;
                metrosCubiertos : integer;
                cantBanios : integer;
                cantHab : integer;
                equiposGas : integer;
            public
                constructor create(cantMetrosTotales : integer; cantMetrosCubiertos : integer; nuevaCantBanios : integer; nuevaCantHab : integer; cantEquiposGas : integer); // No vamos a dejar los getters en el protected porque no hay variables sensibles
                function getMetrosTotales() : integer;
                function getMetrosCubiertos() : integer;
                function getCantBanios() : integer;
                function getCantHab() : integer;
                function getEquiposGas() : integer;
        end;

        Contratado = class
            private
                nombre : string;
                precioHora : real;
            protected
                function getHorasExtra(unaPropiedad : Propiedad) : real; virtual; abstract;
            public
                constructor create(unNombre : string; unPrecioHora : real);
                function getNombre() : string;
                function getPrecioHora() : real; // getters inofensivos, no los ponemos en el protected
                function presupuestar(unaPropiedad : Propiedad) : real;
        end; 

        Pintor = class(Contratado)
            protected
                function getHorasExtra(unaPropiedad : Propiedad) : real; override;
        end;    
        Plomero = class(Contratado)
            protected
                function getHorasExtra(unaPropiedad : Propiedad) : real; override;
        end;    
        Electricista = class(Contratado)
            protected
                function getHorasExtra(unaPropiedad : Propiedad) : real; override;
        end;    
        Jardinero = class(Contratado)
            protected
                function getHorasExtra(unaPropiedad : Propiedad) : real; override;
        end;    

        listaContratados = specialize LinkedList<Contratado>;
        vectorMeses = array [1..12] of real;

        Inmobiliaria = class
            private
                contratados : listaContratados;
                propiedadesPresupuestadas : integer;
                montosPresupuestados : vectorMeses;
            protected
            public
                constructor create();
                procedure agregarContratado(unContratado : Contratado);
                function presupuestarPropiedad(unaPropiedad: Propiedad; unaFecha: Date): real;
                function resumen() : ansistring;
        end;
implementation
uses SysUtils;
    constructor Propiedad.create(cantMetrosTotales, cantMetrosCubiertos, nuevaCantBanios, nuevaCantHab, cantEquiposGas : integer);
    begin
        metrosTotales := cantMetrosTotales;
        metrosCubiertos := cantMetrosCubiertos;
        cantBanios := nuevaCantBanios;
        cantHab := nuevaCantHab;
        equiposGas := cantEquiposGas;
    end;
    function Propiedad.getMetrosTotales() : integer;
    begin
        getMetrosTotales := metrosTotales;
    end;
    function Propiedad.getMetrosCubiertos () : integer;
    begin
        getMetrosCubiertos := metrosCubiertos;
    end;
    function Propiedad.getCantBanios() : integer;
    begin
        getCantBanios := cantBanios;
    end;
    function Propiedad.getCantHab() : integer;
    begin
        getCantHab := cantHab;
    end;
    function Propiedad.getEquiposGas() : integer;
    begin
        getEquiposGas := equiposGas;
    end;
    
    constructor Contratado.create(unNombre : string; unPrecioHora : real);
    begin
        nombre := unNombre;
        precioHora := unPrecioHora;
    end;
    function Contratado.getNombre() : string;
    begin
        getNombre := nombre;
    end;
    function Contratado.getPrecioHora() : real;
    begin
        getPrecioHora := precioHora;
    end;
    function Contratado.presupuestar(unaPropiedad : Propiedad) : real;
    begin
        presupuestar := ((unaPropiedad.getMetrosTotales() div 10) * (self.getPrecioHora() + self.getHorasExtra(unaPropiedad)));
    end;

    function Pintor.getHorasExtra(unaPropiedad : Propiedad) : real;
    var
        rg : RandomGenerator;
        precio_litro_pintura : real;
    begin
        rg := RandomGenerator.create();
        precio_litro_pintura := rg.getReal(7500, 15000);
        getHorasExtra := (unaPropiedad.getMetrosCubiertos() * precio_litro_pintura)
    end;
    function Plomero.getHorasExtra(unaPropiedad : Propiedad) : real;
    begin
        getHorasExtra := ((unaPropiedad.getCantBanios() * 50000) + (unaPropiedad.getEquiposGas() * 10000));
    end;
    function Electricista.getHorasExtra(unaPropiedad : Propiedad) : real;
    var
        rg : RandomGenerator;
        precio_lampara : real;
    begin
        rg := RandomGenerator.create();
        precio_lampara := rg.getReal(15000, 45000);
        getHorasExtra := (unaPropiedad.getMetrosCubiertos() / unaPropiedad.getCantHab() * precio_lampara);
    end;
    function Jardinero.getHorasExtra(unaPropiedad : Propiedad) : real;
    begin
        getHorasExtra := ((unaPropiedad.getMetrosTotales() - unaPropiedad.getMetrosCubiertos()) / 50);
    end;

    constructor Inmobiliaria.create();
    var
        i : integer;
    begin
        contratados := listaContratados.create();
        propiedadesPresupuestadas := 0;
        for i:=1 to 12 do
            montosPresupuestados[i] := 0;
    end;
    procedure Inmobiliaria.agregarContratado(unContratado : Contratado);
    begin
        contratados.add(unContratado);
    end;
    function Inmobiliaria.presupuestarPropiedad(unaPropiedad: Propiedad; unaFecha: Date): real;
    var
        presupuestoActual : real;
    begin
        presupuestoActual := 0;
        contratados.reset();
        while (not contratados.eol()) do begin
            presupuestoActual := presupuestoActual + (contratados.current().presupuestar(unaPropiedad));
            contratados.next();
        end;
        montosPresupuestados[unaFecha.getMonth()] := montosPresupuestados[unaFecha.getMonth()] + presupuestoActual;
        propiedadesPresupuestadas := propiedadesPresupuestadas + 1;
        presupuestarPropiedad := ((unaPropiedad.getMetrosTotales() * 70000) + ((presupuestoActual/12)));
    end;
    function Inmobiliaria.resumen() : ansistring;
    var
        i : integer;
        meses : array[1..12] of string;
    begin
        // DISCLAIMER: Lo hago de esta forma porque solicita hacerlo con un string, de lo contrario lo haría con un ansistring.
        meses[1] := 'ENERO'; meses[2] := 'FEBRERO'; meses[3] := 'MARZO';
        meses[4] := 'ABRIL'; meses[5] := 'MAYO'; meses[6] := 'JUNIO';
        meses[7] := 'JULIO'; meses[8] := 'AGOSTO'; meses[9] := 'SEPTIEMBRE';
        meses[10] := 'OCTUBRE'; meses[11] := 'NOVIEMBRE'; meses[12] := 'DICIEMBRE';
        resumen := '[PROPIEDADES ALQUILADAS]: '+IntToStr(propiedadesPresupuestadas);
        for i:=1 to 12 do
            resumen := resumen + ' | ['+meses[i]+']: $'+Format('%.2f',[montosPresupuestados[i]]);
    end;
end.

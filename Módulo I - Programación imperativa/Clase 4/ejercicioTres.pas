program ejercicioTres;
uses
    GenericLinkedList;
const
    CANT = 4;
type
    venta = record
        fecha : string;
        producto : integer;
        sucursal : integer;
        cantidad : integer;
    end;
    listaVentas = specialize LinkedList<venta>;
    vSucursales = array [1..CANT] of listaVentas;
    ventaAcc = record
        producto : integer;
        cantidad : integer;
    end;
    listaAcc = specialize LinkedList<ventaAcc>;

procedure leerLibros(var v : vSucursales);
var
    i : integer;
    lib : venta;
begin
    for i:=1 to CANT do
        v[i] := listaVentas.create(); 
    writeln('Ingresa el codigo de sucursal:');
    readln(lib.sucursal);
    while (lib.sucursal <> 0) do begin
        writeln('Ingresa la fecha de la venta (DD/MM)');
        readln(lib.fecha);
        writeln('Ingresa el codigo del producto vendido');
        readln(lib.producto);
        writeln('Ingresa la cantidad vendida:');
        readln(lib.cantidad);

        v[lib.sucursal].reset();
        while ((not v[lib.sucursal].eol()) AND (v[lib.sucursal].current().producto <= lib.producto)) do
            v[lib.sucursal].next();
        v[lib.sucursal].add(lib);

        writeln('Ingresa el codigo de sucursal:');
        readln(lib.sucursal);
    end;
end;

procedure buscarMinimo(v : vSucursales; var min : venta);
var
    i, iMin : integer;
begin
    min.producto := -1;
    iMin := -1;
    for i:=1 to CANT do
        if (not v[i].eol()) then
            if (v[i].current().producto <= min.producto) then begin
                min := v[i].current();
                iMin := i;
            end;
    if (iMin <> -1) then
        v[iMin].next();
end;

procedure mergeAcc(var l : listaAcc; v : vSucursales);
var
    i : integer;
    acc : ventaAcc;
    min : venta;
begin
    l := listaAcc.create();
    for i:=1 to CANT do
        v[i].reset();
    buscarMinimo(v, min);
    while (min.producto <> -1) do begin
        acc.producto := min.producto;
        acc.cantidad := 0;
        while (acc.producto = min.producto) do begin
            acc.cantidad := acc.cantidad + min.cantidad;
            buscarMinimo(v, min);
        end;
        l.add(acc);
    end;
end;

var
    sucursales : vSucursales;
    acumulado : listaAcc;
begin
    leerLibros(sucursales);
    mergeAcc(acumulado, sucursales);
end.

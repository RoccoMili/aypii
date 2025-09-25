program Nombres;
uses
    GenericABB;
type
    ABB = specialize ABB<string>;

procedure agregarNodo(a : ABB; str : string);
begin
    if (a.isEmpty()) then
        a.insertCurrent(str)
    else if (str < a.current()) then
        agregarNodo(a.getLeftChild(), str)
    else
        agregarNodo(a.getRightChild(), str);
end;

{ Implemente un módulo cargarArbol que reciba un ABB y lo llene con 
nombres, hasta la aparición del nombre ‘ZZZ’.}
procedure cargarArbol(a : ABB);
var
    nombre : string;
begin
    writeln('Escribi un nombre para insertar en el arbol (ZZZ para terminar):');
    readln(nombre);
    while (nombre <> 'ZZZ') do begin
        agregarNodo(a, nombre);
        writeln('Escribi un nombre para insertar en el arbol (ZZZ para terminar):');
        readln(nombre);
    end;
end;

{Implemente un módulo que reciba un ABB y un nombre (como string) 
e imprima si dicho nombre está o no en el árbol.}
function buscarNombre(a : ABB; nom : string) : boolean;
begin
    if (a.isEmpty()) then
        buscarNombre := false
    else if (a.current() = nom) then
        buscarNombre := true
    else if (nom < a.current()) then
        buscarNombre := buscarNombre(a.getLeftChild(), nom)
    else
        buscarNombre := buscarNombre(a.getRightChild(), nom);
end;

procedure print(a : ABB);
begin
    if (not a.isEmpty()) then begin
        print(a.getLeftChild());
        writeln(a.current());
        print(a.getRightChild());
    end;
end;

procedure printRango(a : ABB; inf, sup : string);
begin
    if (not a.isEmpty()) then begin
        if ((a.current() >= inf) AND (a.current() <= sup)) then begin
            printRango(a.getLeftChild(), inf, sup);
            writeln(a.current());
            printRango(a.getRightChild(), inf, sup);
        end
        else if (a.current() > sup) then
            printRango(a.getLeftChild(), inf, sup)
        else
            printRango(a.getRightChild(), inf, sup);
    end;
end;

{Escriba un programa que cree un ABB de nombres, invoque a los dos 
módulos implementados y finalmente imprima todos los nombres 
almacenados en el árbol y luego imprima solo los nombres que se 
encuentran entre otros dos nombres leídos por teclado.}
var
    arbol : ABB;
    nom1, nom2 : string;
begin
    arbol := ABB.create();
    cargarArbol(arbol);
    writeln('Ingresa un nombre para buscar:');
    readln(nom1);
    if (buscarNombre(arbol, nom1)) then
        writeln('El nombre ',nom1,' esta en el arbol')
    else
        writeln('El nombre ',nom1,' no esta en el arbol');
    print(arbol);

    writeln('Inserta un segundo nombre, alfabeticamente posterior:');
    readln(nom2);
    printRango(arbol, nom1, nom2);
end.
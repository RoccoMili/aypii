program JuegoDeNaipes;
const 
    BARAJA = 48;
uses
    OBJNaipe, OBJMazo, GenericLinkedList, UDateTime, URandomGenerator;

procedure crearMazo(var mazo : OBJMazo);
var
    rg : RandomGenerator;
    i : integer;
    vPalos : array [1..4] of string = ('Oro','Copas','Espadas','Bastos');
    naipeAct : OBJNaipe;
begin
    rg := RandomGenerator.create();
    mazo := OBJMazo.create();
    for i:=1 to BARAJA do begin
        naipeAct := OBJNaipe.create(rg.getInteger(1, 12), vPalos[rg.getInteger(1,4)]); // primero num después palo
        mazo.agregarNaipe(naipeAct);
    end;
end;

procedure playerVSPlayer(mazo : OBJMazo);
var
    pozo : OBJMazo;
    puntos : array [1..2] of integer;
    cantEnPozo : integer;
begin
    // inicialización de variables base
    puntos[1] := 0;
    puntos[2] := 0;
    pozo := OBJMazo.create();
    cantEnPozo := 0;

    writeln('===== EMPEZANDO JUEGO =====');
    writeln('MEZCLANDO MAZO');
    mazo.mezclar();
    writeln('PRIMERA CARTA: ',mazo.sacarNaipe().toString());
    writeln('[JUGADOR 1]: ESCRIBI "mayor" O "menor" SI LA PROXIMA CARTA ES MAYOR O MENOR');
    while ((not mazo.isVacio()) AND (puntos[1] < 20) AND (puntos[2] < 20)) do begin
        writeln('[JUGADOR 1]: ESCRIBI "mayor" O "menor" SI LA PROXIMA CARTA ES MAYOR O MENOR');

    // PENDIENTE DE CONTINUAR.
    end;
end;

var
    mazo : OBJMazo;
begin
    
end;
program JuegoDeNaipes;
uses
    UNaipe, UMazo, GenericLinkedList, UDateTime, URandomGenerator;
const 
    BARAJA = 48;

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
    cantTurnos, turno : integer;
    previa, actual : OBJNaipe;
    prediccion : string;
    terminado : boolean;
begin
    // inicialización de variables base
    puntos[1] := 0;
    puntos[2] := 0;
    pozo := OBJMazo.create();

    writeln('===== EMPEZANDO JUEGO =====');
    writeln('MEZCLANDO MAZO');
    mazo.mezclar();
    previa := mazo.sacarNaipe();
    writeln('CARTA INICIAL: ',previa.toString());
    cantTurnos := 1;
    terminado := false;

    while (not terminado) do begin
        while ((not mazo.isVacio()) AND (puntos[1] < 20) AND (puntos[2] < 20)) do begin
            if (cantTurnos mod 2 <> 0) then
                turno := 1
            else
                turno := 2;

            writeln('[JUGADOR ',turno,']: ESCRIBI "mayor" O "menor" SI LA PROXIMA CARTA ES MAYOR O MENOR');
            readln(prediccion);

            actual := mazo.sacarNaipe();
            writeln('[CARTA NUM.',cantTurnos,']: ',actual.toString());
            if (((prediccion = 'mayor') AND (actual.getNumero() > previa.getNumero())) OR ((prediccion = 'menor') AND (actual.getNumero() < previa.getNumero()))) then begin
                puntos[turno] := puntos[turno] + 1;
                writeln('ACERTASTE! Punto para el jugador ',turno,'. NUEVO PUNTAJE: ',puntos[turno]);
            end
            else if (((prediccion = 'mayor') AND (actual.getNumero() <= previa.getNumero())) OR ((prediccion = 'menor') AND (actual.getNumero() >= previa.getNumero()))) then
                writeln('LE ERRASTE!')
            else
                writeln('ERROR');

            pozo.agregarNaipe(previa);
            pozo.agregarNaipe(actual);

            if (not mazo.isVacio()) then 
                previa := actual;
        
            cantTurnos := cantTurnos + 1;
        end;
        if ((puntos[1] >= 20) OR (puntos[2] >= 20)) then begin
            writeln('FIN DEL JUEGO :: JUGADOR 1: ',puntos[1],' | JUGADOR  2: ',puntos[2]);
            terminado := true;
        end
        else if (mazo.isVacio()) then begin
            writeln('MAZO VACIO. MEZCLANDO.');
            while (not pozo.isVacio()) do begin
                mazo.agregarNaipe(pozo.sacarNaipe());
            end;
            mazo.mezclar();
            writeln('===== CONTINUANDO JUEGO =====');
        end;
    end;
end;

procedure playerVSMachine(mazo : OBJMazo);
var
    pozo : OBJMazo;
    puntos : array [1..2] of integer;
    cantTurnos, turno : integer;
    previa, actual : OBJNaipe;
    prediccion : string;
    terminado : boolean;
begin
    puntos[1] := 0;
    puntos[2] := 0;
    pozo := OBJMazo.create();

    writeln('===== EMPEZANDO JUEGO =====');
    writeln('MEZCLANDO MAZO');
    mazo.mezclar();
    previa := mazo.sacarNaipe();
    writeln('CARTA INICIAL: ',previa.toString());
    cantTurnos := 1;
    terminado := false;

    while (not terminado) do begin
        while ((not mazo.isVacio()) AND (puntos[1] < 20) AND (puntos[2] < 20)) do begin
            if (cantTurnos mod 2 <> 0) then begin
                turno := 1;
                writeln('[JUGADOR ',turno,']: ESCRIBI "mayor" O "menor" SI LA PROXIMA CARTA ES MAYOR O MENOR');
                readln(prediccion);
            end
            else begin
                turno := 2;
                if (previa.getNumero() >= 6) then begin
                    writeln('[TURNO DE LA COMPUTADORA]: MENOR');
                    prediccion := 'menor';
                end
                else begin
                    writeln('[TURNO DE LA COMPUTADORA]: MAYOR');  
                    prediccion := 'mayor';
                end;
            end;
            
            actual := mazo.sacarNaipe();
            writeln('[CARTA NUM.',cantTurnos,']: ',actual.toString());
            if (((prediccion = 'mayor') AND (actual.getNumero() > previa.getNumero())) OR ((prediccion = 'menor') AND (actual.getNumero() < previa.getNumero()))) then begin
                puntos[turno] := puntos[turno] + 1;
                if (turno = 1) then
                    writeln('ACERTASTE! Punto para el jugador. NUEVO PUNTAJE: ',puntos[turno])
                else
                    writeln('ACIERTO! Punto para la computadora. NUEVO PUNTAJE: ',puntos[turno]);
            end
            else if (((prediccion = 'mayor') AND (actual.getNumero() <= previa.getNumero())) OR ((prediccion = 'menor') AND (actual.getNumero() >= previa.getNumero()))) then begin
                if (turno = 1) then
                    writeln('LE ERRASTE!')
                else
                    writeln('LE ERRO LA COMPUTADORA!');
            end
            else
                writeln('ERROR');

            pozo.agregarNaipe(previa);
            pozo.agregarNaipe(actual);

            if (not mazo.isVacio()) then 
                previa := actual;
        
            cantTurnos := cantTurnos + 1;
        end;
        if ((puntos[1] >= 20) OR (puntos[2] >= 20)) then begin
            writeln('FIN DEL JUEGO :: JUGADOR: ',puntos[1],' | COMPUTADORA: ',puntos[2]);
            terminado := true;
        end
        else if (mazo.isVacio()) then begin
            writeln('MAZO VACIO. MEZCLANDO.');
            while (not pozo.isVacio()) do begin
                mazo.agregarNaipe(pozo.sacarNaipe());
            end;
            mazo.mezclar();
            writeln('===== CONTINUANDO JUEGO =====');
        end;
    end;
end;

procedure machineVSMachine(mazo : OBJMazo);
var
    pozo : OBJMazo;
    rg : RandomGenerator;
    puntos : array [1..2] of integer;
    cantTurnos, turno : integer;
    previa, actual : OBJNaipe;
    prediccion : string;
    mayorRandom, terminado : boolean;
begin
    puntos[1] := 0;
    puntos[2] := 0;
    pozo := OBJMazo.create();
    rg := RandomGenerator.create();

    writeln('===== EMPEZANDO JUEGO =====');
    writeln('MEZCLANDO MAZO');
    mazo.mezclar();
    previa := mazo.sacarNaipe();
    writeln('CARTA INICIAL: ',previa.toString());
    cantTurnos := 1;
    terminado := false;

    while (not terminado) do begin
        while ((not mazo.isVacio()) AND (puntos[1] < 20) AND (puntos[2] < 20)) do begin
            if (cantTurnos mod 2 <> 0) then
                turno := 1
            else
                turno := 2;
            mayorRandom := rg.getBoolean();
            if (mayorRandom) then
                prediccion := 'mayor';
            
            actual := mazo.sacarNaipe();
            writeln('[CARTA NUM.',cantTurnos,']: ',actual.toString());
            if (((prediccion = 'mayor') AND (actual.getNumero() > previa.getNumero())) OR ((prediccion = 'menor') AND (actual.getNumero() < previa.getNumero()))) then begin
                puntos[turno] := puntos[turno] + 1;
                if (turno = 1) then
                    writeln('ACIERTO! Punto para la PC num. ',turno,'. NUEVO PUNTAJE: ',puntos[turno])
                else
                    writeln('ACIERTO! Punto para la PC num.',turno,'. NUEVO PUNTAJE: ',puntos[turno]);
            end
            else if (((prediccion = 'mayor') AND (actual.getNumero() <= previa.getNumero())) OR ((prediccion = 'menor') AND (actual.getNumero() >= previa.getNumero()))) then begin
                writeln('EQUIVOCADO!')
            end
            else
                writeln('ERROR');

            pozo.agregarNaipe(previa);
            pozo.agregarNaipe(actual);

            if (not mazo.isVacio()) then 
                previa := actual;
        
            cantTurnos := cantTurnos + 1;
        end;
        if ((puntos[1] >= 20) OR (puntos[2] >= 20)) then begin
            writeln('FIN DEL JUEGO :: PC 1: ',puntos[1],' | PC 2: ',puntos[2]);
            terminado := true;
        end
        else if (mazo.isVacio()) then begin
            writeln('MAZO VACIO. MEZCLANDO.');
            while (not pozo.isVacio()) do begin
                mazo.agregarNaipe(pozo.sacarNaipe());
            end;
            mazo.mezclar();
            writeln('===== CONTINUANDO JUEGO =====');
        end;
    end;
end;

var
    mazo : OBJMazo;
begin
    crearMazo(mazo);
    playerVSPlayer(mazo);
    playerVSMachine(mazo);
    machineVSMachine(mazo);
end.
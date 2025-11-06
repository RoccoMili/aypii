program ClubDeFutbol;
uses UEntrenador, UJugador, UTrabajador, UPersona, UDateTime, UCajaDeAhorro, URandomGenerator;

{Implemente un módulo que reciba un Trabajador y le haga cobrar su 
salario.}
procedure cobrarSueldo(worker : Trabajador);
begin
    worker.cobrarSalario();
end;

var
    tEntrenador : Entrenador;
    tJugador : Jugador;
    rg : RandomGenerator;
    fechaMin, fechaMax : Date;
    cajaNueva : CajaDeAhorro;
    i, j, cant : integer;
BEGIN
{
 ● Instancie un entrenador y un jugador
 ● Implemente un módulo que reciba un Trabajador y le haga cobrar su 
salario.
 ● Usando el módulo implementado en el inciso anterior, mes a mes, 
haga que el entrenador y el jugador cobren su salario e imprima toda la 
información de ambos}
    rg := RandomGenerator.create();
    fechaMin := Date.create(1, 1, 1960);
    fechaMax := Date.create(31, 12, 2025);
    cajaNueva := CajaDeAhorro.create(rg.getInteger(0, 2500));
    tEntrenador:= Entrenador.create('Mourinho', rg.getString(8), rg.getDate(fechaMin, fechaMax), cajaNueva, rg.getReal(10000, 250000));
    cajaNueva := CajaDeAhorro.create(rg.getInteger(0, 2500)); // las chances de que se repita la caja son ínfimas
    tJugador:= Jugador.create('Momo', rg.getString(8), rg.getDate(fechaMin, fechaMax), cajaNueva, rg.getReal(10000, 250000));

{● Simule seis semestres de trabajo:
 ○ En cada semestre el jugador recibe tarjetas amarillas, rojas y 
convierte goles (cantidades elegidas al azar).
 ○ Al finalizar cada semestre al entrenador se le suma un 
campeonato ganado.}
    for i:= 1 to 36 do begin
        if (i mod 6 = 0) then begin
            cant := rg.getInteger(1, 50);
            for j:=1 to cant do
                tJugador.golConvertido();

            cant := rg.getInteger(1, 15);
            for j:=1 to cant do
                tJugador.amarillaRecibida();

            cant := rg.getInteger(1, 5);
            for j:=1 to cant do
                tJugador.expulsado();

            tEntrenador.campeonatoGanado();  
        end;

    {Usando el módulo implementado en el inciso anterior, mes a mes, 
    haga que el entrenador y el jugador cobren su salario e imprima toda la 
    información de ambos}
    cobrarSueldo(tEntrenador);
    cobrarSueldo(tJugador);
    writeln(tEntrenador.toString());
    writeln(tJugador.toString());
    end;
END.
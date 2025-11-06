program Personas;
uses UDateTime, UPersona, UEstudiante, UCajaDeAhorro, UTrabajador, URandomGenerator;
var
    rg : RandomGenerator;
    testTrabajador : Trabajador;
    fechaMin, fechaMax : Date;
    cajaTrabajador : CajaDeAhorro;
    i, j : integer;
    testEstudiante : Estudiante;
    materiaAct : UEstudiante.materia;
BEGIN
    rg := RandomGenerator.create();
    fechaMin := Date.create(1, 1, 1960);
    fechaMax := Date.create(31, 12, 2025);
    cajaTrabajador := CajaDeAhorro.create(rg.getInteger(0, 2500));
    testTrabajador := Trabajador.create(rg.getString(6), rg.getString(8), rg.getDate(fechaMin, fechaMax), cajaTrabajador, rg.getReal(10000, 250000));

    for i:=1 to 12 do begin
        testTrabajador.cobrarSalario();
        testTrabajador.pagarImpuesto(rg.getReal(500, 7500));
        writeln(testTrabajador.toString());
    end;


    testEstudiante := Estudiante.create(rg.getString(6), rg.getString(8), rg.getDate(fechaMin, fechaMax));
    
    for i:=1 to 5 do begin
        for j:=1 to 10 do
            writeln('[MATERIA ',i,'] RESPUESTA: ',testEstudiante.responderPregunta(rg.getString(3)));
        materiaAct.asignatura := rg.getString(6);
        materiaAct.nota := rg.getReal(1, 10);
        testEstudiante.recibirCalificacion(materiaAct);
    end;
    writeln(testEstudiante.toString());
END.
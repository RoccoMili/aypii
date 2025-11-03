program PCarniceria;
uses
	UMercaderia, UCarniceria, URandomGenerator, UDateTime_EJ, UCliente, GenericLinkedList, UCajaDeAhorro;

var
	rg : RandomGenerator;
	carniceriaT : Carniceria;
	clienteT : Cliente;
	cajaCliente, cajaCarniceria : CajaDeAhorro; 
	i : integer;
BEGIN
	rg := RandomGenerator.create();
	cajaCarniceria := CajaDeAhorro.create(rg.getInteger(1, 9999));
	carniceriaT := Carniceria.create('Las Carnes Hermanos', cajaCarniceria);
	for i:=1 to 10 do begin
	  	cajaCliente := CajaDeAhorro.create(rg.getInteger(1, 9999));
		cajaCliente.depositar(rg.getReal(50000, 100000));
		clienteT := Cliente.create(rg.getString(5), cajaCliente);
		writeln('[SALDO INICIAL]: ',cajaCliente.consultarSaldo():0:2);
		clienteT.comprarEnCarniceria(carniceriaT);
		writeln('[SALDO FINAL]: ',cajaCliente.consultarSaldo():0:2);
	end;
END.

program PCarniceria;
uses
	UMercaderia, UCarniceria, URandomGenerator, UDateTime, UCliente, GenericLinkedList, UCajaDeAhorro;

var
	rg : RandomGenerator;
	carniceriaT : Carniceria;
	clienteT : Cliente;
	cajaCliente : CajaDeAhorro; 
BEGIN
	rg := RandomGenerator.create();
	// Valores de testeo
	cajaCliente := CajaDeAhorro.create(2710);
	cajaCliente.depositar(rg.getReal(50000, 100000));
	clienteT := Cliente.create('Rocco', cajaCliente);
	carniceriaT := Carniceria.create('Las Carnes Hermanos');
	
	writeln('[SALDO INICIAL]: ',cajaCliente.consultarSaldo():0:2);
	clienteT.comprarEnCarniceria(carniceriaT);
	writeln('[SALDO FINAL]: ',cajaCliente.consultarSaldo():0:2);
END.

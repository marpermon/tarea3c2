module probador (
	Clk, Reset, PIN, TARJETA_RECIBIDA, TIPO_TRANS, DIGITO, DIGITO_STB, 
  MONTO, MONTO_STB, BALANCE_ACTUALIZADO, ENTREGAR_DINERO, FONDOS_INSUFICIENTES,
  PIN_INCORRECTO, ADVERTENCIA, Bloqueo, TIPO_STB
  );

output reg Clk, Reset, TARJETA_RECIBIDA, TIPO_TRANS, DIGITO_STB, MONTO_STB, TIPO_STB;
output reg [15:0] PIN;
output reg [3:0] DIGITO;
output reg [31:0] MONTO;
input BALANCE_ACTUALIZADO, ENTREGAR_DINERO, FONDOS_INSUFICIENTES, PIN_INCORRECTO, ADVERTENCIA, Bloqueo;

///ver si las salidas funcionas sintetizado

parameter medio_T = 5;
  initial begin
    Clk = 0;
    Reset = 1;
    TARJETA_RECIBIDA = 0;
    TIPO_TRANS = 0;
    TIPO_STB= 0;
    DIGITO_STB = 0;
    PIN = 0;
    DIGITO = 0;
    MONTO = 0;
    MONTO_STB = 0;
    
    #15 Reset = 0; //reseteamos la máquina
    #10 Reset = 1; //
    //*Prueba 1: Depósito básico*
    #10 TARJETA_RECIBIDA = 1; //llega tarjeta
        PIN = 16'h5916;//importante recordar que es bcd
    #10 DIGITO_STB=1;//se escribe el pin correcto
        DIGITO= 5;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 9;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 1;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 6;
    #10 DIGITO_STB = 0;
    #10 TIPO_TRANS = 0; //señal depósito
        TIPO_STB=1;
    #10 TIPO_STB=0;
    #20 MONTO_STB=1;
        MONTO=10000;
    #10 MONTO_STB=0;
    #20 TARJETA_RECIBIDA = 0; //verificamos que podemos retirar la tarjeta
    //volvemos al estado idle

    //*Prueba 2: Retiro básico*
    #20 TARJETA_RECIBIDA = 0; //verificamos que podemos retirar la tarjeta
    #20 TARJETA_RECIBIDA = 1; //llega tarjeta
        PIN = 16'h5916;
    #10 DIGITO_STB=1;//se escribe el pin correcto
        DIGITO= 5;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 9;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 1;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 6;
    #10 DIGITO_STB = 0;
    #10 TIPO_TRANS = 1; //señal retiro,// se aprieta en este momento porque sino no la reconoce
        TIPO_STB=1;
    #10 TIPO_STB=0;    
    #30 MONTO_STB=1;
        MONTO=9000; 
    #10 MONTO_STB=0;
    #20 TARJETA_RECIBIDA = 0; //verificamos que podemos retirar la tarjeta

    //volvemos al estado idle

    //Prueba 3: *Fondos insuficientes.* 

    #20 TARJETA_RECIBIDA = 1; //llega tarjeta
        PIN = 16'h5916;
    #10 DIGITO_STB=1;//se escribe el pin correcto
        DIGITO= 5;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 9;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 1;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 6;
    #10 DIGITO_STB = 0;
    #10 TIPO_TRANS = 1; //señal retiro
        TIPO_STB=1;
    #10 TIPO_STB=0;
    #20 MONTO_STB=1;
        MONTO=2000;    //volvemos al estado idle
    #10 MONTO_STB=0;
    #20 TARJETA_RECIBIDA = 0; //verificamos que podemos retirar la tarjeta

    //Prueba 4: *Ingreso de pin incorrecto 3 veces*
    
    #20 TARJETA_RECIBIDA = 1; //llega tarjeta
        PIN = 16'h5916;
    #10 DIGITO_STB=1;//primer intento
        DIGITO= 4;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 9;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 1;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 6;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;//segundo intento
        DIGITO= 5;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 9;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 1;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 7;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;//tercer intento
        DIGITO= 5;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 3;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 1;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 6;
    #10 DIGITO_STB = 0;
    //Prueba 5: *reset *
    #30 Reset = 0; //reseteamos la máquina desde el bloqueo
    #10 Reset = 1; //
    #20 TARJETA_RECIBIDA = 0; //verificamos que podemos retirar la tarjeta
    #20 TARJETA_RECIBIDA = 1; //llega tarjeta
        PIN = 16'h5916;
    #10 DIGITO_STB=1;//se escribe el pin correcto
        DIGITO= 5;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 9;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 1;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 6;
    #10 DIGITO_STB = 0;
    #10 TIPO_TRANS = 1; //señal retiro
        TIPO_STB=1;
    #10 TIPO_STB=0;
    #10 Reset = 0; //reseteamos la máquina 
    #10 Reset = 1; //
    #20 TARJETA_RECIBIDA = 0; //verificamos que podemos retirar la tarjeta
    #20 TARJETA_RECIBIDA = 1; //llega tarjeta
        PIN = 16'h5916;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;//se escribe el pin correcto
        DIGITO= 5;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 9;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 1;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 6;
    #10 DIGITO_STB = 0;
    #10 TIPO_TRANS = 0; //señal depósito
        TIPO_STB=1;
    #10 TIPO_STB=0;
    #10 Reset = 0; //reseteamos la máquina 
    #10 Reset = 1; //
    #20 TARJETA_RECIBIDA = 0;

    //Prueba 6: Ingreso de pin incorrecto menos de 3 veces* 
    #20 TARJETA_RECIBIDA = 1; //llega tarjeta
        PIN = 16'h5916;
    #10 DIGITO_STB=1;//primer intento
        DIGITO= 6;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 1;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 9;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 4;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;//segundo intento
        DIGITO= 7;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 1;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 9;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 5;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;//tercer intento, pin correcto
        DIGITO= 5;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 9;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 1;
    #10 DIGITO_STB = 0;
    #10 DIGITO_STB=1;
        DIGITO= 6;
    #10 DIGITO_STB = 0;
    #10 TIPO_TRANS = 0; //señal depósito
        TIPO_STB=1;
    #10 TIPO_STB=0;
    #20 MONTO_STB=1;
        MONTO=8000;
    #10 MONTO_STB=0;
    #20 TARJETA_RECIBIDA = 0; 
    #40 $finish;
  end

  always begin
    #medio_T Clk = !Clk;
  end

endmodule

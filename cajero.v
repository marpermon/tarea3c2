/*Paulette Pérez Monge- Carnet B95916
Tarea 3 - Digitales 2
Cajero automàtico 
Maquina Mealy */

module cajero(
	Clk, Reset, PIN, TARJETA_RECIBIDA, TIPO_TRANS, DIGITO, DIGITO_STB, 
  MONTO, MONTO_STB, BALANCE_ACTUALIZADO, ENTREGAR_DINERO, FONDOS_INSUFICIENTES,
  PIN_INCORRECTO, ADVERTENCIA, Bloqueo, TIPO_STB
);

input Clk, Reset, TARJETA_RECIBIDA, TIPO_TRANS, DIGITO_STB, MONTO_STB, TIPO_STB;
input [15:0] PIN;
input [3:0] DIGITO;
input [31:0] MONTO;
output reg BALANCE_ACTUALIZADO, ENTREGAR_DINERO, FONDOS_INSUFICIENTES, PIN_INCORRECTO, ADVERTENCIA, Bloqueo;

reg [3:0] state;
reg [3:0] nxt_state;
reg [1:0] incorrecto; 
reg [1:0] nxt_incorrecto;
reg [3:0] n_dig; 
reg [3:0] nxt_n_dig; 
reg [31:0] balance; 
reg [31:0] nxt_balance; 
reg [15:0] pinCOMPLETO; 
reg [15:0] nxt_pinCOMPLETO; 

// Asignación de estados
parameter	IDLE =4'b0001;
parameter	RETIRO =4'b0010;
parameter	DEPOSITO=4'b0100;
parameter	BLOQUEADO=4'b1000;


//Memoria de estados
always @(posedge Clk) begin

  if (Reset==0)begin
    state  <= IDLE; // si hay un reset 0 empezamos con estado de espera
    incorrecto <= 0; //y con los contadores en 0
    n_dig <= 0; // 
    balance <= 0; // el balance podìa tener cualquier valor inicial
    pinCOMPLETO <= 0; 
    
  end else begin
    state  <= nxt_state;  //sino se desactiva el reset, vamos al proximo estado en memoria
    incorrecto <= nxt_incorrecto;  
    n_dig <= nxt_n_dig; // Asigna el valor próximo de nxt_n_dig a n_dig
    balance <= nxt_balance; // Asigna el valor próximo de nxt_balance a balance
    pinCOMPLETO <= nxt_pinCOMPLETO; // Asigna el valor próximo de nxt_pinCOMPLETO a pinCOMPLETO
    
  end
end


//logica combinacional
always @(*) begin
  //por defecto
  nxt_state = state;  
  nxt_incorrecto = incorrecto;
  nxt_n_dig = n_dig; // Asigna el valor actual de n_dig a nxt_n_dig
  nxt_balance = balance; // Asigna el valor actual de balance a nxt_balance
  nxt_pinCOMPLETO = pinCOMPLETO; // Asigna el valor actual de pinCOMPLETO a nxt_pinCOMPLETO


  BALANCE_ACTUALIZADO = 1'b0;
  ENTREGAR_DINERO = 1'b0;
  FONDOS_INSUFICIENTES = 1'b0;
  PIN_INCORRECTO = 1'b0;
  ADVERTENCIA = 1'b0;
  Bloqueo = 1'b0;

  case (state)
    IDLE: begin //si empezamos con la compuerta cerrada
      BALANCE_ACTUALIZADO = 1'b0;
      ENTREGAR_DINERO = 1'b0;
      FONDOS_INSUFICIENTES = 1'b0;
      PIN_INCORRECTO = 1'b0;
      ADVERTENCIA = 1'b0;
      Bloqueo = 1'b0;
        if (TARJETA_RECIBIDA) begin
          if ((DIGITO_STB) && (n_dig<4)) begin //si no es el cuarto dìgito
              nxt_pinCOMPLETO = pinCOMPLETO+(DIGITO << (12-n_dig * 4));//***revisando
              nxt_n_dig=n_dig+1;     //hay que sacar el resto del strobe    
            end   //calculamos en el siguiente ciclo de reloj, cuando se vuelva 4
          else if ((pinCOMPLETO==PIN)&&(n_dig==4)) begin
            nxt_incorrecto = 2'b00; //Cuando se ingresa la clave correcta se debe limpiar el contador de pines incorrectos
            if (TIPO_STB==1'b1) begin //le pedimos al cliente que avance la transacción
              nxt_n_dig=0;
              nxt_pinCOMPLETO=0; //ya que se evaluó el pin completo, se puede limpiar
              if (TIPO_TRANS==1'b0) nxt_state = DEPOSITO;
              else nxt_state = RETIRO;
            end
            
            end 
          else if ((pinCOMPLETO!=PIN)&&(n_dig==4)) begin
            nxt_incorrecto = incorrecto+1;
            PIN_INCORRECTO = 1'b1;
            nxt_n_dig=0;
            nxt_pinCOMPLETO=0;
            end
          //****estas hay que hacerlas independietemente de lo anterior
          if (incorrecto==2) ADVERTENCIA = 1'b1; 
          if (incorrecto>=3) begin //***usamos el nxt?? 
            nxt_state = BLOQUEADO; //si es el tercer pin incorrecto se va al estado bloqueo
            Bloqueo=1'b1; //output***està en veremos
            nxt_incorrecto=2'b0;//limpiamos el contador de pin incorrecto
            end   
          end
          //si no se ha dado el digito, no hacer nada, porque no se ha ingresado nada
        end

     

    DEPOSITO:	begin
      BALANCE_ACTUALIZADO = 1'b0;
      ENTREGAR_DINERO = 1'b0;
      FONDOS_INSUFICIENTES = 1'b0;
      PIN_INCORRECTO = 1'b0;
      ADVERTENCIA = 1'b0;
      Bloqueo = 1'b0;
      nxt_incorrecto = 2'b00; //cuando se hace una transacción se limpia el contador*
      if (MONTO_STB)
        begin
          nxt_balance=balance+MONTO;
          BALANCE_ACTUALIZADO=1'b1;
          nxt_state=IDLE;
        end
        // no hay else porque si no ha terminado de entrar, la compuerta sigue abierta
    end

    RETIRO:	begin
      BALANCE_ACTUALIZADO = 1'b0;
      ENTREGAR_DINERO = 1'b0;
      FONDOS_INSUFICIENTES = 1'b0;
      PIN_INCORRECTO = 1'b0;
      ADVERTENCIA = 1'b0;
      Bloqueo = 1'b0;
      nxt_incorrecto = 2'b00; //cuando se hace una transacción se limpia el contador*
      if (MONTO_STB)begin
        if (MONTO<=balance)begin
          nxt_balance=balance-MONTO;//le restamos el monto al balance
          BALANCE_ACTUALIZADO=1'b1;
          ENTREGAR_DINERO=1'b1;
          nxt_state=IDLE;
        end else begin
          FONDOS_INSUFICIENTES=1'b1;
          nxt_state=IDLE;
        end
      end
          
          
        // no hay else porque si no ha terminado de entrar, la compuerta sigue abierta
    end

    BLOQUEADO: begin
      BALANCE_ACTUALIZADO = 1'b0;
      ENTREGAR_DINERO = 1'b0;
      FONDOS_INSUFICIENTES = 1'b0;
      PIN_INCORRECTO = 1'b0;
      ADVERTENCIA = 1'b0;
      Bloqueo = 1'b1;
      nxt_incorrecto = 2'b00;
    end
    default nxt_state = state;
  endcase  
end

endmodule

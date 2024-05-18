//incluimos los archivos de tester y  controlador
`include "testerO.v"
//`include "cajero.v"
`include "sint_comp.v" //archivo sintetizado
`include "cmos_cellsO.v" //archivo compuertas
                                        
//modulo del testbench
module cajero_tb;
  wire Clk, Reset, TARJETA_RECIBIDA, TIPO_TRANS, DIGITO_STB, MONTO_STB, TIPO_STB;
  wire [15:0] PIN;
  wire [3:0] DIGITO;
  wire [31:0] MONTO;

  initial begin
	$dumpfile("resultados.vcd"); //generamos archivo de resultados
	$dumpvars(-1, U0);//analizamos todas las variables
	$monitor ("Clk=%b, Reset=%b, TARJETA_RECIBIDA=%b, TIPO_TRANS=%b, TIPO_STB=%b, DIGITO_STB=%b, MONTO_STB=%b, PIN=%b, DIGITO=%b, MONTO=%b", 
  Clk, Reset, TARJETA_RECIBIDA, TIPO_TRANS, TIPO_STB, DIGITO_STB, MONTO_STB, PIN, DIGITO, MONTO);
 //variables impresas en consola
  end

//modulo del cajero
cajero U0 (
    .Clk (Clk), 
    .Reset (Reset), 
    .TARJETA_RECIBIDA (TARJETA_RECIBIDA), 
    .TIPO_TRANS (TIPO_TRANS), 
    .DIGITO_STB (DIGITO_STB), 
    .MONTO_STB (MONTO_STB), 
    .PIN (PIN), 
    .DIGITO (DIGITO), 
    .MONTO (MONTO), 
    .TIPO_STB (TIPO_STB)
);

  
  //modulo del tester
  probador P0 (
    .Clk (Clk), 
    .Reset (Reset), 
    .TARJETA_RECIBIDA (TARJETA_RECIBIDA), 
    .TIPO_TRANS (TIPO_TRANS), 
    .DIGITO_STB (DIGITO_STB), 
    .MONTO_STB (MONTO_STB), 
    .PIN (PIN), 
    .DIGITO (DIGITO), 
    .MONTO (MONTO), 
    .TIPO_STB (TIPO_STB)
  );

endmodule

module spi_master(
   input clk,                // Reloj del sistema
   input reset,              // Señal de reset
   input [7:0] data_in,      // Datos de entrada para enviar
   input start,              // Inicio de la transmisión
   input [15:0] div_factor,   // Divisor del reloj para la velocidad SPI
   input  miso,          // Master In Slave Out
   output reg mosi,               // Master Out Slave In
   output reg sclk,          // Reloj SPI
   output reg cs,            // Chip Select
   output reg [7:0] data_out, // Datos recibidos
   output reg busy,          // Señal de ocupado
   output reg avail  // Señal de dato recibido
);

   reg [7:0] shift_reg;
   reg [3:0] bit_count;
   reg [15:0] clk_count;
	reg active;
   
	

	always @(posedge clk or posedge reset) begin
	  if (reset) begin
			sclk <= 0;
			cs <= 1;
			shift_reg <= 0;
			bit_count <= 0;
			clk_count <= 0;
			active <= 0;
			busy <= 0;
			avail <= 0;
	  end else if (start && !active) begin
			active <= 1;
			busy <= 1;
			avail <= 0;
			cs <= 0;
			shift_reg <= data_in;
			bit_count <= 8;
	  end else if (active) begin
			if (clk_count < div_factor - 1) begin
				 clk_count <= clk_count + 1;
			end else begin
				 clk_count <= 0;
				 sclk <= !sclk;

				 if (sclk) begin
						mosi <= shift_reg[7];
				 end else begin
					  if (bit_count > 0) begin
							bit_count <= bit_count - 1;
							shift_reg <= {shift_reg[6:0], miso};
					  end else begin
							data_out <= shift_reg;
							cs <= 1;
							active <= 0;
							busy <= 0;
							avail <= 1;
					  end
				 end
			end
	  end
	end
endmodule


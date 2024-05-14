module TopModule (
    input wire clk,
    input wire rst_n,
    output reg [6:0] seg_data,
    output reg dp,
    output [11:0] temperature
);


reg [11:0] temperature;

// Instanciación del controlador
TemperatureController controller_inst (
    .clk(clk),
    .rst_n(rst_n),
    .temperature(temperature),
    .seg_data(seg_data),
    .dp(dp)
);

endmodule

module TopMax6675 (
    input wire clk,
    input wire rst,
    input wire cs,
    input wire sclk,
    input wire serial_data,
    output reg [6:0] display_data,
    output reg [3:0] display_select
);

wire [11:0] temperature_serial; // Datos serializados de temperatura desde MAX6675_interface

// Instanciar MAX6675_interface
MAX6675_interface MAX6675_inst (
    .clk(clk),
    .rst(rst),
    .cs(cs),
    .sclk(sclk),
    .data(temperature_serial), // Conectar salida serializada de temperatura
    .drdy()
);

// Instanciar DisplayController
DisplayController display_controller_inst (
    .clk(clk),
    .rst(rst),
    .serial_data(temperature_serial), // Conectar datos serializados de temperatura
    .display_data(display_data),
    .display_select(display_select)
);

endmodule

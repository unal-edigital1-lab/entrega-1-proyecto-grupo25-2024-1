module TemperatureController (
    input wire clk,      // Entrada de reloj
    input wire rst_n,    // Entrada de reset asincrónico (activo bajo)
    output reg [11:0] temperature, // Temperatura en grados Celsius
    output reg [6:0] seg_data,     // Datos de segmentos de display
    output reg dp                  // Punto decimal
);

reg [23:0] counter;

MAX6675 max6675_inst (
    .clk(clk),
    .rst_n(rst_n),
    .cs(1'b1), // Seleccionar el chip MAX6675
    .sclk(),  // Conexión del clock de serial
    .din(),   // Conexión de datos de entrada
    .temperature(temperature)
);

SevenSegmentDisplay display_inst (
    .clk(clk),
    .rst_n(rst_n),
    .temperature(temperature),
    .seg_data(seg_data),
    .dp(dp)
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        temperature <= 12'h000; // Valor de temperatura inicial
    end else begin
        if (counter == 24000000) // 30 segundos a 50 MHz de frecuencia de reloj
            counter <= 0;
        else
            counter <= counter + 1;
    end
end

always @(posedge clk) begin
    if (counter == 24000000) 
    ;// Actualizar cada 30 segundos
        // Actualizar temperatura leyendo el MAX6675
        // Pseudocódigo: temperature <= read_temperature_from_MAX6675();
end

endmodule

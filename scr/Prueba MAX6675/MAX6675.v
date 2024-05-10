module MAX6675 (
    input wire clk,      // Entrada de reloj
    input wire rst_n,    // Entrada de reset asincrónico (activo bajo)
    input wire cs,       // Chip select
    input wire sclk,     // Clock de serial
    input wire [15:0] din, // Entrada de datos
    output reg [11:0] temperature // Salida de temperatura en grados Celsius
);

reg [15:0] data_in;
reg [15:0] data_out;
reg [3:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_in <= 16'h0000;
        data_out <= 16'h0000;
        state <= 4'b0000;
    end else begin
        case (state)
            4'b0000: begin
                // Esperar a que se active el chip select
                if (!cs)
                    state <= 4'b0001;
            end
            4'b0001: begin
                // Leer los datos de salida
                data_out <= {data_out[14:0], din[15]};
                state <= 4'b0010;
            end
            4'b0010: begin
                // Muestrear el dato de salida
                data_in <= data_out;
                state <= 4'b0011;
            end
            4'b0011: begin
                // Listo para leer el dato de salida
                state <= 4'b0000;
            end
            default: state <= 4'b0000;
        endcase
    end
end

// Convertir datos a temperatura en grados Celsius
always @(*) begin
    if (data_in[15:13] == 3'b110)
        temperature = {4'b0000, data_in[11:3]} - 12'd4096; // Temperatura negativa
    else
        temperature = data_in[11:3]; // Temperatura positiva
end

endmodule

module MAX6675_SPI (
    input wire clk, // Reloj del sistema
    input wire rst, // Señal de reinicio
    output reg [11:0] temperature, // Temperatura leída del MAX6675
    output reg data_ready // Indica cuando los datos están listos para ser leídos
);

    // Declara las señales de la interfaz SPI
    reg CS;
    reg SCK;
    wire SO;

    // Declara las variables internas
    reg [11:0] data_in;
    reg [3:0] bit_counter;

    // Máquina de estados para la lectura de datos
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            CS <= 1'b1;
            SCK <= 1'b0;
            bit_counter <= 4'b0;
            data_in <= 12'b0;
            data_ready <= 1'b0;
        end else begin
            case (bit_counter)
                4'b0000: begin
                    CS <= 1'b0; // Inicia la lectura de datos
                    bit_counter <= bit_counter + 1;
                end
                4'b0001 to 4'b1100: begin
                    SCK <= ~SCK; // Cambia el estado del reloj SPI
                    if (SCK) begin
                        data_in[bit_counter-2] <= SO; // Lee el bit de datos
                        bit_counter <= bit_counter + 1;
                    end
                end
                4'b1101: begin
                    SCK <= 1'b0; // Asegura que el reloj SPI esté en bajo
                    bit_counter <= bit_counter + 1;
                end
                4'b1110: begin
                    CS <= 1'b1; // Termina la lectura de datos
                    temperature <= data_in;
                    data_ready <= 1'b1;
                    bit_counter <= bit_counter + 1;
                end
                4'b1111: begin
                    data_ready <= 1'b0; // Espera hasta la próxima lectura de datos
                    bit_counter <= 4'b0;
                end
            endcase
        end
    end

endmodule

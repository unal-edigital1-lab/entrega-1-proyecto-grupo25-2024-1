module DisplayController(
    input wire clk,
    input wire rst,
    input wire serial_data,
    output reg [6:0] display_data,
    output reg [3:0] display_select
);

reg [11:0] serial_buffer; // Buffer para recibir datos serializados
reg [3:0] bit_count; // Contador de bits recibidos
reg [11:0] temperature; // Variable para almacenar la temperatura recibida

// Constantes para definir los estados del receptor
parameter IDLE = 2'b00;
parameter RECEIVING = 2'b01;

// Asignación de estados iniciales
reg [1:0] state = IDLE;
reg [3:0] disp_counter = 4'b0000;

// Inicialización de variables
initial begin
    serial_buffer = 12'b0000_0000_0000;
    bit_count = 4'b0000;
    temperature = 12'b0000_0000_0000;
    display_data = 7'b0000000;
    display_select = 4'b0000;
end

// Proceso principal
always @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        serial_buffer <= 12'b0000_0000_0000;
        bit_count <= 4'b0000;
        temperature <= 12'b0000_0000_0000;
        disp_counter <= 4'b0000;
    end else begin
        case(state)
            IDLE: begin
                if (serial_data == 1'b0) begin
                    // Comenzar recepción de datos
                    state <= RECEIVING;
                    bit_count <= 4'b0000;
                    serial_buffer <= 12'b0000_0000_0000;
                end
            end
            RECEIVING: begin
                if (bit_count < 4'b1100) begin
                    // Recibir datos
                    serial_buffer <= {serial_buffer[10:0], serial_data};
                    bit_count <= bit_count + 1;
                end else begin
                    // Fin de la recepción de datos
                    temperature <= serial_buffer;
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

// Proceso para mostrar la temperatura en los displays de 7 segmentos
always @(posedge clk) begin
    if (rst) begin
        display_data <= 7'b0000000;
        display_select <= 4'b0000;
    end else begin
        // Mostrar temperatura en los displays
        case(disp_counter)
            4'b0000: begin // Unidades de temperatura
                display_data <= temperature[3:0];
                display_select <= 4'b1110; // Selección del primer display
            end
            4'b0001: begin // Decenas de temperatura
                display_data <= temperature[7:4];
                display_select <= 4'b1101; // Selección del segundo display
            end
            4'b0010: begin // Centenas de temperatura
                display_data <= temperature[11:8];
                display_select <= 4'b1011; // Selección del tercer display
            end
            default: begin
                display_data <= 7'b0000000;
                display_select <= 4'b0000;
            end
        endcase

        // Contador para alternar entre los displays
        if (disp_counter == 4'b0011) begin
            disp_counter <= 4'b0000;
        end else begin
            disp_counter <= disp_counter + 1;
        end
    end
end

endmodule

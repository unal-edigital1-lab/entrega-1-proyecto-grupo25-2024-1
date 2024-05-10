module SevenSegmentDisplay (
    input wire clk,      // Entrada de reloj
    input wire rst_n,    // Entrada de reset asincrónico (activo bajo)
    input wire [11:0] temperature, // Temperatura en grados Celsius
    output reg [6:0] seg_data,     // Datos de segmentos de display
    output reg dp                  // Punto decimal
);

// Tabla de codificación de los dígitos
// B C D E F G A
// 0 0 0 0 0 1 1 -> 0
// 1 0 0 1 1 1 0 -> 1
// 0 0 1 0 0 0 1 -> 2
// 0 0 0 0 1 0 1 -> 3
// 1 0 0 1 1 0 0 -> 4
// 0 1 0 0 1 0 0 -> 5
// 0 1 0 0 0 0 0 -> 6
// 0 0 0 1 1 1 1 -> 7
// 0 0 0 0 0 0 0 -> 8
// 0 0 0 0 1 0 0 -> 9

// Asignación de segmentos para cada dígito
//           A
//        -----
//     F |  G  | B
//        -----
//     E |     | C
//        -----
//           D

always @(*) begin
    case (temperature)
        12'h000: seg_data = 7'b1000000; // 0
        12'h001: seg_data = 7'b1111001; // 1
        12'h002: seg_data = 7'b0100100; // 2
        12'h003: seg_data = 7'b0110000; // 3
        12'h004: seg_data = 7'b0011001; // 4
        12'h005: seg_data = 7'b0010010; // 5
        12'h006: seg_data = 7'b0000010; // 6
        12'h007: seg_data = 7'b1111000; // 7
        12'h008: seg_data = 7'b0000000; // 8
        12'h009: seg_data = 7'b0010000; // 9
        default: seg_data = 7'b1111111; // Apagar todos los segmentos
    endcase
end

endmodule

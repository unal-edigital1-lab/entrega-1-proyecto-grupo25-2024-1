module DisplayController(
    input wire clk,
    input wire reset,
    input wire [15:0] temperature,
    output reg [6:0] seg_display
);

reg [3:0] digit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        digit_counter <= 4'd0;
    end else if ($fell(clk)) begin
        digit_counter <= (digit_counter == 4'd9) ? 4'd0 : digit_counter + 1;
    end
end

always @(posedge clk) begin
    case(digit_counter)
        // Asignar temperatura a cada display de 7 segmentos en función del contador de dígitos aquí
    endcase
end

endmodule

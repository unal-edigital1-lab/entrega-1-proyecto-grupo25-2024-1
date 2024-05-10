module usage_MAX7219 (
    input sys_clk, _rst, _str, 
    output CS, CLK, Din,
    input [1:0] image
);

reg [3:0] IRreg = 4'b0000;
reg [7:0] data = 8'h00;
reg [7:0] display[7:0];
reg [22:0] cnt = 23'd0;
reg clk_roll = 1'b0;

MAX7219 #(
    .Freq_KiloHZ(12)
) U0 (
    .sys_clk(sys_clk),
    ._rst(_rst),
    ._str(_str),
    .Din(Din),
    .CS(CS),
    .CLK(CLK),
    .IRreg(IRreg),
    .data(data)
);

always @(posedge sys_clk) begin
    if (_rst) begin
        cnt <= 23'd0;
        clk_roll <= 1'b0;
    end else begin
        if (cnt == 23'd5000000) begin
            clk_roll <= ~clk_roll;
            cnt <= 23'd0;
        end else begin
            clk_roll <= clk_roll;
            cnt <= cnt + 1'b1;
        end
    end
end

always @(posedge sys_clk) begin
    if (_rst) begin
        // Reiniciar valores de display si es necesario
    end else begin
        case (image)
            2'b00: begin
                display[0] <= 8'b00111100;
                display[1] <= 8'b01111110;
                display[2] <= 8'b11011011;
                display[3] <= 8'b11111111;
                display[4] <= 8'b10111101;
                display[5] <= 8'b11000011;
                display[6] <= 8'b01111110;
                display[7] <= 8'b00111100;
            end
            2'b01: begin
                display[0] <= 8'b00111100;
                display[1] <= 8'b01111110;
                display[2] <= 8'b11011011;
                display[3] <= 8'b11111111;
                display[4] <= 8'b11111111;
                display[5] <= 8'b10000001;
                display[6] <= 8'b01111110;
                display[7] <= 8'b00111100;
            end
            2'b10: begin
                display[0] <= 8'b00111100;
                display[1] <= 8'b01111110;
                display[2] <= 8'b11011011;
                display[3] <= 8'b11111111;
                display[4] <= 8'b11111111;
                display[5] <= 8'b11000011;
                display[6] <= 8'b10111101;
                display[7] <= 8'b01111110;
            end
            2'b11: begin
                display[0] <= 8'b11111111;
                display[1] <= 8'b10111101;
                display[2] <= 8'b11011011;
                display[3] <= 8'b11100111;
                display[4] <= 8'b11100111;
                display[5] <= 8'b11011011;
                display[6] <= 8'b10111101;
                display[7] <= 8'b11111111;
            end
        endcase
    end
end

endmodule

module MAX6675_interface (
    input wire clk,         // Clock input
    input wire rst,         // Reset input
    input wire cs,          // Chip select input
    input wire sclk,        // Serial clock input
    output reg [11:0] data, // Data output (12 bits)
    output reg drdy         // Data ready output
);

reg [11:0] shift_reg;      // Shift register for SPI communication
reg [3:0]  bit_count;      // Counter for bit shifting

// State machine states
parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;

reg [1:0] state;            // State machine state

// Counter for conversion delay
reg [7:0] conv_delay_cnt;
parameter CONV_DELAY = 8'd10; // Adjust according to datasheet

// Assign initial values
initial begin
    state <= IDLE;
    bit_count <= 4'd0;
    shift_reg <= 12'd0;
    drdy <= 1'b0;
    conv_delay_cnt <= 8'd0;
    data <= 12'd0;
end

// State machine
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        bit_count <= 4'd0;
        shift_reg <= 12'd0;
        drdy <= 1'b0;
        conv_delay_cnt <= 8'd0;
        data <= 12'd0;
    end else begin
        case(state)
            IDLE: begin
                if (cs == 1'b0) begin
                    state <= SHIFT;
                    bit_count <= 4'd0;
                    shift_reg <= 12'd0;
                    drdy <= 1'b0;
                    conv_delay_cnt <= 8'd0;
                end
            end
            SHIFT: begin
                if (sclk == 1'b1) begin
                    if (bit_count < 4'd15) begin
                        shift_reg <= {shift_reg[10:0], sdo};
                        bit_count <= bit_count + 4'd1;
                    end else begin
                        drdy <= 1'b1;
                        data <= shift_reg[11:0];
                        conv_delay_cnt <= conv_delay_cnt + 8'd1;
                        if (conv_delay_cnt >= CONV_DELAY) begin
                            state <= IDLE;
                        end
                    end
                end
            end
            default: state <= IDLE;
        endcase
    end
end

// Connect MAX6675 SPI signals
assign sdo = cs ? 1'b1 : shift_reg[0];

endmodule

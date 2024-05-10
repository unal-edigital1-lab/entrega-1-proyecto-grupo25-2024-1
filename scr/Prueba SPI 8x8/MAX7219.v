module MAX7219 (
    input sys_clk, _rst, _str,
    input [7:0] IRreg,
    input [7:0] data,
    output reg CS, CLK, Din,
    output reg busy
);

parameter Freq_KiloHZ = 12;
reg [5:0] cnt = 6'd0;
reg [2:0] state = 3'd0;
reg [2:0] flag = 3'b001;
reg [2:0] TxCnt = 3'd0;

parameter IDLE     = 3'd0;
parameter Address  = 3'd1;
parameter TxData   = 3'd2;
parameter finished = 3'd3;
parameter ON       = 8'h01;
parameter OFF      = 8'h00;

always @(*) begin
    // Cálculo de la señal busy
    busy = (state == IDLE) ? 1'b0 : 1'b1;
end

always @(posedge sys_clk, negedge _rst) begin
    if (!_rst) begin
        cnt <= 6'd0;
        // No es necesario asignar a sys_clk en un always
    end else begin
        if (_str) begin
            if (cnt == Freq_KiloHZ/2) begin
                // sys_clk <= ~sys_clk; // Esto debería ser parte de un bloque siempre activo, no aquí
                cnt <= 6'd0;
            end else 
                cnt <= cnt + 1'b1;
        end else begin
            cnt <= 6'd0;
            // No es necesario asignar a sys_clk en un always
        end
    end
end

always @(posedge sys_clk) begin
    if (!_rst) begin
        flag <= 3'b001;
        CS <= 1'b1;
        TxCnt <= 3'd7;
        state <= IDLE;
    end else begin
        case(state)
            IDLE: begin
                if (_str) begin
                    TxCnt <= 3'd7;
                    CS <= 1'b0;
                    flag <= 3'b001;
                    state <= Address;
                end else begin
                    CS <= 1'b1;
                    state <= IDLE;
                end
            end
            Address: begin
                flag <= flag << 1;
                if (flag == 3'b001)
                    Din <= IRreg[TxCnt];
                else if (flag == 3'b010)
                    CLK <= 1'b1;
                else if (flag == 3'b100) begin
                    CLK <= 1'b0;
                    flag <= 3'b001;
                    if (TxCnt == 3'd0) begin
                        TxCnt <= 3'd7;
                        state <= TxData;
                    end else
                        TxCnt <= TxCnt - 1'b1;
                end
            end
            TxData: begin
                flag <= flag << 1;
                if (flag == 3'b001)
                    Din <= data[TxCnt];
                else if (flag == 3'b010)
                    CLK <= 1'b1;
                else if (flag == 3'b100) begin
                    CLK <= 1'b0;
                    flag <= 3'b001;
                    if (TxCnt == 3'd0) begin
                        TxCnt <= 3'd7;
                        state <= finished;
                    end else
                        TxCnt <= TxCnt - 1'b1;
                end
            end
            finished: begin
                Din <= 1'b0;
                CS <= 1'b1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule

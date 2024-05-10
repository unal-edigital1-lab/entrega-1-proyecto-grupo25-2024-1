module usage_MAX7219(sys_clk, _rst, _str, Din, CS, CLK, shutdown, image);
input sys_clk, _rst, _str, shutdown;
input [1:0] image;
output Din, CS, CLK;
/*---------------------------------------------------*/
reg [3:0]IRreg = 4'b0000;
reg [7:0]data = 8'h00;
reg clk_roll = 1'b0;
reg [7:0]display[7:0];
/*---------------------------------------------------*/
MAX7219#(.Freq_KiloHZ(12))
		 U0(.sys_clk(sys_clk), ._rst(_rst), .str(~_str), .busy(busy), .IRreg({4'b0000,IRreg}), .data(data), .CS(CS), .CLK(CLK), .Din(Din));
/*---------------------------------------------------*/
reg [22:0]cnt = 'd0;
	always@(posedge sys_clk)begin
		if(!_rst)begin
			cnt      <= 'd0;
			clk_roll <= 1'b0;
		end
		else begin
			if(cnt=='d200)begin
				clk_roll <= ~clk_roll;
				cnt <= 'd0;
			end
			else
				cnt <= cnt + 1'b1;
		end
	end
/*---------------------------------------------------*/
	always@(posedge clk_roll, negedge _rst)begin
		if(!_rst)begin
           case(image[1:0])
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
					display[0] <= 8'b00000000;
					display[1] <= 8'b01000010;
					display[2] <= 8'b00100100;
					display[3] <= 8'b00011000;
					display[4] <= 8'b00011000;
					display[5] <= 8'b00100100;
					display[6] <= 8'b01000010;
					display[7] <= 8'b00000000;

				end
				default: begin
					// Código por defecto si no se cumple ninguna de las condiciones anteriores
				end
			endcase
		end
	end
/*---------------------------------------------------*/
	always@(negedge busy, negedge _rst)begin
		if(!_rst)
			IRreg <= 4'd0;
		else
			IRreg <= IRreg + 1;
	end
/*---------------------------------------------------*/
	always@(IRreg)begin
		case(IRreg)
			4'h0:data  = 8'h00;
			4'h1:data  = display[0];
			4'h2:data  = display[1];
			4'h3:data  = display[2];
			4'h4:data  = display[3];
			4'h5:data  = display[4];
			4'h6:data  = display[5];
			4'h7:data  = display[6];
			4'h8:data  = display[7];
			4'h9:data  = 8'h00;//decode mode
			4'hA:data  = 8'h00;//light(0~15)
			4'hB:data  = 8'h07;//scanline(0~7)
			4'hC:data  = {7'b0000000,shutdown};//shutdown
			4'hF:data  = 8'h00;//test
			default:data  = 8'h00;
		endcase
	end
/*---------------------------------------------------*/
	
endmodule 
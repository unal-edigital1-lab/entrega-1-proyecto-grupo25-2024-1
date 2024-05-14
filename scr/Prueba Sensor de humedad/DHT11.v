module DHT11(
    input wire clk,     // Señal de reloj
    input wire rst,     // Señal de reset
    input wire dht_data, // Comunicación con el DHT11
    output wire [1:0] temp_bits // Salida de dos bits para la temperatura
);

reg [7:0] data;
reg [2:0] count;
reg [1:0] temperature;
wire [1:0] temp_bits_wire;

assign temp_bits = temp_bits_wire;

always @(posedge clk or posedge rst) begin
    case (count)
        3'b000:
            if (rst) begin
                data <= 8'b0;
                count <= 3'b0;
                temperature <= 2'b0;
            end
        3'b001:
            if (rst) begin
                data <= 8'b0;
            end else begin
                data <= {data[6:0], dht_data};
            end
        3'b010:
            if (rst) begin
                // No se necesita hacer nada en este estado durante el reset
            end else if (data == 8'b00000101) begin
                count <= count + 1;
            end
        3'b011:
            if (rst) begin
                // No se necesita hacer nada en este estado durante el reset
            end else begin
                temperature[0] <= (data[7] == 1'b1); // Primer bit (mayor a 25°C)
                count <= count + 1;
            end
        3'b100:
            if (rst) begin
                // No se necesita hacer nada en este estado durante el reset
            end else begin
                temperature[1] <= (data[7] == 1'b1); // Segundo bit (menor a 15°C)
                count <= count + 1;
            end
        default:
            count <= 3'b0;
    endcase
end

assign temp_bits_wire = temperature;

endmodule

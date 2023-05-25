module PE(
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    input wire [7:0] weight_in,
    output reg [7:0] weight_out,
    output reg [31:0] sum
);

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            data_out <= 0;
            weight_out <= 0;
            sum <= 0;
        end
        else if(en) begin
            data_out <= data_in;
            weight_out <= weight_in;
            sum <= data_in[7]^weight_in[7] ? sum - data_in[6:0]*weight_in[6:0] : sum + data_in[6:0]*weight_in[6:0];
        end
    end
endmodule

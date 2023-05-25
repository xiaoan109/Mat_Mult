module PE_array4x4(
    input wire clk,
    input wire rst_n,
    // Global Enable
    input wire en,
    // Data an Weight Ports
    input wire [7:0] data_in0,
    input wire [7:0] data_in1,
    input wire [7:0] data_in2,
    input wire [7:0] data_in3,
    input wire [7:0] weight_in0,
    input wire [7:0] weight_in1,
    input wire [7:0] weight_in2,
    input wire [7:0] weight_in3,
    // Output Data Selection
    input wire [3:0] out_sel,
    output wire [31:0] result
);

    wire [7:0] tmp_data [11:0];
    wire [7:0] tmp_weight [11:0];
    wire [31:0] tmp_result [15:0];

    reg [7:0] data_reg1_0;
    reg [7:0] data_reg2_0;
    reg [7:0] data_reg2_1;
    reg [7:0] data_reg3_0;
    reg [7:0] data_reg3_1;
    reg [7:0] data_reg3_2;

    reg [7:0] weight_reg1_0;
    reg [7:0] weight_reg2_0;
    reg [7:0] weight_reg2_1;
    reg [7:0] weight_reg3_0;
    reg [7:0] weight_reg3_1;
    reg [7:0] weight_reg3_2;

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            data_reg1_0 <= 0;
            data_reg2_0 <= 0;
            data_reg2_1 <= 0;
            data_reg3_0 <= 0;
            data_reg3_1 <= 0;
            data_reg3_2 <= 0;
            weight_reg1_0 <= 0;
            weight_reg2_0 <= 0;
            weight_reg2_1 <= 0;
            weight_reg3_0 <= 0;
            weight_reg3_1 <= 0;
            weight_reg3_2 <= 0;
        end
        else if(en) begin
            data_reg1_0 <= data_in1;
            data_reg2_0 <= data_in2;
            data_reg2_1 <= data_reg2_0;
            data_reg3_0 <= data_in3;
            data_reg3_1 <= data_reg3_0;
            data_reg3_2 <= data_reg3_1;
            weight_reg1_0 <= weight_in1;
            weight_reg2_0 <= weight_in2;
            weight_reg2_1 <= weight_reg2_0;
            weight_reg3_0 <= weight_in3;
            weight_reg3_1 <= weight_reg3_0;
            weight_reg3_2 <= weight_reg3_1;
        end
    end

    PE u0_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (data_in0),
        .data_out  (tmp_data[0]),
        .weight_in (weight_in0),
        .weight_out(tmp_weight[0]),
        .sum       (tmp_result[0])
    );
    PE u1_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (data_reg1_0),
        .data_out  (tmp_data[1]),
        .weight_in (tmp_weight[0]),
        .weight_out(tmp_weight[4]),
        .sum       (tmp_result[1])
    );
    PE u2_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (data_reg2_1),
        .data_out  (tmp_data[2]),
        .weight_in (tmp_weight[4]),
        .weight_out(tmp_weight[8]),
        .sum       (tmp_result[2])
    );
    PE u3_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (data_reg3_2),
        .data_out  (tmp_data[3]),
        .weight_in (tmp_weight[8]),
        .weight_out(),
        .sum       (tmp_result[3])
    );
    PE u4_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (tmp_data[0]),
        .data_out  (tmp_data[4]),
        .weight_in (weight_reg1_0),
        .weight_out(tmp_weight[1]),
        .sum       (tmp_result[4])
    );
    PE u5_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (tmp_data[1]),
        .data_out  (tmp_data[5]),
        .weight_in (tmp_weight[1]),
        .weight_out(tmp_weight[5]),
        .sum       (tmp_result[5])
    );
    PE u6_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (tmp_data[2]),
        .data_out  (tmp_data[6]),
        .weight_in (tmp_weight[5]),
        .weight_out(tmp_weight[9]),
        .sum       (tmp_result[6])
    );
    PE u7_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (tmp_data[3]),
        .data_out  (tmp_data[7]),
        .weight_in (tmp_weight[9]),
        .weight_out(),
        .sum       (tmp_result[7])
    );
    PE u8_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (tmp_data[4]),
        .data_out  (tmp_data[8]),
        .weight_in (weight_reg2_1),
        .weight_out(tmp_weight[2]),
        .sum       (tmp_result[8])
    );
    PE u9_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (tmp_data[5]),
        .data_out  (tmp_data[9]),
        .weight_in (tmp_weight[2]),
        .weight_out(tmp_weight[6]),
        .sum       (tmp_result[9])
    );
    PE u10_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (tmp_data[6]),
        .data_out  (tmp_data[10]),
        .weight_in (tmp_weight[6]),
        .weight_out(tmp_weight[10]),
        .sum       (tmp_result[10])
    );
    PE u11_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (tmp_data[7]),
        .data_out  (tmp_data[11]),
        .weight_in (tmp_weight[10]),
        .weight_out(),
        .sum       (tmp_result[11])
    );
    PE u12_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (tmp_data[8]),
        .data_out  (),
        .weight_in (weight_reg3_2),
        .weight_out(tmp_weight[3]),
        .sum       (tmp_result[12])
    );
    PE u13_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (tmp_data[9]),
        .data_out  (),
        .weight_in (tmp_weight[3]),
        .weight_out(tmp_weight[7]),
        .sum       (tmp_result[13])
    );
    PE u14_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (tmp_data[10]),
        .data_out  (),
        .weight_in (tmp_weight[7]),
        .weight_out(tmp_weight[11]),
        .sum       (tmp_result[14])
    );
    PE u15_PE(
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .data_in   (tmp_data[11]),
        .data_out  (),
        .weight_in (tmp_weight[11]),
        .weight_out(),
        .sum       (tmp_result[15])
    );

    assign result = tmp_result[out_sel];


endmodule
module PA_top(
    input wire clk,
    input wire rst_n,
    // Control Signals
    input wire start,
    // Size of Matrix
    input wire [31:0] lhs_rows,
    input wire [31:0] rhs_rows,
    input wire [31:0] rhs_cols,
    // Data Ports
    input wire [31:0] din,
    output wire [31:0] dout,
    // Memory Access
    output reg wen,
    output reg ren,
    output reg [31:0] addr
    // // NICE Interface
    // // Command Channel
    // output wire nice_icb_cmd_valid,
    // input wire nice_icd_cmd_ready,
    // output wire [31:0] nice_icb_cmd_addr,
    // output wire nice_icb_cmd_read,
    // output wire [31:0] nice_icb_cmd_wdata,
    // output wire [1:0] nice_icb_cmd_size,
    // output wire nice_icb_cmd_mmode,
    // output wire nice_mem_holdup,
    // // Responce Channel
    // input wire nice_icb_rsp_valid,
    // output wire nice_icb_rsp_ready,
    // input wire [31:0] nice_icb_rsp_rdata,
    // input wire nice_icb_rsp_err
);
    // State Machine
    parameter IDLE = 6'b000001;
    parameter LOAD_RHS = 6'b000010;
    parameter LOAD_LHS = 6'b000100;
    parameter STORE_RESULT = 6'b001000;

    reg [5:0] cur_state;
    reg [5:0] next_state;

    // FIFO data
    reg [15:0] weightfifo_rd;
    reg [15:0] weightfifo_wr;
    reg [31:0] weightfifo_wdata [15:0];
    wire [7:0] weightfifo_rdata [15:0];

    reg [3:0] datafifo_rd;
    reg [3:0] datafifo_wr;
    reg [31:0] datafifo_wdata [3:0];
    wire [7:0] datafifo_rdata [3:0];

    // Output
    reg [3:0] out_sel;
    wire [31:0] result [3:0];



    // Counters
    parameter ARRAY_SIZE = 4*16;
    reg [31:0] lhs_rows_cnt;
    reg [31:0] lhs_cols_cnt;
    reg [31:0] rhs_rows_cnt;
    reg [31:0] rhs_cols_cnt;
    reg [31:0] store_cnt;

    genvar i;
    generate
        for(i=0;i<16;i=i+1) begin
            FIFO #(8, 9) u_weight_fifo(
                .clk(clk),
                .resetn(rst_n),
                .rd(weightfifo_rd[i]),
                .wr(weightfifo_wr[i]),
                .w_data(weightfifo_wdata[i]),
                .r_data(weightfifo_rdata[i])
            );
        end
        for(i=0;i<4;i=i+1) begin
            FIFO #(8, 3) u_data_fifo(
                .clk(clk),
                .resetn(rst_n),
                .rd(datafifo_rd[i]),
                .wr(datafifo_wr[i]),
                .w_data(datafifo_wdata[i]),
                .r_data(datafifo_rdata[i])
            );
        end
        for(i=0; i<4; i=i+1) begin
            PE_array4x4 u_PE_array(
                .clk       (clk),
                .rst_n     (rst_n),
                .en        (en),
                .data_in0  (datafifo_rdata[0]),
                .data_in1  (datafifo_rdata[1]),
                .data_in2  (datafifo_rdata[2]),
                .data_in3  (datafifo_rdata[3]),
                .weight_in0(weightfifo_rdata[i]),
                .weight_in1(weightfifo_rdata[i+4]),
                .weight_in2(weightfifo_rdata[i+8]),
                .weight_in3(weightfifo_rdata[i+12]),
                .out_sel   (out_sel),
                .result    (result[i])
            );
        end
    endgenerate



    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            cur_state <= IDLE;
        end
        else begin
            cur_state <= next_state;
        end
    end

    always @(*) begin
        next_state = cur_state;
        case(cur_state)
            IDLE:
                if(start) begin
                    next_state = LOAD_RHS;
                end
                else begin
                    next_state = IDLE;
                end
            LOAD_RHS:
                if(rhs_cols_cnt == rhs_cols) begin
                    next_state = LOAD_LHS;
                end
                else begin
                    next_state = LOAD_RHS;
                end
            LOAD_LHS:
                if(lhs_cols_cnt == rhs_cols) begin
                    next_state = STORE_RESULT;
                end
                else begin
                    next_state = LOAD_LHS;
                end
            STORE_RESULT:
                if(store_cnt == ARRAY_SIZE) begin
                    if(lhs_rows_cnt == lhs_rows) begin
                        if(rhs_rows_cnt == rhs_rows) begin
                            next_state  = IDLE;
                        end
                        else begin
                           next_state = LOAD_RHS; 
                        end
                    end
                    else begin
                        next_state = LOAD_LHS;
                    end
                end
                else begin
                    next_state = STORE_RESULT;
                end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            wen <= 1'b0;
            ren <= 1'b0;
            addr <= 32'b0;
            datafifo_rd <= 4'b0;
            datafifo_wr <= 4'b0;
            datafifo_wdata[0] <= 32'b0;
            datafifo_wdata[1] <= 32'b0;
            datafifo_wdata[2] <= 32'b0;
            datafifo_wdata[3] <= 32'b0;
            weightfifo_rd <= 16'b0;
            weightfifo_wr <= 16'b0;
            weightfifo_wdata[0] <= 32'b0;
            weightfifo_wdata[1] <= 32'b0;
            weightfifo_wdata[2] <= 32'b0;
            weightfifo_wdata[3] <= 32'b0;
            weightfifo_wdata[4] <= 32'b0;
            weightfifo_wdata[5] <= 32'b0;
            weightfifo_wdata[6] <= 32'b0;
            weightfifo_wdata[7] <= 32'b0;
            weightfifo_wdata[8] <= 32'b0;
            weightfifo_wdata[9] <= 32'b0;
            weightfifo_wdata[10] <= 32'b0;
            weightfifo_wdata[11] <= 32'b0;
            weightfifo_wdata[12] <= 32'b0;
            weightfifo_wdata[13] <= 32'b0;
            weightfifo_wdata[14] <= 32'b0;
            weightfifo_wdata[15] <= 32'b0;
            lhs_rows_cnt <= 32'b0;
            lhs_cols_cnt <= 32'b0;
            rhs_rows_cnt <= 32'b0;
            rhs_cols_cnt <= 32'b0;
            store_cnt <= 32'b0;
        end
        else begin
            if(cur_state == LOAD_RHS) begin
                wen <= 1'b0;
                ren <= 1'b1;
                addr <= rhs_rows_cnt*rhs_cols + rhs_cols_cnt;
            end
        end
    end





endmodule
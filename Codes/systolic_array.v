module systolic_array_2x2 #(
    parameter DATA_WIDTH = 8
)(
    input  wire                      clk,
    input  wire                      reset,
    input  wire                      start,
    
    input  wire [DATA_WIDTH-1:0]     A00, A01, 
    input  wire [DATA_WIDTH-1:0]     A10, A11,
    input  wire [DATA_WIDTH-1:0]     B00, B01, 
    input  wire [DATA_WIDTH-1:0]     B10, B11,
    
    output wire [(2*DATA_WIDTH)-1:0] C00, C01,
    output wire [(2*DATA_WIDTH)-1:0] C10, C11,
    output reg                       done
);

    reg [2:0] cycle_count;
    reg       pe_en;

    always @(posedge clk) begin
        if (reset) begin
            cycle_count <= 0;
            pe_en       <= 0;
            done        <= 0;
        end else if (start) begin
            pe_en <= 1;
            if (cycle_count < 3'd5) begin
                cycle_count <= cycle_count + 1;
            end else begin
                pe_en <= 0; 
                done  <= 1; 
            end
        end
    end

    reg [DATA_WIDTH-1:0] rA0_idx1, rA1_idx0, rA1_idx1;
    reg [DATA_WIDTH-1:0] rB0_idx1, rB1_idx0, rB1_idx1;

    always @(posedge clk) begin
        if (reset) begin
            rA0_idx1 <= 0; rA1_idx0 <= 0; rA1_idx1 <= 0;
            rB0_idx1 <= 0; rB1_idx0 <= 0; rB1_idx1 <= 0;
        end else if (pe_en) begin
            rA0_idx1 <= A01;
            rA1_idx0 <= A10;
            rA1_idx1 <= A11;

            rB0_idx1 <= B10;
            rB1_idx0 <= B01;
            rB1_idx1 <= B11;
        end
    end

    wire [DATA_WIDTH-1:0] pe00_A = (cycle_count == 0) ? A00      : (cycle_count == 1) ? rA0_idx1 : 0;
    wire [DATA_WIDTH-1:0] pe10_A = (cycle_count == 1) ? rA1_idx0 : (cycle_count == 2) ? rA1_idx1 : 0;

    wire [DATA_WIDTH-1:0] pe00_B = (cycle_count == 0) ? B00      : (cycle_count == 1) ? rB0_idx1 : 0;
    wire [DATA_WIDTH-1:0] pe01_B = (cycle_count == 1) ? rB1_idx0 : (cycle_count == 2) ? rB1_idx1 : 0;

    wire [DATA_WIDTH-1:0] net_A00_to_01, net_B00_to_10;
    wire [DATA_WIDTH-1:0] net_A10_to_11, net_B01_to_11;
    wire [DATA_WIDTH-1:0] junk_B01, junk_A10, junk_A11, junk_B11;

    PE #(.DATA_WIDTH(DATA_WIDTH)) pe00 (
        .clk(clk), .reset(reset), .en(pe_en),
        .A_in(pe00_A), .B_in(pe00_B),
        .A_out(net_A00_to_01), .B_out(net_B00_to_10), .Acc_out(C00)
    );

    PE #(.DATA_WIDTH(DATA_WIDTH)) pe01 (
        .clk(clk), .reset(reset), .en(pe_en),
        .A_in(net_A00_to_01), .B_in(pe01_B),
        .A_out(junk_A10), .B_out(net_B01_to_11), .Acc_out(C01)
    );

    PE #(.DATA_WIDTH(DATA_WIDTH)) pe10 (
        .clk(clk), .reset(reset), .en(pe_en),
        .A_in(pe10_A), .B_in(net_B00_to_10),
        .A_out(net_A10_to_11), .B_out(junk_B01), .Acc_out(C10)
    );

    PE #(.DATA_WIDTH(DATA_WIDTH)) pe11 (
        .clk(clk), .reset(reset), .en(pe_en),
        .A_in(net_A10_to_11), .B_in(net_B01_to_11),
        .A_out(junk_A11), .B_out(junk_B11), .Acc_out(C11)
    );

endmodule
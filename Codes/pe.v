module PE#(parameter DATA_WIDTH = 8)(
    input wire clk,
    input wire reset,
    input wire en,
    input wire[DATA_WIDTH-1:0] A_in,
    input wire[DATA_WIDTH-1:0] B_in,
    output reg[DATA_WIDTH-1:0] A_out,
    output reg[DATA_WIDTH-1:0] B_out,
    output reg[2*DATA_WIDTH-1:0] Acc_out
);
wire [(2*DATA_WIDTH)-1:0] product;
    wire [(2*DATA_WIDTH)-1:0] sum;
    assign product = A_in * B_in;
    assign sum = Acc_out + product;
    always @(posedge clk) begin
        if (reset) begin
            A_out <= 0;
            B_out <= 0;
            Acc_out <= 0;
        end else if (en) begin
            A_out <= A_in;
            B_out <= B_in;
            Acc_out <= sum;
        end
    end
endmodule
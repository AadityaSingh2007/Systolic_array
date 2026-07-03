`timescale 1ns/1ps

module PE_tb;
reg clk;
reg reset;
reg en;

reg [7:0] A_in;
reg [7:0] B_in;

wire [7:0] A_out;
wire [7:0] B_out;

wire [15:0] Acc_out;
PE #(
    .DATA_WIDTH(8)
) dut (
    .clk(clk),
    .reset(reset),
    .en(en),
    .A_in(A_in),
    .B_in(B_in),
    .A_out(A_out),
    .B_out(B_out),
    .Acc_out(Acc_out)
);
always #5 clk = ~clk;
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, PE_tb);
end

initial begin

    clk = 0;
    reset = 1;
    en = 0;

    A_in = 0;
    B_in = 0;

    #10;
    reset = 0;
    en = 1;
    A_in = 2;
    B_in = 3;

    #10;
    A_in = 4;
    B_in = 5;

    #10;
    A_in = 1;
    B_in = 7;

    #10;
    $finish;

end
always @(posedge clk)
begin
    $display("Time=%0t  A=%d  B=%d  Acc=%d",
              $time, A_in, B_in, Acc_out);
end
endmodule

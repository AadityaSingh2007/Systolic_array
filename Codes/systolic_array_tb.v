`timescale 1ns/1ps

module systolic_array_tb;
    reg clk;
    reg reset;
    reg start;

    reg [7:0] A00, A01, A10, A11;
    reg [7:0] B00, B01, B10, B11;

    wire [15:0] C00, C01, C10, C11;
    wire done;

    systolic_array_2x2 #(.DATA_WIDTH(8)) uut (
        .clk(clk), .reset(reset), .start(start),
        .A00(A00), .A01(A01), .A10(A10), .A11(A11),
        .B00(B00), .B01(B01), .B10(B10), .B11(B11),
        .C00(C00), .C01(C01), .C10(C10), .C11(C11),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        start = 0;
        
        A00 = 2; A01 = 3;
        A10 = 4; A11 = 5;

        B00 = 1; B01 = 2;
        B10 = 3; B11 = 4;

        #15;
        reset = 0; 
        start = 1; 

        @(posedge done);
        #5;
        
        $display("\n--- Computation Finished! ---");
        $display("Resulting Matrix C:");
        $display("[%3d  %3d]", C00, C01);
        $display("[%3d  %3d]", C10, C11);
        $display("\n");
        
        $finish;
    end
initial begin
    $dumpfile("systolic_wave.vcd"); // Name of the waveform output file
    $dumpvars(0, systolic_array_tb); // Dump all signals in the testbench and below
end
endmodule
module alu_tb;
reg [3:0] A, B, opcode;
wire [3:0] C;

alu uut(
    .A(A),
    .B(B),
    .opcode(opcode),
    .C(C)
);
initial begin
    $dumpfile("alu.vcd");   // This is the waveform output file
    $dumpvars(0, alu_tb);   // Dumps everything in the testbench

    $monitor("A: %b B: %b opcode: %b => C: %b", A, B, opcode, C);

    // Try ADD
    A = 4'b0011; B = 4'b0101; opcode = 4'b0000; #10;

    // Try SUB
    A = 4'b1000; B = 4'b0010; opcode = 4'b0001; #10;

    // Try AND
    A = 4'b1010; B = 4'b1100; opcode = 4'b0010; #10;

    // Try OR
    A = 4'b1010; B = 4'b1100; opcode = 4'b0011; #10;

    // Try NOT A
    A = 4'b1111; opcode = 4'b0101; #10;

    $finish;
  end
endmodule



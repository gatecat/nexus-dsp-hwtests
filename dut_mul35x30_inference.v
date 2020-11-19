module dut(
	input a_signed, b_signed,
	input [34:0] a,
	input [29:0] b,
	output [64:0] z
);

	assign z = a * b;

endmodule

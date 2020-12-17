module dut(
	input [8:0] a0, a1, a2, a3, b0, b1, b2, b3,
	input [3:0] addsub,
	input is_signed,
	input [53:0] c,
	output [53:0] z
);
	MULTADDSUB9X9WIDE #(
		.REGINPUTAB0("BYPASS"),
		.REGINPUTAB1("BYPASS"),
		.REGINPUTAB2("BYPASS"),
		.REGINPUTAB3("BYPASS"),
		.REGINPUTC("BYPASS"),
		.REGADDSUB("BYPASS"),
		.REGLOADC("BYPASS"),
		.REGLOADC2("BYPASS"),
		.REGPIPELINE("BYPASS"),
		.REGOUTPUT("BYPASS")
	) mult_i (
		.A0(a0), .A1(a1), .A2(a2), .A3(a3),
		.B0(b0), .B1(b1), .B2(b2), .B3(b3),
		.ADDSUB(addsub), .SIGNED(is_signed), .C(c), .LOADC(1'b1),
		.Z(z)
	);
endmodule

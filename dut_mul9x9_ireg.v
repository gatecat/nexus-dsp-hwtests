module dut(
	input clk, strobe,
	input cea, ceb, rsta, rstb,
	input a_signed, b_signed,
	input [8:0] a, b,
	output [17:0] z
);

	MULT9X9 #(
		.REGINPUTA("REGISTER"),
		.REGINPUTB("REGISTER"),
		.REGOUTPUT("BYPASS"),
		.GSR("DISABLED")
	) mult_i (
		.CLK(clk),
		.A(a), .CEA(cea && strobe), .RSTA(rsta && strobe),
		.B(b), .CEB(ceb && strobe), .RSTB(rstb && strobe),
		.SIGNEDA(a_signed),
		.SIGNEDB(b_signed),
		.Z(z)
	);

endmodule

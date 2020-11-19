module dut(
	input clk, strobe,
	input ceout, rstout,
	input a_signed, b_signed,
	input [8:0] a, b,
	output [17:0] z
);

	MULT9X9 #(
		.REGINPUTA("BYPASS"),
		.REGINPUTB("BYPASS"),
		.REGOUTPUT("REGISTER"),
		.GSR("DISABLED")
	) mult_i (
		.CLK(clk),
		.A(a),
		.B(b),
		.SIGNEDA(a_signed),
		.SIGNEDB(b_signed),
		.CEOUT(ceout && strobe), .RSTOUT(rstout && strobe),
		.Z(z)
	);

endmodule

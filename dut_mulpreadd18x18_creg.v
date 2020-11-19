module dut(
	input clk, strobe,
	input a_signed, b_signed, c_signed,
	input [17:0] a, b, c,
	input rstc, cec,
	output [35:0] z
);

	MULTPREADD18X18 #(
		.REGINPUTA("BYPASS"),
		.REGINPUTB("BYPASS"),
		.REGINPUTC("REGISTER"),
		.REGOUTPUT("BYPASS"),
		.GSR("DISABLED")
	) mult_i (
		.CLK(clk),
		.A(a),
		.B(b),
		.C(c),
		.RSTC(rstc && strobe), .CEC(cec && strobe),
		.SIGNEDA(a_signed),
		.SIGNEDB(b_signed),
		.SIGNEDC(c_signed),
		.Z(z)
	);

endmodule

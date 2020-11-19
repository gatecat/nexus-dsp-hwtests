module dut(
	input a_signed, b_signed, c_signed,
	input [8:0] a, b, c,
	output [17:0] z
);

	MULTPREADD9X9 #(
		.REGINPUTA("BYPASS"),
		.REGINPUTB("BYPASS"),
		.REGINPUTC("BYPASS"),
		.REGOUTPUT("BYPASS"),
		.GSR("DISABLED")
	) mult_i (
		.A(a),
		.B(b),
		.C(c),
		.SIGNEDA(a_signed),
		.SIGNEDB(b_signed),
		.SIGNEDC(c_signed),
		.Z(z)
	);

endmodule

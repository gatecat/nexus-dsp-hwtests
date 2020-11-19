module dut(
	input a_signed, b_signed, c_signed,
	input [17:0] a, b, c,
	output [35:0] z
);

	MULTPREADD18X18 #(
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

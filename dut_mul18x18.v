module dut(
	input a_signed, b_signed,
	input [17:0] a, b,
	output [35:0] z
);

	MULT18X18 #(
		.REGINPUTA("BYPASS"),
		.REGINPUTB("BYPASS"),
		.REGOUTPUT("BYPASS"),
		.GSR("DISABLED")
	) mult_i (
		.A(a),
		.B(b),
		.SIGNEDA(a_signed),
		.SIGNEDB(b_signed),
		.Z(z)
	);

endmodule

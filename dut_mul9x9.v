module dut(
	input a_signed, b_signed,
	input [8:0] a, b,
	output [17:0] z
);

	MULT9X9 #(
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

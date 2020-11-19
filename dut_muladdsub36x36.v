module dut(
	input is_signed, addsub, cin,
	input [35:0] a, b,
	input [107:0] c,
	output [107:0] z
);

	MULTADDSUB36X36 #(
		.REGINPUTA("BYPASS"),
		.REGINPUTB("BYPASS"),
		.REGINPUTC("BYPASS"),
		.REGADDSUB("BYPASS"),
		.REGLOADC("BYPASS"),
		.REGLOADC2("BYPASS"),
		.REGCIN("BYPASS"),
		.REGPIPELINE("BYPASS"),
		.REGOUTPUT("BYPASS"),
		.GSR("DISABLED")
	) mult_i (
		.A(a),
		.B(b),
		.C(c),
		.SIGNED(is_signed),
		.ADDSUB(addsub),
		.LOADC(1'b1),
		.CIN(cin),
		.Z(z)
	);

endmodule

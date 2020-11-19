module dut(
	input is_signed, addsub, cin,
	input [17:0] a, b,
	input [53:0] c,
	output [53:0] z
);

	MULTADDSUB18X18 #(
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

module dut(
	input clk, strobe,
	input ceout, rstout,
	input is_signed, addsub, cin,
	input loadc,
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
		.REGOUTPUT("REGISTER"),
		.GSR("DISABLED")
	) mult_i (
		.CLK(clk),
		.A(a),
		.B(b),
		.C(c),
		.CEOUT(ceout && strobe), .RSTOUT(rstout && strobe),
		.SIGNED(is_signed),
		.ADDSUB(addsub),
		.LOADC(loadc),
		.CIN(cin),
		.Z(z)
	);

endmodule

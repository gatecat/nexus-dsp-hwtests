module dut(
	input clk, strobe,
	input [2:0] cepipe, rstpipe, cectrl, rstctrl, cec, rstc, cecin, rstcin,
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
		.REGPIPELINE("REGISTER"),
		.REGOUTPUT("BYPASS"),
		.GSR("DISABLED")
	) mult_i (
		.CLK(clk),
		.A(a),
		.B(b),
		.C(c),
		.CEPIPE(|cepipe && strobe), .RSTPIPE(&rstpipe && strobe),
		.CECTRL(|cectrl && strobe), .RSTCTRL(&cectrl && strobe),
		.CEC(|cec && strobe), .RSTC(&rstc && strobe),
		.CECIN(|cecin && strobe), .RSTCIN(&rstcin && strobe),
		.SIGNED(is_signed),
		.ADDSUB(addsub),
		.LOADC(1'b1),
		.CIN(cin),
		.Z(z)
	);

endmodule

module dut(
	input clk, strobe,
	input a_signed, b_signed,
	// using a vector here and reduce-and/oring reduces the probability of being reset/disabled
	input [2:0] cea, ceb, rsta, rstb,
	input [2:0] ceout, rstout,

	input [35:0] a,
	input [35:0] b,
	output [71:0] z
);

	MULT36X36 #(
		.REGINPUTA("REGISTER"),
		.REGINPUTB("REGISTER"),
		.REGOUTPUT("REGISTER"),
		.GSR("DISABLED")
	) mult_i (
		.CLK(clk),
		.A(a), .CEA(|cea && strobe), .RSTA(&rsta && strobe),
		.B(b), .CEB(|ceb && strobe), .RSTB(&rstb && strobe),
		.SIGNEDA(a_signed),
		.SIGNEDB(b_signed),
		.CEOUT(|ceout && strobe), .RSTOUT(&rstout && strobe),
		.Z(z)
	);

endmodule

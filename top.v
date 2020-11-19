module top(input gsrn, uart_rx, output uart_tx, output [3:0] led);

	wire clk, strobe;

	OSC_CORE #(
		.HF_CLK_DIV("15")
	) osc_i (
		.HFOUTEN(1'b1),
		.HFCLKOUT(clk)
	);

	reg reset = 1'b1;
	always @(posedge clk)
		reset <= !gsrn;

	`include `DUT_INCLUDE

	control #(
		.FREQ(28125000),
		.BAUD(115200),
		.DOUT_WIDTH(DOUT_WIDTH),
		.DIN_WIDTH(DIN_WIDTH)
	) ctrl_i (
		.clk(clk),
		.reset(reset),
		.uart_rx(uart_rx),
		.uart_tx(uart_tx),

		.strobe(strobe),
		.dout(dut_din),
		.din(dut_dout)
	);

	reg [23:0] led_ctr;
	always @(posedge clk)
		if (reset) led_ctr <= 0;
		else led_ctr <= led_ctr + 1'b1;

	assign led = ~{reset, ~uart_tx, ~uart_rx, led_ctr[23]};

endmodule

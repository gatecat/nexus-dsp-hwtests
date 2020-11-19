`default_nettype none

module control #(
	parameter FREQ = 28125000,
	parameter BAUD = 115200,
	parameter DOUT_WIDTH = 64,
	parameter DIN_WIDTH = 64
) (
	input clk, reset,
	input uart_rx,
	output uart_tx,

	output reg strobe,
	output reg [DOUT_WIDTH-1:0] dout,
	input [DIN_WIDTH-1:0] din
);

	localparam DOUT_NIBBLES = (DOUT_WIDTH + 3) / 4;
	localparam DIN_NIBBLES = (DIN_WIDTH + 3) / 4;

	reg [DOUT_NIBBLES*4 - 1 : 0] dout_sr = 0;

	wire uart_rx_ready;
	wire [7:0] uart_rx_data;

	reg [1:0] shift_out_state;
	reg [15:0] shift_out_ctr;
	reg [7:0] uart_tx_data;
	reg uart_tx_valid = 1'b0;

	wire uart_tx_busy;

	always @(posedge clk) begin
		strobe <= 1'b0;

		if (uart_rx_ready) begin
			if (uart_rx_data[7:4] == 4'h4) // Shift in nibble
				dout_sr <= {dout_sr[DOUT_NIBBLES*4 - 5 : 0], uart_rx_data[3:0]};
			else if (uart_rx_data == 8'h6F) begin // Start shift out
				shift_out_ctr <= 16'hFFFF;
				shift_out_state <= 1;
				strobe <= 1'b1;
			end
		end

		if (shift_out_state == 1) begin
			uart_tx_valid <= 1'b1;
			shift_out_state <= 2;
		end else if (shift_out_state == 2) begin
			uart_tx_valid <= 1'b0;
			shift_out_state <= 3;
		end else if (shift_out_state == 3) begin
			if (!uart_tx_busy) begin
				shift_out_ctr <= shift_out_ctr + 1'b1;
				if (shift_out_ctr < DIN_NIBBLES || &shift_out_ctr)
					shift_out_state <= 1;
				else
					shift_out_state <= 0;
			end
		end

		dout <= dout_sr;
		uart_tx_data <= &shift_out_ctr ? 8'h07 : {4'h4, din[shift_out_ctr * 4 +: 4]};
		if (reset) begin
			dout <= 0;
			dout_sr <= 0;
			shift_out_ctr <= 0;
			shift_out_state <= 1'b0;
			uart_tx_data <= 0;
			uart_tx_valid <= 0;
			strobe <= 1'b0;
		end
	end


    uart_rx #(
        .clk_freq(FREQ),
        .baud(BAUD)
    ) uart_rx_i (
        .clk(clk),
        .rx(uart_rx),
        .rx_ready(uart_rx_ready),
        .rx_data(uart_rx_data)
    );

    uart_tx #(
        .clk_freq(FREQ),
        .baud(BAUD)
    ) uart_tx_i (
        .clk(clk),
        .tx_start(uart_tx_valid),
        .tx_data(uart_tx_data),
        .tx_busy(uart_tx_busy),
        .tx(uart_tx)
    );

endmodule


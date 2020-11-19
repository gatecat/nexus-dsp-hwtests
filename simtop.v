module simtop;
	`include `DUT_INCLUDE

	reg clk;
	always #5 clk = (clk === 1'b0);

	reg strobe = 1'b0;
	reg [DOUT_WIDTH-1:0] dout_reg;
	assign dut_din = dout_reg;

	localparam Nwarmup = 10;
	localparam N = 1000;

	integer fp;

	initial begin
		fp = $fopen(`VECTORS_FILE);

		repeat (Nwarmup) begin
			dout_reg = {(DOUT_WIDTH){1'b1}};
			repeat (5) @(posedge clk);
			strobe = 1'b1;
			repeat (1) @(posedge clk);
			strobe = 1'b0;
			repeat (5) @(posedge clk);
			$fdisplay(fp, "%b %b warmup", dout_reg, dut_dout);
		end

		repeat (N) begin
			dout_reg = {((DOUT_WIDTH+31)/32){$random}};
			repeat (5) @(posedge clk);
			strobe = 1'b1;
			repeat (1) @(posedge clk);
			strobe = 1'b0;
			repeat (5) @(posedge clk);
			$fdisplay(fp, "%b %b", dout_reg, dut_dout);
		end

		$fclose(fp);

		$finish;
	end

endmodule

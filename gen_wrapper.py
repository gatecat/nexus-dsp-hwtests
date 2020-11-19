from get_ports import get_ports
import sys

def main():
	inputs, outputs = get_ports(sys.argv[1])
	i_width = 0
	o_width = 0
	for i, w in inputs:
		if i == "clk":
			assert w == 1
			continue
		i_width += w
	for o, w in outputs:
		o_width += w
	with open(sys.argv[2], "w") as vhf:
		print("localparam DOUT_WIDTH = {};".format(i_width), file=vhf)
		print("localparam DIN_WIDTH = {};".format(o_width), file=vhf)
		print("wire [{}:0] dut_din;".format(i_width-1), file=vhf)
		print("wire [{}:0] dut_dout;".format(o_width-1), file=vhf)
		conn = []
		i_offset = 0
		o_offset = 0
		for i, w in inputs:
			if i == "clk" or i == "strobe":
				conn.append(".{i}({i})".format(i=i))
			else:
				conn.append(".{}(dut_din[{} +: {}])".format(i, i_offset, w))
				i_offset += w
		for o, w in outputs:
			conn.append(".{}(dut_dout[{} +: {}])".format(o, o_offset, w))
			o_offset += w
		print("dut dut_i ({});".format(",\n    ".join(conn)), file=vhf)

if __name__ == '__main__':
	main()

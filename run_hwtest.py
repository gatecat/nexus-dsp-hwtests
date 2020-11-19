from get_ports import get_ports
import serial
import sys

def write_vector(port, vec, count):
	msg = bytearray()
	for i in range(0, count, 4):
		nibble = 0
		for j in range(4):
			if (i + j) >= count:
				continue
			if vec & (1 << (i + j)):
				nibble |= (1 << j)
		msg.append(0x40 | nibble)
	# reversed shift order
	msg.reverse()
	port.write(msg)

def read_vector(port, count):
	port.reset_input_buffer()
	port.write(bytes([0x6F]))
	port.flush()
	nibbles = ((count + 3) // 4)
	msg = port.read(nibbles + 1)
	assert len(msg) == (nibbles + 1), len(msg)
	assert msg[0] == 0x07
	bitvec = 0
	for i in range(count):
		if msg[(i // 4) + 1] & (1 << (i % 4)):
			bitvec |= (1 << i)
	return bitvec

def fmt_vector(ports, vec):
	offset = 0
	vals = []
	for p, w in ports:
		if p in ("clk", "strobe"):
			continue
		port_value = (vec >> offset) & ((1 << w) - 1)
		vals.append("{p}={val:0{width}b}".format(p=p, val=port_value, width=w))
		offset += w
	return " ".join(vals)

def main():
	retcode = 0
	pass_count = 0
	fail_count = 0
	total_count = 0
	with serial.Serial(port=sys.argv[1], baudrate=115200) as port, \
			open(sys.argv[3], "r") as vf, \
			open(sys.argv[4], "w") as logf:
		inputs, outputs = get_ports(sys.argv[2])
		for line in vf:
			sl = line.strip().split(" ")
			if len(sl) < 2:
				continue
			inp_vec = int(sl[0], 2)
			outp_vec = int(sl[1], 2)
			warmup = len(sl) == 3 and sl[2] == "warmup"
			print("input: {}".format(fmt_vector(inputs, inp_vec)), file=logf)
			print(" exp: {}".format(fmt_vector(outputs, outp_vec)), file=logf)
			write_vector(port, inp_vec, len(sl[0]))
			dut_vec = read_vector(port, len(sl[1]))
			if not warmup:
				# During the warmup period, we flush out any old state and so don't check the output
				if dut_vec == outp_vec:
					print("PASS", file=logf)
					pass_count += 1
				else:
					print(" dut: {} *FAIL*".format(fmt_vector(outputs, dut_vec)), file=logf)
					fail_count += 1
					retcode = 1
				if (total_count + 1) % 20 == 0:
					print("count={:5d} pass={:5d} fail={:5d}".format(total_count + 1, pass_count, fail_count))
				total_count += 1
			else:
				print(" dut: {} *WARMUP*".format(fmt_vector(outputs, dut_vec)), file=logf)
			print(file=logf)
			logf.flush()
	print("{} passed, {} failed".format(pass_count, fail_count))
	return retcode

if __name__ == '__main__':
	sys.exit(main())

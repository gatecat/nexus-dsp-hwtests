import json

def get_ports(f):
	with open(f, "r") as jf:
		parsed = json.load(jf)

	assert "dut" in parsed["modules"]

	dut = parsed["modules"]["dut"]

	inputs = []
	outputs = []

	for port_name in sorted(dut["ports"].keys()):
		port_data = dut["ports"][port_name]
		assert port_data["direction"] in ("input", "output")
		if port_data["direction"] == "input":
			inputs.append((port_name, len(port_data["bits"])))
		else:
			outputs.append((port_name, len(port_data["bits"])))

	return (inputs, outputs)

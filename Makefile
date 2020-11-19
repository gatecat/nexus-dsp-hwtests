BUILD_DIR=.build

SIM_VLOG=simtop.v
HW_VLOG=top.v control.v uart_rx.v uart_tx.v uart_baud_tick_gen.v

PDC=vip.pdc

PORT=/dev/ttyUSB1

$(BUILD_DIR)/dut_%.json: dut_%.v
	yosys -p "write_json $@" $<

$(BUILD_DIR)/dut_%.vh: $(BUILD_DIR)/dut_%.json
	python3 gen_wrapper.py $< $@

$(BUILD_DIR)/dut_%.vvp: $(BUILD_DIR)/dut_%.vh dut_%.v $(SIM_VLOG)
	iverilog -o $@ -DDUT_INCLUDE=\"$(BUILD_DIR)/dut_$*.vh\" -DVECTORS_FILE=\"$(BUILD_DIR)/vectors_$*.txt\" dut_$*.v $(SIM_VLOG) -I"`yosys-config --datdir`/nexus" "`yosys-config --datdir`/nexus/cells_sim.v"

$(BUILD_DIR)/vectors_%.txt: $(BUILD_DIR)/dut_%.vvp
	vvp $^


$(BUILD_DIR)/hw_%.json: dut_%.v $(BUILD_DIR)/dut_%.vh $(HW_VLOG)
	yosys -p 'read_verilog -DDUT_INCLUDE="$(BUILD_DIR)/dut_$*.vh" dut_$*.v $(HW_VLOG); synth_nexus -top top -json $@'

$(BUILD_DIR)/hw_%.fasm: $(BUILD_DIR)/hw_%.json $(PDC)
	nextpnr-nexus --json $< --fasm $@ --device LIFCL-40-9BG400CES --router router2 --pdc $(PDC)

$(BUILD_DIR)/hw_%.bit: $(BUILD_DIR)/hw_%.fasm
	prjoxide pack $< $@

%.prog: $(BUILD_DIR)/hw_%.bit
	ecpprog -S $<

%.run: %.prog $(BUILD_DIR)/dut_%.json $(BUILD_DIR)/vectors_%.txt
	python3 run_hwtest.py $(PORT) $(BUILD_DIR)/dut_$*.json $(BUILD_DIR)/vectors_$*.txt $(BUILD_DIR)/hw_$*.log

.PHONY: %.prog %.run
.SECONDARY:

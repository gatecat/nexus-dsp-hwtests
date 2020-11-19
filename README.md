Prerequisites: Yosys, nextpnr-nexus, prjoxide, Icarus Verilog, Lattice CrossLink-NX VIP

Run `make test_name.run` to run a test (e.g. `make muladdsub36x36.run`)

1000 test vectors are generated for the DUT using Icarus and the Yosys sim models. A harness is programmed to the device that lets inputs be written and outputs be read over the UART, and these vectors are compared against the 'golden' simulation results.


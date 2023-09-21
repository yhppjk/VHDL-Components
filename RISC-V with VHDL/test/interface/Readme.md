# This Folder has stored interface code and testbench

## The interface_1 has the completed version of interface
	
	
## The unused_code has the former version of interface.
	
		
## interface_1

	This folder contains :
		1. the elements of interface
			1. addr_interface: address part
			2. mock of memory: to simulate the reaction of memory
			3. mux2togen: mux element
			4. rdata_interface1: to output rdata, step 1
			5. rdata_interface2: to output rdata, step 2
			6. register1_interface: a register for saving certain signal value
			7. registergen_interface: a register for saving certain signal value
			8. registergen_PRDATA: a register for saving PRDATA64 value
			9. size_interface: to get the correct size for processing
			10. wdata_interface: to input wdata
			
		2. the interface code
		
		3. the interface testbench
		
		4. the interface testbench package
		
### testbench
	The testbench will use the list in the package to simulate the reactions of interface.
	The mock of memory is to respond the correct signal to make interface work.
	
	
`include "rooms.sv"
`include "gold_states.sv"

import rooms::*;
import gold_states::*;

module gold_state_machine(input logic clk,
								  input logic reset,
								  input room_state room,
								  output logic gold);
		
	gold_state current, next;
	
	always_ff @(posedge clk, posedge reset)
		if(reset) current <= G0;
		else current <= next;
		
	always_comb
		case (current)
			G0: if (room == R4) next = G1;
				  else next = G0;
			G1: next = G1;
		endcase
		
	assign gold = (next == G1);
endmodule
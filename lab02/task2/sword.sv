`include "rooms.sv"
`include "sword_states.sv"

import rooms::*;
import sword_states::*;

module sword_state_machine(input logic clk,
								   input logic reset,
								   input room_state room,
								   output logic sword);
		
	sword_state current, next;
	
	always_ff @(posedge clk, posedge reset)
		if(reset) current <= SW0;
		else current <= next;
		
	always_comb
		case (current)
			SW0: if (room == R6) next = SW1;
				  else next = SW0;
			SW1: next = SW1;
		endcase
		
	assign sword = (next == SW1);
endmodule
`include "rooms.sv"
import rooms::*;

module room_state_machine(input logic clk,
								  input logic reset,
								  input logic n, s, e, w,
								  input logic sword, shield, amulet,
								  output room_state room);
		
	room_state current, next;
	
	always_ff @(posedge clk,
					posedge reset)
		if (reset) current <= R1;
		else current <= next;
		
	always_comb 
		case (current)
			R1: if (n) next = R2;
				 else if (e) next = R3;
				 else next = R1;
			R2: if (s) next = R1;
				 else next = R2;
			R3: if (n) next = R4;
				 else if (w) next = R1;
				 else if (s) next = R5;
				 else next = R3;
			R4: if (s) next = R3;
				 else next = R4;
			R5: if (w) next = R6;
				 else if (n) next = R3;
				 else if (s) next = R7;
				 else if (e) next = R8;
				 else next = R5;
			R6: if (e) next = R5;
				 else next = R6;
			R7: if (n) next = R5;
				 else next = R7;
			R8: if (w) next = R5;
				 else if (sword || shield) next = R10;
				 else next = R9;
			R9: if (amulet && (s || n || e || w)) next = R10;
				 else next = R9;
			R10: next = R10;
			default: next = R1;
		endcase
		
	assign room = next;
endmodule
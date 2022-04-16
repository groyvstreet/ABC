`include "rooms.sv"
import rooms::*;

module lab02_task2(input logic clk,
						 input logic reset,
						 input logic n, s, e, w,
						 output logic win, die);
						 
	room_state room;
	logic sword, gold, shield, amulet;
	
	room_state_machine r(clk, reset, n, s, e, w, sword, shield, amulet, room);
	sword_state_machine sw(clk, reset, room, sword);
	gold_state_machine g(clk, reset, room, gold);
	shield_state_machine sh(clk, reset, room, gold, shield);
	amulet_state_machine a(clk, reset, room, amulet);
	
	assign win = (room == R10);
	assign die = (room == R9);
endmodule
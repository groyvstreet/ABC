import states::*;

module main_state_machine(input logic clk,
								  input logic reset,
								  input logic [6:0] op,
								  output logic branch,
								  output logic pcupdate,
								  output logic regwrite,
								  output logic memwrite,
								  output logic irwrite,
								  output logic [1:0] resultsrc,
								  output logic [1:0] alusrcb,
								  output logic [1:0] alusrca,
								  output logic adrsrc,
								  output logic [1:0] aluop);
	state current, next;
	always_ff @(posedge clk,
					posedge reset)
		if (reset) current <= FETCH;
		else current <= next;
	
	always_comb 
		case (current)
			FETCH: next = DECODE;
			DECODE: case (op)
							7'b0000011: next = MEMADR;
							7'b0100011: next = MEMADR;
							7'b0110011: next = EXECUTER;
							7'b0010011: next = EXECUTEL;
							7'b1101111: next = JAL;
							7'b1100011: next = BEQ;
							default:		next = UNKNOWN;
					  endcase
			MEMADR: case (op)
							7'b0000011: next = MEMREAD;
							7'b0100011: next = MEMWRITE;
							default:		next = UNKNOWN;
					  endcase
			EXECUTER: next = ALUWB;
			EXECUTEL: next = ALUWB;
			JAL:		 next = ALUWB;
			BEQ:		 next = FETCH;
			MEMREAD:  next = MEMWB;
			MEMWRITE: next = FETCH;
			ALUWB: 	 next = FETCH;
			MEMWB:	 next = FETCH;
			default:  next = UNKNOWN;
		endcase
	assign {branch, pcupdate, regwrite, memwrite, irwrite, resultsrc, alusrcb, alusrca, adrsrc, aluop} = current;
endmodule
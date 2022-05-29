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
	typedef enum logic [13:0] {
		FETCH  	= 14'b0_1_0_0_1_10_10_00_0_00,
		DECODE 	= 14'b0_0_0_0_0_00_01_01_0_00,
		MEMADR 	= 14'b0_0_0_0_0_00_01_10_0_00,
		EXECUTER = 14'b0_0_0_0_0_00_00_10_0_10,
		EXECUTEL = 14'b0_0_0_0_0_00_01_10_0_10,
		JAL 		= 14'b0_1_0_0_0_00_10_01_0_00,
		BEQ		= 14'b1_0_0_0_0_00_00_10_0_01,
		MEMREAD  = 14'b0_0_0_0_0_00_00_00_1_00,
		MEMWRITE = 14'b0_0_0_1_0_00_00_00_1_00,
		ALUWB		= 14'b0_0_1_0_0_00_00_00_0_00,
		MEMWB		= 14'b0_0_1_0_0_01_00_00_0_00,
		UNKNOWN  = 14'bx_x_x_x_x_xx_xx_xx_x_xx
	} state;
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
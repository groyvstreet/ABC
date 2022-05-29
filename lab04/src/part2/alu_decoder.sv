module alu_decoder(input logic [1:0] aluop,
						 input logic opb5,
						 input logic [2:0] funct3,
						 input logic funct7b5,
						 output logic [2:0] alucontrol);
	logic rtypesub;
	assign rtypesub = funct7b5 & opb5; // TRUE for R-type subtract instruction
	always_comb
		case(aluop)
			2'b00: alucontrol = 3'b000; // addition
			2'b01: alucontrol = 3'b001; // subtraction
			default: case(funct3) // R-type or I-type ALU
							3'b000: if (rtypesub) 
											alucontrol = 3'b001; // sub
									  else 
											alucontrol = 3'b000; // add, addi
							3'b010: alucontrol = 3'b101; // slt, slti
							3'b110: alucontrol = 3'b011; // or, ori
							3'b111: alucontrol = 3'b010; // and, andi
							default: alucontrol = 3'bxxx; // ???
						endcase
		endcase
endmodule
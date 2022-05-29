module controller(input logic clk,
						input logic reset, 
						input logic [6:0] op,
						input logic [2:0] funct3,
						input logic funct7b5,
						input logic zero,
						output logic [1:0] immsrc,
						output logic [1:0] alusrca, alusrcb,
						output logic [1:0] resultsrc, 
						output logic adrsrc,
						output logic [2:0] alucontrol,
						output logic irwrite, pcwrite, 
						output logic regwrite, memwrite);
	logic branch, pcupdate;
	logic [1:0] aluop;
	main_state_machine msm(clk,
								  reset,
								  op,
								  branch,
								  pcupdate,
								  regwrite,
								  memwrite,
								  irwrite,
								  resultsrc,
								  alusrcb,
								  alusrca,
								  adrsrc,
								  aluop);
	alu_decoder ad(aluop, op[5], funct3, funct7b5, alucontrol);
	instruction_decoder id(op, immsrc);
	assign pcwrite = (zero & branch) | pcupdate;
endmodule
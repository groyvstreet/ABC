///////////////////////////////////////////////////////////////
// top
//
// Instantiates multicycle RISC-V processor and memory
///////////////////////////////////////////////////////////////

module top(input  logic        clk, reset, 
           output logic [31:0] WriteData, DataAdr, 
           output logic        MemWrite);

  logic [31:0] ReadData;
  
  // instantiate processor and memories
  riscvmulti rvmulti(clk, reset, MemWrite, DataAdr, 
                     WriteData, ReadData);
  mem mem(clk, MemWrite, DataAdr, WriteData, ReadData);
endmodule

///////////////////////////////////////////////////////////////
// mem
//
// Single-ported RAM with read and write ports
// Initialized with machine language program
///////////////////////////////////////////////////////////////

module mem(input  logic        clk, we,
           input  logic [31:0] a, wd,
           output logic [31:0] rd);

  logic [31:0] RAM[63:0];
  
  initial
      $readmemh("riscvtest.txt",RAM);

  assign rd = RAM[a[31:2]]; // выравнивание на слово

  always_ff @(posedge clk)
    if (we) RAM[a[31:2]] <= wd;
endmodule

///////////////////////////////////////////////////////////////
// riscvmulti
//
// Multicycle RISC-V microprocessor
///////////////////////////////////////////////////////////////

module riscvmulti(input  logic        clk, reset,
                  output logic        memwrite,
                  output logic [31:0] adr, writedata,
                  input  logic [31:0] readdata);
	logic [31:0] instr;
	logic zero;
	logic [1:0] immsrc, alusrca, alusrcb, resultsrc;
	logic [2:0] alucontrol;
	logic adrsrc, irwrite, pcwrite, regwrite;
	controller c(clk,
				    reset, 
				    instr[6:0],
				    instr[14:12],
					 instr[30],
				    zero,
				    immsrc,
				    alusrca,
				    alusrcb,
				    resultsrc, 
				    adrsrc,
				    alucontrol,
				    irwrite,
				    pcwrite, 
				    regwrite,
				    memwrite);
	
	logic [31:0] pc, oldpc, result, data;
	
	flopenr #(32) flen1(clk, reset, pcwrite, result, pc);
	mux2 #(32) m2(pc, result, adrsrc, adr);
	flopenr #(32) flen2(clk, reset, irwrite, pc, oldpc);
	flopenr #(32) flen3(clk, reset, irwrite, readdata, instr);
	flopr #(32) fl1(clk, reset, readdata, data);
	
	logic [31:0] rd1, rd2, immext, a, srcb, srca, aluresult, aluout;
	
	regfile regf(clk, regwrite, instr[19:15], instr[24:20], instr[11:7], result, rd1, rd2);
	extend ext(instr[31:7], immsrc, immext);
	flopr #(32) fl2(clk, reset, rd1, a);
	flopr #(32) fl3(clk, reset, rd2, writedata);
	mux3 #(32) m3_1(pc, oldpc, a, alusrca, srca);
	mux3 #(32) m3_2(writedata, immext, 4, alusrcb, srcb);
	alu al(srca, srcb, alucontrol, aluresult, zero);
	flopr #(32) fl4(clk, reset, aluresult, aluout);
	mux3 #(32) m3_3(aluout, data, aluresult, resultsrc, result);
endmodule
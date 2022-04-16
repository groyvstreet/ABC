module testbench(); 
	logic clk, reset;
	logic left, right, la, lb, lc, ra, rb, rc;
	logic [5:0] expected;
	logic [31:0] vectornum, errors;
	logic [7:0] testvectors[10000:0];
	
	lab02_task1 dut(clk, reset, left, right, la, lb, lc, ra, rb, rc);
	
	always
		begin
			clk=1; #5; clk=0; #5; 
		end
		
	initial
		begin
			$readmemb("thunderbird.tv", testvectors); 
			vectornum = 0; errors = 0; reset = 1; #22; reset = 0; 
		end
		
	always @(posedge clk) 
		begin
			#1; {left, right, expected} = testvectors[vectornum]; 
		end
		
	always @(negedge clk) 
		if (~reset) begin
			if ({la, lb, lc, ra, rb, rc} !== expected) begin
				$display("Error: inputs = %b", {left, right});
				$display(" outputs = %b %b %b %b %b %b (%b expected)", 
					la, lb, lc, ra, rb, rc, expected); 
				errors = errors + 1; 
			end
			vectornum = vectornum + 1;
			if (testvectors[vectornum] === 8'bx) begin
				$display("%d tests completed with %d errors", vectornum, errors); 
				$stop; 
			end
		end
endmodule
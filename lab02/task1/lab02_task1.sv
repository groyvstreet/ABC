module lab02_task1(input logic clk,
						 input logic reset,
						 input logic left, right,
						 output logic la, lb, lc, ra, rb, rc);
	logic [3:0] q;
	logic [3:0] q_next;
	
	assign q_next[0] = (!q[0] && q[1] && !q[3]) || (!q[0] &&  q[2] && !q[3]) || (!q[0] && !q[1]
								&& !q[2] && q[3]) || (left && !right && !q[0] && !q[3]);
	assign q_next[1] = (q[0] && !q[1] && !q[2]) || (!q[0] && q[1] && !q[3]) || (!left && right &&
								!q[0] && !q[2] && !q[3]);
	assign q_next[2] = (!q[0] && q[2] && !q[3]) || (q[0] && q[1] && !q[2] && !q[3]) || (!left &&
								right && !q[0] && !q[1] && !q[3]);
	assign q_next[3] = (!q[1] && !q[2] && q[3]) || (q[0] && q[1] && q[2] && !q[3]);
	
	always_ff @(posedge clk,
					posedge reset)
		if (reset) q <= 4'b0;
		else q <= q_next;
	
	assign lc = !q_next[1] && q_next[2] && !q_next[3];
	assign lb = (q_next[0] && q_next[1] && !q_next[2] && !q_next[3]) || (!q_next[0] && !q_next[1] && q_next[2] && !q_next[3]);
	assign la = q_next[1] && !q_next[2] && !q_next[3];
	assign ra = (q_next[0] && q_next[1] && q_next[2] && !q_next[3]) || (!q_next[0] && !q_next[1] && !q_next[2] && q_next[3]);
	assign rb = !q_next[1] && !q_next[2] && q_next[3];
	assign rc = (q_next[0] && !q_next[1] && !q_next[2] && q_next[3]) || (!q_next[0] && q_next[1] && !q_next[2] && q_next[3]);
endmodule
module radix2
  (
   input		CLK,
   input		RST_X,
   input signed [32:0] IN0_RE,
   input signed [32:0] IN0_IM,
   input signed [32:0] IN1_RE,
   input signed [32:0] IN1_IM,

   output signed [32:0] OUT0_RE,
   output signed [32:0] OUT0_IM,
   output signed [32:0] OUT1_RE,
   output signed [32:0] OUT1_IM
   );

	//wire[32:0] WX1_RE, WX1_IM;
	assign OUT0_RE = IN0_RE + IN1_RE;
	assign OUT0_IM = IN0_IM + IN1_IM;
	assign OUT1_RE = IN0_RE - IN1_RE;
	assign OUT1_IM = IN0_IM - IN1_IM;
   //‚ ‚ ‚ 

endmodule

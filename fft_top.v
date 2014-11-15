module fft_top
  (
   input		CLK,
   input		RST_X,
   input signed [32:0] IN0_RE,
   input signed [32:0] IN0_IM,
   input signed [32:0] IN1_RE,
   input signed [32:0] IN1_IM,
   input signed [32:0] IN2_RE,
   input signed [32:0] IN2_IM,
   input signed [32:0] IN3_RE,
   input signed [32:0] IN3_IM,

   output signed [32:0] OUT0_RE,
   output signed [32:0] OUT0_IM,
   output signed [32:0] OUT1_RE,
   output signed [32:0] OUT1_IM,
   output signed [32:0] OUT2_RE,
   output signed [32:0] OUT2_IM,
   output signed [32:0] OUT3_RE,
   output signed [32:0] OUT3_IM
   );

    //radix wire
   	wire signed [32:0] WX0_RE, WX1_RE, WX2_RE, WX3_RE;
	wire signed [32:0] WX0_IM, WX1_IM, WX2_IM, WX3_IM;

	//MULT wire
   	wire signed [32:0] MX0_RE, MX1_RE, MX2_RE, MX3_RE;
	wire signed [32:0] MX0_IM, MX1_IM, MX2_IM, MX3_IM;

	wire signed[1:0] W0_RE, W1_RE, W2_RE, W3_RE;
	wire signed[1:0] W0_IM, W1_IM, W2_IM, W3_IM;

	assign W0_RE = 1;
	assign W0_IM = 0;
	assign W1_RE = 0;
	assign W1_IM = -1;
	assign W2_RE = 1;
	assign W2_IM = 0;
	assign W3_RE = 1;
	assign W3_IM = 0;

	 radix2 radix2_0
	 (
	  .CLK 			(CLK),
	  .RST_X		(RST_X),
	  .IN0_RE 	  	(IN0_RE),
	  .IN0_IM 	  	(IN0_IM),
	  .IN1_RE 	  	(IN2_RE),
	  .IN1_IM 	  	(IN2_IM),

	  .OUT0_RE 	  	(WX0_RE),
	  .OUT0_IM 	  	(WX0_IM),
	  .OUT1_RE 	  	(MX0_RE),
	  .OUT1_IM 	  	(MX0_IM)
	  );

	 radix2 radix2_1
	 (
	  .CLK 			(CLK),
	  .RST_X		(RST_X),
	  .IN0_RE 	  	(IN1_RE),
	  .IN0_IM 	  	(IN1_IM),
	  .IN1_RE 	  	(IN3_RE),
	  .IN1_IM 	  	(IN3_IM),

	  .OUT0_RE 	  	(WX1_RE),
	  .OUT0_IM 	  	(WX1_IM),
	  .OUT1_RE 	  	(MX1_RE),
	  .OUT1_IM 	  	(MX1_IM)
	  );

	 mult mult0
	 (
	  .CLK 			(CLK),
	  .RST_X		(RST_X),
	  .IN_RE 	  	(MX0_RE),
	  .IN_IM 	  	(MX0_IM),
	  .W_RE			(W0_RE),
	  .W_IM			(W0_IM),

	  .OUT_RE 	  	(WX2_RE),
	  .OUT_IM 	  	(WX2_IM)
	  );

	 mult mult1
	 (
	  .CLK 			(CLK),
	  .RST_X		(RST_X),
	  .IN_RE 	  	(MX1_RE),
	  .IN_IM 	  	(MX1_IM),
	  .W_RE			(W1_RE),
	  .W_IM			(W1_IM),

	  .OUT_RE 	  	(WX3_RE),
	  .OUT_IM 	  	(WX3_IM)
	  );

	 radix2 radix2_2
	 (
	  .CLK 			(CLK),
	  .RST_X		(RST_X),
	  .IN0_RE 	  	(WX0_RE),
	  .IN0_IM 	  	(WX0_IM),
	  .IN1_RE 	  	(WX1_RE),
	  .IN1_IM 	  	(WX1_IM),

	  .OUT0_RE 	  	(OUT0_RE),
	  .OUT0_IM 	  	(OUT0_IM),
	  .OUT1_RE 	  	(MX2_RE),
	  .OUT1_IM 	  	(MX2_IM)
	  );

	 radix2 radix2_3
	 (
	  .CLK 			(CLK),
	  .RST_X		(RST_X),
	  .IN0_RE 	  	(WX2_RE),
	  .IN0_IM 	  	(WX2_IM),
	  .IN1_RE 	  	(WX3_RE),
	  .IN1_IM 	  	(WX3_IM),

	  .OUT0_RE 	  	(OUT1_RE),
	  .OUT0_IM 	  	(OUT1_IM),
	  .OUT1_RE 	  	(MX3_RE),
	  .OUT1_IM 	  	(MX3_IM)
	  );

	 mult mult2
	 (
	  .CLK 			(CLK),
	  .RST_X		(RST_X),
	  .IN_RE 	  	(MX2_RE),
	  .IN_IM 	  	(MX2_IM),
	  .W_RE			(W2_RE),
	  .W_IM			(W2_IM),

	  .OUT_RE 	  	(OUT2_RE),
	  .OUT_IM 	  	(OUT2_IM)
	  );

	 mult mult3
	 (
	  .CLK 			(CLK),
	  .RST_X		(RST_X),
	  .IN_RE 	  	(MX3_RE),
	  .IN_IM 	  	(MX3_IM),
	  .W_RE			(W3_RE),
	  .W_IM			(W3_IM),

	  .OUT_RE 	  	(OUT3_RE),
	  .OUT_IM 	  	(OUT3_IM)
	  );
endmodule
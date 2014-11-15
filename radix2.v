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
	
	/*
	assign WX1_RE = IN0_RE - IN1_RE;
	assign WX1_IM = IN0_IM - IN1_IM;

	//OUT1_RE
	always @(posedge CLK or negedge RST_X) begin
		if(!RST_X) 
			OUT1_RE <= 33'b0;
		else if(WX1_RE[32] == 1) //•„†”½“](‚±‚±‚Å•K—v‚©H)
			OUT1_RE <= ~WX1_RE + 33'b1;
		else //‚»‚Ì‚Ü‚Ü
			OUT1_RE <= WX1_RE;
	end
	
	//OUT1_IM
	always @(posedge CLK or negedge RST_X) begin
		if(!RST_X) 
			OUT1_IM <= 33'b0;
		else if(WX1_IM[32] == 1)
			OUT1_IM <= ~WX1_IM + 33'b1;
		else //‚»‚Ì‚Ü‚Ü
			OUT1_IM <= WX1_IM;
	end
	*/
	
endmodule
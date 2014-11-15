module mult
  (
   input		CLK,
   input		RST_X,
   input signed [32:0] IN_RE,
   input signed [32:0] IN_IM,
   input signed [ 1:0] W_RE,
   input signed [ 1:0] W_IM,

   output signed [32:0] OUT_RE,
   output signed [32:0] OUT_IM
   );
	
	wire signed [32:0] WXA_RE, WXB_RE;
	wire signed [32:0] WXA_IM, WXB_IM;
	
	assign WXA_RE = IN_RE * W_RE;
	assign WXB_RE = IN_IM * W_IM;
	assign WXA_IM = IN_RE * W_IM;
	assign WXB_IM = IN_IM * W_RE;
	
	assign OUT_RE = WXA_RE - WXB_RE;
	assign OUT_IM = WXA_IM + WXB_IM;
	
	/*
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
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

endmodule
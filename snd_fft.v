module snd_fft
  (
   input		CLK,
   input        RST_X,
   input [31:0] FIFO_DOUT_R, //32�r�b�g
   input [31:0] FIFO_DOUT_L, //32�r�b�g  

   output reg [15:0] L_SNDDATA, //signed�ɂ����特���
   output reg [15:0] R_SNDDATA
   );
	
	wire[7:0] L1, L2, R1, R2;
	wire[31:0] fifo_dout_l, fifo_dout_r; //32�r�b�g
	assign fifo_dout_l = FIFO_DOUT_L;
	assign fifo_dout_r = FIFO_DOUT_R;
	
   	// --- ���ؗp ---
	wire[15:0] l_snddata, r_snddata; 
   	assign l_snddata = { fifo_dout_l[23:16] , fifo_dout_l[31:24]}; //23 01
	assign r_snddata = { fifo_dout_r[7:0]   , fifo_dout_r[15:8]};  //67 45
	// ---
	
	assign L1 = fifo_dout_l[23:16];
	assign L2 = fifo_dout_l[31:24];
	assign R1 = fifo_dout_r[7:0];
	assign R2 = fifo_dout_r[15:8];
	
	//wire�Q 32bit + ����1bit = 33bit
    wire signed [32:0] IN0_RE, IN1_RE, IN2_RE, IN3_RE;
	wire signed [32:0] IN0_IM, IN1_IM, IN2_IM, IN3_IM;
	
	//fft�o�́@�����ϊ��O
	wire signed [32:0] X0_RE, X1_RE, X2_RE, X3_RE;
	wire signed [32:0] X0_IM, X1_IM, X2_IM, X3_IM;
	
	//ifft���� �����ϊ���
	wire signed [32:0] Y0_RE, Y1_RE, Y2_RE, Y3_RE;
	wire signed [32:0] Y0_IM, Y1_IM, Y2_IM, Y3_IM;
	
	wire signed [32:0] T0_RE, T1_RE, T2_RE, T3_RE;
	wire signed [32:0] T0_IM, T1_IM, T2_IM, T3_IM;
	
	//�o�͌��� 8bit�ɖ߂�(�͂�)
	wire signed [7:0] OUT0_RE, OUT1_RE, OUT2_RE, OUT3_RE;
	wire signed [7:0] OUT0_IM, OUT1_IM, OUT2_IM, OUT3_IM;
	
	assign IN0_RE = { 1'b0, 24'b0 , L1};
	assign IN1_RE = { 1'b0, 24'b0 , L2};
	assign IN2_RE = { 1'b0, 24'b0 , R1};
	assign IN3_RE = { 1'b0, 24'b0 , R2};
	assign IN0_IM = 33'b0;
	assign IN1_IM = 33'b0;
	assign IN2_IM = 33'b0;
	assign IN3_IM = 33'b0;
	
	
	//�t�[���G�ϊ�
	fft_top u_fft_top
	 (
	  .CLK 			(CLK),
	  .RST_X		(RST_X),
	  .IN0_RE 	  	(IN0_RE),
	  .IN0_IM 	  	(IN0_IM),
	  .IN1_RE 	  	(IN1_RE),
	  .IN1_IM 	  	(IN1_IM),
	  .IN2_RE 	  	(IN2_RE),
	  .IN2_IM 	  	(IN2_IM),
	  .IN3_RE 	  	(IN3_RE),
	  .IN3_IM 	  	(IN3_IM),
	  .OUT0_RE 	  	(X0_RE),  
	  .OUT0_IM 	  	(X0_IM),	  
	  .OUT1_RE 	  	(X1_RE),  
	  .OUT1_IM 	  	(X1_IM),
	  .OUT2_RE 	  	(X2_RE),  
	  .OUT2_IM 	  	(X2_IM),	  
	  .OUT3_RE 	  	(X3_RE),  
	  .OUT3_IM 	  	(X3_IM)	  	   
	 );
	 
	/* --- �����ϊ��� --- */

	
	/*
	assign Y0_RE = X0_RE;
	assign Y1_RE = X1_RE;
	assign Y2_RE = X2_RE;
	assign Y3_RE = X3_RE;
	assign Y0_IM = X0_IM;
	assign Y1_IM = X1_IM;
	assign Y2_IM = X2_IM;
	assign Y3_IM = X3_IM;
	*/
		
	assign Y0_RE = X1_RE ^ 33'h0_ffff_0000;
	assign Y1_RE = X2_RE ^ 33'h0_ffff_0000;
	assign Y2_RE = X3_RE ^ 33'h0_ffff_0000;
	assign Y3_RE = X0_RE ^ 33'h0_ffff_0000;
	assign Y0_IM = X1_IM ^ 33'h0_ffff_0000;
	assign Y1_IM = X2_IM ^ 33'h0_ffff_0000;
	assign Y2_IM = X3_IM ^ 33'h0_ffff_0000;
	assign Y3_IM = X0_IM ^ 33'h0_ffff_0000;
	
	/* ------------------ */	  
	  
	//�t�[���G�t�ϊ�
	fft_top u_ifft_top
	 (
	  .CLK 			(CLK),
	  .RST_X		(RST_X),
	  .IN0_RE 	  	(Y0_IM),
	  .IN0_IM 	  	(Y0_RE),
	  .IN1_RE 	  	(Y1_IM),
	  .IN1_IM 	  	(Y1_RE),
	  .IN2_RE 	  	(Y2_IM),
	  .IN2_IM 	  	(Y2_RE),
	  .IN3_RE 	  	(Y3_IM),
	  .IN3_IM 	  	(Y3_RE),	
	  .OUT0_RE 	  	(T0_RE),  
	  .OUT0_IM 	  	(T0_IM),	  
	  .OUT1_RE 	  	(T1_RE),  
	  .OUT1_IM 	  	(T1_IM),
	  .OUT2_RE 	  	(T2_RE),  
	  .OUT2_IM 	  	(T2_IM),	  
	  .OUT3_RE 	  	(T3_RE),  
	  .OUT3_IM 	  	(T3_IM)	 
	  );

	//�T���v�����Ŋ���Z
	assign OUT0_IM = T0_RE >> 2;
	assign OUT0_RE = T0_IM >> 2;
	assign OUT1_IM = T1_RE >> 2;
	assign OUT1_RE = T1_IM >> 2;
	assign OUT2_IM = T2_RE >> 2;
	assign OUT2_RE = T2_IM >> 2;
	assign OUT3_IM = T3_RE >> 2;
	assign OUT3_RE = T3_IM >> 2;
	
	/*
	assign L_SNDDATA[15:0] = {OUT0_RE[7:0], OUT1_RE[7:0]};
	assign R_SNDDATA[15:0] = {OUT2_RE[7:0], OUT3_RE[7:0]};
	*/
	
	//�m�C�Y�L�����Z�����O
	wire [15:0] BP_L, BP_R;
	
	assign BP_L[15:0] = {OUT0_RE[7:0], OUT1_RE[7:0]};
	assign BP_R[15:0] = {OUT2_RE[7:0], OUT3_RE[7:0]};

	/*
	�Ԃ�0������Ɗ�{�G���[��f��
	���̍��፷�ɂ���тɂ��m�C�Y�H
	�I�[��0�Ȃ疳��
	臒l
	*/
	always @(posedge CLK or negedge RST_X) begin
	    if( !RST_X )
            L_SNDDATA <= 16'h0;
		else begin 
			 if(BP_L > 16'h0)
				L_SNDDATA <= BP_L;
			else if(BP_L < 16'h0)
				L_SNDDATA <= 16'h0;
			else
				L_SNDDATA <= 16'h0;
			end
	end
	
	always @(posedge CLK or negedge RST_X) begin
	    if( !RST_X )
            R_SNDDATA <= 16'h0;
		else begin 
			 if(BP_R > 16'h0)
				R_SNDDATA <= BP_R;
			else if(BP_R < 16'h0)
				R_SNDDATA <= 16'h0;
			else
				R_SNDDATA <= 16'h0;
			end
	end
	

endmodule // dsp_buffer


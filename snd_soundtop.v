module snd_soundtop
  (
   input         CLK,
   input         RST_X,
   input         VIF_SNDACK,
   input         VIF_SNDRDATAVLD,
   input  [63:0] VIF_RDATA,
   input         CIF_SNDSEL,         // Block select
   input  [3:0]  CIF_REGWRITE,       // Write enable
   input         CIF_REGREAD,        // Read enable
   input  [3:0]  CIF_REGADR,         // Register address
   input  [31:0] CIF_REGWDATA,       // Write data
   
   
   output        SND_LRCLK,
   output        SND_BCLK,
   output        SND_MCLK,
   output        SND_DOUT,
   output        SND_MUTEN,          // シリアルDAC(AK4366VT)用
   output        SND_DEM,            // シリアルDAC(AK4366VT)用
   output        SND_DIF0,           // シリアルDAC(AK4366VT)用
   output        SND_PDN,            // シリアルDAC(AK4366VT)用
   output        SND_VRAMREQ,
   output [22:0] SND_VRAMADR,
   output [31:0] SND_REGRDATA
   );

   assign 		 SND_DIF0 = 1;
   assign 		 SND_PDN  = RST_X;
   

   wire [31:0] FIFO_DOUT_R, FIFO_DOUT_L;
   wire [6:0] LRCLK_COUNT;
   wire [6:0] BCLK_COUNT;
   wire [6:0] MCLK_COUNT;
   wire [ 1:0] REG_CMD;
   wire [22:0] REG_VRAMADR;
   wire [ 7:0] REG_VOLUME;
   wire [31:0] REG_STATUS;
   wire [31:0] REG_MUSIC;
   wire [31:0] REG_DELAY;   
   wire [15:0] L_SNDDATA;
   wire [15:0] R_SNDDATA;
   
     // snd_vramctrl
	 snd_vramctrl u_snd_vramctrl
	 (
      .CLK             (CLK),
      .RST_X           (RST_X),
	  .REG_VRAMADR	   (REG_VRAMADR),
	  .BUF_WREADY	   (BUF_WREADY),
      .REG_CMD		   (REG_CMD),
	  .REG_LOOP		   (REG_LOOP),
	  .REG_MUSIC	   (REG_MUSIC),
	  .VIF_SNDACK	   (VIF_SNDACK),
	  .VIF_SNDRDATAVLD (VIF_SNDRDATAVLD),
	  .VIF_RDATA	   (VIF_RDATA),
	  
      .SND_VRAMREQ     (SND_VRAMREQ),
      .SND_VRAMADR     (SND_VRAMADR),
	  .PLAY_NOW		   (PLAY_NOW)
	 );
	 
	 // cap_buffer
	 snd_buffer u_snd_buffer
	 (
      .CLK             (CLK),
      .BCLK            (SND_BCLK),
      .RST_X           (RST_X),
      .VIF_SNDRDATAVLD (VIF_SNDRDATAVLD),
      .VIF_RDATA       (VIF_RDATA),
	  .FIFO_READ_R	   (FIFO_READ_R),
	  .FIFO_READ_L     (FIFO_READ_L),	  
 
      .BUF_WREADY      (BUF_WREADY),
	  .FIFO_DOUT_R	   (FIFO_DOUT_R),
	  .FIFO_DOUT_L	   (FIFO_DOUT_L)	  
	 );
	 
	 // snd_regctrl
    snd_regctrl u_snd_regctrl
	 (
      .CLK          (CLK),
      .RST_X        (RST_X),
      .CIF_SNDSEL   (CIF_SNDSEL),
      .CIF_REGREAD  (CIF_REGREAD),
      .CIF_REGWRITE (CIF_REGWRITE),
	  .CIF_REGADR	(CIF_REGADR),
	  .CIF_REGWDATA (CIF_REGWDATA),
	  
      .SND_REGRDATA (SND_REGRDATA),
      .REG_CMD      (REG_CMD),
      .REG_VRAMADR  (REG_VRAMADR),
	  .REG_VOLUME	(REG_VOLUME), 
	  .REG_LOOP		(REG_LOOP),
	  .REG_DEM		(SND_DEM),
	  .REG_MUTE		(SND_MUTEN),
	  .REG_STATUS	(REG_STATUS),
	  .REG_MUSIC	(REG_MUSIC),
	  .REG_DELAY	(REG_DELAY)  
	  ); 

	 //snd_clkgen
	snd_clkgen u_snd_clkgen
	(
      .CLK 			(CLK),  
      .RST_X		(RST_X),    
      
	  .SND_LRCLK	(SND_LRCLK),
	  .SND_BCLK		(SND_BCLK),
	  .SND_MCLK		(SND_MCLK),
	  .LRCLK_COUNT  (LRCLK_COUNT),
	  .BCLK_COUNT	(BCLK_COUNT),
	  .MCLK_COUNT   (MCLK_COUNT)
	  );
	
	
	snd_fft u_snd_fft
	(
	  .CLK 			(CLK),
	  .RST_X		(RST_X),
	  .FIFO_DOUT_R	   (FIFO_DOUT_R),
	  .FIFO_DOUT_L	   (FIFO_DOUT_L),	
	  
	  .L_SNDDATA	(L_SNDDATA),
	  .R_SNDDATA	(R_SNDDATA)
	 );
	 
	snd_outgen u_snd_outgen
	(
	  .BCLK 		(SND_BCLK),
	  .RST_X		(RST_X),
	  .SND_LRCLK	(SND_LRCLK),
	  .LRCLK_COUNT	(LRCLK_COUNT),
	  
	  .L_SNDDATA	(L_SNDDATA),
	  .R_SNDDATA	(R_SNDDATA),
	  
	   //.FIFO_DOUT	(FIFO_DOUT),
	  .REG_CMD		(REG_CMD),
	  .REG_STATUS	(REG_STATUS),
	  .REG_DELAY	(REG_DELAY),	  	  
	  
	  .FIFO_READ_R	(FIFO_READ_R),
	  .FIFO_READ_L	(FIFO_READ_L),
	  .SND_DOUT		(SND_DOUT)
	 );  
	 

	
endmodule // snd_soundtop

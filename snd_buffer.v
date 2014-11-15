module snd_buffer
  (
   input        CLK,
   input		BCLK,
   input        RST_X,
   input        VIF_SNDRDATAVLD,
   input [63:0] VIF_RDATA,
   input		FIFO_READ_R,
   input		FIFO_READ_L,
   
   output       BUF_WREADY,
   output [31:0] FIFO_DOUT_R, //32ビット
   output [31:0] FIFO_DOUT_L //32ビット
   );

   wire       rst;
   wire       fifo_full_r, fifo_full_l;
   wire       fifo_empty_r, fifo_empty_l;
   wire       fifo_valid_r, fifo_valid_l;
   wire [8:0] fifo_wcount_r, fifo_wcount_l;

   // for write
   wire        fifo_wr_r, fifo_wr_l;
   wire [63:0] fifo_din;

   // for read
   wire        fifo_rd_r, fifo_rd_l;
   wire [31:0] fifo_dout_r, fifo_dout_l;
   assign     rst = ~RST_X;

   // Xillinx FIFO
   // FIFOへの出し入れ
   fifo_64in32out_512depth u_fifo_right
	 (
	 //in
	  .din           (fifo_din),
      .rd_clk        (BCLK),
      .rd_en         (fifo_rd_r),
      .rst           (rst),
      .wr_clk        (CLK),
      .wr_en         (fifo_wr_r),  
	  //out
      .dout          (fifo_dout_r),
      .empty         (fifo_empty_r), 
      .full          (fifo_full_r), 
	  .valid         (fifo_valid_r),
      .wr_data_count (fifo_wcount_r)
	  );
   
   fifo_64in32out_512depth u_fifo_left
	 (
	 //in
	  .din           (fifo_din),
      .rd_clk        (BCLK),
      .rd_en         (fifo_rd_l),
      .rst           (rst),
      .wr_clk        (CLK),
      .wr_en         (fifo_wr_l),
	  
	  //out
      .dout          (fifo_dout_l),
      .empty         (fifo_empty_l), 
      .full          (fifo_full_l), 
	  .valid         (fifo_valid_l),
      .wr_data_count (fifo_wcount_l)
	  );
   
   /****************************************/
   /* ToDo: 以下にFIFOを制御する論理を記述 */
   /****************************************/
   
	/* --- fifo in --- */
	//fifo_wr
	assign fifo_wr_r = VIF_SNDRDATAVLD & !(fifo_full_r);
	assign fifo_wr_l = VIF_SNDRDATAVLD & !(fifo_full_l);
	
	//fifo_rd
	assign fifo_rd_r = FIFO_READ_R & !(fifo_empty_r); //empty排除
	assign fifo_rd_l = FIFO_READ_L & !(fifo_empty_l); //empty排除

	//fifo_din
	assign fifo_din = VIF_RDATA;
	
	/* --- fifo out --- */
	//fifo_wcount
	//面倒なのでrightだけ
	assign BUF_WREADY = (fifo_wcount_r < 9'd256); 

	//fifo_dout
	assign FIFO_DOUT_R[31:0] = fifo_dout_r[31:0];
	assign FIFO_DOUT_L[31:0] = fifo_dout_l[31:0];	

endmodule // dsp_buffer



   
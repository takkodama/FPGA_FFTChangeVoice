`timescale 1ns/10ps

module snd_outgen
  (
   input		BCLK,
   input        RST_X,
   input 		SND_LRCLK,
   input [ 6:0] LRCLK_COUNT,
   //input [31:0] FIFO_DOUT,

   input [15:0] L_SNDDATA,
   input [15:0] R_SNDDATA,
   input [ 1:0] REG_CMD,
   input [31:0] REG_STATUS,
   input [31:0]  REG_DELAY,

   output reg FIFO_READ_R,
   output reg FIFO_READ_L,
   output reg SND_DOUT //output 1bit one by one
   );

   	wire[6:0] lrclk_count; //0-63 7bit
	assign lrclk_count = LRCLK_COUNT;
	reg [4:0] half_count; //0-15 5bit

	reg [15:0] L_SNDDATA_DE, R_SNDDATA_DE;
	wire [15:0]  L_SNDDATA_OUT, R_SNDDATA_OUT;

	//右delayデータ
	always @(negedge SND_LRCLK or negedge RST_X) begin 
		if(!RST_X) 
			R_SNDDATA_DE <= 16'b0;
		else
			R_SNDDATA_DE <= R_SNDDATA;
	end
	
	//左delayデータ
	always @(negedge SND_LRCLK or negedge RST_X) begin 
		if(!RST_X) 
			L_SNDDATA_DE <= 16'b0;
		else
			L_SNDDATA_DE <= L_SNDDATA;
	end
	
	assign L_SNDDATA_OUT = L_SNDDATA;
	assign R_SNDDATA_OUT = R_SNDDATA;
	
   	// SND_DOUT
    always @ (negedge BCLK or negedge RST_X) begin
        if( !RST_X )
            SND_DOUT <= 1'b0;
		else begin
			if(REG_CMD == 2'b01) begin //状態が再生ならば開始
				if(lrclk_count >= 0 && lrclk_count <= 15) begin
					//SND_DOUT <= 0;
					SND_DOUT <= L_SNDDATA_OUT[15 - lrclk_count]; //0 - 15
				end
				else if(lrclk_count >= 32 && lrclk_count <= 47)
					//SND_DOUT <= 0;
					SND_DOUT <= R_SNDDATA_OUT[47 - lrclk_count]; //0 - 15
				else 
					SND_DOUT <= 0;
				end
			end
	end
	
	// half_count
    always @ (posedge BCLK or negedge RST_X) begin
        if( !RST_X )
            half_count <= 1'b0;
		else begin
			if(half_count == 14) 
				half_count <= 0; 
			else if(lrclk_count == 62)
				half_count <= half_count + 1;
        end
	end
	
	reg [20:0] delay_count; //max1048575
	reg DELAY_SIG;
	
	// delay_count
    always @ (negedge SND_LRCLK or negedge RST_X) begin
        if( !RST_X )
            delay_count <= 20'b0;
		else begin
			if(delay_count > 1048000) 
				delay_count <= 20'b0; 
			else
				delay_count <= delay_count + 20'b1;
        end
	end
	
    always @ (negedge SND_LRCLK or negedge RST_X) begin
        if( !RST_X )
            DELAY_SIG <= 1'b0;
		else begin
			if(delay_count == REG_DELAY)
				DELAY_SIG <= 1'b1;
			//else
			//	DELAY_SIG <= 1'b0;
			//delayなのでさげなくてもよい？
        end
	end	
	
	// FIFO_READ_R
    always @ (posedge BCLK or negedge RST_X) begin
        if( !RST_X )
            FIFO_READ_R <= 1'b0;
		else begin
			if(REG_STATUS == 32'h0000_0000 && lrclk_count == 62) //通常 
					FIFO_READ_R <= 1;
			else if(REG_STATUS == 32'h0000_0001 && (lrclk_count == 62 || lrclk_count == 30)) //倍速
					FIFO_READ_R <= 1;
			else if(REG_STATUS == 32'h0000_0002 && lrclk_count == 62) begin // 1/2倍速 half_countと組み合わせて使用
				if((half_count % 2) == 0) FIFO_READ_R <= 1;
				else FIFO_READ_R <= 0;
			end	
			else if(REG_STATUS == 32'h0000_0003 && (lrclk_count == 62 || lrclk_count == 20 || lrclk_count == 40)) //3倍速
					FIFO_READ_R <= 1;	
			else 
				FIFO_READ_R <= 0;
        end
	end 
	
	// FIFO_READ_L
    always @ (posedge BCLK or negedge RST_X) begin
        if( !RST_X )
            FIFO_READ_L <= 1'b0;
		else begin
			if(DELAY_SIG == 1'b1) begin
				if(REG_STATUS == 32'h0000_0000 && lrclk_count == 62) //通常 
						FIFO_READ_L <= 1;
				else if(REG_STATUS == 32'h0000_0001 && (lrclk_count == 62 || lrclk_count == 30)) //倍速
						FIFO_READ_L <= 1;
				else if(REG_STATUS == 32'h0000_0002 && lrclk_count == 62) begin // 1/2倍速 half_countと組み合わせて使用
					if((half_count % 2) == 0) FIFO_READ_L <= 1;
					else FIFO_READ_L <= 0;
				end	
				else if(REG_STATUS == 32'h0000_0003 && (lrclk_count == 62 || lrclk_count == 20 || lrclk_count == 40)) //3倍速
					FIFO_READ_L <= 1;	
				else 
					FIFO_READ_L <= 0;
			end
        end
	end  
   
endmodule // dsp_buffer



   
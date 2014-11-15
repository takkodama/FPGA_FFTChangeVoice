module snd_clkgen
  (
   input         CLK,
   input         RST_X,
   
   output reg SND_LRCLK,
   output reg SND_BCLK,
   output reg SND_MCLK,
   output [6:0] LRCLK_COUNT,
   output [6:0] BCLK_COUNT,
   output [6:0] MCLK_COUNT
   );
   
	//変数
	reg[6:0] lrclk_count ; //0-63 7ビット
	reg[6:0] bclk_count ; //0-34 7ビット
	reg[6:0] mclk_count ; //0-8 4ビット
	
	assign LRCLK_COUNT = lrclk_count;
	assign BCLK_COUNT = bclk_count;
	assign MCLK_COUNT = mclk_count;
	
	// mclk_count
	always @ (negedge CLK or negedge RST_X) begin
        if( !RST_X )
			mclk_count <= 0;
		else if(mclk_count == 8)
			mclk_count <= 0;
		else
			mclk_count <= mclk_count + 1;
	end
	
	// bclk_count
	always @ (negedge CLK or negedge RST_X) begin
        if( !RST_X )
			bclk_count <= 0;
		else if(bclk_count == 34)
			bclk_count <= 0;
		else
			bclk_count <= bclk_count + 1;
	end
   
 	// lrclk_count
	always @ (posedge SND_BCLK or negedge RST_X) begin
        if( !RST_X )
			lrclk_count <= 0;
		else if(lrclk_count == 63)
			lrclk_count <= 0;
		else
			lrclk_count <= lrclk_count + 1;	
			/*
		else if(bclk_count == 17 && lrclk_count == 63)
			lrclk_count <= 0;
		else if(bclk_count == 17)
			lrclk_count <= lrclk_count + 1;
			*/
	end
	
	// SND_MCLK
    always @ (posedge CLK or negedge RST_X) begin
        if( !RST_X )
            SND_MCLK <= 1'b1;
		else begin
			if(mclk_count == 3)
				SND_MCLK <= 1'b0;	
			else if(mclk_count == 8)
				SND_MCLK <= 1'b1;
        end
	end
	
	// SND_BCLK
    always @ (posedge CLK or negedge RST_X) begin
        if( !RST_X )
            SND_BCLK <= 1'b1;
		else begin
			if(bclk_count == 17)
				SND_BCLK <= 1'b0;	
			else if(bclk_count == 34)
				SND_BCLK <= 1'b1;
        end
	end
	
	// SND_LRCLK
    always @ (negedge SND_BCLK or negedge RST_X) begin
        if( !RST_X )
            SND_LRCLK <= 1'b0;
		else begin
			if(lrclk_count == 31)
				SND_LRCLK <= 1'b1;	
			else if(lrclk_count == 63)
				SND_LRCLK <= 1'b0;
        end
	end
		
endmodule 

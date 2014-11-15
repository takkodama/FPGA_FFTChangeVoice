module snd_regctrl
  (
   //input
   input         CLK, 
   input         RST_X,
   input         CIF_SNDSEL, 
   input         CIF_REGREAD,
   input  [3:0]  CIF_REGWRITE,
   input  [3:0]  CIF_REGADR,
   input  [31:0] CIF_REGWDATA, 
   
   //output
   output reg [31:0] SND_REGRDATA,
   output [ 1:0] REG_CMD,
   output [22:0] REG_VRAMADR,
   output [ 7:0] REG_VOLUME, 
   output 		 REG_LOOP,
   output		 REG_DEM,
   output		 REG_MUTE,
   output [31:0] REG_STATUS,
   output [31:0] REG_MUSIC,
   output [31:0] REG_DELAY  
   );

    reg [ 1:0] CMD;
    reg [22:0] VRAMADR;
    reg [ 7:0] VOLUME;
    reg		   LOOP;
    reg		   DEM;
    reg		   MUTE;
    reg [31:0] STATUS;
	reg	[31:0] MUSIC;
	reg	[31:0] DELAY;	
	
	assign REG_CMD = CMD;
	assign REG_VRAMADR = VRAMADR;
	assign REG_VOLUME = VOLUME;
	assign REG_LOOP = LOOP;
	assign REG_DEM = DEM;
	assign REG_MUTE = MUTE;
	assign REG_STATUS = STATUS;
	assign REG_MUSIC = MUSIC;
	assign REG_DELAY = DELAY;
	
	// register read
	always @ (posedge CLK or negedge RST_X) begin
        if( !RST_X ) begin
			SND_REGRDATA <= 0;
		end
		else if(CIF_SNDSEL == 1 && CIF_REGREAD == 1) begin
			case( CIF_REGADR )
				4'h0 :
					SND_REGRDATA <= { 30'b0 , REG_CMD };
					
				4'h1 :
					SND_REGRDATA <= { 9'b0 , REG_VRAMADR};
					
				4'h2 :
					SND_REGRDATA <= { 24'b0 , REG_VOLUME};

				4'h3 :
					SND_REGRDATA <= { 31'b0 , REG_LOOP};

				4'h4 :
					SND_REGRDATA <= { 30'b0 , REG_DEM, REG_MUTE};

				4'h5 :
					SND_REGRDATA <= {REG_STATUS};
				
				4'h6 :
					SND_REGRDATA <= {REG_MUSIC};
					
				4'h7 :
					SND_REGRDATA <= {REG_DELAY};					

			default :
				SND_REGRDATA <= 32'b0;
				
			endcase
		end				
	end
	
	
    //register write CMD 4'h0
	always @(posedge CLK or negedge RST_X) begin //CON
		if(!RST_X) begin	
			CMD <= 2'b0;
		end
		else if(CIF_SNDSEL && CIF_REGWRITE != 4'h0) begin 
			if(CIF_REGADR == 4'h0) begin
				if(CIF_REGWRITE[0]) begin
					CMD <= CIF_REGWDATA[1:0];
				end
			end
		end
	end
	
	//register write VRAMADR 4'h1
	always @(posedge CLK or negedge RST_X) begin //CON
		if(!RST_X) begin	
			VRAMADR <= 23'b0;
		end
		else if(CIF_SNDSEL && CIF_REGWRITE != 4'h0) begin 
			if(CIF_REGADR == 4'h1) begin
				if(CIF_REGWRITE[2] && CIF_REGWRITE[1] && CIF_REGWRITE[0])
					VRAMADR <= CIF_REGWDATA[22:0];
				else if(CIF_REGWRITE[2] && CIF_REGWRITE[1])
					VRAMADR[22:8] <= CIF_REGWDATA[22:8];
				else if(CIF_REGWRITE[1] && CIF_REGWRITE[0])
					VRAMADR[15:0] <= CIF_REGWDATA[15:0];
				else if(CIF_REGWRITE[2] && CIF_REGWRITE[0]) begin
					VRAMADR[22:16] <= CIF_REGWDATA[22:16];				
					VRAMADR[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[2])
					VRAMADR[22:16] <= CIF_REGWDATA[22:16];	
				else if(CIF_REGWRITE[1])
					VRAMADR[15:8] <= CIF_REGWDATA[15:8];
				else if(CIF_REGWRITE[0])
					VRAMADR[7:0] <= CIF_REGWDATA[7:0];					
				end
		end
	end
	
    //register write VOLUME 4'h2
	always @(posedge CLK or negedge RST_X) begin //CON
		if(!RST_X) begin	
			VOLUME <= 8'b0;
		end
		else if(CIF_SNDSEL && CIF_REGWRITE != 4'h0) begin 
			if(CIF_REGADR == 4'h2) begin
				if(CIF_REGWRITE[0]) begin
					VOLUME <= CIF_REGWDATA[7:0];
				end
			end
		end
	end
	
	//register write LOOP 4'h3
	always @(posedge CLK or negedge RST_X) begin //CON
		if(!RST_X) begin	
			LOOP <= 1'b0;
		end
		else if(CIF_SNDSEL && CIF_REGWRITE != 4'h0) begin 
			if(CIF_REGADR == 4'h3) begin
				if(CIF_REGWRITE[0]) begin
					LOOP <= CIF_REGWDATA[0];
				end
			end
		end
	end
	
	//register write DEM 4'h4
	always @(posedge CLK or negedge RST_X) begin //CON
		if(!RST_X) begin	
			DEM <= 1'b0;
		end
		else if(CIF_SNDSEL && CIF_REGWRITE != 4'h0) begin 
			if(CIF_REGADR == 4'h4) begin
				if(CIF_REGWRITE[0]) begin
					DEM <= CIF_REGWDATA[1];
				end
			end
		end
	end
	
	//register write MUTE 4'h4
	always @(posedge CLK or negedge RST_X) begin //CON
		if(!RST_X) begin	
			MUTE <= 1'b0;
		end
		else if(CIF_SNDSEL && CIF_REGWRITE != 4'h0) begin 
			if(CIF_REGADR == 4'h4) begin
				if(CIF_REGWRITE[0]) begin
					MUTE <= CIF_REGWDATA[0];
				end
			end
		end
	end
	
	//register write STATUS 4'h5
	always @(posedge CLK or negedge RST_X) begin //CON
		if(!RST_X) begin	
			STATUS <= 32'b0;
		end
		else if(CIF_SNDSEL && CIF_REGWRITE != 4'h0) begin 
			if(CIF_REGADR == 4'h5) begin
				if(CIF_REGWRITE[3] & CIF_REGWRITE[2] && CIF_REGWRITE[1] && CIF_REGWRITE[0])
					STATUS <= CIF_REGWDATA[31:0];
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[2] && CIF_REGWRITE[1]) begin
					STATUS[31:24] <= CIF_REGWDATA[31:24];		
					STATUS[23:16] <= CIF_REGWDATA[23:16];	
					STATUS[15:8] <= CIF_REGWDATA[15:8];
					end
				else if(CIF_REGWRITE[2] && CIF_REGWRITE[1] && CIF_REGWRITE[0]) begin
					STATUS[23:16] <= CIF_REGWDATA[23:16];	
					STATUS[15:8] <= CIF_REGWDATA[15:8];
					STATUS[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[2] && CIF_REGWRITE[0]) begin
					STATUS[31:24] <= CIF_REGWDATA[31:24];		
					STATUS[23:16] <= CIF_REGWDATA[23:16];	
					STATUS[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[1] && CIF_REGWRITE[0]) begin		
					STATUS[31:24] <= CIF_REGWDATA[31:24];		
					STATUS[15:8] <= CIF_REGWDATA[15:8];
					STATUS[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[1] && CIF_REGWRITE[0]) begin			
					STATUS[15:8] <= CIF_REGWDATA[15:8];
					STATUS[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[2] && CIF_REGWRITE[0])	begin
					STATUS[23:16] <= CIF_REGWDATA[23:16];	
					STATUS[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[2] && CIF_REGWRITE[1])	begin			
					STATUS[23:16] <= CIF_REGWDATA[23:16];	
					STATUS[15:8] <= CIF_REGWDATA[15:8];
					end
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[0])	begin		
					STATUS[31:24] <= CIF_REGWDATA[31:24];		
					STATUS[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[1])	begin		
					STATUS[31:24] <= CIF_REGWDATA[31:24];		
					STATUS[15:8] <= CIF_REGWDATA[15:8];
					end
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[2])	begin		
					STATUS[31:24] <= CIF_REGWDATA[31:24];		
					STATUS[23:16] <= CIF_REGWDATA[23:16];
					end
				else if(CIF_REGWRITE[3])
					STATUS[31:24] <= CIF_REGWDATA[31:24];					
				else if(CIF_REGWRITE[2])
					STATUS[23:16] <= CIF_REGWDATA[23:16];	
				else if(CIF_REGWRITE[1])
					STATUS[15:8] <= CIF_REGWDATA[15:8];
				else if(CIF_REGWRITE[0])
					STATUS[7:0] <= CIF_REGWDATA[7:0];					
				end
		end
	end	
	
	//register write MUSIC 4'h6
	always @(posedge CLK or negedge RST_X) begin //CON
		if(!RST_X) begin	
			MUSIC <= 32'b0;
		end
		else if(CIF_SNDSEL && CIF_REGWRITE != 4'h0) begin 
			if(CIF_REGADR == 4'h6) begin
				if(CIF_REGWRITE[3] & CIF_REGWRITE[2] && CIF_REGWRITE[1] && CIF_REGWRITE[0])
					MUSIC <= CIF_REGWDATA[31:0];
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[2] && CIF_REGWRITE[1]) begin
					MUSIC[31:24] <= CIF_REGWDATA[31:24];		
					MUSIC[23:16] <= CIF_REGWDATA[23:16];	
					MUSIC[15:8] <= CIF_REGWDATA[15:8];
					end
				else if(CIF_REGWRITE[2] && CIF_REGWRITE[1] && CIF_REGWRITE[0]) begin
					MUSIC[23:16] <= CIF_REGWDATA[23:16];	
					MUSIC[15:8] <= CIF_REGWDATA[15:8];
					MUSIC[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[2] && CIF_REGWRITE[0]) begin
					MUSIC[31:24] <= CIF_REGWDATA[31:24];		
					MUSIC[23:16] <= CIF_REGWDATA[23:16];	
					MUSIC[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[1] && CIF_REGWRITE[0]) begin		
					MUSIC[31:24] <= CIF_REGWDATA[31:24];		
					MUSIC[15:8] <= CIF_REGWDATA[15:8];
					MUSIC[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[1] && CIF_REGWRITE[0]) begin			
					MUSIC[15:8] <= CIF_REGWDATA[15:8];
					MUSIC[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[2] && CIF_REGWRITE[0])	begin
					MUSIC[23:16] <= CIF_REGWDATA[23:16];	
					MUSIC[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[2] && CIF_REGWRITE[1])	begin			
					MUSIC[23:16] <= CIF_REGWDATA[23:16];	
					MUSIC[15:8] <= CIF_REGWDATA[15:8];
					end
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[0])	begin		
					MUSIC[31:24] <= CIF_REGWDATA[31:24];		
					MUSIC[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[1])	begin		
					MUSIC[31:24] <= CIF_REGWDATA[31:24];		
					MUSIC[15:8] <= CIF_REGWDATA[15:8];
					end
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[2])	begin		
					MUSIC[31:24] <= CIF_REGWDATA[31:24];		
					MUSIC[23:16] <= CIF_REGWDATA[23:16];
					end
				else if(CIF_REGWRITE[3])
					MUSIC[31:24] <= CIF_REGWDATA[31:24];					
				else if(CIF_REGWRITE[2])
					MUSIC[23:16] <= CIF_REGWDATA[23:16];	
				else if(CIF_REGWRITE[1])
					MUSIC[15:8] <= CIF_REGWDATA[15:8];
				else if(CIF_REGWRITE[0])
					MUSIC[7:0] <= CIF_REGWDATA[7:0];					
				end
		end
	end
	

	//register write DELAY 4'h7
	always @(posedge CLK or negedge RST_X) begin //CON
		if(!RST_X) begin	
			DELAY <= 32'b0;
		end
		else if(CIF_SNDSEL && CIF_REGWRITE != 4'h0) begin 
			if(CIF_REGADR == 4'h7) begin
				if(CIF_REGWRITE[3] & CIF_REGWRITE[2] && CIF_REGWRITE[1] && CIF_REGWRITE[0])
					DELAY <= CIF_REGWDATA[31:0];
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[2] && CIF_REGWRITE[1]) begin
					DELAY[31:24] <= CIF_REGWDATA[31:24];		
					DELAY[23:16] <= CIF_REGWDATA[23:16];	
					DELAY[15:8] <= CIF_REGWDATA[15:8];
					end
				else if(CIF_REGWRITE[2] && CIF_REGWRITE[1] && CIF_REGWRITE[0]) begin
					DELAY[23:16] <= CIF_REGWDATA[23:16];	
					DELAY[15:8] <= CIF_REGWDATA[15:8];
					DELAY[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[2] && CIF_REGWRITE[0]) begin
					DELAY[31:24] <= CIF_REGWDATA[31:24];		
					DELAY[23:16] <= CIF_REGWDATA[23:16];	
					DELAY[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[1] && CIF_REGWRITE[0]) begin		
					DELAY[31:24] <= CIF_REGWDATA[31:24];		
					DELAY[15:8] <= CIF_REGWDATA[15:8];
					DELAY[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[1] && CIF_REGWRITE[0]) begin			
					DELAY[15:8] <= CIF_REGWDATA[15:8];
					DELAY[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[2] && CIF_REGWRITE[0])	begin
					DELAY[23:16] <= CIF_REGWDATA[23:16];	
					DELAY[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[2] && CIF_REGWRITE[1])	begin			
					DELAY[23:16] <= CIF_REGWDATA[23:16];	
					DELAY[15:8] <= CIF_REGWDATA[15:8];
					end
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[0])	begin		
					DELAY[31:24] <= CIF_REGWDATA[31:24];		
					DELAY[7:0] <= CIF_REGWDATA[7:0];
					end
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[1])	begin		
					DELAY[31:24] <= CIF_REGWDATA[31:24];		
					DELAY[15:8] <= CIF_REGWDATA[15:8];
					end
				else if(CIF_REGWRITE[3] && CIF_REGWRITE[2])	begin		
					DELAY[31:24] <= CIF_REGWDATA[31:24];		
					DELAY[23:16] <= CIF_REGWDATA[23:16];
					end
				else if(CIF_REGWRITE[3])
					DELAY[31:24] <= CIF_REGWDATA[31:24];					
				else if(CIF_REGWRITE[2])
					DELAY[23:16] <= CIF_REGWDATA[23:16];	
				else if(CIF_REGWRITE[1])
					DELAY[15:8] <= CIF_REGWDATA[15:8];
				else if(CIF_REGWRITE[0])
					DELAY[7:0] <= CIF_REGWDATA[7:0];					
				end
		end
	end		
	
endmodule // dsp_regctrl

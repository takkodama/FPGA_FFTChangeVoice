module snd_vramctrl
  (
   input         CLK,
   input         RST_X,
   input [22:0]  REG_VRAMADR,
   input		 BUF_WREADY,
   input [ 1:0]  REG_CMD,
   input 		 REG_LOOP,
   input [31:0]  REG_MUSIC,
   input         VIF_SNDACK,
   input         VIF_SNDRDATAVLD,
   input  [63:0] VIF_RDATA,

   output        SND_VRAMREQ,
   output [22:0] SND_VRAMADR,
   output reg    PLAY_NOW
   );

   reg[22:0] addcount; //�ǂ񂾉�
   reg	endflg; //�Ȃ��I�������炨�m�点
   
	//�X�e�[�g����t��
	reg [2:0] state, nextState;
	parameter S_IDLE  = 3'b000;
	parameter S_PLAY  = 3'b001;
	parameter S_PAUSE = 3'b010;
	parameter S_WAIT  = 3'b011;
	parameter S_END	  = 3'b100;
	
	//MUSIC�������addcount��datasize�����傫�����1�ȏI��
	
	//play��ԂȂ�΃��N�G�X�g
	assign SND_VRAMREQ = (state == S_PLAY) && BUF_WREADY;
	
	//REG_VRAMADR + �ǂ񂾉�
	assign SND_VRAMADR = {REG_VRAMADR + addcount};
	
	/* ���g�p */
	// PLAY_NOW ... �X�e�[�g��play��Ԃ̎��ɊO���ɏo���M��
	always @ (posedge CLK or negedge RST_X) begin
        if( !RST_X )
			PLAY_NOW <= 1'b0;
 		else if(state == S_PLAY) 
			PLAY_NOW <= 1'b1;
		else 
			PLAY_NOW <= 1'b0; 		
	end
	
	// addcount
	always @ (posedge CLK or negedge RST_X) begin
        if( !RST_X )
			addcount <= 23'b0;
		else if(/*state == S_PLAY && */ addcount == (REG_MUSIC))
			addcount <= 23'b0;	
		//else if(/*state == S_PLAY && */ addcount > (REG_MUSIC))
		//	addcount <= 23'b0;		
 		else if((SND_VRAMREQ == 1)&&(VIF_SNDACK == 1)) 
			addcount <= addcount + 23'b1;
		//else if(/*state == S_PLAY*/ &&  addcount > (REG_MUSIC))
		//	addcount <= 23'b0;
		
	end
	
	// endflg
	always @ (posedge CLK or negedge RST_X) begin
        if( !RST_X )
			endflg <= 1'b0;
		//else if(state == S_PLAY && addcount > REG_MUSIC) 
 		//else if(state == S_PLAY && addcount == REG_MUSIC) 
		else if(state == S_PLAY && (addcount+1) == REG_MUSIC)  //����␳�̂���-1
			endflg <= 1'b1;
		else 
			endflg <= 1'b0; 		
	end
	
	// �X�e�[�gFF
    always @( posedge CLK, negedge RST_X ) begin
       if( !RST_X )
           state <= S_IDLE;
       else
           state <= nextState;
    end
	
	// �X�e�[�g�J�ڏ����L�q
	always @* begin
		case( state )
			S_IDLE :
				if (REG_CMD == 2'b01) nextState <= S_PLAY;
				else nextState <= S_IDLE;
				
			S_PLAY : //001
				if (REG_CMD == 2'b11) nextState <= S_IDLE; //��~
				else if( REG_CMD == 2'b10 ) nextState <= S_PAUSE;
				
				//�ȏI���A���[�v�Ȃ� -> end
				else if( endflg == 1'b1 && REG_LOOP == 1'b0 ) nextState <= S_END;
				//�ȏI���A���[�v���� -> play
				//else if( endflg == 1'b1 && REG_LOOP == 1'b1 ) nextState <= S_IDLE;
				else if( endflg == 1'b1 && REG_LOOP == 1'b1 ) nextState <= S_PLAY;

				else if( BUF_WREADY == 1'b0 ) nextState <= S_WAIT;
				else nextState <= S_PLAY;

			S_PAUSE : //010
				if (REG_CMD == 2'b01) nextState <= S_PLAY;
				else if(REG_CMD == 2'b11) nextState <= S_IDLE;
				else nextState <= S_PAUSE;
				
			S_WAIT : //011
				if ( BUF_WREADY == 1'b1 ) nextState <= S_PLAY;
				else nextState <= S_WAIT;
				
			S_END :	//100
				if( REG_CMD != 2'b01 ) nextState <= S_IDLE;
				else nextState <= S_END;
					
			default  :
				nextState <= S_IDLE;
		endcase
	end
	
	
endmodule // dsp_vramctrl

   
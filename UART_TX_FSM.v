module UART_TX_FSM (

	input  						DATA_VALID, 
	input 						PAR_EN,
 	input		                ser_done,
	input 						CLK, RST,
	
 	output  reg     [1:0]       mux_sel, 
	output  reg                 Ser_enable,
	output 						Busy
	
);

// state encoding
parameter   [2:0]      IDLE   = 3'b000,
                       start  = 3'b001,
					   data   = 3'b011,
					   parity = 3'b010,
					   stop   = 3'b110 ;

reg         [2:0]      curr_st , next_st ;			
reg                    temp_Busy ;

// state transition
always @ (posedge CLK or negedge RST)
 	begin
  		if(!RST)
   			begin
    			curr_st <= IDLE ;
   			end
  		else
   			begin
    			curr_st <= next_st ;
   			end
 	end

// next state logic
always @ (*)
 	begin
  		case(curr_st)
  			IDLE  : begin
            			if(DATA_VALID)
							 next_st = start ;
						else
							 next_st = IDLE ; 			
           			end
			
			start : begin
						next_st = data ;  
			        end

  			data  : begin
            			if(ser_done)
							begin
			  					if(PAR_EN)
			  						next_st = parity ;
              					else
			   						next_st = stop ;			  
			 				end
						else
			 				next_st = data ; 			
           			end

			parity: begin
						next_st = stop ; 
			        end

			stop  : begin
						next_st = IDLE ; 			
			         end

			default: begin
						next_st = IDLE ; 
			        end	
  		endcase                 	   
	end 

endmodule : UART_TX_FSM
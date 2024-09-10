module UART_TX_parity_calc #(parameter DATA_WIDTH = 8) (
	
	input [DATA_WIDTH-1 : 0]  	P_DATA,
	input  						DATA_VALID, 
	input 						PAR_EN,
	input 						PAR_TYP,
	input 						CLK, RST,
	input  		                Busy, 
	
	output reg					par_bit_out
);

reg [DATA_WIDTH-1 : 0] 	temp_data_out;

always @ (posedge CLK or negedge RST)
 	begin
  		if(!RST)
   			begin
    			temp_data_out <= 'b0 ;
   			end

  		else if(DATA_VALID && !Busy)
  			begin
    			temp_data_out <= P_DATA ; // store input parellel data
   			end	
   	end
   	
always @ (posedge CLK or negedge RST)
 	begin
  		if(!RST)
   			begin
    			par_bit_out <= 'b0 ;
   			end
  		else
   			begin
    			if (PAR_EN)
	 				begin
	  					
	  					case(PAR_TYP)
	  						
	  						1'b0 : begin                 
	         					par_bit_out <= ^temp_data_out  ;     // Even par_bit_out
	         					end
	  						
	  						1'b1 : begin
	          					par_bit_out <= ~^temp_data_out ;     // Odd par_bit_out
	        					end		
	  					endcase       	 
	 				end
   			end
 	end 

endmodule : UART_TX_parity_calc
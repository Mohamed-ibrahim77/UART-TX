module UART_TX_serializer #(parameter DATA_WIDTH = 8) (
	
	input [DATA_WIDTH-1 : 0]   	P_DATA, 
	input  						DATA_VALID, 
	input 						SER_EN,
	input 						CLK, RST,
	input   	                Busy,
	
	output 						ser_data_out,
	output 						ser_done
);

reg [DATA_WIDTH-1 : 0] 	temp_data_out;
reg [2:0]          		ser_counter;

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
  		
  		else if(SER_EN)
  			begin
   				temp_data_out <= temp_data_out >> 1 ;  // convert to serial through shift reg     
   			end
	end

always @ (posedge CLK or negedge RST)
	begin
	  	if(!RST)
	   		begin
	    		ser_counter <= 'b0 ;
	   		end

	  	else if (SER_EN)
		 		begin
	      			ser_counter <= ser_counter + 'b1 ;		 
		 		end
			else 
		 		begin
	      			ser_counter <= 'b0 ;		 
		 		end	
	   		
 	end 

assign ser_done = (ser_counter == 3'b111) ? 1'b1 : 1'b0 ; // all bits are shifted

assign ser_data_out = temp_data_out[0] ; // out bit every clk

endmodule : UART_TX_serializer
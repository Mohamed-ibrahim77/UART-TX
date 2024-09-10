module UART_TX_MUX (

	input         start_bit_IN_0,
	input         stop_bit_IN_1,
	input         ser_data_IN_2,
	input         par_bit_IN_3,
	input  [1:0]  MUX_SEL,
	input 		  CLK, RST,
	
	output reg	  TX_OUT
);

reg  temp_mux_out ;

always @ (*)
  	begin
	    case(MUX_SEL)

			2'b00 : begin                 
			         	temp_mux_out = start_bit_IN_0 ;       
			        end
			2'b01 : begin
			         	temp_mux_out = stop_bit_IN_1 ;      
			        end	
			2'b10 : begin
			         	temp_mux_out = ser_data_IN_2 ;       
			        end	
			2'b11 : begin
			         	temp_mux_out = par_bit_IN_3 ;      
			        end		
		endcase        	   
 	end

always @ (posedge CLK or negedge RST)
 	begin
  		if(!RST)
   			begin
    			TX_OUT <= 'b0 ;
   			end
  		else
   			begin
    			TX_OUT <= temp_mux_out ;
   			end 
 	end  
   
endmodule : UART_TX_MUX
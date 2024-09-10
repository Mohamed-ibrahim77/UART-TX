module UART_TX_Top #(parameter DATA_WIDTH = 8) (

	input [DATA_WIDTH-1 : 0]  	P_DATA,
	input  						DATA_VALID, 
	input 						PAR_EN,
	input 						PAR_TYP,
	input 						CLK, RST,
	
	output 						TX_OUT,
	output 						Busy
);

wire            ser_en    , 
	            ser_done  ,
			 	ser_data  ,
			 	parity    ;	

wire  [1:0]     mux_sel ;
 
UART_TX_serializer # (.DATA_WIDTH(DATA_WIDTH)) Serializer (

.CLK(CLK),
.RST(RST),
.P_DATA(P_DATA),
.Busy(Busy),
.SER_EN(ser_en), 
.DATA_VALID(DATA_VALID), 
.ser_data_out(ser_data),
.ser_done(ser_done)
);

UART_TX_FSM  fsm (

.CLK(CLK),
.RST(RST),
.DATA_VALID(DATA_VALID), 
.PAR_EN(PAR_EN),
.ser_done(ser_done), 
.Ser_enable(ser_en),
.mux_sel(mux_sel), 
.Busy(Busy)
);

UART_TX_parity_calc # (.DATA_WIDTH(DATA_WIDTH)) parity_calc (

.CLK(CLK),
.RST(RST),
.PAR_EN(PAR_EN),
.PAR_TYP(PAR_TYP),
.P_DATA(P_DATA),
.Busy(Busy),
.DATA_VALID(DATA_VALID), 
.par_bit_out(parity)
); 

UART_TX_MUX mux (

.CLK(CLK),
.RST(RST),
.start_bit_IN_0(1'b0),
.stop_bit_IN_1(ser_data),
.ser_data_IN_2(parity),
.par_bit_IN_3(1'b1),
.MUX_SEL(mux_sel),
.TX_OUT(TX_OUT) 
);


endmodule : UART_TX_Top
vlib work
vlog -f source_file.txt
vsim -voptargs=+acc work.UART_TX_TB
add wave *
run -all
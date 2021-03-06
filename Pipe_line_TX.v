module pipe_line_TX ( dout , seconds , minutes , hours , months , days ,
         clk , rst , ADC , bd_rate, dnum , snum , par );
 
output [5:0] seconds,minutes;
output [4:0] hours;
output [3:0] months;
output [4:0] days;

output wire dout ;

input [7:0] ADC  ;
input dnum , snum ;
input [1:0] par ;
input clk , rst ;
input [1:0] bd_rate ;


wire One_Hz_clk,Tx_clk;
wire clock_for_count;
wire start_UART;

checkdata m0( minutes, seconds, rst, start_UART);

frequency_divider m1(clk,rst, bd_rate, One_Hz_clk, Rx_clk,Tx_clk,clock_for_count);

Digital_Clock m2(clock_for_count,rst,minutes,seconds,hours,months,days);
 
TX_2 m3( dout, par , ADC , Tx_clk , rst , start_UART , snum , dnum );



endmodule


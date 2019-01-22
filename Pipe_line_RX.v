module pipe_line_RX (  temp_out , parity_warning, frame_warning , shutdown , alarm ,
         clk , rst , bd_rate, dnum , snum , par ,dout , data);
 
output shutdown , alarm ;
output wire parity_warning , frame_warning ; 
output wire [7:0] temp_out  ;
output wire [7:0] data ;



input wire dout ;
input dnum , snum ;
input [1:0] par ;
input clk , rst ;
input [1:0] bd_rate ;


wire Rx_clk ;

frequency_divider m1(clk,rst, bd_rate, One_Hz_clk, Rx_clk,Tx_clk,clock_for_count);

RXRX m2(data , parity_warning , frame_warning , dout , Rx_clk , rst , snum , dnum);

controller m3(temp_out , alarm , shutdown , data , clk , rst );


endmodule
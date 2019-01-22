module frequency_divider(input clk,rst,input[1:0] bd_rate, 
output reg One_Hz_clk, Rx_clk,Tx_clk,clock_for_count);
  
reg[25:0] Q;
  
always @(posedge clk ,posedge rst)
begin
  begin	if(rst) 
	begin
	  
  One_Hz_clk<=0;
   Rx_clk<=0;
   Tx_clk<=0;
   clock_for_count<=0;
   Q<=26'b0;
 end
	else 
		Q<=Q-1'b1;
		

   end
end

always @(Q)
begin
 One_Hz_clk<=Q[25];   
 clock_for_count<=Q[10]; // any clk just for examine the digital clock
case (bd_rate)
  2'b00:
    begin
       Rx_clk<=Q[2]; // 10
       Tx_clk<=Q[6]; // 14
     end
  2'b01:
    begin
       Rx_clk<=Q[3]; //11
       Tx_clk<=Q[7]; //15
     end
  2'b10:
    begin
       Rx_clk<=Q[4]; //12
       Tx_clk<=Q[8]; //16
     end 
  2'b11:
    begin
       Rx_clk<=Q[5]; //13
       Tx_clk<=Q[9]; //17
     end
   endcase

 end
endmodule



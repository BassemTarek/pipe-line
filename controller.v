module controller (temp_out , alarm , shutdown , ADC , clk , rst );
 
output reg  shutdown , alarm ;
output reg [0:7] temp_out ;


input [0:7] ADC  ; // ADC data in parallel 
input clk , rst ;

parameter min_temp = 8'b01100011 ;
parameter alarm_temp =  8'b11001000 ;
parameter shutdown_temp = 8'b11111001 ;

always@(posedge clk , posedge rst)       
        begin
if(rst)
  begin
    shutdown <= 1'b0;
    alarm <= 1'b0;
    temp_out <= 8'b0;
  end
else       
if (ADC > min_temp && ADC < shutdown_temp )
  begin 
         temp_out <= ADC ; 
    if(ADC > alarm_temp ) alarm <= 1;
  end
else if (ADC > shutdown_temp )
      begin
         shutdown <= 1;
         alarm <= 0;     
      end
end
         
endmodule 
module controller (temp_out , alarm , shutdown , ADC , clk , rst );
 
output reg  shutdown , alarm ;
output reg [0:7] temp_out ;


input [0:7] ADC  ; // ADC data in parallel 
input clk , rst ;

parameter min_temp = 8'b01100100 ;
parameter alarm_temp =  8'b11001000 ;
parameter shutdown_temp = 8'b11111010 ;

always @(posedge clk , posedge rst)
        begin
if (ADC >= min_temp && ADC < shutdown_temp )
  begin 
         temp_out <= ADC ; 
    if (ADC >= alarm_temp )
      begin
         alarm <= 1;
         temp_out <= ADC ;
      end
  end
else if (ADC >= shutdown_temp )
      begin
         shutdown = 1;
         alarm = 0;         
      end
end
         
endmodule 

module controller_test ; // self testbench
reg [0:7] ADC ;
reg  rst , clk ;

wire [0:7] temp_out ;
wire shutdown , alarm ;
// ----------------------------
integer j=0;
controller test_1 (
.temp_out(temp_out),
.alarm(alarm) ,
.shutdown(shutdown),
.ADC(ADC),
.clk(clk),
.rst(rst)
);

parameter min_temp = 8'b01100100 ; // 100 
parameter alarm_temp =  8'b11001000 ; //200
parameter shutdown_temp = 8'b11111010 ; //250

initial 
begin 
  clk = 1 ;
  rst = 1 ; 
  ADC = 8'b0000_0000 ;
end 

always 
#5 clk=~clk;

event reset_trigger;
event reset_done_trigger;
initial begin
	forever begin
	@(reset_trigger);
	@(negedge clk);
	rst=1;  
if( ADC != 0 && temp_out!= 0 && shutdown!= 0 && alarm!= 0 )
$display("Error in reset");
	@(negedge clk);
	rst=0;
	-> reset_done_trigger;
	end
	end
	
	
initial begin 
#1 ->reset_trigger;
@(reset_done_trigger);
forever
begin 
@(posedge clk)
if (ADC!=8'b0000_0000)
  begin 
    if (temp_out==(8'b0000_0000) && ADC >= min_temp)
     $display("outputs isn't push"); 
    else if ( ADC < shutdown_temp && (ADC == alarm_temp || ADC > alarm_temp ) && alarm == 0)
       $display("alarm isn't push"); 
    else if ( (ADC == shutdown_temp || ADC > shutdown_temp ) && shutdown == 0)
      $display("shutdown isn't push"); 
    else if ( (ADC == shutdown_temp || ADC > shutdown_temp ) && shutdown == 0 && alarm == 1)
      $display("shutdown & alarm is push error alarm should be reset"); 
    else if (temp_out!=0 && ADC <= min_temp)
      $display("ADC under of that limit & you push outputs");
  end

end
end 

initial begin
forever
begin 
for(j=0;j<13;j=j+1)
begin 
@(posedge clk)
ADC = ADC + 5'b11001 ; //     ADC + = 25
end
$finish;
end
end

endmodule
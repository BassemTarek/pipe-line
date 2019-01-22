`timescale 1ns/1ns

module Tx_benech_test;

wire dout;
reg [1:0] par;
reg [7:0] din;
reg clk,rst,start,snum,dnum ;

reg [3:0] counter ;

reg reset_done_trigger;

Tx K(dout , par , din , clk , rst , start ,snum ,dnum);

initial begin
  par <= 2'b00 ;
  start <= 1'b0 ;
  snum <= 1'b0 ;
  dnum <= 1'b0 ;  
  clk  <= 1'b0 ;
  counter <= 4'b0000;
  rst <= 1'b0 ;
  din <= 8'b10101011;
  reset_done_trigger <= 0;
end


always
begin
 #50  clk <= ~clk ; 
end


event reset_trigger;
event count;


always @(reset_trigger)
  begin
    @(negedge clk)    
      rst <= 1'b1 ;
    @(negedge clk)
      rst <= 1'b0 ;
    reset_done_trigger <= 1;          
  end
  
  

initial begin
#5 -> reset_trigger;
end

always @(count)
    if( (snum == 0 && counter < 4'b1100) || (snum == 1 && counter < 4'b1011))
      begin           
        if((counter == 4'b0000 && dout == 1'b0 && start == 1'b0) || (counter > 4'b0000)) counter <= counter + 1'b1 ;
      end

always @(posedge clk)
begin
    if( (snum == 0 && counter < 4'b1100) || (snum == 1 && counter < 4'b1011))
    begin
       if( (counter == 4'b0000) && (dout == 1'b0) && (start == 1'b0) && (rst==0) )
       begin
        if(reset_done_trigger) reset_done_trigger <= 1'b0; 
        else  $display("starting bit isn't equal to 0");
      end
              
       else if( ( counter > 4'b0000 && counter < 4'b1001 /*9*/ ) && ( dout != din[(counter - 1'b1)] ) )  
                  $display(" warnning in data bits ");
    
       else if (counter == 4'b1001) $display( "\t%b" , dout  );
    
       else if( ( counter > 4'b1001 ) && ( dout != 1'b1 ) ) $display(" warnning in stop bits ");
    end
    else
    begin
       counter <= 4'b0000 ;
       snum <= snum + 1'b1 ;
       -> reset_trigger;
    end
    -> count;
end

always
begin
#10000;
$stop;
end

endmodule
`timescale 1ns/1ps

module test_pipe_line;
    
wire [5:0] seconds,minutes;
wire [4:0] hours;
wire [3:0] months;
wire [4:0] days;

wire shutdown , alarm;
wire parity_warning , frame_warning ; 
wire [7:0] temp_out  ;
wire [7:0] data;

reg [7:0] ADC  ;
reg dnum , snum ;
reg [1:0] par ;
reg clk , rst ;
reg [1:0] bd_rate ;


pipe_line_TX T( dout , seconds , minutes , hours , months , days ,
         clk , rst , ADC , bd_rate, dnum , snum , par );

pipe_line_RX R(  temp_out , parity_warning, frame_warning , shutdown , alarm ,
         clk , rst , bd_rate, dnum , snum , par , dout ,data );


initial begin
    ADC <= 8'b10001111;
    dnum <= 1'b0;
    snum <= 1'b0;
    par <= 2'b00;
    bd_rate <= 2'b00;
    rst <= 1'b1;
    clk <= 1'b0;
end

always #10 clk <= ~clk ;

event reset_trigger;
event reset_done_trigger;

always @(reset_trigger)
  begin
    @(negedge clk)    
      rst <= 1'b1 ;
    @(negedge clk)
      rst <= 1'b0 ;       
  end
  
initial begin
  #5 -> reset_trigger;
end

always @(temp_out)
begin 
    if(temp_out != ADC && rst==0) $display("warning");
end

endmodule

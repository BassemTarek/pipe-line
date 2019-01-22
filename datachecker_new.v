module checkdata(input [5:0] minutes ,
 input [5:0] seconds,
  input rst ,
   output reg send_data);
   
  reg [5:0] x ;
  reg [3:0] y ;
   
  always  @(rst)
  begin
    if(rst)
    begin
       y <= 4'b0000;
       x <= 6'b000000 ; 
       send_data <= 1'b1 ;
    end
  end
    
  always @(minutes)
  begin
    if(~rst)
    begin
      y <= y + 4'b0001 ;
        if (y == 4'b0100) // to be 15 minuits 
             begin 
        //datacheck = datarecieved
             send_data <= 1'b0 ; //negative logic
             y <= 4'b0000 ;
             x <= x+6'b000001 ;
             end   
       else  send_data <= 1'b1 ;
    end
  end
  
  always @(seconds)
  begin
     //if(y == 4'b0000 && send_data == 0 && x == 6'b0)  x <= x + 6'b000001;
      /*else*/ if(y == 4'b0000 && send_data == 0 && x == 6'b000001 && rst == 0 ) 
        begin
            send_data <= 1'b1; 
            x <= 6'b000000 ;
        end
  end
        
endmodule
  

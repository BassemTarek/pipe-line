module TXTX( output reg dout,
input [1:0] par,
input [7:0] din,
input clk,rst,start,snum,dnum );

reg [10:0] save ;
wire parity;
reg [3:0] state;
parameter stop=2'b11;

    assign parity=
            (par == 2'b00) ? (^din)  :  // odd
            (par == 2'b11) ? (~^din) :  // even
            ((par == 2'b01) || (par == 2'b10)) ? 0 : 1'bx; // no parity

always @(posedge clk,posedge rst,negedge start)
begin
  if(rst)
    begin
  state <= 0 ;
  dout <= 1'b1 ;
  save <= 11'b0;
    end
  else begin
case (state)
  0: if (~start) 
  begin dout <= 0; state <= 1; save [8:1] <= din; end
  else begin dout <= 1 ; state <= 0 ; end
    
  1: begin 
  dout<= save[0]; 
  save <= { 1'b0 , save[10:1] } ;
  state<=2; end
  2: begin 
  dout<= save[0]; save <= {1'b0,save[10:1]};
  state<=3; end
  3: begin 
  dout<= save[0]; save <= {1'b0,save[10:1]};
  state<=4; end
  4: begin 
  dout<= save[0]; save <= {1'b0,save[10:1]};
  state<=5; end
  5: begin 
  dout<= save[0]; save <= {1'b0,save[10:1]};
  state<=6; end
  6: begin 
  dout<= save[0]; save <= {1'b0,save[10:1]};
  state<=7; end
  7: begin 
  dout<= save[0]; save <= {1'b0,save[10:1]};
  state<=8; end
  
  8: begin 
    if(dnum) // 7 bit 
      dout <= 0 ;
    else   
    dout<= save[0];
    state<=9;
     end
  9: begin dout <= parity; state<=10; end
  10: begin if (~snum) 
     state<=11;
     else state<=0;
     dout <= stop[0]; 
     end 
  11:begin  dout<= stop[1] ; state<=0; end
 endcase 
 end
 end
 endmodule 
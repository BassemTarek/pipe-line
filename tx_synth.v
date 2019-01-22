module tx_synth( output reg dout,
input [1:0] par,
input [7:0] din,
input clk,rst,start,snum,dnum );

reg [10:0]save;
wire parity;
reg [3:0] y=0;
reg [3:0] state=0;
parameter stop=11;

    assign parity=
            (par == 2'b00) ? (^din)  :  // odd
            (par == 2'b11) ? (~^din) :  // even
            ((par == 2'b01) || (par == 2'b10)) ? 0 : 1'bx; // no parity
            
  always @(rst, start)
    begin
    if(rst)
    begin
      y<=0;
      dout<=1;
    end
     else if (~start && y==0)
     begin dout <= 0; y <= 1; save <= din; end
    end

always @(state)
begin
case (state)
  
  0: if (~start)
     begin dout <= 0; y <= 1; save <= din; end
     else begin dout <= 1 ; y <= 0 ; end

  1: begin 
  dout<= save[0]; 
  save <= {1'b0,save[10:1]};
  y<=2; end
  2: begin 
  dout<= save[0]; save <= {1'b0,save[10:1]};
  y<=3; end
  3: begin 
  dout<= save[0]; save <= {1'b0,save[10:1]};
  y<=4; end
  4: begin 
  dout<= save[0]; save <= {1'b0,save[10:1]};
  y<=5; end
  5: begin 
  dout<= save[0]; save <= {1'b0,save[10:1]};
  y<=6; end
  6: begin 
  dout<= save[0]; save <= {1'b0,save[10:1]};
  y<=7; end
  7: begin 
  dout<= save[0]; save <= {1'b0,save[10:1]};
  y<=8; end
  
  8: begin 
    if(dnum) // 7 bit 
      dout <= 0 ;
    else   
    dout<= save[0];
    y<=9;
     end
  9: begin dout <= parity; y<=10; end
  10: begin if (~snum) 
     y<=11;
     else y<=0;
     dout <= stop[0]; 
     end 
  11:begin  dout<= stop[1] ; y<=0; end
 endcase
 end 

always@(posedge clk)
begin
state<=y;
end
 
 
 endmodule
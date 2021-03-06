module RXRX( data , parity_warning , frame_warning , input_signal , RX_clk , rst , snum , dnum , par ) ;

input RX_clk , rst ;
input input_signal ;          // the input bit that is recieved from the TX
input snum ;            // the number of the stop bits (1'b0 : 2 , 1'b1 : 1 stop bit) 
input dnum;             // the number of the transmitted data bits (1'b0 : 8 , 1'b1 : 7 t data bit)
input [1:0] par ;             /* identify the parity check weather it a even or odd parity
                           (2'b00 : odd / 2'b11 : even / (2'b10 | 2'b01) : no parity */   

/////////////////////////////

output reg [7:0] data ;  // the reg the data will be saved in and the o/p of the system
output reg parity_warning;      // checking for parity 
output reg frame_warning;

////////////////////////////
reg data_par;           // recieved data parity (used to check it with the parity of the transmitted signal)
reg signal_par ;         // the transmitted parity
reg [3:0] count_clk ;    // the counter that controls the operation of sampling

reg [3:0] state ;
reg [7:0] Rec; 

always @(rst)
begin
    if(rst)
    begin
        data <= 00_000_000 ;
        Rec <= 00_000_000 ; 
        count_clk <= 4'b0000 ;
        parity_warning <= 1'b0;
        frame_warning <= 1'b0;
        state <= 4'b0000;
        case(par) 
            2'b11   :begin signal_par <= 1'b1; data_par <= 1'b1 ; end
            default :begin signal_par <= 1'b0; data_par <= 1'b0 ; end
            
        endcase
    end
end


always @(posedge RX_clk)
begin    
    if(count_clk == 4'b1111)  count_clk <= 4'b0000 ;
    else if(~rst) count_clk <= count_clk + 4'b0001 ;
end

always @(count_clk)
begin
    case(state)
    0: begin
         if(count_clk == 4'b0111)
         begin
            if(input_signal) state <= 3'b001;
            else if(!(input_signal)) state <= 4'b0010;
            count_clk <= 4'b0000;
         end
       end
    
    1:begin
         if(count_clk == 4'b1111)
         begin
            if( input_signal) state <= 3'b001;
            else if(!input_signal) state <= 4'b0010; end
       end   
       
    2:begin if(count_clk == 4'b1111) begin
             Rec <= Rec >> 1 ;      // shifting right 
             Rec[7] <= input_signal ;
             state <= 4'b0011; end end
      
      3:begin if(count_clk == 4'b1111) begin
             Rec <= Rec >> 1 ;     
             Rec[7] <= input_signal ;
             state <= 4'b0100; end end
      
      4:begin if(count_clk == 4'b1111) begin
             Rec <= Rec >> 1 ;      
             Rec[7] <= input_signal ;
             state <= 4'b0101; end end
      
      5:begin if(count_clk == 4'b1111) begin
             Rec <= Rec >> 1 ;       
             Rec[7] <= input_signal ;
             state <= 4'b0110; end end
      
      6:begin if(count_clk == 4'b1111)begin
             Rec <= Rec >> 1 ;      
             Rec[7] <= input_signal ;
             state <= 4'b0111; end end
      
      7:begin if(count_clk == 4'b1111) begin
             Rec <= Rec >> 1 ; 
             Rec[7] <= input_signal ;
             state <= 4'b1000; end end
      
      8:begin if(count_clk == 4'b1111) begin
             Rec <= Rec >> 1 ;     
             Rec[7] <= input_signal ;
             state <= 4'b1001; end end
      
      9:begin if(count_clk == 4'b1111) begin
             Rec <= Rec >> 1 ;     
             if(~dnum) Rec[7] <= input_signal ;
             state <= 4'b1010; end end
      
     10:begin if(count_clk == 4'b1111) begin
            signal_par <= input_signal;
            state <= 4'b1011 ; end end
      
      11:begin
            if(count_clk == 4'b1111)
            begin
              if(input_signal)
                begin
                   if(snum) begin
                       state <= 4'b0001;
                       $display("signal recieved");
                       data[7:0] <= Rec[7:0] ; end
                                              
                   else state <= 4'b1100;                   
                end
              else if(!input_signal) begin
                  frame_warning <= 1'b1;
                  state <= 4'b0001;  end
              end
         end
           
      12: begin
            if(count_clk == 4'b1111) begin
                if(input_signal) begin
                    state <= 4'b0001;
                    $display("signal recieved");
                    data[7:0] <= Rec[7:0] ; end
                    
                else if(!(input_signal)) begin
                    frame_warning <= 1'b1;
                    state <= 4'b0001;    end
              end
          end
         
      endcase
               
end

always @(signal_par) begin
     data_par = (^data) ;
     parity_warning = data_par ^ signal_par ;
end

endmodule
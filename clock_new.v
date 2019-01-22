
module Digital_Clock(
    OneSecClock,                    //Clock with 1 Hz frequency
    reset,    
      minutes , seconds,hours,months,days
    );


    input  OneSecClock ;  
    input reset;
    output reg[5:0] seconds,minutes;
    output reg [4:0] hours;
    output reg[3:0] months;
     output reg [4:0] days;
        


   
    always @(posedge( OneSecClock) or posedge(reset))
    begin
        if(reset == 1'b1) begin  //check for active high reset.
            //reset the time.
            seconds <= 4'b0;
            
            minutes <= 4'b0;
         
            hours   <= 4'b0; 
      
            days    <=4'b0;
           
            months  <=4'b0;
             end
        else if( OneSecClock == 1'b1) begin  //at the beginning of each second
            seconds <= seconds + 1; // unit sec counter
          
            if(seconds == 59) begin
                seconds <= 0;  //reset sec counter
                minutes <= minutes+1; //minutes ount
               
                if(minutes == 59) begin //check for max value of minutes
                   minutes <= 0;  // reset minutes
                    hours <= hours + 1;  //hours counter
                   if(hours ==  24) begin  //check for max value of hours
                        hours <= 0; //reset hours 
                        days <= days+1;end
                      if (days == 30)begin
                         days <= 0;
                         months <= months+1; 
                         if (months == 12)
                           months <=0;
                         end
                        
                    end 
                end
            end     
        end
		  
         

endmodule



module Wishbone_slave
  #(parameter master_width, slave_width)
  (
    input CLK_I,
    input RST_I,
  
    input [slave_width-1:0] S_DATA_I,
    input [7:0] S_ADR_I,
    input S_CYC_I,
    input S_STB_I,
    input S_WE_I,
    input [2:0]S_SEL_I,
    
    output reg [slave_width-1:0]S_DATA_O,
    output reg S_ACK_O
  );
  
  reg [slave_width-1:0]memory [255 :0];
  
  always@(posedge CLK_I)
  begin
    if(RST_I == 1)
    begin
      S_DATA_O <= 0;
      S_ACK_O <= 0;
    end
    else
    begin 
      if(S_CYC_I)
      begin 
        if(S_STB_I)
        begin
          S_ACK_O = ~S_ACK_O;
          if(S_WE_I)
            memory[S_ADR_I] <= S_DATA_I;
          else
            S_DATA_O <= memory[S_ADR_I];
        end
      end
      else
        S_ACK_O = 0;
    end
  end
endmodule 
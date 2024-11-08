module wishbone_intercon 
  #(parameter master_width , slave_width )
  (
    input CLK_I,
    input RST_I,
    
    input [master_width-1:0]DATA_INPUT,
    input [7:0]ADR_INPUT,
    input WE_INPUT,
    input SMP,
    output reg [master_width-1:0]DATA_OUTPUT
  );
  
    reg [slave_width-1:0] DATA_M_S;
    reg [slave_width-1:0] DATA_S_M;
    reg [7:0] ADR;
    reg CYC;
    reg STB;
    reg WE;
    reg [2:0]SEL;
    
    reg ACK;
    
    Wishbone_master #(master_width,slave_width) uut(
                      .CLK_I(CLK_I),
                      .RST_I(RST_I),
                      .M_DATA_O(DATA_M_S),
                      .M_ADR_O(ADR),
                      .M_CYC_O(CYC),
                      .M_STB_O(STB),
                      .M_WE_O(WE),
                      .M_SEL_O(SEL),
                      .M_DATA_I(DATA_S_M),
                      .M_ACK_I(ACK),
                      .DATA_INPUT(DATA_INPUT),
                      .ADR_INPUT(ADR_INPUT),
                      .WE_INPUT(WE_INPUT),
                      .SMP(SMP),
                      .DATA_OUTPUT(DATA_OUTPUT)
                      );
                      
    Wishbone_slave #(master_width,slave_width) uut2(
                      .CLK_I(CLK_I),
                      .RST_I(RST_I),
                      .S_DATA_I(DATA_M_S),
                      .S_ADR_I(ADR),
                      .S_CYC_I(CYC),
                      .S_STB_I(STB),
                      .S_WE_I(WE),
                      .S_SEL_I(SEL),
                      .S_DATA_O(DATA_S_M),
                      .S_ACK_O(ACK)
                      );
endmodule 
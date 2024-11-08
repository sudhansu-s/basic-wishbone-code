module wishbone_tb_verilog;
  parameter master_width = 64 , slave_width = 64 ;
  
  reg CLK_I;
  reg RST_I;
  reg [master_width-1:0]DATA_INPUT;
  reg [7:0]ADR_INPUT;
  reg  WE_INPUT;
  wire [master_width-1:0]DATA_OUTPUT;
  reg SMP;
  
  wishbone_intercon #(64,8) uut(
              .CLK_I(CLK_I),
              .RST_I(RST_I),
              .DATA_INPUT(DATA_INPUT),
              .ADR_INPUT(ADR_INPUT),
              .WE_INPUT(WE_INPUT),
              .SMP(SMP),
              .DATA_OUTPUT(DATA_OUTPUT)
              );
              
  always #5 CLK_I = ~CLK_I;
  
  initial begin 
    CLK_I = 1;
    RST_I = 1;
    SMP =0;
    DATA_INPUT = 'h123ababaabcdef90;
    ADR_INPUT = 'b10110110;
    WE_INPUT = 1;
    #30;
    RST_I = 0;
    #40 ;
    WE_INPUT = 1;
    DATA_INPUT = 'h1234567812345678;
    ADR_INPUT = 'b11000110;
    WE_INPUT = 1;
    #350;
    WE_INPUT =0;
    #40;
    SMP = 1;
    ADR_INPUT = 'b10110110;
    #30;
    DATA_INPUT = 'habcdefabcdefabcd;
    // WE_INPUT = 1;
    #200;
    SMP = 0;
    #200;
    // WE_INPUT = 1;
    ADR_INPUT = 'b11000110;
    
  end
  
endmodule 
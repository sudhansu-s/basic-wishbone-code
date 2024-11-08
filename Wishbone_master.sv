module Wishbone_master
  #(parameter master_width , slave_width)           // Declaration of parameter for the size of input data and slave size.
  (
    // Clock and Reset condition declaration 
    input       CLK_I,                                    // main Clock from INTERCON
    input       RST_I,                                    // main reset from INTERCON
    // output from Master to Slave
    output reg  [slave_width-1:0] M_DATA_O,         //data which transfers from master to slave
    output reg  [7:0] M_ADR_O,                        //Address for the data to accessed
    output reg  M_CYC_O,                              //Cycle Enable to indicate high in case of block read WRITE
    output reg  M_STB_O,                          
    output reg  M_WE_O,
    output reg  [2:0]M_SEL_O,
    // Input from slave to Master
    input       [slave_width-1:0]M_DATA_I,
    input       M_ACK_I,
    // Main input from USER (for verification)
    input       [master_width-1:0]DATA_INPUT,
    input       [7:0]ADR_INPUT,
    input       WE_INPUT,
    input       SMP,
    output reg  [master_width-1:0]DATA_OUTPUT
  );
  
  reg [3:0] CR_STATE;
  parameter IDLE = 4'b0000,
            WRITE = 4'b0001,
            READ = 4'b0010,
            COMPLETE = 4'b0011,
            RESET = 4'b0100;
  reg [master_width-1: 0]data_temp;
  reg [7:0]adr_temp;
  reg [master_width-1:0]data_out_temp;
  reg [2:0] STATE;
  reg SMP_temp;
  
  always@(posedge CLK_I )
  begin 
    if(RST_I == 1'b1)
    begin 
      M_DATA_O <= 0;
      M_ADR_O <= 0;
      M_CYC_O <= 0;
      M_STB_O <= 0;
      M_WE_O  <= 0;
      M_SEL_O <= 0;
      STATE <= 3'b000;
      CR_STATE <= RESET;
      DATA_OUTPUT <= 0;
      data_out_temp <= 0;
      data_temp <= 0;
      adr_temp <= 0;
      SMP_temp <= 0;
      $display("%0t, entered reset condition",$time);
    end
    else
    begin 
      case(CR_STATE)
        RESET : begin 
                M_CYC_O <= 0;
                M_STB_O <= 0;
                CR_STATE <= IDLE;
                M_WE_O <= WE_INPUT;
                data_temp <= DATA_INPUT;
                adr_temp <= ADR_INPUT;
                SMP_temp <= SMP;
                $display("%0t, entered reset condition",$time);
                end
        IDLE : begin
                M_CYC_O <= 1;
                M_STB_O <= 1;
                $display("%0t, entered inside the IDLE condition and CYC, stb got high",$time);
                if(M_WE_O ==  1)
                begin 
                  case(M_SEL_O)
                    3'b000 :begin 
                              if(master_width == slave_width)
                              begin
                                $display("%0t, sel_o 000 -1",$time);
                                M_DATA_O <= data_temp;
                                M_ADR_O <= adr_temp;
                                CR_STATE <= WRITE;
                              end
                              else if(slave_width == (master_width/2))
                              begin 
                                $display("%0t, sel_o 000 - 2",$time);
                                M_DATA_O = data_temp[(master_width/2)-1:0];
                                M_ADR_O <= adr_temp + 0;
                                CR_STATE <= WRITE;
                                end
                              else if(slave_width == (master_width/4))
                              begin 
                                $display("%0t, sel_o 000 - 3",$time);
                                M_DATA_O <= data_temp[(master_width/4)-1:0];
                                M_ADR_O <= adr_temp + 0;
                                CR_STATE <= WRITE;
                                end
                              else if(slave_width == (master_width/8))
                              begin 
                                $display("%0t, sel_o 000 - 4",$time);
                                M_DATA_O <= data_temp [(master_width/8)-1:0];
                                M_ADR_O <= adr_temp + 0;
                                CR_STATE <= WRITE;
                              end
                              else
                              begin 
                                $display("%0t, sel_o 000 - 5",$time);
                                M_DATA_O <= data_temp;
                                M_ADR_O <= adr_temp;
                                CR_STATE <= WRITE;
                              end
                            end
                    3'b001 :begin 
                              if(slave_width == (master_width/2))
                              begin 
                                $display("%0t, sel_o 001 - 1",$time);
                                M_DATA_O <= data_temp[master_width-1:master_width/2];
                                M_ADR_O <= adr_temp + 1;
                                CR_STATE <= WRITE;
                              end
                              else if(slave_width == (master_width/4))
                              begin 
                                $display("%0t, sel_o 001 - 2",$time);
                                M_DATA_O <= data_temp[(master_width/2)-1:(master_width/4)];
                                M_ADR_O <= adr_temp + 1;
                                CR_STATE <= WRITE;
                              end
                              else if(slave_width == (master_width/8))
                              begin 
                                $display("%0t, sel_o 001 - 3",$time);
                                M_DATA_O <= data_temp [(master_width/4)-1:(master_width/8)];
                                M_ADR_O <= adr_temp + 1;
                                CR_STATE <= WRITE;
                              end
                              else
                              begin 
                                $display("%0t, sel_o 001 - 4",$time);
                                M_DATA_O <= data_temp;
                                M_ADR_O <= adr_temp;
                                CR_STATE <= WRITE;
                              end
                            end
                      
                    3'b010 :begin 
                              if(slave_width  == (master_width/4))
                              begin 
                                $display("%0t, sel_o 010 - 1",$time);
                                M_DATA_O <= data_temp[((3*master_width)/4)-1:(master_width/2)];
                                M_ADR_O <= adr_temp + 2;
                                CR_STATE <= WRITE;
                              end
                              else if(slave_width == (master_width/8))
                              begin 
                                $display("%0t, sel_o 010 - 2",$time);
                                M_DATA_O <= data_temp [((3*master_width)/8)-1:(master_width/4)];
                                M_ADR_O <= adr_temp + 2;
                                CR_STATE <= WRITE;
                              end
                              else
                              begin 
                                $display("%0t, sel_o 010 - 3",$time);
                                M_DATA_O <= data_temp;
                                M_ADR_O <= adr_temp;
                                CR_STATE <= WRITE;
                              end
                            end
                      
                    3'b011 :begin 
                              if(slave_width== (master_width/4))
                              begin 
                                $display("%0t, sel_o 011 - 1",$time);
                                M_DATA_O <= data_temp[(master_width)-1:((3*master_width)/4)];
                                M_ADR_O <= adr_temp + 3;
                                CR_STATE <= WRITE;
                              end
                              else if(slave_width== (master_width/8))
                              begin 
                                $display("%0t, sel_o 011 - 2",$time);
                                M_DATA_O <= data_temp [(master_width/2)-1:((3 * master_width)/8)];
                                M_ADR_O <= adr_temp + 3;
                                CR_STATE <= WRITE;
                              end
                              else
                              begin 
                                $display("%0t, sel_o 011 - 3",$time);
                                M_DATA_O <= data_temp;
                                M_ADR_O <= adr_temp;
                                CR_STATE <= WRITE;
                              end
                            end
                      
                    3'b100 :begin 
                              if(slave_width == (master_width/8))
                              begin 
                                $display("%0t, sel_o 100 - 1",$time);
                                M_DATA_O <= data_temp [((5 * master_width)/8)-1:(master_width/2)];
                                M_ADR_O <= adr_temp + 4;
                                CR_STATE <= WRITE;
                              end
                              else
                              begin 
                                $display("%0t, sel_o 100 - 2",$time);
                                M_DATA_O <= data_temp;
                                M_ADR_O <= adr_temp;
                                CR_STATE <= WRITE;
                              end
                            end
                              
                    3'b101 :begin 
                              if(slave_width == (master_width/8))
                              begin 
                                $display("%0t, sel_o 101 - 1",$time);
                                M_DATA_O <= data_temp[((6 * master_width)/8)-1:((5 * master_width)/8)];
                                M_ADR_O <= adr_temp + 5;
                                CR_STATE <= WRITE;
                              end
                              else
                              begin 
                                $display("%0t, sel_o 101 - 2",$time);
                                M_DATA_O <= data_temp;
                                M_ADR_O <= adr_temp;
                                CR_STATE <= WRITE;
                              end
                            end
                              
                    3'b110 :begin 
                              if(slave_width== (master_width/8))
                              begin 
                                $display("%0t, sel_o 110 - 1",$time);
                                M_DATA_O <= data_temp [((7 * master_width)/8)-1:((6 * master_width)/8)];
                                M_ADR_O <= adr_temp + 6;
                                CR_STATE <= WRITE;
                              end
                              else
                              begin 
                                $display("%0t, sel_o 110 - 2",$time);
                                M_DATA_O <= data_temp;
                                M_ADR_O <= adr_temp;
                                CR_STATE <= WRITE;
                              end
                            end
                              
                    3'b111 :begin 
                              if(slave_width == (master_width/8))
                              begin 
                                $display("%0t, sel_o 111 - 1",$time);
                                M_DATA_O <= data_temp[(master_width)-1:((7 * master_width)/8)];
                                M_ADR_O <= adr_temp + 7;
                                CR_STATE <= WRITE;
                              end
                              else
                              begin 
                                $display("%0t, sel_o 111 - 2",$time);
                                M_DATA_O <= data_temp;
                                M_ADR_O <= adr_temp;
                                CR_STATE <= WRITE;
                              end
                            end
                    default :begin 
                              $display("%0t, sel_o dafault",$time);
                              M_DATA_O <= 'bX;
                              M_ADR_O <= 'bX;
                              CR_STATE <= WRITE;
                              $display("default -> WRITE ");
                             end
                  endcase
                  end
                  else
                  begin
                    $display("%0t, IDLE -> REAd -> ",$time);
                    case(STATE)
                      3'b000 :begin 
                                if(master_width == slave_width)
                                  begin
                                    $display("%0t, state 000 - 1",$time);
                                    M_ADR_O <= adr_temp;
                                    CR_STATE <= READ;
                                  end
                                else if(slave_width == (master_width/2))
                                  begin 
                                    $display("%0t, state 000 - 2",$time);
                                    M_ADR_O <= adr_temp + 0;
                                    CR_STATE <= READ;
                                  end
                                else if(slave_width == (master_width/4))
                                  begin 
                                    $display("%0t, state 000 - 3",$time);
                                    M_ADR_O <= adr_temp+ 0;
                                    CR_STATE <= READ;
                                  end
                                else if(slave_width == (master_width/8))
                                  begin 
                                    $display("%0t, state 000 - 4",$time);
                                    M_ADR_O <= adr_temp + 0;
                                    CR_STATE <= READ;
                                  end
                                else
                                  begin 
                                    $display("%0t, state 000 - 5",$time);
                                    M_ADR_O <= adr_temp;
                                    CR_STATE <= READ;
                                  end
                              end
                      3'b001 :begin 
                                if(slave_width == (master_width/2))
                                  begin 
                                    $display("%0t, state 001 - 1",$time);
                                    M_ADR_O <= adr_temp + 1;
                                    CR_STATE <= READ;
                                  end
                                else if(slave_width == (master_width/4))
                                  begin 
                                    $display("%0t, state 001 - 2",$time);
                                    M_ADR_O <= adr_temp + 1;
                                    CR_STATE <= READ;
                                  end
                                else if(slave_width == (master_width/8))
                                  begin 
                                    $display("%0t, state 001 - 3",$time);
                                    M_ADR_O <= adr_temp + 1;
                                    CR_STATE <= READ;
                                  end
                                else
                                  begin 
                                    $display("%0t, state 001 - 4",$time);
                                    M_ADR_O <= adr_temp;
                                  // $display("001 -> read ");
                                    CR_STATE <= READ;
                                  end
                              end
                      
                      3'b010 :begin 
                                if(slave_width  == (master_width/4))
                                  begin 
                                    $display("%0t, state 010 - 1",$time);
                                    M_ADR_O <= adr_temp + 2;
                                    CR_STATE <= READ;
                                  end
                                else if(slave_width == (master_width/8))
                                  begin 
                                    $display("%0t, state 010 - 2",$time);
                                    M_ADR_O <= adr_temp + 2;
                                    CR_STATE <= READ;
                                  end
                                else
                                  begin 
                                    $display("%0t, state 010 - 3",$time);
                                    M_ADR_O <= adr_temp;
                                    CR_STATE <= READ;
                                  end
                              end
                      
                      3'b011 : begin 
                                if(slave_width== (master_width/4))
                                  begin 
                                    $display("%0t, state 011 - 1",$time);
                                    M_ADR_O <= adr_temp + 3;
                                    CR_STATE <= READ;
                                  end
                                else if(slave_width== (master_width/8))
                                  begin 
                                    $display("%0t, state 011 - 2",$time);
                                    M_ADR_O <= adr_temp + 3;
                                    CR_STATE <= READ;
                                  end
                                else
                                  begin 
                                    $display("%0t, state 011 - 3",$time);
                                    M_ADR_O <= adr_temp;
                                    CR_STATE <= READ;
                                  // $display("011 -> read ");
                                  end
                              end
                      
                      3'b100 : begin 
                                if(slave_width == (master_width/8))
                                  begin 
                                    $display("%0t, state 100 - 1",$time);
                                    M_ADR_O <= adr_temp + 4;
                                    CR_STATE <= READ;
                                  end
                                else
                                  begin 
                                    $display("%0t, state 100 - 2",$time);
                                    M_ADR_O <= adr_temp;
                                    CR_STATE <= READ;
                                  $display("100 -> read ");
                                  end
                              end
                              
                      3'b101 : begin 
                                if(slave_width == (master_width/8))
                                  begin 
                                    $display("%0t, state 101 - 1",$time);
                                    M_ADR_O <= adr_temp + 5;
                                    CR_STATE <= READ;
                                  end
                                else
                                  begin 
                                    $display("%0t, state 101 - 2",$time);
                                    M_ADR_O <= adr_temp;
                                    CR_STATE <= READ;
                                  $display("101 -> read ");
                                  end
                              end
                              
                      3'b110 : begin 
                                if(slave_width== (master_width/8))
                                  begin 
                                    $display("%0t, state 110 - 1",$time);
                                    M_ADR_O <= adr_temp + 6;
                                    CR_STATE <= READ;
                                  end
                                else
                                  begin 
                                    $display("%0t, state 110 - 2",$time);
                                    M_ADR_O <= adr_temp;
                                    CR_STATE <= READ;
                                  $display("110 -> read ");
                                  end
                              end
                              
                      3'b111 : begin 
                                if(slave_width == (master_width/8))
                                  begin 
                                    $display("%0t, state 111 - 1",$time);
                                    M_ADR_O <= adr_temp + 7;
                                    CR_STATE <= READ;
                                  end
                                else
                                  begin 
                                    $display("%0t, state 111 - 2",$time);
                                    M_ADR_O <= adr_temp;
                                    CR_STATE <= READ;
                                  $display("111 -> read ");
                                  end
                              end
                    endcase
                end
               end
               
        WRITE :begin 
                  if(M_ACK_I == 1 && M_STB_O && M_CYC_O)
                  begin 
                    if(M_SEL_O == 'b000 && slave_width == master_width)
                    begin 
                      $display("%0t, 459 ",$time);
                      CR_STATE <= COMPLETE;
                      M_SEL_O <= 'b000;
                      M_STB_O <= 0;
                      M_CYC_O <= 0;
                    end
                    else if(M_SEL_O == 'b001 && slave_width == master_width/2)
                    begin 
                      $display("%0t, 467 ",$time);
                      CR_STATE <= COMPLETE;
                      M_SEL_O <= 'b000;
                      M_STB_O <= 0;
                      M_CYC_O <= 0;
                    end
                    else if(M_SEL_O == 'b011 && slave_width == master_width/4)
                    begin 
                      $display("%0t, 475 ",$time);
                      CR_STATE <= COMPLETE;
                      M_SEL_O <= 'b000;
                      M_STB_O <= 0;
                      M_CYC_O <= 0;
                    end
                    else if(M_SEL_O == 'b111 && slave_width == master_width/8)
                    begin 
                      $display("%0t, 483 ",$time);
                      CR_STATE <= COMPLETE;
                      M_SEL_O <= 'b000;
                      M_STB_O <= 0;
                      M_CYC_O <= 0;
                    end
                    else
                    begin 
                      $display("%0t, 502 ",$time);
                      M_SEL_O <= M_SEL_O + 1'b1;
                      CR_STATE = IDLE;
                      M_STB_O <= 0;
                    end
                  end
                  else
                  begin
                    $display("%0t, enetered else mode in write state when ack = 0",$time);
                    $display("%0t, ack =0 next_state %b ",$time,CR_STATE);
                    CR_STATE <= WRITE;
                  end
               end 
               
        READ :begin 
                if(M_ACK_I)
                begin
                  $display("%0t, entered READ state and inside if ack",$time);
                case(STATE)
                    3'b000 :begin 
                              if(master_width == slave_width)
                              begin
                                $display("%0t, read state 000 - 1",$time);
                                data_out_temp <= M_DATA_I;
                                CR_STATE <= COMPLETE;
                              end
                              else if(slave_width == (master_width/2))
                              begin 
                                $display("%0t, read state 000 - 2",$time);
                                data_out_temp[(master_width/2)-1:0] <= M_DATA_I;
                                CR_STATE <= IDLE;
                                STATE <= 3'b001;
                              end
                              else if(slave_width == (master_width/4))
                              begin 
                                $display("%0t, read state 000 - 3",$time);
                                data_out_temp[(master_width/4)-1:0] <= M_DATA_I;
                                CR_STATE <= IDLE;
                                STATE <= 3'b001;
                              end
                              else if(slave_width == (master_width/8))
                              begin 
                                $display("%0t, read state 000 - 4",$time);
                                data_out_temp[(master_width/8)-1:0] <= M_DATA_I;
                                CR_STATE <= IDLE;
                                STATE <= 3'b001;
                              end
                              else
                              begin 
                                $display("%0t, read state 000 - 5",$time);
                                data_out_temp <= M_DATA_I;
                                CR_STATE <= COMPLETE;
                              end
                            end
                          
                    3'b001 :begin 
                              if(slave_width == (master_width/2))
                              begin 
                                $display("%0t, read state 001 - 1",$time);
                                data_out_temp[master_width-1:master_width/2] <= M_DATA_I;
                                CR_STATE <= COMPLETE;
                                STATE <= 0;
                              end
                              else if(slave_width == (master_width/4))
                              begin 
                                $display("%0t, read state 001 - 2",$time);
                                data_out_temp[(master_width/2)-1:(master_width/4)] <= M_DATA_I;
                                CR_STATE <= IDLE;
                                STATE <= 3'b010;
                              end
                            else if(slave_width == (master_width/8))
                              begin 
                                $display("%0t, read state 001 - 3",$time);
                                data_out_temp[(master_width/4)-1:(master_width/8)] <= M_DATA_I;
                                CR_STATE <= IDLE;
                                STATE <= 3'b010;
                              end
                              else
                              begin 
                                $display("%0t, read state 001 - 4",$time);
                                data_out_temp <= M_DATA_I;
                                CR_STATE <= COMPLETE;
                              end
                            end
                    
                    3'b010 :begin 
                              if(slave_width  == (master_width/4))
                              begin 
                                $display("%0t, read state 010 - 1",$time);
                                data_out_temp[((3 * master_width)/4)-1:(master_width/2)] <= M_DATA_I;
                                CR_STATE <= IDLE;
                                STATE <= 3'b011;
                              end
                              else if(slave_width == (master_width/8))
                              begin 
                                $display("%0t, read state 010 - 2",$time);
                                data_out_temp [((3 * master_width)/8)-1:(master_width/4)] <= M_DATA_I;
                                CR_STATE <= IDLE;
                                STATE <= 3'b011;
                              end
                              else
                              begin 
                                $display("%0t, read state 010 - 3",$time);
                                data_out_temp <= M_DATA_I;
                                CR_STATE <= COMPLETE;
                              end
                            end
                    
                    3'b011 :begin 
                              if(slave_width== (master_width/4))
                              begin 
                                $display("%0t, read state 011 - 1",$time);
                                data_out_temp[(master_width)-1:((3 * master_width)/4)] <= M_DATA_I;
                                CR_STATE <= COMPLETE;
                              end
                              else if(slave_width== (master_width/8))
                              begin 
                                $display("%0t, read state 011 - 2",$time);
                                data_out_temp[(master_width/2)-1:((3 * master_width)/8)] <= M_DATA_I;
                                CR_STATE <= IDLE;
                                STATE <= 3'b100;
                              end
                              else
                              begin 
                                $display("%0t, read state 011 - 3",$time);
                                data_out_temp <= M_DATA_I;
                                CR_STATE <= COMPLETE;
                              end
                            end
                    
                    3'b100 :begin 
                              if(slave_width == (master_width/8))
                              begin 
                                $display("%0t, read state 100 - 1",$time);
                                data_out_temp [((5 * master_width)/8)-1:(master_width/2)] <= M_DATA_I;
                                CR_STATE <= IDLE;
                                STATE <= 3'b101;
                              end
                              else
                              begin 
                                $display("%0t, read state 100 - 2",$time);
                                data_out_temp <= M_DATA_I;
                              CR_STATE <= COMPLETE;
                              end
                             end
                            
                    3'b101 :begin 
                              if(slave_width == (master_width/8))
                              begin 
                                $display("%0t, read state 101 - 1",$time);
                                data_out_temp[((6 * master_width)/8)-1:((5 * master_width)/8)] <= M_DATA_I;
                                CR_STATE <= IDLE;
                                STATE <= 3'b110;
                              end
                              else
                              begin 
                                $display("%0t, read state 101 - 1",$time);
                                data_out_temp <= M_DATA_I;
                                CR_STATE <= COMPLETE;
                              end
                            end
                            
                    3'b110 :begin 
                            if(slave_width== (master_width/8))
                              begin 
                                $display("%0t, read state 110 - 1",$time);
                                data_out_temp [((7 * master_width)/8)-1:((6 * master_width)/8)] <= M_DATA_I;
                                CR_STATE <= IDLE;
                                STATE <= 3'b111;
                              end
                              else
                              begin 
                                $display("%0t, read state 110 - 2",$time);
                                data_out_temp <= M_DATA_I;
                                CR_STATE <= COMPLETE;
                              end
                            end
                            
                    3'b111 :begin 
                              if(slave_width == (master_width/8))
                              begin 
                              $display("%0t, read state 111 - 1",$time);
                              data_out_temp[(master_width)-1:((7 * master_width)/8)] <= M_DATA_I;
                              CR_STATE <= COMPLETE;
                              STATE <= 3'b000;
                            end
                              else
                              begin 
                                $display("%0t, read state 111 - 1",$time);
                                data_out_temp <= M_DATA_I;
                                CR_STATE <= COMPLETE;
                              end
                            end
                  endcase
                  M_STB_O <= 0;
                end
              end
              
        COMPLETE :begin 
                    $display("%0t, WE_INPUT != M_WE_O  line 690",$time);
                    DATA_OUTPUT = data_out_temp;
                    if(SMP_temp == 0)
                    begin 
                      if(M_WE_O == 0)
                      begin 
                        M_CYC_O <= 0;
                        begin
                          if(SMP == 1)
                          begin 
                            $display("%0t, WE_INPUT != M_WE_O  line 693",$time);
                            SMP_temp <= 1;
                            CR_STATE <= IDLE;
                            M_WE_O <= 0;
                            STATE <= 0;
                          end
                          else if(WE_INPUT != M_WE_O)
                          begin 
                            $display("%0t, WE_INPUT != M_WE_O  line 705",$time);
                            M_WE_O <= WE_INPUT;
                            adr_temp <= ADR_INPUT;
                            CR_STATE <= IDLE;
                            STATE <= 0;
                          end
                        end
                        if(data_temp != DATA_INPUT || adr_temp != ADR_INPUT)
                        begin 
                          M_STB_O <= 0;
                          M_CYC_O <= 0;
                          $display("%0t, COMPLETE -> M_WE_O =1 -> DATA_INPUT  line 715",$time);
                          data_temp <= DATA_INPUT;
                          adr_temp <= ADR_INPUT;
                          CR_STATE = IDLE;
                          M_SEL_O<= 0;
                        end
                      end
                      else
                      begin 
                        begin 
                          if(SMP == 1)
                          begin 
                            $display("%0t, WE_INPUT != M_WE_O  line 730",$time);
                            SMP_temp <= 1;
                            CR_STATE <= IDLE;
                            M_WE_O <= 0;
                          end
                          else if(WE_INPUT != M_WE_O)
                          begin 
                            $display("%0t, WE_INPUT != M_WE_O  line 727",$time);
                            M_WE_O <= WE_INPUT;
                            adr_temp <= ADR_INPUT;
                            CR_STATE <= IDLE;
                            STATE <= 0;
                          end
                        end
                        if(data_temp != DATA_INPUT || adr_temp != ADR_INPUT)
                        begin 
                          M_STB_O <= 0;
                          M_CYC_O <= 0;
                          $display("%0t, COMPLETE -> M_WE_O =1 -> DATA_INPUT  line 737",$time);
                          data_temp <= DATA_INPUT;
                          adr_temp <= ADR_INPUT;
                          CR_STATE = IDLE;
                          M_SEL_O<= 0;
                        end
                      end
                    end
                    else
                    begin
                      $display("%0t, COMPLETE -> M_WE_O =1 -> DATA_INPUT  line 747",$time);
                      if(M_WE_O == 1)
                      begin 
                        $display("%0t, COMPLETE -> M_WE_O =1 -> DATA_INPUT  line 750",$time);
                        SMP_temp <= 0;
                        M_CYC_O <= 0;
                        M_WE_O <= WE_INPUT;
                        CR_STATE <= COMPLETE;
                      end
                      else
                      begin 
                        $display("%0t, COMPLETE -> M_WE_O =1 -> DATA_INPUT  line 760",$time);
                        M_WE_O <= 1;
                        CR_STATE <= IDLE;
                        M_SEL_O <= 0;
                      end
                          
                    end
                  end
      endcase
      $display("%0t, outside end case",$time);
    end 
  end
endmodule 
`timescale 1 ns / 1 ns
module bfm_tb ();

   reg         clk;                                                
   reg         reset_n;    
   wire  [31:0] wvRegisterWritePort;
   reg   [31:0] rvRegisterReadPort ;
   
   simple_avmm_bfm u0 (
      .clk_clk                                                 ( clk                  ),
      .reg32_read_port_external_connection_export              ( wvRegisterReadPort   ),
      .reg32_write_port_external_connection_export             ( wvRegisterWritePort  ),
      .reset_reset_n                                           ( reset_n              ) 
   );

   bfm_master bfm_master_inst();
   
   initial 
   begin
      reset_n = 0;     
   #100    
      reset_n = 1;
   end
   
   initial 
   begin
      clk = 0;     
   forever   
   #10 
      clk = ~clk;
   end
   
   initial 
   begin
      rvRegisterReadPort = 32'h20190409;
   end
   
endmodule

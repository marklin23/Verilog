//---------------------------------------------------
// Macro definition
//---------------------------------------------------
`timescale 1ns / 1ns

`define BFM_MASTER $root.bfm_tb.u0.mm_master_bfm_0
`define AV_ADDRESS_W   20
`define AV_DATA_W      32

// qsys address define
`define onchip_memory2_0_base  32'h0000_0000
`define reg32_write_port_base  32'h0000_1010
`define reg32_read_port_base   32'h0000_1000
`define sysid_qsys_0_base      32'h0000_1020


 import verbosity_pkg::*;
 import avalon_mm_pkg::*;

module bfm_master();

   wire clk = $root.bfm_tb.u0.clk_clk;
   integer i,k;
   parameter time_unit      = 1;					
   parameter clk_time       = 10 * time_unit;  
   parameter wait_time      = clk_time * 3000; 
   parameter wait_long_time = clk_time * 5000;  
   
   reg   [31:0]temp;
   reg   [31:0]temp1;
   reg   [31:0]dummy;
   reg   [31:0]rvI2cReadData = 0;
   reg   [31:0]rvErrorCount;
   reg   [31:0]rvCorrectCount;   
   initial
   begin
      dummy = 32'h00;
      rvErrorCount = 32'h0;
      rvCorrectCount = 32'h0;
      set_verbosity(VERBOSITY_INFO);
      wait (bfm_tb.u0.reset_reset_n == 1);
      $display("Starting master test program");
      
      for(k=0;k<100;k=k+1) begin
         # 200 avalon_write ( (`onchip_memory2_0_base+ (k*4)), {k});
      end
      $display("Write Memory Done");
      
      for(k=0;k<100;k=k+1) begin
         # 100 avalon_read ( (`onchip_memory2_0_base+ (k*4)), {dummy});
         # 100 
         
               if(dummy==k) begin
                  $display("Read from  ram address: 0x%h , Read Data: 0x%h is correct ", k*4 , dummy);
                  rvCorrectCount = rvCorrectCount +1;
               end
               else begin 
                  $display("Read from  ram address: 0x%h , Read Data: 0x%h is not correct ", k*4 , dummy);   
                  rvErrorCount = rvErrorCount +1;
               end         
      end
      $display("read Memory Done");
      $display("read correct num: 0x%h ",rvCorrectCount);
      $display("read error num: 0x%h ",rvErrorCount);
   end
    
    
//-----------------------------------------------
//                  Tasks
//-----------------------------------------------

    task avalon_write (
        input [`AV_ADDRESS_W-1:0] addr,
        input [`AV_DATA_W-1:0]    data
    );
    begin
        $display("-------Master sending out write commands-------");
        // Construct the BFM_MASTER request
        `BFM_MASTER.set_command_address(addr);
        `BFM_MASTER.set_command_request(REQ_WRITE);
        `BFM_MASTER.set_command_idle(0, 0);
        `BFM_MASTER.set_command_burst_count(1); 
        `BFM_MASTER.set_command_burst_size(1);
        `BFM_MASTER.set_command_init_latency(0);
        `BFM_MASTER.set_command_byte_enable('1,0);
        `BFM_MASTER.set_command_data(data, 0);      
        $display ( "          addr                 write_data      " );
	     $display ("       0x%h                 0x%h         ",
                          addr,                data           );
                          
        // Queue the command
        `BFM_MASTER.push_command();
        
        // Wait until the transaction has completed
        while (`BFM_MASTER.get_response_queue_size() != 1)
            @(posedge clk);

        // Dequeue the response and discard
        `BFM_MASTER.pop_response();
    end
    endtask
            
// ------------------------------------------------------------
    task avalon_read (
    
        input  [`AV_ADDRESS_W-1:0] addr,
        output [`AV_DATA_W-1:0]    data
    );
    begin
        $display("-------Master sending out read commands-------");
        // Construct the BFM_MASTER request
        `BFM_MASTER.set_command_request(REQ_READ);
        `BFM_MASTER.set_command_idle(0, 0);
        `BFM_MASTER.set_command_burst_count(1); 
        `BFM_MASTER.set_command_init_latency(0);
        `BFM_MASTER.set_command_address(addr);    
        `BFM_MASTER.set_command_byte_enable('1,0);
        `BFM_MASTER.set_command_data(0, 0);      

        // Queue the command
        `BFM_MASTER.push_command();
        
        // Wait until the transaction has completed
        while (`BFM_MASTER.get_response_queue_size() != 1)
            @(posedge clk);

        // Dequeue the response and return the data
        `BFM_MASTER.pop_response();
        data = `BFM_MASTER.get_response_data(0);
        $display ( "          addr                read_data   " );
	     $display ("       0x%h                0x%h      ",
                          addr,               data        );        
    end
    endtask

endmodule

   
   
   
   
   
   
   
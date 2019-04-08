   
#================================================================
#*   Date:           2018.11.20
#*   Project:        i2c config tcl edit mark lin 20181120 
#*   Platform:        
#*   Application:     
#*   File Name:      i2c_config.tcl          
#*   Author:         Galaxy_Mark
#*   Email:          mark.lin@macnica.com
#*   Description:    
#*   Version:        1.0.0
#================================================================
#*   Change History:
#*     1.  Version 1.0.0
#*     
#================================================================
   
   # I2C Register 
   variable TFR_CMD          0x0 
   variable RX_DATA          0x1
   variable CTRL             0x2 
   variable ISER             0x3 
   variable ISR              0x4 
   variable STATUS           0x5 
   variable TFR_CMD_FIFO_LVL 0x6 
   variable RX_DATA_FIFO_LVL 0x7 
   variable SCL_LOW          0x8 
   variable SCL_HIGH         0x9 
   variable SDA_HOLD         0xA 
   
   # i2c hdmi_tx
   variable I2C_0_BASE       0x00011040
   # i2c camera
   variable I2C_1_BASE       0x00011000
   # SYS_ID
   variable SYS_ID_BASE      0x00000000
   # PIO
   variable PIO_BASE         0x00000010
   
   set jtag_i2c_config_path [ lindex [ get_service_paths master ] 0 ]
   open_service master $jtag_i2c_config_path
   proc Board_init { } {
      set jtag_i2c_config_path [ lindex [ get_service_paths master ] 0 ]
      open_service master $jtag_i2c_config_path
      variable TFR_CMD          0x0 
      variable RX_DATA          0x1
      variable CTRL             0x2 
      variable ISER             0x3 
      variable ISR              0x4 
      variable STATUS           0x5 
      variable TFR_CMD_FIFO_LVL 0x6 
      variable RX_DATA_FIFO_LVL 0x7 
      variable SCL_LOW          0x8 
      variable SCL_HIGH         0x9 
      variable SDA_HOLD         0xA 
      
      variable I2C_0_BASE       0x00011040
      variable I2C_1_BASE       0x00011000
      variable I2C_0_BASE       0x00011040
   }
   
   proc clr_isr { } {
      global jtag_i2c_config_path
      global I2C_0_BASE
      global I2C_1_BASE
      global ISR
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_0_BASE} + ${ISR}*4 ] 0x07
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_1_BASE} + ${ISR}*4 ] 0x07
   }
  
   proc i2c_write_1byte { i2c_base address offset data} {
      global jtag_i2c_config_path
      global I2C_0_BASE
      global I2C_1_BASE
      global TFR_CMD           
      global CTRL              
      global ISER              
      global ISR               
      global STATUS            
      global TFR_CMD_FIFO_LVL  
      global RX_DATA_FIFO_LVL  
      global SCL_LOW           
      global SCL_HIGH          
      global SDA_HOLD          
       
      set fifo_value [ master_read_32  ${jtag_i2c_config_path} [ expr ${i2c_base} + ${TFR_CMD_FIFO_LVL}*4 ] 1 ]
      while { $fifo_value > 25 } {
         puts "wait fifo is almost full"
         break
      }      
      master_write_32 ${jtag_i2c_config_path} [ expr ${i2c_base} + ${TFR_CMD}*4 ] [expr {$address<<1}]
      master_write_32 ${jtag_i2c_config_path} [ expr ${i2c_base} + ${TFR_CMD}*4 ] [expr {$offset}] 
      master_write_32 ${jtag_i2c_config_path} [ expr ${i2c_base} + ${TFR_CMD}*4 ] [expr {$data|0x100}]
      puts " i2c write address: $address, offset: $offset, data: $data "
   }
   
   
   proc i2c_read_N_byte { address offset num } {
   
      global jtag_i2c_config_path
      global I2C_0_BASE
      global I2C_1_BASE
      global TFR_CMD           
      global CTRL              
      global ISER              
      global ISR               
      global STATUS            
      global TFR_CMD_FIFO_LVL  
      global RX_DATA_FIFO_LVL  
      global SCL_LOW           
      global SCL_HIGH          
      global SDA_HOLD          
      global RX_DATA   
     
      master_write_32 ${jtag_i2c_config_path} [ expr ${I2C_0_BASE} + ${TFR_CMD}*4 ] [expr {$address<<1}]
      master_write_32 ${jtag_i2c_config_path} [ expr ${I2C_0_BASE} + ${TFR_CMD}*4 ] [expr {$offset}] 
      master_write_32 ${jtag_i2c_config_path} [ expr ${I2C_0_BASE} + ${TFR_CMD}*4 ] [expr {($address<<1)|0x201}] 
      
      for {set x 0} {$x < $num - 1 } {incr x } {
         master_write_32 ${jtag_i2c_config_path} [ expr ${I2C_0_BASE} + ${TFR_CMD}*4 ] 0x000
      }
      master_write_32 ${jtag_i2c_config_path} [ expr ${I2C_0_BASE} + ${TFR_CMD}*4 ] [expr {0x100}]
      
      for {set x 0} {$x < $num  } {incr x } {
         set BUF [ master_read_8 $jtag_i2c_config_path [ expr ${I2C_0_BASE} + ${RX_DATA}*4 ] 1 ]  
        puts " i2c read $x byte is :  $BUF "
      }
      
      puts " i2c_read_1byte done"
     
      
   }
   proc i2c_enable { } {
      global jtag_i2c_config_path
      global I2C_0_BASE
      global I2C_1_BASE
      global TFR_CMD           
      global CTRL              
      global ISER              
      global ISR               
      global STATUS            
      global TFR_CMD_FIFO_LVL  
      global RX_DATA_FIFO_LVL  
      global SCL_LOW           
      global SCL_HIGH          
      global SDA_HOLD          

      #config i2c master 0
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_0_BASE} + ${CTRL}*4 ] 0x01	
      
      #config i2c master 1
      
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_1_BASE} + ${CTRL}*4 ] 0x01	
   }   
   proc i2c_disable { } {
      global jtag_i2c_config_path
      global I2C_0_BASE
      global I2C_1_BASE
      global TFR_CMD           
      global CTRL              
      global ISER              
      global ISR               
      global STATUS            
      global TFR_CMD_FIFO_LVL  
      global RX_DATA_FIFO_LVL  
      global SCL_LOW           
      global SCL_HIGH          
      global SDA_HOLD          
      global I2C_0_BASE        
      global I2C_1_BASE 
     # config i2c master 0
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_0_BASE} + ${CTRL}*4 ] 0x00	
      
     # config i2c master 1
     
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_1_BASE} + ${CTRL}*4 ] 0x00	
   }
   proc i2c_init { } {
      global jtag_i2c_config_path
      global I2C_0_BASE
      global I2C_1_BASE
      global TFR_CMD           
      global CTRL              
      global ISER              
      global ISR               
      global STATUS            
      global TFR_CMD_FIFO_LVL  
      global RX_DATA_FIFO_LVL  
      global SCL_LOW           
      global SCL_HIGH          
      global SDA_HOLD          
      global I2C_0_BASE        
      global I2C_1_BASE 
     # config i2c master 0
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_0_BASE} + ${CTRL}*4 ] 0x00	
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_0_BASE} + ${ISER}*4 ] 0x1F	
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_0_BASE} + ${SCL_LOW}*4 ] 0xFA
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_0_BASE} + ${SCL_HIGH}*4 ] 0xF9
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_0_BASE} + ${SDA_HOLD}*4 ] 0x7E
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_0_BASE} + ${CTRL}*4 ] 0x01	
      
     # config i2c master 1
     
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_1_BASE} + ${CTRL}*4 ] 0x00	
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_1_BASE} + ${ISER}*4 ] 0x1F	
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_1_BASE} + ${SCL_LOW}*4 ] 0xFA
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_1_BASE} + ${SCL_HIGH}*4 ] 0xF9
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_1_BASE} + ${SDA_HOLD}*4 ] 0x7E
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_1_BASE} + ${CTRL}*4 ] 0x01

   }
   
   proc read_file { } {  
      set fp [open "input.txt" w+]
      puts $fp "test"
      close $fp
      set fp [open "input.txt" r]
      set file_data [read $fp]
      puts $file_data
      close $fp
   }
   
   proc init_AD9889B {} {
      global jtag_i2c_config_path
      global SYS_ID_BASE
      global I2C_0_BASE
      
      set jtag_i2c_config_path [ lindex [ get_service_paths master ] 0 ]
      open_service master $jtag_i2c_config_path
      
      set SYSID [ master_read_32 $jtag_i2c_config_path [expr ${SYS_ID_BASE}] 1 ]  
      puts "System ID is : $SYSID"
      
      i2c_init
      i2c_disable
      i2c_enable
      set fp [open "input_AD9889B.txt" r]
      set file_data [read $fp]
      # i2c_read_N_byte 0x39 0x42 1
      for {set x 0} {$x < 2*2 } { set x [expr $x+2] } {
      
         set offset_buf [lindex $file_data $x]
         set data_buf [lindex $file_data [expr $x+1 ]  ]
         i2c_write_1byte $I2C_0_BASE 0x39 $offset_buf $data_buf
         after 50
      }
      #close "input_AD9889B.txt"
      close_service master $jtag_i2c_config_path
      puts "AD9889B Config done"

   }
   
   
   proc init_vip_core { } {
      set my_service_path [ lindex [ get_service_paths master ] 1 ]
      open_service master $my_service_path
      # go sig
      master_write_32 $my_service_path 0x0200 0x01
      master_write_32 $my_service_path 0x0000 0x01
      master_write_32 $my_service_path 0x0400 0x01
      
      master_read_32 $my_service_path  0x0204 0x1
      master_read_32 $my_service_path  0x0004 0x1
      master_read_32 $my_service_path  0x0404 0x1
      
      #scaler Output Width
      master_write_32 $my_service_path 0x020C 1920 
      #scaler Output Height
      master_write_32 $my_service_path 0x0210 1080
      
      #ptg Output Width
      master_write_32 $my_service_path 0x000C 1920 
      #ptg Output Height
      master_write_32 $my_service_path 0x0010 1080
      
      
      close_service master $my_service_path
      
   }
   
   
   proc init_AR0134 {} {
      global jtag_i2c_config_path
      global SYS_ID_BASE
      global I2C_1_BASE

      set jtag_i2c_config_path [ lindex [ get_service_paths master ] 0 ]
      open_service master $jtag_i2c_config_path
      
      set SYSID [ master_read_32 $jtag_i2c_config_path [expr ${SYS_ID_BASE}] 1 ]  
      puts "System ID is : $SYSID"
      
      
      i2c_init
      i2c_disable
      i2c_enable
      set fp [open "input_AR0134.txt" r]
      set file_data [read $fp]
      # i2c_read_N_byte 0x39 0x42 1
      for {set x 0} {$x < 205 } { set x [expr $x+2] } {
      
         set offset_buf [lindex $file_data $x]
         set data_buf [lindex $file_data [expr $x+1 ]  ]
         i2c_write_1byte $I2C_1_BASE 0x39 $offset_buf $data_buf
         after 50
      }
      close "input_AR0134.txt"
      close_service master $jtag_i2c_config_path
      puts "AD9889B Config done"
      
   }
   
   proc main { } {

      i2c_init
      init_vip_core
      init_AD9889B

   }
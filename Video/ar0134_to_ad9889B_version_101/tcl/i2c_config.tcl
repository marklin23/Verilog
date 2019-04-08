   
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
   
   # TEST_PATTERN_GEN
   variable TPG_BASE         0x00000000
   # SCALER
   variable SCALER_BASE      0x00000200
   # CVO
   variable CVO_BASE         0x00000400   
   
   
   
   
   
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
   }
   
   proc check_isr { } {
      global jtag_i2c_config_path
      global ISR
      global I2C_0_BASE
      global I2C_1_BASE
      
      set isr_value1 [ master_read_32  ${jtag_i2c_config_path} [ expr ${I2C_0_BASE} + ${TFR_CMD_FIFO_LVL}*4 ] 1 ]
      set isr_value2 [ master_read_32  ${jtag_i2c_config_path} [ expr ${I2C_1_BASE} + ${ISR}*4 ] 1 ]
      if { isr_value1 != 0 } {
         puts "I2C Master1 : $i2c_base  Error (  ADDR_NACK.  RX_OVER. ARBIT_STOP. )"
      }
      if { isr_value2 != 0 } {
         puts "I2C Master2 : $i2c_base  Error (  ADDR_NACK.  RX_OVER. ARBIT_STOP. )"
      }
      
   }
   proc clr_isr { } {
      global jtag_i2c_config_path
      global I2C_0_BASE
      global I2C_1_BASE
      global ISR
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_0_BASE} + ${ISR}*4 ] 0x07
      master_write_32 $jtag_i2c_config_path [ expr ${I2C_1_BASE} + ${ISR}*4 ] 0x07
   }
   proc i2c_write_2byte { i2c_base address offset1 offset2 data1 data2 } {
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
      
      while { $fifo_value > 23 } {
         puts "wait! fifo is almost full"
         break
      }      
      
      master_write_32 ${jtag_i2c_config_path} [ expr ${i2c_base} + ${TFR_CMD}*4 ] [expr {$address<<1}]
      
      #check_isr
      
      
      master_write_32 ${jtag_i2c_config_path} [ expr ${i2c_base} + ${TFR_CMD}*4 ] [expr {$offset1}] 
      master_write_32 ${jtag_i2c_config_path} [ expr ${i2c_base} + ${TFR_CMD}*4 ] [expr {$offset2}] 
      master_write_32 ${jtag_i2c_config_path} [ expr ${i2c_base} + ${TFR_CMD}*4 ] [expr {$data1}]
      master_write_32 ${jtag_i2c_config_path} [ expr ${i2c_base} + ${TFR_CMD}*4 ] [expr {$data2|0x100}]
      
      puts " i2c write address: $address, offset: $offset1 , $offset2, data: $data1 , $data2 "
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
      
      #check_isr
      
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
   
   proc i2c_read_N_2byte { i2c_base address offset1 offset2 num } {
   
      global jtag_i2c_config_path
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
     
      master_write_32 ${jtag_i2c_config_path} [ expr ${i2c_base} + ${TFR_CMD}*4 ] [expr {$address<<1}]
      master_write_32 ${jtag_i2c_config_path} [ expr ${i2c_base} + ${TFR_CMD}*4 ] [expr {$offset1}] 
      master_write_32 ${jtag_i2c_config_path} [ expr ${i2c_base} + ${TFR_CMD}*4 ] [expr {$offset2}] 
      master_write_32 ${jtag_i2c_config_path} [ expr ${i2c_base} + ${TFR_CMD}*4 ] [expr {($address<<1)|0x201}] 
      
      for {set x 0} {$x < $num*2 - 1 } {incr x } {
         master_write_32 ${jtag_i2c_config_path} [ expr ${i2c_base} + ${TFR_CMD}*4 ] 0x000
      }
      master_write_32 ${jtag_i2c_config_path} [ expr ${i2c_base} + ${TFR_CMD}*4 ] [expr {0x100}]
      
      for {set x 0} {$x < $num*2  } {incr x } {
         set BUF [ master_read_8 $jtag_i2c_config_path [ expr ${i2c_base} + ${RX_DATA}*4 ] 1 ]  
        puts " i2c read $x byte is :  $BUF "
      }
      
      puts " i2c_read_2byte done"
     
      
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
   
   proc init_whole_AD9889B {} {
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
      set fp [open "input_whole_AD9889B.txt" r]
      set file_data [read $fp]
      # i2c_read_N_byte 0x39 0x42 1
      for {set x 0} {$x < 205*2 } { set x [expr $x+2] } {
      
         set offset_buf [lindex $file_data $x]
         set data_buf [lindex $file_data [expr $x+1 ]  ]
         i2c_write_1byte $I2C_0_BASE 0x39 $offset_buf $data_buf
         after 50
      }
      #close "input_AD9889B.txt"
      close_service master $jtag_i2c_config_path
      puts "AD9889B whole Config done"

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

   proc init_vip_core { } {
      global TPG_BASE         
      global SCALER_BASE      
      global CVO_BASE          
      set my_service_path [ lindex [ get_service_paths master ] 1 ]
      open_service master $my_service_path
      # go sig
      master_write_32 $my_service_path $TPG_BASE 0x01
      master_write_32 $my_service_path $SCALER_BASE 0x01
      master_write_32 $my_service_path $CVO_BASE 0x01
      
      master_read_32 $my_service_path  [ expr ${TPG_BASE} + 4 ] 0x1
      master_read_32 $my_service_path  [ expr ${SCALER_BASE} + 4 ] 0x1
      master_read_32 $my_service_path  [ expr ${CVO_BASE} + 4 ] 0x1
      
      #scaler Output Width
      master_write_32 $my_service_path [ expr ${SCALER_BASE} + 12 ] 1920 
      #scaler Output Height
      master_write_32 $my_service_path [ expr ${SCALER_BASE} + 16 ] 1080
      
      #ptg Output Width
      master_write_32 $my_service_path [ expr ${TPG_BASE} + 12 ] 1920 
      #ptg Output Height
      master_write_32 $my_service_path [ expr ${TPG_BASE} + 16 ] 1080
      
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
      for {set x 0} {$x < 162*4 } { set x [expr $x+4] } {
      
         set offset_buf1 [lindex $file_data $x]
         set offset_buf2 [lindex $file_data [expr $x+1 ]  ]
         set data_buf1 [lindex $file_data [expr $x+2 ]  ]
         set data_buf2 [lindex $file_data [expr $x+3 ]  ]
         
         i2c_write_2byte $I2C_1_BASE 0x10 $offset_buf1 $offset_buf2 $data_buf1 $data_buf2
         after 50
      }
      close_service master $jtag_i2c_config_path
      puts "AR0134 Config done"
      
   }
	
   proc main { } {

      i2c_init
      #init_vip_core
      
      init_AR0134
      init_AD9889B
      #set ar0134 window
      AR0134_WINDOW_X_Y 0x00 0x00 0x00 0x00 0x02 0xD1 0x05 0x01
      pattern_select 5
      reset
      #  ar0134 select test pattern
      #  AR0134_Pattern_test

   }
   
   proc AR0134_Pattern_test { } {
      global jtag_i2c_config_path
      global SYS_ID_BASE
      global I2C_1_BASE
	#-----------------------------------------------------------  
	# 0x3070  
	#-----------------------------------------------------------
	#0: Normal operation: Generate output data from pixel array
	#1: Solid color test pattern.
	#2: 100% color bar test pattern
	#3: Fade to gray color bar test pattern
	#256 : Walking 1s test pattern (12 bit)
	#-----------------------------------------------------------
	
	#-----------------------------------------------------------  
	# 0x3072 test_data_red
	#-----------------------------------------------------------
	# 0x3074 test_data_greenr
	#-----------------------------------------------------------
	# 0x3076 test_data_blue
	#-----------------------------------------------------------
	# 0x3078 est_data_greenb
	#-----------------------------------------------------------
	# 0x3070
     i2c_write_2byte $I2C_1_BASE 0x10 0x30 0x70 0x00 0x01  
	# 0x3072 test_data_red
	  i2c_write_2byte $I2C_1_BASE 0x10 0x30 0x72 0x01 0x00 
    # 0x3076 test_data_blue
	  i2c_write_2byte $I2C_1_BASE 0x10 0x30 0x76 0x01 0x10
    # 0x3076 test_data_color_bar
	  i2c_write_2byte $I2C_1_BASE 0x10 0x30 0x70 0x00 0x03 
   }
   
   proc AR0134_WINDOW_X_Y { Y_ADDR_START1 Y_ADDR_START2 X_ADDR_START1 X_ADDR_START2 Y_ADDR_END1 Y_ADDR_END2 X_ADDR_END1  X_ADDR_END2} {
      global jtag_i2c_config_path
      global SYS_ID_BASE
      global I2C_1_BASE
	#-----------------------------------------------------------  
	# 0x3070  
	#-----------------------------------------------------------
   # 0x30 0x02 0x00 0x00
   # 0x30 0x04 0x00 0x00
   # 0x30 0x06 0x02 0xD1
   # 0x30 0x08 0x05 0x01 
   
   # AR0134_WINDOW_X_Y 0x00 0x00 0x00 0x00 0x02 0xD1 0x05 0x01
   #{0x3002, 0x0078}, 	// Y_ADDR_START - 0x0078=120
   #{0x3004, 0x0004}, 	// X_ADDR_START - 0x0000=0
   #{0x3006, 0x0348}, 	// Y_ADDR_END - 0x0347=839
   #{0x3008, 0x0503}, 	// X_ADDR_END - 0x04FF=1280
   #-----------------------------------------------------------
     i2c_write_2byte $I2C_1_BASE 0x10 0x30 0x02 $Y_ADDR_START1 $Y_ADDR_START2
     i2c_write_2byte $I2C_1_BASE 0x10 0x30 0x04 $X_ADDR_START1 $X_ADDR_START2
     i2c_write_2byte $I2C_1_BASE 0x10 0x30 0x06 $Y_ADDR_END1 $Y_ADDR_END2
     i2c_write_2byte $I2C_1_BASE 0x10 0x30 0x08 $X_ADDR_END1 $X_ADDR_END2

   }
   proc AR0134_MIRRORING { Column_Rev Row_Rev } {
      global jtag_i2c_config_path
      global SYS_ID_BASE
      global I2C_1_BASE
	#-----------------------------------------------------------  
	# Column_Mirror  0x3040[14]==1
	# Row_Mirror     0x3040[15]==1
	#-----------------------------------------------------------

         i2c_write_2byte $I2C_1_BASE 0x10 0x30 0x40 [expr {($Column_Rev<<6)|($Row_Rev<<7)|0x00}] 0x00

   }
   

   
   proc reset {  } {
      global jtag_i2c_config_path
      global PIO_BASE
      master_write_32 ${jtag_i2c_config_path} $PIO_BASE  0x305
      master_write_32 ${jtag_i2c_config_path} $PIO_BASE  0x005
   }
   
   proc pattern_select { NUM } {
      global jtag_i2c_config_path
      global PIO_BASE
      master_write_32 ${jtag_i2c_config_path} $PIO_BASE $NUM
      master_write_32 ${jtag_i2c_config_path} $PIO_BASE $NUM
   }

   proc EDID {} {
      global jtag_i2c_config_path
      global SYS_ID_BASE
      global I2C_0_BASE
      
      set jtag_i2c_config_path [ lindex [ get_service_paths master ] 0 ]
      open_service master $jtag_i2c_config_path
      
      i2c_init
      i2c_disable
      i2c_enable
	  
	  #check 0x42 bit 6 is 1
	  i2c_read_N_byte 0x39 0x41 1
	  
     i2c_write_1byte $I2C_0_BASE 0x39 0x30 0x70   
	  i2c_write_1byte $I2C_0_BASE 0x39 0x30 0x72  
	  i2c_write_1byte $I2C_0_BASE 0x39 0x30 0x76 
	  
	  
	  
    
    #close "input_AD9889B.txt"
      close_service master $jtag_i2c_config_path
      puts "AD9889B EDID Read Done"

   }
   
   # ar0134 Y total: frame_length_lines
   # i2c_write_2byte $I2C_1_BASE 0x10 0x30 0x0A 0x02 0xEE
   
   # ar0134 X total: line_length_pck
   # i2c_write_2byte $I2C_1_BASE 0x10 0x30 0x0C 0x06 0x70 
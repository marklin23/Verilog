
#important page : 31
#page31 DE and Hsync/Vsync Generation and Adjustment Common Settings




#1. check 0x42 bit 6 is 1
 i2c_read_N_byte 0x39 0x42 1

 
 
#2. Power-up the Tx (HPD must be high)
#   0x41[6] = 0b0 for power-up – 0b1 for power-down
i2c_write_1byte $I2C_0_BASE 0x39 0x41 0x00

#TMDS Power-Down Related Registers (Main Register Map)
i2c_write_1byte $I2C_0_BASE 0x39 0xA1 0x00

 
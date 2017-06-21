#include <stdio.h>
//#include <stdlib.h>
//#include <string.h>
#include "system.h"
#include <io.h>
#define TFR_CMD 0x0 //Transfer command FIFO
#define CTRL 0x2 //Control register
#define ISER 0x3 //Interrupt status enable register
#define ISR 0x4 //Interrupt status register
#define STATUS 0x5 //Status register
#define TFR_CMD_FIFO_LVL 0x6 //TFR_CMD FIFO level register
#define RX_DATA_FIFO_LVL 0x7 //RX_DATA FIFO level register
#define SCL_LOW 0x8 //SCL low count register
#define SCL_HIGH 0x9 //SCL high count register
#define SDA_HOLD 0xA //SDA hold count register


//==============================================
//i2C
//==============================================

void i2c_init(){
	IOWR(I2C_0_BASE,CTRL,0x00);		// Disable Altera Avalon I2C (Master)core through CTRL register
	IOWR(I2C_0_BASE,ISER,0x1F);		// Enable All Interrupt Status Enable Register
	IOWR(I2C_0_BASE,SCL_LOW,0xFA);	// SCL Low  Count (SCL LOW)
	IOWR(I2C_0_BASE,SCL_HIGH,0xF9);	// SCL High Count (SCL HIGH)
	IOWR(I2C_0_BASE,SDA_HOLD,0x7E);	// SDA Hold Count (SDA HOLD)
	IOWR(I2C_0_BASE,CTRL,0x01);		// EANBLE Altera Avalon I2C (Master)core through CTRL register
	printf("I2c Core is enabled\n");
}
void i2c_status(){
	int value;
	read_message(I2C_0_BASE,ISR);
	delay(100000);
	value =	IORD(I2C_0_BASE,ISR);
	delay(100000);
	while((value & 0x01)!=0x01){
		value =	IORD(I2C_0_BASE,ISR);
		printf("ISR is 0x%x\n",value);
	}
	printf("ISR Status is : 0x%x\n",value);
	printf("STATUS is");
	read_message(I2C_0_BASE,STATUS);
	printf("SCL_LOW is");
	read_message(I2C_0_BASE,SCL_LOW);
	printf("SCL_HIGH is");
	read_message(I2C_0_BASE,SCL_HIGH);
	printf("SDA_HOLD is");
	read_message(I2C_0_BASE,SDA_HOLD);
	printf("TFR_CMD_FIFO_LVL is");
	read_message(I2C_0_BASE,TFR_CMD_FIFO_LVL);
	printf("RX_DATA_FIFO_LVL is");
	read_message(I2C_0_BASE,RX_DATA_FIFO_LVL);
	printf("ISR is");
	read_message(I2C_0_BASE,ISR);
	printf("TFR_CMD is");
	read_message(I2C_0_BASE,TFR_CMD);
	printf("CTRL is");
	read_message(I2C_0_BASE,CTRL);
}
void i2c_write_1byte(int slave_addr,int offset, int write_data){

	IOWR(I2C_0_BASE,TFR_CMD,slave_addr<<1); // Slave Address left shift 1 stage + 1'b0
	check_isr();
	IOWR(I2C_0_BASE,TFR_CMD,offset);
	check_isr();
	IOWR(I2C_0_BASE,TFR_CMD,write_data|0x100);
	check_isr();
	printf("i2c_write_1byte done");
}
void i2c_read_2byte(int slave_addr,int offset){

	IOWR(I2C_0_BASE,TFR_CMD,slave_addr<<1); // Slave Address left shift 1 stage + 1'b0
	check_isr();
	IOWR(I2C_0_BASE,TFR_CMD,offset);
	check_isr();
	IOWR(I2C_0_BASE,TFR_CMD,(slave_addr<<1)|0x201); // SRsig + Slave Address left shift 1 stage + 1'b1
	check_isr();
	IOWR(I2C_0_BASE,TFR_CMD,0x000); // Slave Address left shift 1 stage + 1'b1
	check_isr();
	IOWR(I2C_0_BASE,TFR_CMD,0x100);
	check_isr();
	printf("i2c_read_2byte done");

}
void clr_isr(){

	IOWR(I2C_0_BASE,ISR,0x07);

}
//==============================================
//==============================================


void led_test(int value){

	IOWR(PIO_BASE,0,value);

}
void delay(int value){
	int cnt;
	while(cnt<value){
		cnt++;
	}

}
void led_blink(){
	int counter = 0;
	while(counter<100){

		delay(100000);
		counter++;
		IOWR(PIO_BASE,0,counter);
		printf("counter = %d \n",counter);
	}
}
void check_isr(){

	int value = 0x00;
	value = IORD(I2C_0_BASE,ISR);
	while((value & 0x01)!=0x01){
		value =	IORD(I2C_0_BASE,ISR);
		printf("ISR is 0x%x\n",value);
	}
}
void read_message(int BASE,int offset){
	int value = IORD(BASE,offset);
	printf("ADDRESS-> 0x%x, Data-> 0x%x\n",offset,value);

}

//==============================================
//==============================================

int main(){
//=======================================
//spi test
//=======================================

//=======================================
//i2c test
//=======================================
		led_blink();
		i2c_init();
		i2c_status();
		//i2c_write_1byte(0x31,0x02,0x31);
		//i2c_write_1byte(0x55,0x10,0x05);
		//i2c_write_1byte(0x55,0x00,0xA5);
		//i2c_read_2byte(0x55,0x10);

		return 0;
}


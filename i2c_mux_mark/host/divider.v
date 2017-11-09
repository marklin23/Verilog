/* divider	#(
			.Clock_IN_Frequency(25000000), //Mhz
			.Clock_OUT1_Frequency(1000000), //Mhz
			.Clock_OUT2_Frequency(10000000), //Mhz
			.Clock_OUT3_Frequency(4),  //Mhz
			.CNT1_WIDTH(5),
			.CNT2_WIDTH(5),
			.CNT3_WIDTH(32)
			)	divider_clk(
						.CLK_IN(CPLD_25M_CLK),
						.RST_N(internal_rstn),
						.CLKOUT_1(clk_5mhz),//5mhz
						.CLKOUT_2(),//4hz
						.CLKOUT_3(clk_4hz)
					); */




`define div_number_1 (Clock_IN_Frequency/Clock_OUT1_Frequency)/2
`define div_number_2 (Clock_IN_Frequency/Clock_OUT2_Frequency)/2
`define div_number_3 (Clock_IN_Frequency/Clock_OUT3_Frequency)/2
//parameter clki_freq = 25000000;// xHZ
//parameter clko_freq = 1; // xHZ
//cnt = (clki_freq/clko_freq)*2
module divider #(

    parameter Clock_IN_Frequency = 5'd25,
    parameter Clock_OUT1_Frequency = 5'd1,
	parameter Clock_OUT2_Frequency = 5'd10,
	parameter Clock_OUT3_Frequency = 5'd10,
	parameter CNT1_WIDTH = 'd32,
	parameter CNT2_WIDTH = 'd32,
	parameter CNT3_WIDTH = 'd32
	)(
				RST_N,
				CLK_IN,
				CLKOUT_1,
				CLKOUT_2,
				CLKOUT_3,
				cnt_1,
				cnt_2,
				cnt_3
				
				);

input CLK_IN;//25Mz
input RST_N;
output CLKOUT_1;//6.25MHz  == 5Mhz
output CLKOUT_2;//4hz
output CLKOUT_3;
reg CLKOUT_1;
reg CLKOUT_2;
reg CLKOUT_3;
/* parameter div_number_1 = 3'd1;
parameter div_number_2 = 24'd3125000;
parameter div_number_3 = 24'd100; */

output	reg [CNT1_WIDTH-1:0]	cnt_1;	
output	reg [CNT2_WIDTH-1:0]	cnt_2;
output	reg [CNT3_WIDTH-1:0]	cnt_3;

//--------------------------------------------------------------------------------------------
//CLKOUT_1
//--------------------------------------------------------------------------------------------
always@(posedge CLK_IN or negedge RST_N )
	if (RST_N == 1'b0)
		cnt_1 <= 0;
	else if (cnt_1 == `div_number_1-1)
		cnt_1 <= 0;
	else
		cnt_1 <= cnt_1 + 1'b1;

always@(posedge CLK_IN or negedge RST_N )	
	if (RST_N == 1'b0)
		CLKOUT_1 <= 0;
	else if (cnt_1 == `div_number_1-1)
		CLKOUT_1 <= ~CLKOUT_1;
	
//--------------------------------------------------------------------------------------------
//CLKOUT_2
//--------------------------------------------------------------------------------------------
always@(posedge CLK_IN or negedge RST_N )
	if (RST_N == 1'b0)
		cnt_2 <= 1'b0;
	else if (cnt_2 == `div_number_2-1)
		cnt_2 <= 0;
	else
		cnt_2 <= cnt_2 + 1'b1;

always@(posedge CLK_IN or negedge RST_N )	
	if (RST_N == 1'b0)
		CLKOUT_2 <= 1'b0;
	else if (cnt_2 == `div_number_2-1 )
		CLKOUT_2 <= ~CLKOUT_2;
//--------------------------------------------------------------------------------------------
//CLKOUT_3
//--------------------------------------------------------------------------------------------

always@(posedge CLK_IN or negedge RST_N )
	if (RST_N == 1'b0)
		cnt_3 <= 1'b0;
	else if (cnt_3 == `div_number_3-1)
		cnt_3 <= 0;
	else
		cnt_3 <= cnt_3 + 1'b1;

always@(posedge CLK_IN or negedge RST_N )	
	if (RST_N == 1'b0)
		CLKOUT_3 <= 1'b0;
	else if (cnt_3 == `div_number_3-1 )
		CLKOUT_3 <= ~CLKOUT_3;
		
endmodule
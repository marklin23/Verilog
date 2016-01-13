module i2c_mark_rw(
input   RESETn, SYSTEM_CLK,
input   SCL,
inout   SDA
);

parameter slave_addr = 7'b010_0011;
reg [7:0] read_data = 7'b0101_0011;

reg [3:0]CS;
reg [3:0]NS;
//counter
reg [4:0]bitcnt;
reg [4:0]bitcnt_o;

//data bus
reg [7:0]data_recived;
reg  RW ;
reg [6:0]device_addr_o;
reg [7:0]register_addr_o;
reg [7:0]data_o;
reg sda_o;

//pipe dectect 
reg [1:0] sda_pipe ;
reg [1:0] scl_pipe ;

//reg [7:0] sda_data;
parameter idle				=4'b0000;
parameter device_addr		=4'b0010;
parameter device_addr_ack	=4'b0011;
parameter register_addr		=4'b0100;
parameter register_addr_ack	=4'b0101;
parameter data_write		=4'b0110;
parameter data_write_ack	=4'b0111;
parameter data_read			=4'b1000;
parameter data_read_ack		=4'b1001;
parameter stop				=4'b1010;




assign SDA         = sda_o;

always @(posedge SYSTEM_CLK)
	begin
	if (!RESETn)
		bitcnt_o <= 5'd8;
	else if(scl_pipe==2'b01)
		begin
			if(bitcnt_o == 5'd0)
				bitcnt_o <= 5'd8;
			else 
				begin
					bitcnt_o <= bitcnt_o-5'd1;
					data_recived <= {data_recived[6:0],SDA};
				end
		end
	else if((sda_pipe==2'b01 && scl_pipe==2'b11)|| (sda_pipe==2'b10 && scl_pipe==2'b11) )
		bitcnt_o <= 5'd8;
	end
		
	
//creat pipe
always @(posedge SYSTEM_CLK)
	begin
		sda_pipe<={sda_pipe[0],SDA};
		scl_pipe<={scl_pipe[0],SCL};
	end
	
//state machine
always @(posedge SYSTEM_CLK)
    begin
		CS <= (!RESETn)? idle : NS ;
    end	

always @(*)
	begin
		 bitcnt <= bitcnt_o;
		case(CS)
		idle: //00
					begin
						NS 					<= (sda_pipe==2'b10 && scl_pipe==2'b11) ? device_addr : idle ; //START 
						device_addr_o		<= 7'dx;
						register_addr_o		<= 8'dx;
						data_o   			<= 8'dx;
						sda_o				<= 1'bz;
						data_recived		<= 8'bx;
						bitcnt				<= 5'd8;
						RW 					<= 1'bx;
						
					end
		device_addr: //10
					begin

						RW 					<= ((bitcnt == 0) && scl_pipe==2'b10 ) ? data_recived[0] : RW ;
						device_addr_o		<= ((bitcnt == 0&& scl_pipe==2'b10 )) ? data_recived[7:1] : device_addr_o ;
						NS					<= (bitcnt == 0 && scl_pipe==2'b10) ? device_addr_ack : device_addr ;
						
					end
		device_addr_ack: //11
					begin
						NS 					<= (device_addr_o == slave_addr)?
												((bitcnt == 8 && scl_pipe==2'b10 )?(RW ? data_read:register_addr):device_addr_ack)
												:idle;
						sda_o				<= (device_addr_o == slave_addr)?((bitcnt == 8 && scl_pipe==2'b10 )?1'bz:1'b0):1'bz ;
					end
		register_addr: //100
					begin
						register_addr_o		<= ((bitcnt == 0)&& scl_pipe==2'b10 ) ? data_recived[6:0] : register_addr_o ;
						NS					<= (bitcnt == 0 && scl_pipe==2'b10 ) ? register_addr_ack : register_addr ;
					end
		register_addr_ack: //101
					begin

						sda_o				<= (device_addr_o == slave_addr)?((bitcnt == 8 && scl_pipe==2'b10 )?1'bz:1'b0):1'bz ;
						NS					<= (device_addr_o == slave_addr)?((bitcnt == 8 && scl_pipe==2'b10 )? data_write:register_addr_ack):idle;
					end
		data_write: //110
					begin
						data_o				<= RW ? 1'bz : (((bitcnt == 0)&& scl_pipe==2'b10 ) ? data_recived[7:0]: data_o) ;
						//If start condition comes:(Repeat Start)==>Next State change to device_addr 
						if (sda_pipe==2'b10 && scl_pipe==2'b11) 
							begin
							NS					<= device_addr;
							bitcnt				<= 5'd8;
							end
						else
							NS					<= (bitcnt == 0 && scl_pipe==2'b10 ) ? data_write_ack : data_write ;
					end
		data_write_ack: //111
					begin

						NS					<= ((bitcnt == 8)&& scl_pipe==2'b10 ) ? stop : data_write_ack ;
						sda_o				<= (device_addr_o == slave_addr)?((bitcnt == 0 && scl_pipe==2'b10 )?1'bz:1'b0):1'bz ;
					end
		data_read: //1000
					begin
						sda_o				<= (scl_pipe==2'b00)&&(bitcnt>=5'b1)? read_data[bitcnt-1]:sda_o;
						NS					<= (bitcnt == 0 && scl_pipe==2'b10 ) ? data_read_ack : data_read ;
					end
		data_read_ack: //1001
					begin
						NS					<= ((bitcnt == 8)&& scl_pipe==2'b10 ) ? stop : data_read_ack ;
						sda_o				<= (device_addr_o == slave_addr)?1'bz:((bitcnt == 0 && scl_pipe==2'b10 )?1'bz:1'b0) ;
					end
		stop: //1010
					begin
						NS					<= (sda_pipe==2'b01 && scl_pipe==2'b11) ? idle : stop ;
						sda_o				<= 1'bz;
						bitcnt				<= 5'd8;
					end
		
		default:
					begin
						device_addr_o		<= 7'dx;
						register_addr_o		<= 8'dx;
						data_o   			<= 8'dx;
						sda_o				<= 1'bz;
						data_recived		<= 8'bx;
						RW 					<= 1'bx;
						bitcnt				<= 5'd8;
					end
		endcase		
	end	
endmodule

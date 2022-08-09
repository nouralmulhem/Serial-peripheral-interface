module Slave(
        reset,
	slaveDataToSend, slaveDataReceived,
	SCLK, CS, MOSI, MISO
);
input SCLK; 
input reset; 
input MOSI;
input CS; 
input [7:0] slaveDataToSend; 
output reg [7:0] slaveDataReceived;  
output reg MISO;
integer count;
reg [7:0] next_slaveDataToSend; //the shifted data

always @(CS) begin
	count = 0;
end

always @ (posedge CS)begin 
	MISO <= 1'bz;
	count = 'bz; 
end

always @(negedge SCLK)begin
	if(!CS) MISO<=slaveDataReceived[0];
end

always @ (posedge SCLK) begin

	if(reset) begin
		next_slaveDataToSend =0;
		count = 0;
	end
	else if(CS==0)begin
		if(count==0)  begin
			next_slaveDataToSend = slaveDataToSend;
			count = count +1;
		end
		else if(count<=8)begin
			next_slaveDataToSend = {MOSI,slaveDataReceived[7:1]};
			count = count +1;
		end
		
	end
	slaveDataReceived <= next_slaveDataToSend;


end

endmodule

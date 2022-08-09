module Slave_tb();

reg SCLK; 
reg reset;  
reg [7:0] slaveDataToSend[0:1]; 
wire [7:0] slaveDataReceived[0:1];  
reg [0:1]CS; 
wire MISO; 
reg MOSI;
reg [7:0] Master;
localparam PERIOD = 20;
integer index, failures;
integer i; 
reg [7:0]test;
Slave u (  reset,slaveDataToSend[0], slaveDataReceived[0],SCLK, CS[0], MOSI, MISO);
Slave u2 (  reset,slaveDataToSend[1], slaveDataReceived[1],SCLK, CS[1], MOSI, MISO);

wire [7:0] vector [0:1];
assign test =0;
assign vector[0] = 8'b00001001;
assign vector[1] = 8'b00100101;

initial begin
	index = 0;
	failures = 0;
	SCLK = 0;
    reset = 1; 
	Master = 8'b00101011;
	slaveDataToSend[0] = 0;
	slaveDataToSend[1] = 0;
	#PERIOD reset = 0;
	
	for(CS = 1; CS <= 2; CS=CS+1) slaveDataToSend[CS-1] = vector[CS-1];
		
	for(CS = 1; CS <= 2; CS=CS+1) begin
		#PERIOD
		for(i=0;i<8;i=i+1) begin
			MOSI = Master[i];
			#PERIOD
			test[i] = MISO;
		end
		if(slaveDataReceived[CS-1] == Master) $display("From to Master Slave %d: Success", CS-1);
		else begin
			$display("From Master to Slave %d: Failure (Expected: %b, Received: %b)", CS, Master, slaveDataReceived[CS-1]);
			failures = failures + 1;
		end
		if(test == slaveDataToSend[CS-1]) $display("From Slave %d to Master: Success", CS-1);
		else begin
			$display("From Slave %d to Master: Failure (Expected: %b, Received: %b)", CS, slaveDataToSend[CS-1], test);
			failures = failures + 1;
		end
	end
	
if(failures) $display("FAILURE: %d testcases have failed", failures);
else $display("SUCCESS: All testcases have been successful");
$finish;
end
always #(PERIOD/2) SCLK = ~SCLK;
endmodule

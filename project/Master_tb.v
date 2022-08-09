module Master_tb();

reg clk; 
reg reset; 
reg start; 
reg [1:0] slaveSelect; 
reg [7:0] masterDataToSend; 
wire [7:0] masterDataReceived;
wire SCLK;    
wire [0:2] CS; 
wire MOSI; 
reg MISO;
localparam PERIOD = 20;
integer index, failures;
integer i; 
reg [7:0]test;

Master u (clk,reset,start,slaveSelect,masterDataToSend,masterDataReceived,SCLK,CS,MOSI,MISO);

wire [7:0] vector [0:1];
assign test =0;
assign vector[0] = 8'b00001001;
assign vector[1] = 8'b00100101;

initial begin
	index = 0;
	failures = 0;
	clk = 0;
    reset = 1; 
	masterDataToSend = 8'b00101011;
	#PERIOD reset = 0;
		
	for(slaveSelect = 0; slaveSelect <= 1; slaveSelect=slaveSelect+1) begin
		start =1;
		#PERIOD
		start=0;
		for(i=0;i<8;i=i+1) begin
			MISO = vector[slaveSelect][i];
			#PERIOD
			test[i] = MOSI;
		end
		if(masterDataReceived == vector[slaveSelect]) $display("From Slave %d to Master: Success", slaveSelect);
		else begin
			$display("From Slave %d to Master: Failure (Expected: %b, Received: %b)", slaveSelect+1, vector[slaveSelect], masterDataReceived);
			failures = failures + 1;
		end
		if(test == masterDataToSend) $display("From Master to Slave %d: Success", slaveSelect);
		else begin
			$display("From Master to Slave %d: Failure (Expected: %b, Received: %b)", slaveSelect+1, masterDataToSend, test);
			failures = failures + 1;
		end
	end
	
if(failures) $display("FAILURE: %d testcases have failed", failures);
else $display("SUCCESS: All testcases have been successful");
$finish;
end
always #(PERIOD/2) clk = ~clk;

endmodule 

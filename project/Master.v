 module Master(
	clk, reset, start, slaveSelect, 
	masterDataToSend, masterDataReceived,
	SCLK, CS, MOSI, MISO
);
input clk; 
input reset; 
input start; 
input [1:0] slaveSelect; 
input [7:0] masterDataToSend; 
output reg [7:0] masterDataReceived;
output SCLK;    
output reg [0:2] CS; 
output reg MOSI;  
input MISO;
reg [7:0] next;
assign SCLK = clk;
integer count;

always @ (negedge clk)begin
	if(CS) MOSI <= masterDataReceived[0];
end

always @(posedge start) begin
	if(count >8 )count =0;
	case(slaveSelect)
		0: CS = 3'b011;
		1: CS = 3'b101;
		2: CS = 3'b110;
	endcase
end

always @ (posedge clk) begin
	if(count>=8) CS =3'b111;

end

always @ (posedge clk) begin

	if(reset) begin
		next =0;
		count =0;
	end
	else if(count ==0) begin
		next=masterDataToSend;
		count = count +1;
	end
	else if(count <=8)begin
		next = {MISO,masterDataReceived[7:1]};
		count = count +1;
	end
masterDataReceived<=next;
end
endmodule

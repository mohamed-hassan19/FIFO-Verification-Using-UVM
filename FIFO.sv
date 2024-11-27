////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

input [FIFO_WIDTH-1:0] data_in;
input clk, rst_n, wr_en, rd_en;
output reg [FIFO_WIDTH-1:0] data_out;
output reg wr_ack, overflow, underflow;
output full, empty, almostfull, almostempty;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
		wr_ack   <= 0; //reset the value of wr_ack flag
		overflow <= 0; //reset the value of overflow flag

	end
	else if (wr_en && count < FIFO_DEPTH)  begin
		mem[wr_ptr] <= data_in;
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		wr_ack <= 0; 
	end

	if (full && wr_en && rst_n)
		overflow <= 1;
	else
		overflow <= 0;
	
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;
		underflow <= 0; //reset the underflow flag

	end
	else if ( rd_en && count != 0 ) begin
		data_out <= mem[rd_ptr];                                                       
		rd_ptr <= rd_ptr + 1;
	end

	if (rd_en && empty && rst_n) begin  // adding the underflow signal into this block because it's sequential not combinational as it was made.
		underflow <= 1;
	end
	else begin
		underflow <= 0;
	end 
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if	( ( ({wr_en, rd_en} == 2'b10) && (!full) ) || (wr_en && rd_en && empty) ) 
			count <= count + 1;
		else if ( ( ({wr_en, rd_en} == 2'b01) && (!empty) ) || (wr_en && rd_en && full) )
			count <= count - 1;
	end
end

assign full        = (count == FIFO_DEPTH)? 1 : 0;
assign empty       = (count == 0)? 1 : 0;
assign almostfull  = (count == FIFO_DEPTH-1)? 1 : 0;  // modify the condition of setting "almostfull" signal from (count == FIFO_DEPTH-2) to (count == FIFO_DEPTH-1) 
assign almostempty = (count == 1)? 1 : 0;

endmodule
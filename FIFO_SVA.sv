module FIFO_SVA(data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out, wr_ptr, rd_ptr, count);

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

input logic [FIFO_WIDTH-1:0] data_in;
input logic clk, rst_n, wr_en, rd_en;

input logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
input logic [max_fifo_addr:0] count;

input logic [FIFO_WIDTH-1:0] data_out;
input logic wr_ack, overflow, underflow;
input logic full, empty, almostfull, almostempty;

always_comb begin

	if(!rst_n) begin
		reset_assert: assert final(rd_ptr == 0 && wr_ptr == 0 && count == 0 && wr_ack == 0 && overflow == 0 && underflow == 0
			          && full == 0 && empty == 1 &&  almostfull == 0 && almostempty == 0);
		cover (rd_ptr == 0 && wr_ptr == 0 && count == 0 && wr_ack == 0 && overflow == 0 && underflow == 0
			          && full == 0 && empty == 1 &&  almostfull == 0 && almostempty == 0);
	end

end

property pr1;
	@(posedge clk) disable iff (!rst_n) ( ( ({wr_en, rd_en} == 2'b10 ) && (!full) ) || (wr_en && rd_en && empty) ) |=>
	(count == ( $past(count) + 1 ) );
endproperty

property pr2;
	@(posedge clk) disable iff (!rst_n) ( ( ({wr_en, rd_en} == 2'b01) && (!empty) ) || (wr_en && rd_en && full) ) |=> 
	(count == ( $past(count) - 1 ) );
endproperty

property pr3;
	@(posedge clk) disable iff (!rst_n) (rd_en && empty) |=> (underflow == 1);
endproperty

property pr4;
	@(posedge clk) disable iff (!rst_n) (full & wr_en)   |=> (overflow == 1);
endproperty

property pr5;
	@(posedge clk) disable iff (!rst_n) (wr_en && count < FIFO_DEPTH) |=> (wr_ack == 1);
endproperty

property pr6;
	@(posedge clk) disable iff (!rst_n) ( wr_en && !full ) |=> (wr_ptr == ( $past(wr_ptr) + 1 ) % FIFO_DEPTH);
endproperty

property pr7;
	@(posedge clk) disable iff (!rst_n) ( rd_en && !empty ) |=> (rd_ptr == ( $past(rd_ptr) + 1 ) % FIFO_DEPTH);
endproperty

property pr8;
	@(posedge clk) (count == FIFO_DEPTH) |-> (full == 1);
endproperty

property pr9;
	@(posedge clk) (count == 0) |-> (empty == 1);
endproperty

property pr10;
	@(posedge clk) (count == FIFO_DEPTH - 1) |-> (almostfull == 1);
endproperty

property pr11;
	@(posedge clk) (count == 1) |-> (almostempty == 1);
endproperty


count_increment_assert: assert property(pr1);  count_decrement_assert: assert property(pr2);  underflow_assert: assert property(pr3);  overflow_assert: assert property(pr4);
wr_ack_assert: assert property(pr5);  wr_ptr_assert: assert property(pr6);  rd_ptr_assert: assert property(pr7); full_assert: assert property(pr8);
empty_assert : assert property(pr9); almostfull_assert: assert property(pr10); almostempty_assert: assert property(pr11);

cover property(pr1);  cover property(pr2);  cover property(pr3) ; cover property(pr4) ;  cover property(pr5);  cover property(pr6);  cover property(pr7);
cover property(pr8);  cover property(pr9);  cover property(pr10); cover property(pr11);

endmodule

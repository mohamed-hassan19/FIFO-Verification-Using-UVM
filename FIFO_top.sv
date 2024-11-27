import test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module top();

bit clk;

initial begin
	clk = 0;
	forever begin
		#1 clk = ~clk;
	end
end

FIFO_if fifo_if(clk);

FIFO F1(fifo_if.data_in, fifo_if.wr_en, fifo_if.rd_en, clk,
        fifo_if.rst_n, fifo_if.full, fifo_if.empty,
        fifo_if.almostfull, fifo_if.almostempty, fifo_if.wr_ack,
        fifo_if.overflow, fifo_if.underflow, fifo_if.data_out);

bind FIFO FIFO_SVA SVA1(fifo_if.data_in, fifo_if.wr_en, fifo_if.rd_en, clk,
        fifo_if.rst_n, fifo_if.full, fifo_if.empty,
        fifo_if.almostfull, fifo_if.almostempty, fifo_if.wr_ack,
        fifo_if.overflow, fifo_if.underflow, fifo_if.data_out,
        F1.wr_ptr, F1.rd_ptr, F1.count);

initial begin
	uvm_config_db#(virtual FIFO_if)::set(null, "uvm_test_top", "IF", fifo_if);
	run_test("FIFO_test");
end

endmodule

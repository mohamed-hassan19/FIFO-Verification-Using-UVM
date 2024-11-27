package seq_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_seq_item extends uvm_sequence_item;
	`uvm_object_utils(FIFO_seq_item)

	parameter FIFO_WIDTH = 16; 
	parameter FIFO_DEPTH = 8;

	rand logic [FIFO_WIDTH-1:0] data_in;
	rand logic rst_n, wr_en, rd_en;

	logic [FIFO_WIDTH-1:0] data_out;
	logic wr_ack, overflow, underflow;
	logic full, empty, almostfull, almostempty;

    integer RD_EN_ON_DIST, WR_EN_ON_DIST;

    function void rand_parameters(integer RD_EN_ON_DIST = 30, integer WR_EN_ON_DIST = 70);
    	this.RD_EN_ON_DIST = RD_EN_ON_DIST;
		this.WR_EN_ON_DIST = WR_EN_ON_DIST;
    endfunction

	function new(string name = "FIFO_seq_item");
		super.new(name);
	endfunction 

	constraint reset { rst_n dist {1'b0 := 10, 1'b1 := 90}; }
	constraint write_read {
	wr_en dist {1'b1 := WR_EN_ON_DIST, 1'b0 := (100 - WR_EN_ON_DIST)};
	rd_en dist {1'b1 := RD_EN_ON_DIST, 1'b0 := (100 - RD_EN_ON_DIST)};
	}

    constraint read_only  {wr_en == 0; rd_en == 1;}
    constraint write_only {wr_en == 1; rd_en == 0;}

	function string convert2string();
		return $sformatf("%s rst_n = %0b, data_in =  %0b, wr_en =  %0b, rd_en =  %0b, data_out =  %0b, wr_ack =  %0b, overflow =  %0b, underflow =  %0b,full =  %0b,empty   =  %0b,almostfull =  %0b,almostempty =  %0b"
				         ,super.convert2string(), rst_n, data_in, wr_en, rd_en, data_out, wr_ack, overflow, underflow, full, empty, almostfull, almostempty);
	endfunction
		
	function string convert2string_stimulus();
		return $sformatf("rst_n = %0b, data_in =  %0b, wr_en =  %0b, rd_en =  %0b", rst_n, data_in, wr_en, rd_en);
	endfunction

endclass 

endpackage

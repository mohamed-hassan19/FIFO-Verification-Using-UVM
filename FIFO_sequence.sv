package sequence_pkg;

import seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_reset_seq extends uvm_sequence #(FIFO_seq_item);
	`uvm_object_utils(FIFO_reset_seq)

	FIFO_seq_item seq_item;

	function new(string name = "FIFO_seq");
		super.new(name);
	endfunction

	task body();
		
		seq_item = FIFO_seq_item::type_id::create("seq_item");

		start_item(seq_item);
		seq_item.rst_n = 0; seq_item.wr_en = 0; seq_item.rd_en = 0;
		finish_item(seq_item);

	endtask 

endclass

class FIFO_write_only_seq extends uvm_sequence #(FIFO_seq_item);
	`uvm_object_utils(FIFO_write_only_seq)

	FIFO_seq_item seq_item;

	function new(string name = "FIFO_seq");
		super.new(name);
	endfunction

	task body();
		
		repeat(1000) begin

			seq_item = FIFO_seq_item::type_id::create("seq_item");

			seq_item.reset.constraint_mode(1); seq_item.write_read.constraint_mode(0); seq_item.write_only.constraint_mode(1); seq_item.read_only.constraint_mode(0);

			start_item(seq_item);
			assert(seq_item.randomize());
			finish_item(seq_item);

		end

	endtask 

endclass

class FIFO_read_only_seq extends uvm_sequence #(FIFO_seq_item);
	`uvm_object_utils(FIFO_read_only_seq)

	FIFO_seq_item seq_item;

	function new(string name = "FIFO_seq");
		super.new(name);
	endfunction

	task body();
		
		repeat(1000) begin

			seq_item = FIFO_seq_item::type_id::create("seq_item");

			seq_item.reset.constraint_mode(1); seq_item.write_read.constraint_mode(0); seq_item.write_only.constraint_mode(0); seq_item.read_only.constraint_mode(1);

			start_item(seq_item);
			assert(seq_item.randomize());
			finish_item(seq_item);

		end

	endtask 

endclass

class FIFO_write_read_seq extends uvm_sequence #(FIFO_seq_item);
	`uvm_object_utils(FIFO_write_read_seq)

	FIFO_seq_item seq_item;

	function new(string name = "FIFO_seq");
		super.new(name);
	endfunction

	task body();
		
		repeat(5000) begin

			seq_item = FIFO_seq_item::type_id::create("seq_item");

			seq_item.rand_parameters();
			seq_item.reset.constraint_mode(1); seq_item.write_read.constraint_mode(1); seq_item.write_only.constraint_mode(0); seq_item.read_only.constraint_mode(0);

			start_item(seq_item);
			assert(seq_item.randomize());
			finish_item(seq_item);

		end

	endtask 

endclass

endpackage
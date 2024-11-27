package monitor_pkg;

import seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_monitor extends uvm_monitor;
	`uvm_component_utils(FIFO_monitor)

	virtual FIFO_if vif;
	FIFO_seq_item mon_seq_item;
	uvm_analysis_port #(FIFO_seq_item) mon_ap;

	function new(string name = "FIFO_monitor", uvm_component parent = null);
		super.new(name, parent);
	endfunction 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon_ap = new("mon_ap", this);
	endfunction 

	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		forever begin
			
			mon_seq_item = FIFO_seq_item::type_id::create("mon_seq_item");

			@(negedge vif.clk);

			mon_seq_item.rst_n = vif.rst_n; mon_seq_item.data_in = vif.data_in; mon_seq_item.wr_en = vif.wr_en; mon_seq_item.rd_en = vif.rd_en;
			mon_seq_item.data_out = vif.data_out; mon_seq_item.wr_ack = vif.wr_ack; mon_seq_item.overflow = vif.overflow; mon_seq_item.underflow = vif.underflow;
			mon_seq_item.full = vif.full; mon_seq_item.empty = vif.empty; mon_seq_item.almostfull = vif.almostfull; mon_seq_item.almostempty = vif.almostempty;

			mon_ap.write(mon_seq_item);

			`uvm_info("run_phase", mon_seq_item.convert2string(), UVM_HIGH)

		end

	endtask

endclass

endpackage
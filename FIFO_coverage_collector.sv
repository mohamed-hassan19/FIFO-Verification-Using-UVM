package coverage_collector_pkg;
	
import seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_coverage_collector extends uvm_component;
	`uvm_component_utils(FIFO_coverage_collector)

	uvm_analysis_export #(FIFO_seq_item) cov_aexp;
	uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
	FIFO_seq_item cov_seq_item;

	covergroup cvr_gp;

		wr_en: coverpoint cov_seq_item.wr_en{option.weight = 0;}  rd_en: coverpoint cov_seq_item.rd_en{option.weight = 0;}  
		wr_ack: coverpoint cov_seq_item.wr_ack{option.weight = 0;} 
		overflow  : coverpoint cov_seq_item.overflow  {option.weight = 0;} underflow  : coverpoint cov_seq_item.underflow  {option.weight = 0;}
		full : coverpoint cov_seq_item.full {option.weight = 0;}  empty: coverpoint cov_seq_item.empty{option.weight = 0;}
		almostfull: coverpoint cov_seq_item.almostfull{option.weight = 0;} almostempty: coverpoint cov_seq_item.almostempty{option.weight = 0;}
		
		
		
		en_with_full       : cross wr_en, rd_en, full;
		en_with_empty      : cross wr_en, rd_en, empty;
		en_with_almostfull : cross wr_en, rd_en, almostfull;
		en_with_almostempty: cross wr_en, rd_en, almostempty;
		en_with_overflow   : cross wr_en, rd_en, overflow;
		en_with_underflow  : cross wr_en, rd_en, underflow;
		en_with_wr_ack     : cross wr_en, rd_en, wr_ack;
			
	endgroup

	function new(string name = "FIFO_coverage_collector", uvm_component parent = null);
		super.new(name, parent);

		cvr_gp = new();
	endfunction 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		cov_aexp = new("cov_aexp", this);
		cov_fifo = new("cov_fifo", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		cov_aexp.connect(cov_fifo.analysis_export);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		forever begin
			cov_fifo.get(cov_seq_item);
	
			cvr_gp.sample();
		end

	endtask

endclass

endpackage
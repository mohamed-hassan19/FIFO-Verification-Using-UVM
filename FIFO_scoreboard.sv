package scoreboard_pkg;

import seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(FIFO_scoreboard)

	uvm_analysis_export   #(FIFO_seq_item) sb_aexp;
	uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;
	FIFO_seq_item sb_seq_item;

	parameter FIFO_WIDTH = 16; 
	parameter FIFO_DEPTH = 8;

	localparam max_fifo_addr = $clog2(FIFO_DEPTH);

	logic [FIFO_WIDTH-1:0] data_out_ref;
	logic wr_ack_ref, overflow_ref, underflow_ref;
	logic full_ref, empty_ref, almostfull_ref, almostempty_ref;

	logic [max_fifo_addr-1:0] rd_ptr_ref, wr_ptr_ref;
	logic [max_fifo_addr:0] count_ref;

	logic [FIFO_WIDTH-1:0] mem_ref [FIFO_DEPTH-1:0];

	integer correct_count = 0, error_count = 0;

	function new(string name = "FIFO_scoreboard", uvm_component parent = null);
		super.new(name, parent);
	endfunction 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		sb_aexp = new("sb_aexp", this);
		sb_fifo = new("sb_fifo", this);
	endfunction 

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		sb_aexp.connect(sb_fifo.analysis_export);
	endfunction 

	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		forever begin
			sb_fifo.get(sb_seq_item);	
			reference_model(sb_seq_item);

			if(data_out_ref !== sb_seq_item.data_out || wr_ack_ref !== sb_seq_item.wr_ack || overflow_ref !== sb_seq_item.overflow || underflow_ref !== sb_seq_item.underflow 
			  || full_ref !== sb_seq_item.full || empty_ref !== sb_seq_item.empty || almostfull_ref !== sb_seq_item.almostfull || almostempty_ref !== sb_seq_item.almostempty) begin

				`uvm_error("run_phase", $sformatf("Comparison failed, Transaction received by the DUT: %s while the reference data_out: 0b%0b"
					       ,sb_seq_item.convert2string(), data_out_ref))
				error_count++;
			end
			else begin
				`uvm_info("run_phase", $sformatf("Correct FIFO out: %s",sb_seq_item.convert2string()), UVM_HIGH)
				correct_count++;
			end
		end

	endtask

	task reference_model(FIFO_seq_item chk_seq_item);

		if (!chk_seq_item.rst_n) begin
			wr_ack_ref = 0; rd_ptr_ref = 0; wr_ptr_ref = 0; count_ref = 0;
			overflow_ref = 0; underflow_ref = 0;
		end
		else begin

			if(chk_seq_item.wr_en && count_ref < chk_seq_item.FIFO_DEPTH)  begin
				mem_ref[wr_ptr_ref] = chk_seq_item.data_in;
				wr_ack_ref = 1;
				wr_ptr_ref = wr_ptr_ref + 1;
			end
			else begin
				wr_ack_ref = 0;
			end 

			if (full_ref && chk_seq_item.wr_en && chk_seq_item.rst_n)
				overflow_ref = 1;
			else
				overflow_ref = 0;



			if(chk_seq_item.rd_en && count_ref != 0)  begin 
				data_out_ref = mem_ref[rd_ptr_ref];                                                       
				rd_ptr_ref   = rd_ptr_ref + 1;
			end

			if (chk_seq_item.rd_en && empty_ref && chk_seq_item.rst_n)  
				underflow_ref = 1;
			else 
				underflow_ref = 0;



			if( ( ({chk_seq_item.wr_en, chk_seq_item.rd_en} == 2'b10) && (!full_ref) ) || (chk_seq_item.wr_en && chk_seq_item.rd_en && empty_ref) ) begin
				count_ref = count_ref + 1;
			end 
			else if( ( ({chk_seq_item.wr_en, chk_seq_item.rd_en} == 2'b01) && (!empty_ref) ) || (chk_seq_item.wr_en && chk_seq_item.rd_en && full_ref) ) begin
				count_ref = count_ref - 1;
			end 

		end

		full_ref        = (count_ref == chk_seq_item.FIFO_DEPTH)? 1 : 0;
		empty_ref       = (count_ref == 0)? 1 : 0;
		almostfull_ref  = (count_ref == chk_seq_item.FIFO_DEPTH-1)? 1 : 0;
	    almostempty_ref = (count_ref == 1)? 1 : 0;

	endtask

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);

		`uvm_info("report_phase", $sformatf("Total successfull transactions: %0d", correct_count), UVM_MEDIUM)
		`uvm_info("report_phase", $sformatf("Total failed transactions: %0d", error_count), UVM_MEDIUM)
	endfunction 

endclass

endpackage
package test_pkg;
	
import sequence_pkg::*;
import config_obj_pkg::*;
import env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_test extends uvm_test;
	`uvm_component_utils(FIFO_test)
	
	virtual FIFO_if vif;
	FIFO_config_obj cfg_obj;
	FIFO_reset_seq reset_seq;
	FIFO_write_only_seq write_only_seq;
	FIFO_read_only_seq read_only_seq;
	FIFO_write_read_seq write_read_seq;
	FIFO_env env;
	
	function new(string name = "FIFO_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		cfg_obj   = FIFO_config_obj::type_id::create("cfg_obj");
		reset_seq  = FIFO_reset_seq  ::type_id::create("reset_seq");
		write_only_seq  = FIFO_write_only_seq  ::type_id::create("write_only_seq");
		read_only_seq  = FIFO_read_only_seq  ::type_id::create("read_only_seq");
		write_read_seq  = FIFO_write_read_seq  ::type_id::create("write_read_seq");
		env = FIFO_env::type_id::create("env", this);

		if(!uvm_config_db#(virtual FIFO_if)::get(this, "", "IF", cfg_obj.vif)) begin
			`uvm_fatal("build_phase", "Unable to get the virtual interface of the FIFO from uvm_congif_db")
		end

		uvm_config_db#(FIFO_config_obj)::set(this, "*", "CFG", cfg_obj);
		
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		phase.raise_objection(this);

		`uvm_info("run_phase", "Reset Asserted", UVM_MEDIUM)
		reset_seq.start(env.agt.sqr);
		`uvm_info("run_phase", "Reset Deasserted", UVM_MEDIUM)

		`uvm_info("run_phase", "Write only sequence started", UVM_MEDIUM)
		write_only_seq.start(env.agt.sqr);
		`uvm_info("run_phase", "Write only sequence ended", UVM_MEDIUM)

		`uvm_info("run_phase", "read only sequence started", UVM_MEDIUM)
		read_only_seq.start(env.agt.sqr);
		`uvm_info("run_phase", "read only sequence ended", UVM_MEDIUM)

		`uvm_info("run_phase", "Write - Read sequence started", UVM_MEDIUM)
		write_read_seq.start(env.agt.sqr);
		`uvm_info("run_phase", "Write - Read sequence ended", UVM_MEDIUM)

		phase.drop_objection(this);

	endtask 

endclass

endpackage


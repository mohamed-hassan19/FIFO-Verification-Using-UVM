package env_pkg;

import scoreboard_pkg::*;
import coverage_collector_pkg::*;
import agent_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_env extends uvm_env;
	`uvm_component_utils(FIFO_env)

	FIFO_scoreboard sb;
	FIFO_coverage_collector cov;
	FIFO_agent agt;

	function new(string name = "FIFO_env", uvm_component parent = null);
		super.new(name, parent);
	endfunction 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		sb  = FIFO_scoreboard::type_id::create("sb", this);
		cov = FIFO_coverage_collector::type_id::create("cov", this);
		agt = FIFO_agent::type_id::create("agt", this);
	endfunction 

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		agt.agt_ap.connect(sb.sb_aexp);
		agt.agt_ap.connect(cov.cov_aexp);
	endfunction

endclass

endpackage
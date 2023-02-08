// Module : MicroController TestBench
`timescale 1ns / 1ps
module MCU_tb;

	// Inputs
	reg clk;
	reg rst;
	
	// Outputs
	wire [1:0] current_state,next_state;
	wire load_done;
	wire [7:0] load_addr;
	wire [11:0] load_instr;
	wire [7:0] PC,  DR, Acc;
	wire [11:0] IR;
	wire [3:0]  SR;
	wire PC_E,Acc_E,SR_E,DR_E,IR_E;
	wire PC_clr,Acc_clr,SR_clr,DR_clr,IR_clr;
	wire [7:0] PC_updated,DR_updated;
	wire [11:0] IR_updated;
	wire [3:0] SR_updated;
	wire PMem_E,DMem_E,DMem_WE,ALU_E,PMem_LE,MUX1_Sel,MUX2_Sel;
	wire [3:0] ALU_Mode;
	wire [7:0] Adder_Out;
	wire [7:0] ALU_Out,ALU_Oper2;

	// Instantiate the Unit Under Test (UUT)
	MicroController uut (
		.clk(clk), 
		.rst(rst),
		.current_state(current_state),
		.next_state(next_state),
		.load_done(load_done),
		.load_addr(load_addr),
		.load_instr(load_instr),
		.PC(PC),
		.DR(DR), 
		.Acc(Acc), 
		.IR(IR), 
		.SR(SR),
		.PC_E(PC_E),
		.Acc_E(Acc_E),
		.SR_E(SR_E),
		.DR_E(DR_E),
		.IR_E(IR_E),
		.PC_clr(PC_clr),
		.Acc_clr(Acc_clr),
		.SR_clr(SR_clr),
		.DR_clr(DR_clr),
		.IR_clr(IR_clr),
		.PC_updated(PC_updated),
		.DR_updated(DR_updated),
		.IR_updated(IR_updated),
		.SR_updated(SR_updated),
		.PMem_E(PMem_E),
		.DMem_E(DMem_E),
		.DMem_WE(DMem_WE),
		.ALU_E(ALU_E),
		.PMem_LE(PMem_LE),
		.MUX1_Sel(MUX1_Sel),
		.MUX2_Sel(MUX2_Sel),
		.ALU_Mode(ALU_Mode),
		.Adder_Out(Adder_Out),
		.ALU_Out(ALU_Out),
		.ALU_Oper2(ALU_Oper2)
	);

	initial begin
		// Initialize Inputs
		rst = 1;
		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
	end
	
	initial begin 
		clk = 0;
		forever #10 clk = ~clk;
	end 
	
	initial
	begin
		#15000 $finish;
	end
endmodule 
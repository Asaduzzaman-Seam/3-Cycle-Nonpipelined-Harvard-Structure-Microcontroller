// Project Name : 3 Cycle Nonpipeline 8 bit Harvard Structure MicroController
// (similar to Microchip PIC12)
// Student ID : 180105100, 180105091, 180105092, 180105095, 180105198

// Module: MicroController
module MicroController(clk,rst,current_state,next_state,load_done,load_addr,load_instr,
    PC,  DR, Acc, IR, SR,PC_E,Acc_E,SR_E,DR_E,IR_E,PC_clr,Acc_clr,SR_clr,
	 DR_clr,IR_clr,PC_updated,DR_updated,IR_updated,SR_updated,PMem_E,DMem_E,
	 DMem_WE,ALU_E,PMem_LE,MUX1_Sel,MUX2_Sel,ALU_Mode,Adder_Out,ALU_Out,ALU_Oper2);
	 
	input clk,rst;
	
	parameter test_data = 3; // Select 1 to 4
	parameter LOAD = 2'b00,FETCH = 2'b01, DECODE = 2'b10, EXECUTE = 2'b11;
	reg [11:0] program_mem[9:0];
	
	output reg [1:0] current_state,next_state;
	output reg load_done;
	output reg [7:0] load_addr;
	output wire[11:0] load_instr;
	output reg [7:0] PC,  DR, Acc;
	output reg [11:0] IR;
	output reg [3:0]  SR;
	output wire PC_E,Acc_E,SR_E,DR_E,IR_E;
	output reg  PC_clr,Acc_clr,SR_clr,DR_clr,IR_clr;
	output wire [7:0] PC_updated,DR_updated;
	output wire [11:0] IR_updated;
	output wire [3:0] SR_updated;
	output wire PMem_E,DMem_E,DMem_WE,ALU_E,PMem_LE,MUX1_Sel,MUX2_Sel;
	output wire [3:0] ALU_Mode;
	output wire [7:0] Adder_Out;
	output wire [7:0] ALU_Out,ALU_Oper2;
	
	// LOAD instruction memory
	initial begin
		// Test Data Set 1
		if(test_data == 1) begin
			program_mem[0] = 12'b000000000000;
			program_mem[1] = 12'b101100000001; 
			program_mem[2] = 12'b001000100000; 
			program_mem[3] = 12'b101100000000; 
			program_mem[4] = 12'b001100110000; 
			program_mem[5] = 12'b000100000101; 
			program_mem[6] = 12'b000000000000; 
			program_mem[7] = 12'b000000000000; 
			program_mem[8] = 12'b000000000000; 
			program_mem[9] = 12'b000000000000;
		end
		
		// Test Data Set 2
		else if(test_data == 2) begin
			program_mem[0] = 12'b000000000000;
			program_mem[1] = 12'b101100000001;
			program_mem[2] = 12'b001000100000;
			program_mem[3] = 12'b001100000000;
			program_mem[4] = 12'b001000000000;
			program_mem[5] = 12'b001100010000;
			program_mem[6] = 12'b001000010000;
			program_mem[7] = 12'b001101110000;
			program_mem[8] = 12'b001001110000;
			program_mem[9] = 12'b000100001001;
		end
		
		// Test Data Set 3
		else if(test_data == 3) begin
			program_mem[0] = 12'b000000000000;
			program_mem[1] = 12'b101100000101;
			program_mem[2] = 12'b001000100000;
			program_mem[3] = 12'b001000100001;
			program_mem[4] = 12'b001000100010;
			program_mem[5] = 12'b101100000011;
			program_mem[6] = 12'b001001000000;
			program_mem[7] = 12'b001001010001;
			program_mem[8] = 12'b001001100010;
			program_mem[9] = 12'b000100001001;
		end
		
		// Test Data Set 4
		else if(test_data == 4) begin
			program_mem[0] = 12'b000000000000;
			program_mem[1] = 12'b101100000101;
			program_mem[2] = 12'b101000000000;
			program_mem[3] = 12'b100000000111;
			program_mem[4] = 12'b100100000110;
			program_mem[5] = 12'b111100000111;
			program_mem[6] = 12'b110000000011;
			program_mem[7] = 12'b110100000101;
			program_mem[8] = 12'b111000000011;
			program_mem[9] = 12'b000100001001;
		end
	end
	
	// ALU
	ALU ALU_unit( 
		.Operand1(Acc),
		.Operand2(ALU_Oper2),
		.E(ALU_E),
		.Mode(ALU_Mode),
		.CFlags(SR),
		.Out(ALU_Out),
		.Flags(SR_updated)
	);

	// MUX2
	MUX1 MUX2_unit(
		.In2(IR[7:0]),
		.In1(DR),
		.Sel(MUX2_Sel),
		.Out(ALU_Oper2)
	);

	// Data Memory
	DMem DMem_unit( .clk(clk),
		.E(DMem_E), 		// Enable port 
		.WE(DMem_WE), 		// Write enable port
		.Addr(IR[3:0]), 	// Address port 
		.DI(ALU_Out), 		// Data input port
		.DO(DR_updated) 	// Data output port
	 );
 
	// Program memory
	PMem PMem_unit( .clk(clk),
		.E(PMem_E), 		// Enable port
		.Addr(PC), 			// Address port
		.I(IR_updated), 	// Instruction port
		
		// 3 special ports are used to load program to the memory
		.LE(PMem_LE), 		// Load enable port 
		.LA(load_addr), 	// Load address port
		.LI(load_instr)	//Load instruction port
	);

	// PC Adder
	adder PC_Adder_unit(
		.In(PC),
		.Out(Adder_Out)
	);


	// MUX1
	MUX1 MUX1_unit( 
		.In2(IR[7:0]),
		.In1(Adder_Out),
		.Sel(MUX1_Sel),
		.Out(PC_updated)
	);
 
	// Control logic
	Control_Logic Control_Logic_Unit( 
		.stage(current_state),
		.IR(IR),
		.SR(SR),
		.PC_E(PC_E),
		.Acc_E(Acc_E),
		.SR_E(SR_E),
		.IR_E(IR_E),
		.DR_E(DR_E),
		.PMem_E(PMem_E),
		.DMem_E(DMem_E),
		.DMem_WE(DMem_WE),
		.ALU_E(ALU_E),
		.MUX1_Sel(MUX1_Sel),
		.MUX2_Sel(MUX2_Sel),
		.PMem_LE(PMem_LE),
		.ALU_Mode(ALU_Mode)
	);

	// LOAD
	always @(posedge clk)
	begin
		if(rst==1) begin
			load_addr <= 0;
			load_done <= 1'b0;
		end 
		else if(PMem_LE==1)
		begin 
			load_addr <= load_addr + 8'd1;
			if(load_addr == 8'd9)
			begin
			load_addr <= 8'd0;
			load_done <= 1'b1;
			end
			else
			begin
			load_done <= 1'b0;
			end
		end 
	end

	assign load_instr = program_mem[load_addr];

	// next state
	always @(posedge clk)
	begin
		if(rst==1)
		current_state <= LOAD;
		else
		current_state <= next_state;
	end
	always @(*)
	begin
		PC_clr = 0;
		Acc_clr = 0;
		SR_clr = 0;
		DR_clr = 0; 
		IR_clr = 0;
		case(current_state)
		LOAD: begin
		if(load_done==1) begin
		next_state = FETCH;
		PC_clr = 1;
		Acc_clr = 1;
		SR_clr = 1;
		DR_clr = 1; 
		IR_clr = 1;
		end
		else
		next_state = LOAD;
		end
		FETCH: begin
		next_state = DECODE;
		end
		DECODE: begin
		next_state = EXECUTE;
		end
		EXECUTE: begin
		next_state = FETCH;
		end 
		endcase
	end

	// 3 programmer visible register
	always @(posedge clk)
	begin
		if(rst==1) 
		begin
		PC <= 8'd0;
		Acc <= 8'd0;
		SR <= 4'd0;
		end
		else 
		begin
		if(PC_E==1'd1) 
		PC <= PC_updated;
		else if (PC_clr==1)
		PC <= 8'd0;
		if(Acc_E==1'd1) 
		Acc <= ALU_Out;
		else if (Acc_clr==1)
		Acc <= 8'd0;
		if(SR_E==1'd1) 
		SR <= SR_updated; 
		else if (SR_clr==1)
		SR <= 4'd0; 
		end
	end

	// 2 programmer invisible register
	always @(posedge clk)
	begin
		if(DR_E==1'd1) 
		DR <= DR_updated;
		else if (DR_clr==1)
		DR  <= 8'd0;
		if(IR_E==1'd1) 
		IR <= IR_updated;
		else if(IR_clr==1)
		IR <= 12'd0;
	end
endmodule



// Submodule: Control Unit
module Control_Logic( 
	input [1:0] stage,
	input [11:0] IR,
	input [3:0] SR,
	output reg PC_E,Acc_E,SR_E,IR_E,DR_E,PMem_E,DMem_E,DMem_WE,ALU_E,MUX1_Sel,MUX2_Sel,PMem_LE,
	output reg [3:0] ALU_Mode
);

	parameter LOAD = 2'b00,FETCH = 2'b01, DECODE = 2'b10, EXECUTE = 2'b11;
	
	always @(*)
	begin
		PMem_LE = 0;
		PC_E = 0;
		Acc_E = 0;
		SR_E = 0;
		IR_E = 0;
		DR_E = 0;
		PMem_E = 0; 
		DMem_E = 0;
		DMem_WE = 0;
		ALU_E  =0; 
		ALU_Mode = 4'd0;
		MUX1_Sel = 0;
		MUX2_Sel = 0;
		if(stage== LOAD )
		begin
			PMem_LE = 1;
			PMem_E = 1; 
		end
		else if(stage== FETCH ) begin
			IR_E = 1; 
			PMem_E = 1;  
		end
		else if(stage== DECODE ) begin
			if( IR[11:9] == 3'b001) 
			begin
				DR_E = 1;
				DMem_E = 1;
			end
			else
			begin
				DR_E = 0;
				DMem_E = 0;
			end
		end
		else if(stage== EXECUTE ) 
		begin
			if(IR[11]==1) begin // ALU I-type
				PC_E = 1; 
				Acc_E = 1; 
				SR_E = 1;
				ALU_E = 1;
				ALU_Mode = IR[10:8];
				MUX1_Sel = 1;
				MUX2_Sel = 0; 
			end
			else if(IR[10]==1) // JZ, JC,JS, JO
			begin
				PC_E = 1; 
				MUX1_Sel = SR[IR[9:8]]; 
			end
			else if(IR[9]==1) 
			begin
				PC_E = 1; 
				Acc_E = IR[8]; 
				SR_E = 1;
				DMem_E = !IR[8];
				DMem_WE = !IR[8];
				ALU_E = 1;
				ALU_Mode = IR[7:4];
				MUX1_Sel = 1;
				MUX2_Sel = 1;
			end
			else if(IR[8]==0)
			begin
				PC_E = 1; 
				MUX1_Sel = 1; 
			end
			else
			begin
				PC_E = 1; 
				MUX1_Sel = 0; 
			end
		end
	end
endmodule



// Submodule: Program Memory
module PMem(
	input clk,
   input E, 			// Enable port
	input [7:0] Addr, // Address port
	output [11:0] I, 	// Instruction port
	
	// 3 special ports are used to load program to the memory
	input LE, 			// Load enable port 
	input[7:0] LA, 	// Load address port
	input [11:0] LI	//Load instruction port
);

	reg [11:0] Prog_Mem[255:0] ;
	
	always @(posedge clk)
	begin
		if(LE == 1) begin
			Prog_Mem[LA] <= LI;
		end
	end
	
	assign I =  (E == 1) ?  Prog_Mem[Addr]: 0 ;
endmodule



// Submodule: Adder
module adder( 
	input [7:0] In,
	output [7:0] Out
);
	assign Out = In + 1;
endmodule



// Submodule: MUX1
module MUX1( 
	input [7:0] In1,In2,
	input Sel,
	output [7:0] Out
);
	assign Out = (Sel==1)? In1: In2;
endmodule



// Submodule: Data Memory
module DMem( 
	input clk,
	input E, // Enable port 
	input WE, // Write enable port
	input [3:0] Addr, // Address port 
	input [7:0] DI, // Data input port
	output [7:0] DO // Data output port
);

	reg [7:0] data_mem [255:0];
	
	always @(posedge clk) 
	begin
		if(E==1 && WE ==1) 
		data_mem[Addr] <= DI;
	end 
	assign DO = (E ==1 )? data_mem[Addr]:0;
endmodule



// Submodule: ALU
module ALU(
	input [7:0] Operand1,Operand2,
	input E, 
	input [3:0] Mode,
	input [3:0] CFlags,
	output [7:0] Out,
	output [3:0] Flags  
);

	wire Z,S,O;
	reg CarryOut;
	reg [7:0] Out_ALU;

	always @(*)
	begin
		case(Mode) 
			4'b0000: {CarryOut,Out_ALU} = Operand1 + Operand2;
			
			4'b0001: 
			begin 
				Out_ALU = Operand1 -  Operand2;
				CarryOut = !Out_ALU[7];
			end
			
			4'b0010: Out_ALU = Operand1;
			4'b0011: Out_ALU = Operand2;
			4'b0100: Out_ALU = Operand1 & Operand2;
			4'b0101: Out_ALU = Operand1 | Operand2;
			4'b0110: Out_ALU = Operand1 ^ Operand2;
			
			4'b0111: 
			begin
				Out_ALU = Operand2 - Operand1;
				CarryOut = !Out_ALU[7];
			end
			
			4'b1000: {CarryOut,Out_ALU} = Operand2 + 8'h1;
			
			4'b1001: 
			begin
				Out_ALU = Operand2 - 8'h1;
				CarryOut = !Out_ALU[7];
			end
			
			4'b1010: Out_ALU = (Operand2 << Operand1[2:0])| ( Operand2 >> Operand1[2:0]);
			4'b1011: Out_ALU = (Operand2 >> Operand1[2:0])| ( Operand2 << Operand1[2:0]);
			4'b1100: Out_ALU = Operand2 << Operand1[2:0];
			4'b1101: Out_ALU = Operand2 >> Operand1[2:0];
			4'b1110: Out_ALU = Operand2 >>> Operand1[2:0];
			
			4'b1111: 
			begin
				Out_ALU = 8'h0 - Operand2;
				CarryOut = !Out_ALU[7];
			end
			
			default: Out_ALU = Operand2;
		endcase
	end
	
	assign O = Out_ALU[7] ^ Out_ALU[6];
	assign Z = (Out_ALU == 0)? 1'b1 : 1'b0;
	assign S = Out_ALU[7];
	assign Flags = {Z,CarryOut,S,O};
	assign Out = Out_ALU;
endmodule

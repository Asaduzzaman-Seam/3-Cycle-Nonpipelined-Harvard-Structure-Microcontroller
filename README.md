# 3-Cycle-Nonpipelined-Harvard-Structure-Microcontroller

### Course No:  EEE 4232
### Course Name:  VLSI II Lab

## Asaduzzaman Seam  180105100  180105100@aust.edu

## Microcontroller (MCU)
A microcontroller is a  compact integrated circuit designed to govern a specific operation in  an embedded  system.  A  typical  microcontroller  includes  a  processor,  memory  and input/output (I/O) peripherals on a single chip.
Sometimes  referred  to  as  an  embedded  controller  or  microcontroller  unit  (MCU), microcontrollers are found in vehicles, robots, office machines, medical devices, mobile radio transceivers, vending machines and home appliances,  among other devices. They are  essentially  simple  miniature  personal  computers  (PCs)  designed  to  control  small features of a larger component, without a complex front-end operating system (OS).

The following two type of components holds programming context:
- Program  counter,  program  memory,  data  memory,  accumulator,  status  register (green boxes). They are programmer visible registers and memories.
- Instruction register and data register (purple boxes). They are programmer invisible registers.
The following two type of  components is Boolean logics that do the actual computation work. They are stateless:
- ALU, MUX1, MUX2, Adder (blue boxes), used as a functional unit.
- Control Logic (yellow box), used to denote all control signals (red signal).

Instruction Set Architecture
Each  instruction  is  12  bits.  There  are  3  types  of  instructions  by  encoding,  shown  as following:
- M type: one operand is accumulator (sometimes ignored) and the other operand is from data memory; the result can be stored into accumulator or  the data memory entry (same entry as the second operand).
- I type:  one operand is accumulator and the other operand is immediate number encoded in instruction; the result is stored into accumulator.
- S type: special instruction, no operand required. (e.g. NOP)

These instructions can be grouped into 4 categories by function:
1. ALU instruction: using ALU to compute result;
2. Unconditional branch: the GOTO instruction;
3. Conditional branch: the JZ, JC, JS, JO instruction;
4. Special instruction: the NOP

Each instruction needs 3 clock cycles to finish, i.e. FETCH stage, DECODE stage, and EXECUTE  stage.  It  is  not  pipelined.  Together  with  the  initial  LOAD state,  it  can  be considered as an FSM of 3 states (technically 4 states). States:
1. LOAD (initial state): load program to program memory, which takes 1 cycle per instruction loaded;
2. FETCH (first cycle): fetch current instruction from program memory;
3. DECODE (second cycle):  decode instruction to generate control logic, read data memory for operand;
4. EXECUTE (of the third cycle): execute instruction;

## Transitions
1.  LOAD →  FETCH (initialization finish): Clear content of PC, IR, DR, Acc, SR; DMem is not required to be cleared.
2.  FETCH → DECODE (rising edge of second cycle): IR = PMem [ PC ]
3.  DECODE → EXECUTE: DR = DMem [ IR[3:0] ]
4.  EXECUTE → FETCH (rising edge of first cycle and fourth cycle): For non-branch instruction, PC = PC + 1; for branch instruction, if branch is taken, PC = IR [7:0], otherwise PC = PC + 1; For ALU instruction, if the result destination is accumulator, Acc = ALU.Out; if the result destination is data memory, DMem [ IR[3:0] ] = ALU.Out. For ALU instruction, SR = ALU.Status; The transitions can be simplified using enable port of corresponding registers, e.g. assign ALU.Out  to  Acc  at every clock rising edge if  Acc.E  is set to  1. Such control signals as Acc.E  are  generated  as  a  Boolean  function  of  both  current  state  and  the  current instruction.

## Components

### Registers
The microcontroller has 3 programmer visible register:
1.  Program Counter (8 bit, denoted as PC): Contains the index of current executing instruction.
2.  Accumulator (8 bit, denoted as Acc):  Holds result and 1 operand of the arithmetic or logic calculation.
3.  Status Register (4 bit, denoted as SR): Holds 4 status bit, i.e. Z, C, S, O.
a.  Z (zero flag, SR[3]): 1 if result is zero, 0 otherwise.
b.  C (carry flag, SR[2]): 1 if carry is generated, 0 otherwise.
c.  S  (sign  flag,  SR[1]):  1  if  result  is  negative  (as  2’s  complement),  0 otherwise.
d.  O (overflow flag, SR[0]): 1 if result generates overflow, 0 otherwise.
Each of these registers has an enable port, as a flag for whether the value of the register should be updated in state transition. They are denoted as PC.E, Acc.E, and SR.E.
The microcontroller has 2 programmer invisible registers:
1.  Instruction  Register  (12  bit,  denoted  as  IR):  Contains  the  current  executing instruction.
2.  Data  Register  (8  bit,  denoted  as  DR):  Contains  the  operand  read  from  data memory.
Similarly, each of these registers has an enable port as a flag for whether the value of the 
register should be updated in state transition. They are denoted as IR.E and DR.E.

### Program memory
The microcontroller has a 256 entry program memory that stores program instructions, denoted as  PMem. Each entry is 12 bits, the ith entry is denoted as  PMem[i]. The program memory has the following input/output ports.
- Enable port (1 bit, input, denoted as PMem.E): enable the device, i.e. if it is 1, then the entry specified by the address port will be read out, otherwise, nothing is read out.
- Address port (8 bit, input, denoted as PMem.Addr): specify which instruction entry is read out, connected to PC.
- Instruction port  (12 bit, output, denoted as  PMem.I): the instruction entry that is read out, connected to IR. 
- 3 special ports are used to load program to  the memory, not used for executing instructions.
- Load enable port (1 bit, input, denoted as PMem.LE): enable the load, i.e. if it is 1, then the entry specified by the address port will be load with the value specified by the load instruction input port and the instruction  port is supplied with the same value;  otherwise,  the  entry  specified  by  the  address  port  will  be  read  out  on instruction port, and value on instruction load port is ignored.
- Load address port  (8 bit, input, denoted as PMem.LA): specify which instruction entry is loaded.
- Load instruction port  (12 bit, input, denoted as PMem.LI): the instruction that is loaded.

### Data memory
The microcontroller has a 16 entry data memory, denoted as DMem. Each entry is 8 bits, the i-th entry is denoted as DMem[i]. The program memory has the following input/output ports -  Enable port (1 bit, input, denoted as DMem.E): Enable the device, i.e. if it is 1, then the  entry  specified  by  the  address  port  will  be  read  out  or  written  in;  otherwise nothing is read out or written in.
- Write enable port (1 bit, input, denoted as DMem.WE): Enable the write, i.e. if it is  1,  then  the  entry  specified  by  the  address  port  will  be  written  with  the  value specified by the data  input port and the data output port is supplied with the same value; otherwise, the entry specified by the address port will be read out on data output port, and value on data input port is ignored.
- Address port (4 bit, input, denoted as DMem.Addr): Specify which data entry is read out, connected to IR[3:0].
- Data input port (8 bit, input, denoted as DMem.DI):  The value that is written in, connected to ALU.Out.
- Data output port (8 bit, output, denoted as DMem.DO):  The data entry that is read out, connected to MUX2.In1.

### PC adder
PC adder is used to add PC by 1, i.e. move to the next instruction. This component is pure combinational. It has the following ports:
- Adder input port (8 bit, input, denoted as Adder.In): Connected to PC.
- Adder output port (8 bit, output, denoted as Adder.Out): Connected to MUX1.In2.

### MUX1
MUX1 is used to choose the source for updating PC. If the current instruction is not a branch or it is a branch but the branch is not taken, PC is incremented by 1; otherwise PC is set to the jumping target, i.e. IR [7:0]. It has the following ports:
- MUX1 input 1 port (8 bit, input, denoted as MUX1.In1): Connected to IR [7:0].
- MUX1 input 2 port (8 bit, input, denoted as MUX1.In2): Connected to Adder.Out.
- MUX1 selection port  (1 bit, input, denoted as MUX1.Sel):  Connected to control logic.
- MUX1 output port (8 bit, output, denoted as MUX1.Out): Connected to PC.

### ALU
ALU is used to do the actual computation for the current instruction. This component is pure combinational. It has the following ports. The mode of ALU is listed in the following table.
- ALU operand 1 port (8 bit, input, denoted as ALU.Operand1): connected to Acc.
- ALU  operand  2  port  (8  bit,  input,  denoted  as  ALU.Operand2):  connected  to MUX2.Out.
- ALU enable port (1 bit, input, denoted as ALU.E): connected to control logic.
- ALU mode port (4 bit, input, denoted as ALU.Mode): connected to control logic.
- Current flags port (4 bit, input, denoted as ALU.CFlags): connected to SR.
- ALU output port (8 bit, output, denoted as ALU.Out): connected to DMem.DI.
- ALU flags port  (4 bit, output, denoted as ALU.Flags): the Z (zero), C (carry), S (sign), O (overflow) bits, from MSB to LSB, connected to status register.

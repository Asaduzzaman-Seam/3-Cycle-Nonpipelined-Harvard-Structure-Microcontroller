# 3-Cycle-Nonpipelined-Harvard-Structure-Microcontroller

Course No:  EEE 4232
Course Name:  VLSI II Lab

Asaduzzaman Seam  180105100  180105100@aust.edu

## Microcontroller (MCU)
A microcontroller is a  compact integrated circuit designed to govern a specific operation in  an embedded  system.  A  typical  microcontroller  includes  a  processor,  memory  and input/output (I/O) peripherals on a single chip.
Sometimes  referred  to  as  an  embedded  controller  or  microcontroller  unit  (MCU), microcontrollers are found in vehicles, robots, office machines, medical devices, mobile radio transceivers, vending machines and home appliances,  among other devices. They are  essentially  simple  miniature  personal  computers  (PCs)  designed  to  control  small features of a larger component, without a complex front-end operating system (OS).
The following diagram is the architecture of the microcontroller. The datapath is shown as black arrows and control signals are red arrows.

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

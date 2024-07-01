Principle
=========

To implement the RV32I baseline, a CPU has to perform at least the following tasks:

- IF (Instruction Fetch): Fetch the current instruction from the memory.
- ID (Instruction Decode): Separate and process the fields of the instruction code.
- RF (Register File read): Read the registers values.
- EX (EXecute): Execute the operations of the instruction.
- MA (Memory Access): Read from or write to the memory, if necessary.
- WB (Write Back): Write the operation result to the destination register, if necessary.

In the AsteRISC RISC-V implementation, those tasks are implemented in combinational blocks connected together by optional registers.

These registers are identified by the labels 1 to 7 in Figure :numref:`fig_arch`. 

.. _fig_arch:
.. figure:: images/AsteRISC_arch_V3.svg
   :class: fig

   AsteRISC Schematic

Optional registers make it possible to buffer key points of the processor's datapath, in order to shorten the critical path. 
This buffering is at the cost of additional execution cycles for instructions whose data follow this path.

These optional registers are selected through verilog parameters in such a way that the user does not need to edit the RTL description. A given optional register combination is called a *configuration*.

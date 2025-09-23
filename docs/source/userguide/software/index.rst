Software
========


.. toctree::
   :maxdepth: 1
   :hidden:
   
   user_programs


Run your own code
-----------------

Step 1: Install the RISC-V toolchain
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   git clone https://github.com/riscv/riscv-gnu-toolchain
   ./configure --prefix=/opt/riscv --with-arch=rv32ima --with-abi=ilp32 --enable-multilib
   make


Step 2: Setup your environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Edit ``AsteRISC-firmware/riscv-env`` to set the path to your RISC-V toolchain installation.

For instance:

.. tabs::

   .. group-tab:: 32 bits toolchain

      .. code-block:: bash
         :linenos:
         :lineno-start: 7

         # RISC-V toolchain install path
         RISCV_DIR=/opt/riscv

         # Target triple <machine>-<vendor>-<os>
         RISCV_TT=riscv32-unknown-elf

         # Binary folder for gcc, as, ld, etc.
         RISCV_BIN=${RISCV_DIR}/bin

         # .a library folder for libc, etc
         RISCV_LIB=${RISCV_DIR}/${RISCV_TT}/lib

         # .h include folder for libc, etc
         RISCV_INC=${RISCV_DIR}/${RISCV_TT}/include

         # GCC library to use
         RISCV_GCC_LIB=rv32i/ilp32

         # Python3 command
         PYTHON3=python3

   .. group-tab:: 32 bits + 64 bits toolchain

      .. code-block:: bash
         :linenos:
         :lineno-start: 7

         # RISC-V toolchain install path
         RISCV_DIR=/opt/riscv-gnu-toolchain/build/multilib

         # Target triple <machine>-<vendor>-<os>
         RISCV_TT=riscv64-unknown-elf

         # Binary folder for gcc, as, ld, etc.
         RISCV_BIN=${RISCV_DIR}/bin

         # .a library folder for libc, etc
         RISCV_LIB=${RISCV_DIR}/${RISCV_TT}/lib/rv32i/ilp32

         # .h include folder for libc, etc
         RISCV_INC=${RISCV_DIR}/${RISCV_TT}/include

         # GCC library to use
         RISCV_GCC_LIB=rv32i/ilp32

         # Python3 command
         PYTHON3=python3

Step 3: Compile examples
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: console

   make firmware

Step 4: Edit the default program
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The default program is located in ``AsteRISC-firmware/firmware/user_programs/my_asterisc_program``. 
You can edit the source code in ``src/my_asterisc_program.c``.

Compile from the AsteRISC root directory or the AsteRISC-firmware directory with:

.. code-block:: console

   make firmware

Or from the ``my_asterisc_program`` directory with simply:

.. code-block:: console

   make

Step 5: Run a simulation of your program
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: console

   make sim

Step 6: Add new programs
~~~~~~~~~~~~~~~~~~~~~~~~

Follow the instructions in section :doc:`/userguide/software/user_programs` to add new programs.

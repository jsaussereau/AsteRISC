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

.. code-block:: console

   git clone https://github.com/riscv/riscv-gnu-toolchain
   ./configure --prefix=/opt/riscv --with-arch=rv32ima --with-abi=ilp32 --enable-multilib
   make


Step 2: Setup your environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Edit AsteRISC-firmware/riscv-env to set the path to your RISC-V toolchain installation.

For instance:

.. code-block:: console

   RISCV_DIR=/opt/riscv32
   RISCV_BIN=${RISCV_DIR}/bin
   RISCV_TC=riscv32
   PYTHON3=python3

Step 3: Compile examples
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: console

   make firmware

Step 4: Edit the default program
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The default program is located in ``AsteRISC-firmware/firmware/user_programs/my_asterisc_program``. 
You edit the source code in my_asterisc_program.c.

You can compile from the AsteRISC root directory or the AsteRISC-firmware directory with:

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
User Programs
=============

Add your own programs
---------------------

Step 1: Configure the RISC-V environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Follow the steps in section :doc:`/userguide/software/index` to setup your environment.

Step 2: Create a new program
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To create a new user program, use the following command in the root of the repository:

.. code-block:: console

   make new NAME=your_program_name

To remove an existing user program, use:

.. code-block:: console

   make del NAME=your_program_name

Step 4: Edit your program
~~~~~~~~~~~~~~~~~~~~~~~~~

Your newly created program is located in ``AsteRISC-firmware/firmware/user_programs/your_program_name``. 

You can edit the source code in ``main.c``. 
You are free to rename this file and add as many other ``.c`` or ``.h`` source files as needed.

.. warning::

   Please note that the program entry point is a function named ``_entry`` and not ``main`` as in standard C programs.

.. note::

   Feel free to copy and modify the example programs provided in the ``AsteRISC-firmware/firmware/user_programs/examples`` directory to get started quickly.

Step 5: Add any required libraries or RISC-V extensions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If your program requires additional libraries or RISC-V extensions, you can add them to the ``Makefile`` located in the same directory as your program.

For example, a simple program requiring only GPIO access would have a Makefile like this:

.. code-block:: makefile
   :linenos:
   :lineno-start: 22

   # […]
   MARCH  = -march=rv32i -mabi=ilp32
   LIBS   = -lasterisc -lgpio
   # […]

Another program using UART and the ``M`` RISC-V extension would have a Makefile like this:

.. code-block:: makefile
   :linenos:
   :lineno-start: 22

   # […]
   MARCH  = -march=rv32im -mabi=ilp32
   LIBS   = -lasterisc -lgpio -luart
   # […]

Step 4: Compile your program
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can compile from the AsteRISC root directory or the AsteRISC-firmware directory with:

.. code-block:: console

   make firmware

Or from the ``your_program_name`` directory with simply:

.. code-block:: console

   make

************
Installation
************

Get AsteRISC
============

Step 1: Clone the repository
----------------------------

.. tabs::

   .. group-tab:: Ubuntu/Debian

      .. code-block:: console

         sudo apt update
         sudo apt install -y git
         git clone https://github.com/jsaussereau/AsteRISC.git
         cd AsteRISC/
         git submodule update --init --recursive

   .. group-tab:: Fedora/CentOS/AlmaLinux

      .. code-block:: console

         sudo dnf update
         sudo dnf install -y git
         git clone https://github.com/jsaussereau/AsteRISC.git
         cd AsteRISC/
         git submodule update --init --recursive

   .. group-tab:: Arch Linux

      .. code-block:: console

         sudo pacman -Syu
         sudo pacman -S git --noconfirm
         git clone https://github.com/jsaussereau/AsteRISC.git
         cd AsteRISC/
         git submodule update --init --recursive

Install Odatix
==============

Step 1: Install Python 3.6+ and make
------------------------------------

.. tabs::

   .. group-tab:: Ubuntu/Debian

      .. code-block:: bash

         sudo apt update
         sudo apt install -y python3 python3-pip python3-venv make

   .. group-tab:: Fedora/CentOS/AlmaLinux

      .. code-block:: bash

         sudo dnf update
         sudo dnf install -y python3 make

   .. group-tab:: Arch Linux

      .. code-block:: bash

         sudo pacman -Syu
         sudo pacman -S python3 make --noconfirm

Step 2: Configure a virtual environment [*Optional*]
----------------------------------------------------

.. code-block:: bash

   # Create a virtual environment
   python3 -m venv odatix_venv
   # Activate the virtual environment
   source odatix_venv/bin/activate # You have to run this command at every new shell session

Step 3: Install the package
----------------------------

.. code-block:: bash

   python3 -m pip install odatix


Install EDA tools
=================

To run command from the :doc:`/userguide/quick_start` section to work, you need the following tools:

- Verilator 5+

.. warning::
   Depending on your system, to have Verilator 5+, you may have to build it `from source <https://verilator.org/guide/latest/install.html#git-quick-install>`_.
   Concerned distributions include: Ubuntu 22.04 and older, Debian 11 and older, Fedora 38 and older.

- Vivado

.. note::
   Vivado ML standard edition is a free Vivado version with no license requirements.

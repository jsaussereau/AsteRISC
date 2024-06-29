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
         cd Asterism/

   .. group-tab:: Fedora/CentOS/AlmaLinux

      .. code-block:: console

         sudo dnf update
         sudo dnf install -y git
         git clone https://github.com/jsaussereau/AsteRISC.git
         cd Asterism/

   .. group-tab:: Arch Linux

      .. code-block:: console

         sudo pacman -Syu
         sudo pacman -S git --noconfirm
         git clone https://github.com/jsaussereau/AsteRISC.git
         cd Asterism/


Install Asterism
================

Step 1: Install Python 3.6+ and make
------------------------------------

.. tabs::

   .. group-tab:: Ubuntu/Debian

      .. code-block:: console

         sudo apt install -y python3 make

   .. group-tab:: Fedora/CentOS/AlmaLinux

      .. code-block:: console

         sudo dnf install -y python3 make

   .. group-tab:: Arch Linux

      .. code-block:: console

         sudo pacman -S python3 make --noconfirm

Step 2: Install Python requirements
-----------------------------------

Option #1: Using pipx (recommended)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tabs::

   .. group-tab:: Ubuntu/Debian

      .. code-block:: console

         cd Asterism
         sudo apt install -y pipx
         make pipx_install
         pipx ensurepath

   .. group-tab:: Fedora/CentOS/AlmaLinux

      .. code-block:: console

         cd Asterism
         sudo dnf install -y pipx
         make pipx_install
         pipx ensurepath

   .. group-tab:: Arch Linux

      .. code-block:: console
         
         cd Asterism
         sudo pacman -S python-pipx --noconfirm
         make pipx_install
         pipx ensurepath

.. warning::
   If the directory where pipx stores apps was not already in your PATH environment variable, you have to start a new shell session before running Asterism

Option #2: Using pip
~~~~~~~~~~~~~~~~~~~~

.. tabs::

   .. group-tab:: Ubuntu/Debian

      .. code-block:: console
         
         cd Asterism
         sudo apt install python3-pip
         pip3 install -r requirements.txt

   .. group-tab:: Fedora/CentOS/AlmaLinux

      .. code-block:: console

         cd Asterism
         sudo dnf install python3-pip
         pip3 install -r requirements.txt

   .. group-tab:: Arch Linux

      .. code-block:: console

         cd Asterism
         sudo pacman -Sy python-pip
         pip3 install -r requirements.txt

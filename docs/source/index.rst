|logo| AsteRISC
===============

.. |AsteRISC| image:: https://img.shields.io/badge/GitHub-AsteRISC-blue.svg?logo=github
  :target:  https://github.com/jsaussereau/AsteRISC

.. |AsteRISCrtl| image:: https://img.shields.io/badge/GitHub-AsteRISC--rtl-blue.svg?logo=github
  :target:  https://github.com/jsaussereau/AsteRISC-rtl

.. |License| image:: https://img.shields.io/github/license/jsaussereau/AsteRISC
  :target:  https://github.com/jsaussereau/AsteRISC/blob/main/LICENSE

.. |Cite| image:: https://img.shields.io/badge/cite-DOI%3A10.1109%2FISCAS46773.2023.10181330-green
  :target: https://doi.org/10.1109/ISCAS46773.2023.10181330

.. |Docs| image:: https://readthedocs.org/projects/asterisc/badge/?version=latest
  :target:  https://asterisc.readthedocs.io

.. |GitHub| image:: https://img.shields.io/badge/GitHub-Asterism-blue.svg?logo=github
  :target:  https://github.com/jsaussereau/Asterism

.. centered:: |AsteRISC| |AsteRISCrtl| |License| |Cite| |Docs|

Overview
---------

.. |logo| image:: images/asterisc_logo.png
  :width: 30
  :target: index.html

**AsteRISC** is a flexible multi-cycle RISC-V core designed for design space exploration. 

It is written in platform-independent SystemVerilog and targets both FPGAs and ASIC technologies.

Supported RISC-V extensions: ``RV32``\[``I``/``E``][``M``][``C``][``Zicsr``]

Key Features
------------

- Architectural flexibility for generating a wide array of microarchitectures.
- Designed to cater to diverse performance requirements and application scenarios.
- Suited for both FPGA and physical (ASIC) implementation.
- Uses `Odatix <https://github.com/jsaussereau/Odatix>`_ to help you find the configuration that best suits your application needs.

Contents
--------

.. toctree::
  :caption: User Guide

  userguide/installation
  userguide/quick_start

.. toctree::
  :caption: Documentation

  documentation/principle
  documentation/stages

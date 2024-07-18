/**********************************************************************\
*                               AsteRISC                               *
************************************************************************
*
* Copyright (C) 2022 Jonathan Saussereau
*
* This file is part of AsteRISC.
* AsteRISC is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
* 
* AsteRISC is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
* 
* You should have received a copy of the GNU General Public License
* along with AsteRISC. If not, see <https://www.gnu.org/licenses/>.
*
*/ 
 
`ifndef __SOC_CONFIG__
`define __SOC_CONFIG__

/*****************************************************
                Choose the target here                
*****************************************************/

//`define TARGET_ASIC_XFAB
//`define TARGET_ASIC_ST28CMOSFDSOI
//`define TARGET_ASIC_ST130BiCMOS9MW
//`define TARGET_FPGA_XC7K325T
//`define TARGET_FPGA_XC7A100T
//`define TARGET_FPGA_XC7A15T
//`define TARGET_FPGA_XA7S6
`define TARGET_SIM

/*****************************************************
                  Synthesis Settings                  
*****************************************************/

// Keep hierarchy after synthesis?
//`define KEEP_HIERARCHY (* keep_hierarchy = "yes" *) // more accurate utilization reports
`define KEEP_HIERARCHY (* keep_hierarchy = "no" *)  // higher max frequency

// Do synthesis with pads (ASIC)? 
`define USE_PADS

`endif // __SOC_CONFIG__

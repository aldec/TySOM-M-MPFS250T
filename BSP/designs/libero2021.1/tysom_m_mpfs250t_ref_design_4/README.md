<a href="https://www.aldec.com/en">
  <img src="https://www.aldec.com/files/file/Aldec_Crescent_rgb_sm.png" width="500" alt="Aldec, Inc. logo" />
</a>

# TySOM-M-MPFS250T Reference design 4

## Table of Content
- [Introduction](#introduction)
- [Supported Interfaces](#supported-interfaces)
- [Generating the design](#generating-design)
- [Running HDMI test](#running-hdmi-test)

## Introduction <a name="introduction"/>

The reference TySOM-M-MPFS250T design is a basic design for this board. The design is provided as a TCL script that will generate the design with the base components in the FPGA (HDMI, DDR) and the microprocessor subsystem from mss directory. 

## Supported Interfaces <a name="supported-interfaces"/>

The following interfaces and modules are supported in this reference design.

1. MSS Interfaces/Modules

| Interface/Module Name | Version | HSS version |
| --------------------- |:-------:|:-----------:|
| DDR                   | 2021.1  | Patch v1.0  |
| USB                   | 2021.1  | Patch v1.0  |
| I2C1                  | 2021.1  | Patch v1.0  |
| ETH1                  | 2021.1  | Patch v1.0  |
| ETH2                  | 2021.1  | Patch v1.0  |
| ETH MDIO              | 2021.1  | Patch v1.0  |
| UART                  | 2021.1  | Patch v1.0  |
| uSD/eMMC              | 2021.1  | Patch v1.0  |
| GPIO LED0             | 2021.1  | Patch v1.0  |
| GPIO PUSHBUTTON       | 2021.1  | Patch v1.0  |
| eMMC                  | 2021.1  | Patch v1.0  |

2. Fabric Interfaces/Modules

| Interface/Module Name | Version | HSS version |
| --------------------- |:-------:|:-----------:|
| DDR                   | 2021.1  | Patch v1.0  |
| HDMI                  | 2021.1  | Patch v1.0  |

## Generating the design <a name="generating-design"/>

The following steps needs to be performed to generate the reference design:
- open Libero and press **Project->Execute Script**
- select the desired TCL script
  - The TySOM-M-MPFS250T_SD.tcl will generate the design which will use the SD card,
  - The TySOM-M-MPFS250T_eMMC.tcl will generate the design which will use the eMMC
- wait few seconds for the design generation
- In the Design Flow tab double click on the Generate FPGA Array Data and wait until finish
- double click on Configure Design Initialization Data and Memories and select the eNVM tab. 
- press Add->Add Boot Mode 1 Client and select the hss.hex file built in the hss directory.
- Generate Bitstream, and Run PROGRAM action in Design Flow tab.

## Running HDMI test <a name="running-hdmi-test"/>

1. Go to the directory with the HDMI bash scripts:

`   cd /root`

2. Execute the script to initialize the ADV7511 module:

`   ./config_adv7511.sh`

3. Execute the script that starts the color change procedure:

`   ./change_colours.sh`

4. Example log from running script:

```
   Take a look at the HDMI screen. The colours should change.
   Script in progress.........
   The script ended successfully!
```


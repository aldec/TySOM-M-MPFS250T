<a href="https://www.aldec.com/en">
  <img src="https://www.aldec.com/files/file/Aldec_Crescent_rgb_sm.png" width="500" alt="Aldec, Inc. logo" />
</a>

# TySOM-M-MPFS250T BSP
This repository provides all necessary files for building and running Linux OS on TySOM-M-MPFS250T board.

## Table of Content
- [Introduction](#introduction)
- [Requirements](#requirements)
    - [Hardware](#requirements-hardware)
    - [Software](#requirements-software)
- [BSP structure](#bsp-structure)
- [Supported Interfaces](#supported-interfaces)
- [Reference designs](#reference-design)
- [Limitations](#limitations)
- [Known problems and issues](#known-problems)

## Introduction <a name="introduction"/>
[TySOM-M-MPFS250T](https://www.aldec.com/en/products/emulation/tysom_boards/polarfire_microchip/tysom_m_mpfs250) is Aldec board based on PolarFire SoC MPFS250T-ES, the first SoC FPGA with 64-bit RISC-V multi-core microprocessor subsystem. There are a few steps that needs to be done to boot Linux on the board:
1. Bitfile generation using Libero SoC with FPGA and microprocessor subsystem configuration.
This repository contains two microprocessor subsystem configurations in mss directory. One is for the design which uses eMMC memory, second is for the design which uses SD Card. In the designs/libero2021.1/reference_design directory there are files to generate two versions of reference design for TySOM-M-MPFS250T using Libero ( with eMMC and with SD Card ).
2. Building Hart Software Services baremetal application for TySOM-M-MPFS250T.
Aldec delivers a patch for official HSS repository which adds TySOM-M-MPFS250T support. HSS is the baremetal application which is zero stage boot loader (ZSBL) in this flow.
3. Linux OS
Aldec Yocto Project layer that needs to be added to the PolarFire SoC Yocto Project repository to build the Linux.

## Requirements <a name="requirements"/>

### Hardware <a name="requirements-hardware"/>
- TySOM-M-MPFS250T
- PMOD/UART extension is needed.
- FlashPro 5 programmer
- 2 x Mini USB Cable

### Software <a name="requirements-software"/>
- Libero 2021.1
- SoftConsole 2021.1

## BSP structure <a name="bsp-structure"/>

Aldec TySOM-M-MPFS250T BSP is composed of the following components:
- baremetal - A set of baremetal applications to use with the board.
- designs - A set of reference designs to demonstrate how to use different interfaces on the board.
- doc - Foder with documentations.
- hss - An Aldec patch for Hart Software Services for TySOM-M-MPFS250T board.
- mss - PolarFire SoC MSS Configuration project for TySOM-M-MPFS250T.
- yocto - Yocto Project layer for Aldec TySOM-M-MPFS250T board.

## Supported Interfaces <a name="supported-interfaces"/>

1. MSS Interfaces

| Interface Name  | Version | HSS version |
| --------------- |:-------:|:-----------:|
| DDR             | 2021.1  | Patch v1.0  |
| USB             | 2021.1  | Patch v1.0  |
| ETH1            | 2021.1  | Patch v1.0  |
| ETH2            | 2021.1  | Patch v1.0  |
| ETH MDIO        | 2021.1  | Patch v1.0  |
| UART            | 2021.1  | Patch v1.0  |
| uSD/eMMC        | 2021.1  | Patch v1.0  |
| GPIO LED0       | 2021.1  | Patch v1.0  |
| GPIO PUSHBUTTON | 2021.1  | Patch v1.0  |

2. Fabric Interfaces

| Interface Name | Version | HSS version |
| -------------- |:-------:|:-----------:|
| DDR-HSIO       | 2021.1  | Patch v1.0  |
| PMOD           | 2021.1  | Patch v1.0  |
| HDMI           | 2021.1  | Patch v1.0  |
| GPIO           | 2021.1  | Patch v1.0  |
| USER SWITCH    | 2021.1  | Patch v1.0  |
| CoreUartapb    | 2021.1  | Patch v1.0  |
| CAN            | 2021.1  | Patch v1.0  |

## Reference design <a name="reference-design"/>
The BSP package contains as well a set of [reference designs](https://github.com/aldec/TySOM-M-MPFS250T/tree/master/BSP/designs) which can be used by customers.

## Limitations <a name="limitations"/>
- USB Driver - The Microsemi Linux Device Driver for USB does not support the OTG mode. The USB works in the HOST mode when using Linux OS. The mini USB cable (with USB OD shorted to GND) must be plugged in before booting Linux, because the driver does not monitor the USB ID in runtime.

**WARNING: Connecting another USB device in Host mode when the USB VBUS voltage is provided can damage the FPGA and the board.**

- SPI Driver - Lack of Microsemi Linux Device Driver for PolarFire SPI controller.

- PolarFire SoC SPI Master programming mode using onboard memory is not supported on this release.

## Known problems and issues <a name="known-problems"/>
Below is the list of known problems and issues. The issues with (Microchip) label at the beginning are under investigation or development on the Microchip side.

Issue 1: The reboot Linux command cause the system crash.

Solution: Microchip recommends powering off/on the board instead of reboot command.

---

Issue 2: Programming the board via JTAG with bit file cause the Linux boot hangs after first run after the programming.

Solution: Microchip recommendation is to do power off/on the board after the programming.

---

Issue 3: The I2C Microchip Linux Device driver can cause hang of the I2C bus while communication with SI7055 temperature sensor.

Solution: The issue is under investigation. To restore I2C bus state the reboot is required.

---

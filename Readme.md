FPGA-SoC-Linux-Kernel-6.1
====================================================================================

Overview
------------------------------------------------------------------------------------

### Introduction

This Repository provides a Linux Kernel (v6.1.22) Image and Device Trees for FPGA-SoC.

### Note

**The Linux Kernel Image provided in this repository is not official.**

**I modified it to my liking. Please handle with care.**

### Features

* Hardware
  + ZYBO    : Xilinx Zynq-7000 ARM/FPGA SoC Trainer Board by Digilent
  + ZYBO-Z7 : Xilinx Zynq-7020 Development Board by Digilent
  + PYNQ-Z1 : Python Productive for Zynq by Digilent
  + DE0-Nano-SoC : Altera SoC FPGA Development Kit by Terasic
  + DE10-Nano    : Altera SoC FPGA Development Kit by Terasic
* Linux Kernel Version 6.1.22
  + Available in both Xilinx-Zynq-7000 and Altera-SoC in a single image
  + Enable Device Tree Overlay
  + Enable FPGA Manager
  + Enable FPGA Bridge
  + Enable FPGA Reagion
  + Patch for issue #3(USB-HOST does not work with PYNQ-Z1)


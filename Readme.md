FPGA-SoC-Linux-Kernel-6.1
====================================================================================

Overview
------------------------------------------------------------------------------------

### Introduction

This Repository provides a Linux Kernel (v6.1.22) Image and Device Trees for FPGA-SoC.

### Note

**The Linux Kernel Image provided in this repository is not official.**    
**I modified it to my liking. Please handle with care.**    

**Downloading the entire repository takes time, so download the files from URL**   

https://github.com/ikwzm/FPGA-SoC-Linux-Kernel-6.1/releases/6.1.22-armv7-fpga-6

### Features

* Hardware
  + ZYBO    : AMD(Xilinx) Zynq-7000 ARM/FPGA SoC Trainer Board by Digilent
  + ZYBO-Z7 : AMD(Xilinx) Zynq-7020 Development Board by Digilent
  + PYNQ-Z1 : Python Productive for Zynq by Digilent
  + DE0-Nano-SoC : Intel(Altera) SoC FPGA Development Kit by Terasic
  + DE10-Nano    : Intel(Altera) SoC FPGA Development Kit by Terasic
* Linux Kernel Version 6.1.22
  + Available in both Xilinx-Zynq-7000 and Altera-SoC in a single image
  + Enable Device Tree Overlay
  + Enable FPGA Manager
  + Enable FPGA Bridge
  + Enable FPGA Reagion
  + Patch for issue #3(USB-HOST does not work with PYNQ-Z1)

Files
------------------------------------------------------------------------------------

* vmlinuz-6.1.22-armv7-fpga-6
* linux-headers-6.1.22-armv7-fpga_6.1.22-armv7-fpga-6_armhf.deb
* linux-image-6.1.22-armv7-fpga_6.1.22-armv7-fpga-6_armhf.deb
* ./devicetrees/6.1.22-armv7-fpga-6/
  + socfpga_cyclone5_de0_nano_soc.dtb
  + zynq-pynqz1.dtb
  + zynq-zybo-z7.dtb
  + zynq-zybo.dtb
* [./files/config-6.1.22-armv7-fpga-6](./files/config-6.1.22-armv7-fpga-6)

Build
------------------------------------------------------------------------------------

* [./doc/build/linux-kernel-6.1.22.md](./doc/build/linux-kernel-6.1.22.md)

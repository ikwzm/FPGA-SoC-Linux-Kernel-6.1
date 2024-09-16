#!/bin/bash

script_description="FPGA-SoC-Linux-Kernel Installer"

target_kernel_image="vmlinuz-\${kernel_release}"
target_uenv_txt="uEnv-linux-\${kernel_release}.txt"

target_id_list="$target_id_list zynq_zybo_z7"
zynq_zybo_z7_pattern="ZYBO-Z7 zybo-z7 zyboz7"
zynq_zybo_z7_dtb_source="zynq-zybo-z7.dtb"
zynq_zybo_z7_dtb_target="devicetree-\${kernel_release}-zynq-zybo-z7.dtb"
zynq_zybo_z7_dts_target="devicetree-\${kernel_release}-zynq-zybo-z7.dts"

target_id_list="$target_id_list zynq_zybo"
zynq_zybo_pattern="ZYBO zybo"
zynq_zybo_dtb_source="zynq-zybo.dtb"
zynq_zybo_dtb_target="devicetree-\${kernel_release}-zynq-zybo.dtb"
zynq_zybo_dts_target="devicetree-\${kernel_release}-zynq-zybo.dts"

target_id_list="$target_id_list zynq_pynqz1"
zynq_pynqz1_pattern="PYNQ-Z1 pynq-z1 pynqz1"
zynq_pynqz1_dtb_source="zynq-pynqz1.dtb"
zynq_pynqz1_dtb_target="devicetree-\${kernel_release}-zynq-pynqz1.dtb"
zynq_pynqz1_dts_target="devicetree-\${kernel_release}-zynq-pynqz1.dts"

target_id_list="$target_id_list socfpga_de10_nano"
socfpga_de10_nano_pattern="DE10-Nano de10-nano"
socfpga_de10_nano_dtb_source="socfpga_cyclone5_de0_nano_soc.dtb"
socfpga_de10_nano_dtb_target="devicetree-\${kernel_release}-socfpga.dtb"
socfpga_de10_nano_dts_target="devicetree-\${kernel_release}-socfpga.dts"

target_id_list="$target_id_list socfpga_de0_nano_soc"
socfpga_de0_nano_soc_pattern="DE0-Nano-SoC de0-nano-soc"
socfpga_de0_nano_soc_dtb_source="socfpga_cyclone5_de0_nano_soc.dtb"
socfpga_de0_nano_soc_dtb_target="devicetree-\${kernel_release}-socfpga.dtb"
socfpga_de0_nano_soc_dts_target="devicetree-\${kernel_release}-socfpga.dts"


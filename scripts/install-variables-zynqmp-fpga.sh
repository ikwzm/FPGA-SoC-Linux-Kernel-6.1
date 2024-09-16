#!/bin/bash

script_description="ZynqMP-FPGA-Linux-Kernel Installer"

target_kernel_image="image-\${kernel_release}"
target_uenv_txt="uEnv-linux-\${kernel_release}.txt"

target_id_list="$target_id_list uz3eg_iocc"
uz3eg_iocc_pattern="UltraZed-EG-IOCC"
uz3eg_iocc_dtb_source="zynqmp-uz3eg-iocc.dtb"
uz3eg_iocc_dtb_target="devicetree-\${kernel_release}-uz3eg-iocc.dtb"
uz3eg_iocc_dts_target="devicetree-\${kernel_release}-uz3eg-iocc.dts"

target_id_list="$target_id_list ultra96"
ultra96_pattern="Ultra96 ultra96"
ultra96_dtb_source="avnet-ultra96-rev1.dtb"
ultra96_dtb_target="devicetree-\${kernel_release}-ultra96.dtb"
ultra96_dts_target="devicetree-\${kernel_release}-ultra96.dts"

target_id_list="$target_id_list ultra96v2"
ultra96v2_pattern="Ultra96v2 ultra96v2 Ultra96-V2"
ultra96v2_dtb_source="avnet-ultra96v2-rev1.dtb"
ultra96v2_dtb_target="devicetree-\${kernel_release}-ultra96v2.dtb"
ultra96v2_dts_target="devicetree-\${kernel_release}-ultra96v2.dts"

target_id_list="$target_id_list kv260_revB"
kv260_revB_pattern="Kv260 kv260"
kv260_revB_dtb_source="zynqmp-kv260-revB.dtb"
kv260_revB_dtb_target="devicetree-\${kernel_release}-kv260-revB.dtb"
kv260_revB_dts_target="devicetree-\${kernel_release}-kv260-revB.dts"

target_id_list="$target_id_list kr260_revB"
kr260_revB_pattern="Kr260 kr260"
kr260_revB_dtb_source="zynqmp-kr260-revB.dtb"
kr260_revB_dtb_target="devicetree-\${kernel_release}-kr260-revB.dtb"
kr260_revB_dts_target="devicetree-\${kernel_release}-kr260-revB.dts"


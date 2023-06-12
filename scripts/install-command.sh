#!/bin/bash

set -e
script_name=$0
verbose=0
dry_run=0
error=0
output_directory=""
target_list=""
run_help=0
run_install_directory=1
run_install_image=1

do_help_option()
{
    if [ -z "$2" ]; then
        echo "    $1"
    else
        echo "    $1 (default=$2)"
    fi
}

do_help()
{
    echo "NAME"
    echo "    $script_name - FPGA-SoC-Linux-Kernel Installer"
    echo ""
    echo "SYNOPSYS"
    echo "    $script_name [<options>] TARGET..."
    echo ""
    echo "DESCRIPTION"
    echo "    ZynqMP-FPGA-Linux-Kernel Installer"
    echo ""
    echo "TARGET"
    echo "    ZYBO-Z7|zybo-z7"
    echo "    ZYBO|zybo"
    echo "    PYNQ-Z1|pynq-z1|pynqz1"
    echo "    DE10-Nano|de10-nano"
    echo "    DE0-Nano-SoC|de0-nano-soc"
    echo ""
    echo "OPTIONS"
    do_help_option "-h, --help                  Run Help command"
    do_help_option "-n, --dry-run               Don't actually run any command"
    do_help_option "-v, --verbose               Turn on verbosity"
    do_help_option "-d, --directory      <args> Target directory"
    do_help_option "-T, --dt-only               Install Device Tree Only"
    do_help_option "-R, --kernel-release <args> Kernel Release" "$KERNEL_RELEASE"
    do_help_option "-V, --kernel-version <args> Kernel version" "$KERNEL_VERSION"
    do_help_option "-L, --local-version  <args> Local version " "$LOCAL_VERSION"
    do_help_option "-B, --build-version  <args> Build version " "$BUILD_VERSION"
    echo ""
}

run_command()
{
    if [ $dry_run -ne 0 ] || [ $verbose -ne 0 ]; then
	echo "$1"
    fi
    if [ $dry_run -eq 0 ]; then
	eval "$1"
    fi
}

if [ $# -eq 0 ]; then
    run_help=1
fi

while [ $# -gt 0 ]; do
    case "$1" in
	-h|--help)
	    run_help=1
	    shift
	    ;;
	-v|--verbose)
	    verbose=1
	    shift
	    ;;
	-n|--dry-run)
	    dry_run=1
	    shift
	    ;;
	-d|--directory)
	    shift
	    output_directory=$1
	    shift
	    ;;
	-T|--dt-only)
	    run_install_image=0
	    shift
	    ;;
	-R|--kernel-release)
	    shift
	    kernel_release=$1
	    shift
	    ;;
	-V|--kernel-version)
	    shift
	    kernel_version=$1
	    shift
	    ;;
	-L|--local-version)
	    shift
	    local_version=$1
	    shift
	    ;;
	-B|--build-version)
	    shift
	    build_version=$1
	    shift
	    ;;
	ZYBO-Z7|zybo-z7)
	    target_list="$target_list ZYBO-Z7"
	    shift
	    ;;
	ZYBO|zybo)
	    target_list="$target_list ZYBO"
	    shift
	    ;;
	PYNQ-Z1|pynq-z1|pynqz1)
	    target_list="$target_list PYNQ-Z1"
	    shift
	    ;;
	DE10-Nano|de10-nano)
	    target_list="$target_list DE10-Nano"
	    shift
	    ;;
	DE0-Nano-SoC|de0-nano-soc)
	    target_list="$target_list DE0-Nano-SoC"
	    shift
	    ;;
	*)
	    echo "Error: Not Support Target $1"
	    error=1
	    run_help=1
	    shift
	    ;;
    esac
done

if [ $run_help -ne 0 ] ; then
    do_help
    exit 0
fi

if [ -z "$REPO_DIR" ]; then
    REPO_DIR=`pwd`
fi

if [ -z "$kernel_version" ] && [ -n "$KERNEL_VERSION" ]; then
    kernel_version="$KERNEL_VERSION"
fi

if [ -z "$local_version"  ] && [ -n "$LOCAL_VERSION"  ]; then
    local_version="$LOCAL_VERSION"
fi

if [ -z "$build_version"  ] && [ -n "$BUILD_VERSION"  ]; then
    build_version="$BUILD_VERSION"
fi

if [ -z "$kernel_release" ] && [ -n "$KERNEL_RELEASE" ]; then
    kernel_release="$KERNEL_RELEASE"
fi

if [ -z "$kernel_release" ] && [ -n "$kernel_version" ] && [ -n "$local_version" ]; then
    kernel_release="$kernel_version-$local_version"
fi

if [ -z "$kernel_release" ]; then
    echo "Error: Kernel Release is not specified"
    error=1
fi

if [ -z "$build_version"  ]; then
    echo "Error: Build Version is not specified"
    error=1
fi

if [ -z "$output_directory" ]; then
    echo "Error: Target Directory is not specified"
    error=1
fi

if [ $verbose -ne 0 ]; then
    echo "# KERNEL_RELEASE  = " $kernel_release
    echo "# BUILD_VERSION   = " $build_version
    echo "# TARGET          = " $target_list
    echo "# TARGET_DIRECTRY = " $output_directory
fi

if [ $error -ne 0 ]; then
    exit 1
fi

if [ ! -e "$REPO_DIR/vmlinuz-$kernel_release-$build_version" ]; then
    echo "Error: Not found vmlinuz-$kernel_release-$build_version in $REPO_DIR"
    error=1
fi

if [ ! -e "$REPO_DIR/devicetrees/$kernel_release-$build_version" ]; then
    echo "Error: Not found devicetrees/$kernel_release-$build_version in $REPO_DIR"
    error=1
fi

if [ $error -ne 0 ]; then
    exit 1
fi

if [ $run_install_directory -ne 0 ]; then
    run_command "install -d $output_directory"
fi

if [ $run_install_image -ne 0 ]; then
    run_command "cp $REPO_DIR/vmlinuz-$kernel_release-$build_version $output_directory/vmlinuz-$kernel_release"
fi

do_dtb_install()
{
    local dtb_source=""
    local dtb_target=""
    local dts_target=""
    if [ $dry_run -ne 0 ] || [ $verbose -ne 0 ]; then
	echo "# do_dtb_install($1)"
    fi    
    case "$1" in
	ZYBO-Z7)
	    dtb_source=zynq-zybo-z7.dtb
	    dtb_target=devicetree-$kernel_release-zynq-zybo-z7.dtb
	    dts_target=devicetree-$kernel_release-zynq-zybo-z7.dts
	    ;;
	ZYBO)
	    dtb_source=zynq-zybo.dtb
	    dtb_target=devicetree-$kernel_release-zynq-zybo.dtb
	    dts_target=devicetree-$kernel_release-zynq-zybo.dts
	    ;;
	PYNQ-Z1)
	    dtb_source=zynq-pynqz1.dtb
	    dtb_target=devicetree-$kernel_release-zynq-pynqz1.dtb
	    dts_target=devicetree-$kernel_release-zynq-pynqz1.dts
	    ;;
	DE10-Nano)
	    dtb_source=socfpga_cyclone5_de0_nano_soc.dtb
	    dtb_target=devicetree-$kernel_release-socfpga.dtb
	    dts_target=devicetree-$kernel_release-socfpga.dts
	    ;;
	DE0-Nano-SoC)
	    dtb_source=socfpga_cyclone5_de0_nano_soc.dtb
	    dtb_target=devicetree-$kernel_release-socfpga.dtb
	    dts_target=devicetree-$kernel_release-socfpga.dts
	    ;;
    esac
    if [ -z "$dtb_source" ]; then
        echo "Error: Device Tree not specified"
        return 1
    fi
    if [ ! -e "$REPO_DIR/devicetrees/$kernel_release-$build_version/$dtb_source" ]; then
        echo "Error: Not found $dtb_source in $REPO_DIR/devicetrees/$kernel_release-$build_version"
        return 1
    fi
	
    run_command "cp $REPO_DIR/devicetrees/$kernel_release-$build_version/$dtb_source $output_directory/$dtb_target"
    run_command "dtc -I dtb -O dts --symbols -o $output_directory/$dts_target $output_directory/$dtb_target"
    return 0
}

if [ -n "$target_list" ]; then
    set $target_list
    while [ $# -gt 0 ]; do
        do_dtb_install $1
        shift
    done
fi

#!/bin/bash

set -e
script_name=$0
script_dir=$(cd $(dirname $0); pwd)
script_version="0.1"
verbose=0
dry_run=0
error=0
output_directory=""
target_list=""
run_help=0
run_install_directory=1
run_install_image=1
run_install_dtb=1
run_generate_uenv=0

if [ -e "$script_dir/install-variables.sh" ]; then
    . "$script_dir/install-variables.sh"
fi

get_install_variable()
{
    local var=$(eval echo "\${$1}")
    echo $var
}

eval_install_variable()
{
    local var=$(eval echo "\${$1}")
    eval echo $var
}

do_help_option()
{
    if [ -z "$2" ]; then
        echo "    $1"
    else
        echo "    $1 (default=$2)"
    fi
}

do_help_target_list()
{
    local target_id
    local pattern_list=""
    for target_id in $(get_install_variable "target_id_list") ; do
        pattern_list=$(get_install_variable "${target_id}_pattern")
        echo "    ${pattern_list// / | }"
    done
}

do_help_examples()
{
    local target_id
    local target_name=""
    local pattern_list=""
    for target_id in $(get_install_variable "target_id_list") ; do
	if [ -z "$target_name" ]; then
            pattern_list=$(get_install_variable "${target_id}_pattern")
	    target_name="${pattern_list%% *}"
        fi
    done
    if [ -n "$target_name" ]; then
        echo "EXAMPLE"
        echo "    ${script_name} -d /mnt/boot/ -v ${target_name}"
        echo ""
    fi
}

do_help()
{
    local script_description=$(get_install_variable "script_description")
    echo "NAME"
    echo "    $script_name - ${script_description} ${script_version}"
    echo ""
    echo "SYNOPSYS"
    echo "    $script_name [<options>] TARGET..."
    echo ""
    echo "DESCRIPTION"
    echo "    ${script_description}"
    echo ""
    echo "TARGET"
    do_help_target_list
    echo ""
    echo "OPTIONS"
    do_help_option "-h, --help                  Run Help command"
    do_help_option "-n, --dry-run               Don't actually run any command"
    do_help_option "-v, --verbose               Turn on verbosity"
    do_help_option "-d, --directory      <args> Target directory"
    do_help_option "-T, --dt-only               Install Device Tree Only"
    do_help_option "-U, --uenv-generate         Generate example uEnv.txt for u-boot"
    do_help_option "-R, --kernel-release <args> Kernel Release" "$KERNEL_RELEASE"
    do_help_option "-V, --kernel-version <args> Kernel version" "$KERNEL_VERSION"
    do_help_option "-L, --local-version  <args> Local version " "$LOCAL_VERSION"
    do_help_option "-B, --build-version  <args> Build version " "$BUILD_VERSION"
    echo ""
    do_help_examples
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
	-U|--uenv-generate)
	    run_generate_uenv=1
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
	*)
	    target_found=0
            for target_id in $(get_install_variable "target_id_list") ; do
		if [ "$target_found" -eq 0 ]; then
		    for target_pattern in $(get_install_variable "${target_id}_pattern") ; do
                        case "$1" in
			    $target_pattern )
		                target_list="$target_list $target_id"
				target_found=1
			        ;;
			    *)
			        ;;
		        esac
		    done
		fi
	    done
	    if [ "$target_found" -eq 0 ] ; then
	        echo "Error: Not Support Target $1"
	        error=1
	        run_help=1
	    fi
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
    echo "# SCRIPT NAME     = " $script_name
    echo "# SCRIPT VERSION  = " $script_version
    echo "# KERNEL_RELEASE  = " $kernel_release
    echo "# BUILD_VERSION   = " $build_version
    echo "# TARGET          = " $target_list
    echo "# TARGET_DIRECTRY = " $output_directory
fi

if [ $error -ne 0 ]; then
    exit 1
fi

if [ -z "$kernel_image_source_file"  ]; then
    kernel_image_source_file="vmlinuz-${kernel_release}-${build_version}"
fi

if [ ! -e "$REPO_DIR/$kernel_image_source_file" ]; then
    echo "Error: Not found $kernel_image_source_file in $REPO_DIR"
    error=1
fi

if [ -z "$device_tree_source_path" ]; then
    device_tree_source_path="devicetrees/${kernel_release}-${build_version}"
fi

if [ ! -e "$REPO_DIR/$device_tree_source_path" ]; then
    echo "Error: Not found $device_tree_source_path in $REPO_DIR"
    error=1
fi

if [ $error -ne 0 ]; then
    exit 1
fi

if [ $run_install_directory -ne 0 ]; then
    run_command "install -d $output_directory"
fi

do_install_image()
{
    local kernel_image_target=$(eval_install_variable "target_kernel_image")
    local install_source_file="${REPO_DIR}/${kernel_image_source_file}"
    local install_target_file="${output_directory}/${kernel_image_target}"
    local install_image_command=""
    case $kernel_image_target in
        vmlinuz-*)
            install_image_command="cp ${install_source_file} ${install_target_file}"
            ;;
        image-*)
            install_image_command="gzip -d -c ${install_source_file} > ${install_target_file}"
	    ;;
        *)
            echo "Error: Not support kernel image type (target_kernel_image=${kernel_image_target})"
	    return 1
	;;
    esac
    run_command "$install_image_command"
}

do_install_dtb()
{
    if [ $dry_run -ne 0 ] || [ $verbose -ne 0 ]; then
	echo "# do_install_dtb($1)"
    fi    

    local dtb_source=$(eval_install_variable "${1}_dtb_source")
    local dtb_target=$(eval_install_variable "${1}_dtb_target")
    local dts_target=$(eval_install_variable "${1}_dts_target")
    local dtb_source_path="${REPO_DIR}/${device_tree_source_path}"
    local dtb_source_file="${dtb_source_path}/${dtb_source}"
    local dtb_target_file="${output_directory}/${dtb_target}"
    local dts_target_file="${output_directory}/${dts_target}"

    if [ -z "$dtb_source" ]; then
        echo "Error: Device Tree not specified"
        return 1
    fi
    if [ ! -e "$dtb_source_file" ]; then
        echo "Error: Not found $dtb_source in $dtb_source_path"
        return 1
    fi

    run_command "cp ${dtb_source_file} ${dtb_target_file}"
    run_command "dtc -I dtb -O dts --symbols -o ${dts_target_file} ${dtb_target_file}"
    return 0
}

do_generate_uenv()
{
    if [ $dry_run -ne 0 ] || [ $verbose -ne 0 ]; then
	echo "# do_generate_uenv($1)"
    fi
    local linux_kernel_name=$(eval_install_variable "target_kernel_image")
    local uenv_file_name=$(eval_install_variable "target_uenv_txt")
    local linux_fdt_image=$(eval_install_variable "${1}_dtb_target")
    
    if [ $dry_run -ne 0 ] || [ $verbose -ne 0 ]; then
	echo "# cat ... > ${output_directory}/${uenv_file_name}"
    fi
    cat <<EOT > "${output_directory}/${uenv_file_name}"
########################################################################
#uenv: config_name   = ${1}
#uenv: menu_title    = Boot linux-${kernel_release}
#uenv: menu_priority = -1
########################################################################

########################################################################
# Linux Kernel Files
#  * linux_kernel_image : Linux Kernel Image File Name
#  * linux_fdt_image    : Linux Device Tree Blob File Name
########################################################################
linux_kernel_image=${linux_kernel_name}
linux_fdt_image=${linux_fdt_image}
EOT

}

if [ $run_install_image -ne 0 ]; then
    do_install_image 
fi

if [ $run_install_dtb -ne 0 ]; then
    for target_id in $(echo "$target_list"); do
        do_install_dtb $target_id
    done
fi

if [ $run_generate_uenv -ne 0 ]; then
    for target_id in $(echo "$target_list"); do
        do_generate_uenv $target_id
    done
fi


#!/bin/bash
__time=$(date +%Y%m%d%H%M%S)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define usage function
usage() {
	echo "-n Dry run,won't do anything"
	echo "-l save log file"
	echo "-b create backup"
	echo "-v log_verbose"
	echo "-r Recreate the symbolic link if there is an exsiting one"
	echo "TLDR: DoTinker -nvl MyPackage"
}
# Parse command line options
while getopts ":nlbvrh" opt; do
	case ${opt} in
	n)
		dry_run=true
		;;
	l)
		save_log=true
		;;
	b)
		need_backup=true
		;;
	v)
		log_verbose=true
		;;
	r)
		do_relink=true
		;;
	h)
		usage
    exit 1
		;;
  ?)
    usage
    exit 1
    ;;
	esac
done
shift $((OPTIND - 1))
# if [[ ! -z $do_relink ]]; then
# 	echo yes
# else
# 	echo no
# fi
# exit 0
#check arugments
if [[ -z $1 ]]; then
  echo "$(tput setaf 1)Something wrong with your args$(tput sgr0)"
  usage
	exit 1
fi
# set pack anme and path
base_pack_name="${1%/}"
base_pack_path="$PWD/$base_pack_name"

source $SCRIPT_DIR/cfg.sh
source $SCRIPT_DIR/lib/util.sh
source $SCRIPT_DIR/lib/log.sh
source $SCRIPT_DIR/lib/linker.sh
source $SCRIPT_DIR/lib/subpack.sh

# check pack
if [[ -z $dry_run ]]; then
	[ $need_backup ] && create_backup_dir
else
	log_warn "This is a Dry Run ,nothing will changed,you wont see your backup path"
fi
if [[ ! -d $base_pack_path ]]; then
	log_error "Cant find Pack :$base_pack_name"
	exit 1
fi
# Start to link
log_info_f "Link Pack : $base_pack_name"
echo
find -P -H "$base_pack_path" -mindepth 1 -maxdepth 1 -type d | while read -r sub_pack; do
	link_subpack "$sub_pack"
done
log_sep
#finish
remove_backup_dir_needed
log_good "Bye!"
[ $save_log ] || rm -f "$log_file"
exit 0

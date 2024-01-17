#!/bin/bash
link_subpack() {
	# set -x
	local _sp_path="$1"
	local _sp_name="$(basename $1)"

	log_sep
	log_info_f "Linking...SubPack:$_sp_name"
	echo
	# check _sp_cfg
	local _sp_cfg="$_sp_path/$file_cfg_sp"
	if [[ ! -f "$_sp_cfg" ]]; then
		log_error "Skipped...Cant find dotkconfig for SubPack:$_sp_name"
		return 1
	fi
	local _sp_target=$(head -n 1 "$_sp_cfg")
	_sp_target=${_sp_target/#\~/$HOME}
	#check target exsisted
	if [[ -z "$_sp_target" ]]; then
		log_error "Skipped...No target for SubPack:$_sp_name"
		return 1
	fi
	#cehck target_dir exsisted
	if [[ ! -d "$_sp_target" ]]; then
		if [[ ! -z $log_verbose ]]; then
			log_warn "Creating target directory:$_sp_target"
		fi
		mkdir -p $_sp_target
	fi
	## Lets GO
	cd $_sp_path
	# Process directory liink link list
	local _dir_link_rule=$(tail -n +2 "$_sp_cfg" | sed "/^\#/d")
	local _dir_link_list=""
	local _dir=""
	local prev_pwd=$PWD
	if [[ ! $_dir_link_rule = "" ]]; then
		while read -r line; do
			if [[ "$line" == *\* ]]; then
				_dir=${line%/*}
				if [[ ! -d $_dir ]]; then
					log_warn "Skipped...$line is not a directory,check your config file"
					continue
				fi
				_dir=$(find $_dir -mindepth 1 -maxdepth 1 -type d)
			else
				_dir=${line%/}
				if [[ ! -d $_dir ]]; then
					log_warn "Skipped...$line is not a directory,check your config file"
					continue
				fi
			fi
			# if [[ $_dir_link_list = "" ]] then
			_dir_link_list=$(printf "$_dir_link_list\n$_dir")
		done <<<"$_dir_link_rule"
	fi
	_dir_link_list=$(echo "$_dir_link_list" | sed '/^$/d')
	# printf "$_dir_link_list"
	# find files to link
	# FIX: doent handle empty folder
	local _file_link_list=$(sed 's/^/-not -path "/' <<<$_dir_link_list)
	_file_link_list=$(sed 's/$/\/*"/' <<<$_file_link_list)
	_file_link_list=$(echo $_file_link_list)
	# echo "find . -type f -not -name $file_cfg_sp $_file_link_list -printf \"%P\\n\""
	# eval "find . -type f -not -name $file_cfg_sp $_file_link_list -printf \"%P\\n\""
	_file_link_list=$(eval "find . -type f -not -name $file_cfg_sp $_file_link_list")
	local _link_list=$(printf "$_dir_link_list\n$_file_link_list")
  _link_list=$(sed "s/.\///"<<<$_link_list)
	# printf "$_link_list"
	#  exit
	while read -r line; do
		create_link "$line" "$_sp_target/$line"
	done <<<"$_link_list"
	cd $prev_pwd
	log_good "Linked...SubPack:$_sp_name"
}

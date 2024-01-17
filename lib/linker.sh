link_cmd() {
	log_info "Linking: $3 $(tput setaf 2)->$(tput sgr0) $_sp_name/$2"
	if [[ -z "$dry_run" ]]; then
		mkdir -p "$(dirname $3)"
		ln -s "$1/$2" "$3"
		if [[ $? -ne 0 ]]; then
			# FIX: should change exit code
			log_error "$_sp_name/$2 linking failed"
		fi
	fi
}
create_link() {
	local _base_path="$PWD"
	local _src_path="$1"
	local _link_target="$2"

	if [[ -L $_link_target ]]; then
		if [[ ! -z $do_relink ]]; then
			# check if need relink
			local _ltarget=$(readlink -f $_link_target)
			if [[ ! -z $log_verbose ]]; then
				log_warn "Removing link $_link_target -> $_ltarget"
			fi

			if [[ -z "$dry_run" ]]; then
				rm $_link_target
			fi
		else
			if [[ ! -z $log_verbose ]]; then
				log_warn "Skiped $_link_target, Link exsisted"
			fi
      return
		fi
		# backup folder
	elif [[ -d $_link_target ]] || [[ -f $_link_target ]]; then
    local _bak_path_short="$(basename $_base_path)/$_src_path"
		local _bak_path="$backup_dir/$_bak_path_short"
		if [[ ! -z $log_verbose ]]; then
			log_warn "Backup... $_link_target to BackupDir/$_bak_path_short"
		fi
		if [[ -z "$dry_run" ]]; then
			mkdir -p $(dirname $_bak_path)
			mv "$_link_target" "$_bak_path"
		fi
	fi
	link_cmd "$_base_path" "$_src_path" "$_link_target"
}

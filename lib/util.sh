#!/bin/bash

# Create backup directory
backup_dir="$(pwd)/backup/dotinker_bakup-$base_pack_name-$__time"

create_backup_dir() {
	mkdir -p "$backup_dir"
}

remove_backup_dir_needed() {
	if [ -d $backup_dir ]; then
		if [ -z "$(ls -A "$backup_dir")" ]; then
			log_info "Nothing need to backup"
			rm -r $backup_dir
		else
      echo
			log_warn "Backup Created at:$backup_dir"
      echo
		fi
	fi
}

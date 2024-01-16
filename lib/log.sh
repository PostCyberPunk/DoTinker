#!/bin/bash

log_file="$PWD/Dotinker-$base_pack_name-$__time.log"
touch "$log_file"
# Log sign
M_GODO="$(tput setab 2)$(tput setaf 0)GOOD$(tput sgr0)"
M_INFO="$(tput setab 6)$(tput setaf 0)INFO$(tput sgr0)"
M_WARN="$(tput setab 3)$(tput setaf 0)WARN$(tput sgr0)"
M_ERROR="$(tput setab 1)$(tput setaf 0)ERROR$(tput sgr0)"

log_good() {
	local __msg="$M_GODO $1"
	echo "$__msg" | tee -a "$log_file"
}
log_info() {
	if [[ ! -z $log_verbose ]]; then
		local __msg="$M_INFO $1"
		echo "$__msg" | tee -a "$log_file"
	fi
}
log_info_f() {
	local __msg="$M_INFO $1"
	echo "$__msg" | tee -a "$log_file"
}
log_warn() {
	local __msg="$M_WARN $1"
	echo "$__msg" | tee -a "$log_file"
}
log_error() {
	local __msg="$M_ERROR $1"
	echo "$__msg" | tee -a "$log_file"
}
log_sep() {
	echo "------------------------" | tee -a "$log_file"
}

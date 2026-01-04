#!/usr/bin/env bash

VALUE=1
MIN=0
MAX=100

usage() {
	cat <<- EOF
		USAGE: ${0##*/} [OPTIONS]

		Adjust default device volume and send a notification with the current level

		OPTIONS:
		    input            Set device as "@DEFAULT_SOURCE@"
		    output           Set device as "@DEFAULT_SINK@"

		    mute             Toggle device mute

		    raise <value>    Raise volume by <value>
		    lower <value>    Lower volume by <value>
		                         Default value: $VALUE

		EXAMPLES:
		    Toggle microphone mute:
		        $ ${0##*/} input mute

		    Raise speaker volume:
		        $ ${0##*/} output raise

		    Lower speaker volume by 5:
		        $ ${0##*/} output lower 5
	EOF
	exit 1
}

get-state() {
	local state
	state=$(wpctl "get-$d_state" | awk '{print $2}')

	case $state in
		"yes") printf "Muted" ;;
		"no") printf "Unmuted" ;;
	esac
}

get-volume() {
	volume=$(wpctl get-volume $d_default | awk '{print $2}')
	echo "$volume * $MAX / 1" | bc
}

get-icon() {
	local state level new_level
	state=$(get-state)
	level=$(get-volume)
	new_level=$level

	if [[ $state == "Muted" ]]; then
		printf "%s" "$n_icon-muted"
	else
		if ((new_level < ((MAX * 33) / 100))); then
			printf "%s" "$n_icon-low"
		elif ((new_level < ((MAX * 66) / 100))); then
			printf "%s" "$n_icon-medium"
		else
			printf "%s" "$n_icon-high"
		fi
	fi
}

set-volume() {
	local level new_level_int new_level_float
	level=$(get-volume)

	case $action in
		"raise")
			new_level_int=$(echo "$level + $value" | bc)
			((new_level_int > MAX)) && exit 0
			new_level_float=$(awk "BEGIN { printf $new_level_int / $MAX }")
			;;
		"lower")
			new_level_int=$(echo "$level - $value" | bc)
			((new_level_int < MIN)) && exit 0
			new_level_float=$(awk "BEGIN { printf $new_level_int / $MAX }")
			;;
	esac

	wpctl set-volume $d_default $new_level_float

	local icon
	icon=$(get-icon)

	notify-send "$n_name: $new_level_int" -h int:value:$new_level_int -i "$icon" \
		-h string:x-canonical-private-synchronous:volume
}

main() {
	device=$1
	action=$2
	value=${3:-$VALUE}

	((value > 0)) || usage

	case $device in
		"input")
			d_default="@DEFAULT_AUDIO_SOURCE@"
			d_state="mute"
			n_icon="mic-volume"
			n_name="Microphone"
			;;
		"output")
			d_default="@DEFAULT_AUDIO_SINK@"
			d_state="mute"
			n_icon="audio-volume"
			n_name="Volume"
			;;
		*) usage ;;
	esac

	case $action in
		"mute")
			wpctl "set-$d_state" toggle

			local state icon
			state=$(get-state)
			icon=$(get-icon)

			notify-send "$n_name: $state" -i "$icon" \
				-h string:x-canonical-private-synchronous:volume
			;;
		"raise" | "lower") set-volume ;;
		*) usage ;;
	esac
}

main "$@"
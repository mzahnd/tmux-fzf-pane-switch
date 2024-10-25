#!/usr/bin/env bash
# This script uses fzf to display a list of panes and allows you to select one.
#
# If you press ENTER, it switches to the selected pane.
# If you press ENTER on an empty line, it creates a new window in the current session.
function select_pane() {
    local pane
    local pane_found
    local session
    local windows_and_pane

    if [[ "${1}" = 'true' ]]; then
        pane=$(tmux list-panes -aF "#{session_name} #{window_index}.#{pane_index} #{window_name} #{pane_title} #{pane_current_command}" | 
           fzf --exit-0 --bind=enter:replace-query+print-query --reverse --tmux "${2}" --preview='tmux capture-pane -ep -t {1}:{2}' --preview-label='pane preview' --preview-window="${3}")
        pane_found=$?
    else
        pane=$(tmux list-panes -aF "#{session_name} #{window_index}.#{pane_index} #{window_name} #{pane_title} #{pane_current_command}" | 
           fzf --exit-0 --bind=enter:replace-query+print-query --reverse --tmux "${2}")
        pane_found=$?
    fi

    IFS=$'\n' read -r -d '' -a pane_array <<< "${pane}"
    if (( pane_found == 0 )); then
        session=$(echo "${pane_array[0]}" | awk '{print $1}')
        windows_and_pane=$(echo "${pane_array[0]}" | awk '{print $2}')
        tmux switch-client -t "${session}:${windows_and_pane}"
    elif (( pane_found == 1 )); then
        tmux command-prompt -b -p "Press ENTER to create a new window in the current session [${pane_array[0]}]" "new-window -n ${pane_array[0]}"
    fi
}
# ${1} preview_pane
# ${2} fzf_window_position
# ${3} fzf_preview_window_position
select_pane "${1}" "${2}" "${3}"

#!/usr/bin/env bash
# This script uses fzf to display a list of panes and allows you to select one.
#
# If you press ENTER, it switches to the selected pane.
# If you press ENTER on an empty line, it creates a new window in the current session.
function select_pane() {
    local pane
    local session
    local windows_and_pane

    # Check if we're using the fzf preview pane
    if [[ "${1}" = 'true' ]]; then
        pane=$(tmux list-panes -aF "#{session_name} #{window_index}.#{pane_index} #{window_name} #{pane_title} #{pane_current_command}" | 
           fzf --exit-0 --bind=enter:replace-query+print-query --reverse --tmux "${2}" --preview='tmux capture-pane -ep -t {1}:{2}' --preview-label='pane preview' --preview-window="${3}")
    else
        pane=$(tmux list-panes -aF "#{session_name} #{window_index}.#{pane_index} #{window_name} #{pane_title} #{pane_current_command}" | 
           fzf --exit-0 --bind=enter:replace-query+print-query --reverse --tmux "${2}")
    fi

    # Check if pane exists
    session=$(echo "${pane}" | awk '{print $1}')
    windows_and_pane=$(echo "${pane}" | awk '{print $2}')
    if tmux has-session -t "${session}:${windows_and_pane}" >/dev/null 2>&1; then
        # Found it! Let's switch.
        tmux switch-client -t "${session}:${windows_and_pane}"
    else
        # Pane not found, let's create it.
        tmux command-prompt -b -p "Press ENTER to create a new window in the current session [${pane}]" "new-window -n \"${pane}\""
    fi
}
# ${1} preview_pane
# ${2} fzf_window_position
# ${3} fzf_preview_window_position
select_pane "${1}" "${2}" "${3}"

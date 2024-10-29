#!/usr/bin/env bash
# This script uses fzf to display a list of panes and allows you to select one.
#
# If you press ENTER, it switches to the selected pane.
# If you press ENTER on an empty line, it creates a new window in the current session.
function select_pane() {
    local pane
    local pane_id

    # Check if we're using the fzf preview pane
    if [[ "${1}" = 'true' ]]; then
        pane=$(tmux list-panes -aF "${4}" | 
           fzf --exit-0 --bind=enter:replace-query+print-query --reverse --tmux "${2}" --preview='tmux capture-pane -ep -t {1}' --preview-label='pane preview' --preview-window="${3}")
    else
        pane=$(tmux list-panes -aF "${4}" | 
           fzf --exit-0 --bind=enter:replace-query+print-query --reverse --tmux "${2}")
    fi

    # Check if pane exists
    pane_id=$(echo "${pane}" | awk '{print $1}')
    if tmux has-session -t "${pane_id}" >/dev/null 2>&1; then
        # Found it! Let's switch.
        tmux switch-client -t "${pane_id}"
    else
        # Pane not found, let's create it.
        tmux command-prompt -b -p "Press ENTER to create a new window in the current session [${pane}]" "new-window -n \"${pane}\""
    fi
}

# Pane preview
preview_pane="${1}"
# FZF window position
fzf_window_position="${2}"
# FZF previe window position
fzf_preview_window_position="${3}"
# TMUX list-panes format
read -r -a list_panes_format_overrides <<< "${4}"
list_panes_formatted_overrides=$(printf '#{%s} ' "${list_panes_format_overrides[@]}")

select_pane "${preview_pane}" "${fzf_window_position}" "${fzf_preview_window_position}" "#{pane_id} ${list_panes_formatted_overrides}"

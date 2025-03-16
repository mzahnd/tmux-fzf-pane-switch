#!/usr/bin/env bash
# This script uses fzf to display a list of panes and allows you to select one.
#
# If you press ENTER, it switches to the selected pane.
# If you press ENTER on an empty line, it creates a new window in the current session.
function select_pane() {
    local border_styling
    local current_pane
    local pane
    local pane_id
    local preview

    # Save the currently active pane ID
    current_pane=$(tmux display-message -p '#{pane_id}')

    # If we have fzf version 0.58.0 or later, we can enable border styling
    vercomp '0.58.0' "$(fzf --version | awk '{print $1}')"
    fzf_version_comparison=$?
    if [[ $fzf_version_comparison -ne 1 ]]; then
        border_styling="--input-label ' Search ' --info=inline-right \
        --list-label ' Panes ' \
        --preview-border --preview-label ' Preview '"
    else
        # Fallback to old border styling used in tmux-fzf-pane-switch v1.1.2
        border_styling="--preview-label='pane preview'"
    fi

    # Check if we're using the fzf preview pane
    if [[ "${1}" = 'true' ]]; then
        preview="--preview 'tmux capture-pane -ep -t {1}' --preview-window=${3}"
    fi

    # Launch switcher
    pane=$(tmux list-panes -aF "${4}" | 
        eval fzf --exit-0 --print-query --reverse --tmux "${2}" --with-nth=2.. "${border_styling}" "${preview}" | 
        tail -1)

    # Set pane_id to first part of fzf output
    pane_id=$(echo "${pane}" | awk '{print $1}')

    # If pane_id is empty, exit without changing pane
    if [[ -z "${pane_id}" ]]; then
        tmux switch-client -t "${current_pane}"
    # Check if pane exists
    elif tmux has-session -t "${pane_id}" >/dev/null 2>&1; then
        # Found it! Let's switch.
        tmux switch-client -t "${pane_id}"
    else
        # Pane not found, let's create it.
        tmux command-prompt -b -p "Press ENTER to create a new window in the current session [${pane}]" "new-window -n \"${pane}\""
    fi
}

function vercomp() {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if ((10#${ver1[i]:=0} > 10#${ver2[i]:=0}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
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

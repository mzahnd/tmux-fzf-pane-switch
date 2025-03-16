#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
default_bind_key='s'
default_preview_session='true'
default_fzf_window_position='center,70%,80%'
default_fzf_preview_window_position='right,,,nowrap'
default_tmux_list_sessions_format='pane_id session_name window_name pane_title pane_current_command'

# User overridable options
tmux_bind_key="@fzf_session_switch_bind-key"
tmux_preview_session="@fzf_session_switch_preview-session"
tmux_fzf_window_position="@fzf_session_switch_window-position"
tmux_fzf_preview_window_position="@fzf_session_switch_preview-session-position"
tmux_list_sessions_format="@fzf_session_switch_list-sessions-format"

# Function to get variables from tmux
get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_override
    option_override=$(tmux show-option -gqv "${option}")
    if [ -z "${option_override}" ]; then
        echo "${default_value}"
    else
        echo "${option_override}"
    fi
}

# Function to set the key binding
function set_switch_session_bindings {
    local bind_key
    bind_key=$(get_tmux_option "${tmux_bind_key}" "${default_bind_key}")
    local preview_session
    preview_session=$(get_tmux_option "${tmux_preview_session}" "${default_preview_session}")
    local fzf_window_position
    fzf_window_position=$(get_tmux_option "${tmux_fzf_window_position}" "${default_fzf_window_position}")
    local fzf_preview_window_position
    fzf_preview_window_position=$(get_tmux_option "${tmux_fzf_preview_window_position}" "${default_fzf_preview_window_position}")
    local list_sessions_format
    list_sessions_format=$(get_tmux_option "${tmux_list_sessions_format}" "${default_tmux_list_sessions_format}")

    tmux bind-key "${bind_key}" run-shell "${CURRENT_DIR}/select_session.sh ${preview_session} ${fzf_window_position} ${fzf_preview_window_position} '${list_sessions_format}'"
}
set_switch_session_bindings


# tmux-fzf-pane-switch

This plugin is like the [brokenricefilms/tmux-fzf-session-switch](https://github.com/brokenricefilms/tmux-fzf-session-switch) TPM plugin, but it's for pane switching.

I use tmux sessions with many panes open, and I wanted a way of using fzf to switch to a pane quickly by filtering on the `#{window_name}`, `#{pane_title}`, or `#{pane_current_command}"`. If a pane cannot be found using the search criteria, it'll offer to create a new pane in the current session.

## Requirements

* [fzf](https://github.com/junegunn/fzf) >= 0.53.0 (requires the `--tmux` option). I tested with 0.55.0.
* [tmux](https://github.com/tmux/tmux) >= 3.3. I tested with 3.3a.

## Installation

1. Install [TPM](https://github.com/tmux-plugins/tpm).

2. Add the plugin to your `tmux.conf` file.

    ```bash
    set -g @plugin 'kristijan/tmux-fzf-pane-switch'
    ```

3. Start tmux and install plugin.

    _Press `prefix + I` (capital i, as in Install) to fetch the plugin._

    _Press `prefix + U` (capital u, as in Update) to update the plugin._

## Customise

You can override the following options in your `tmux.conf` file.

### Key binding

```bash
set -g @fzf_pane_switch_bind-key "key binding"
```

Default is `s`, which replaces the tmux default session select (tmux default: `choose-tree -Zs -O name`)

### fzf window position

```bash
set -g @fzf_pane_switch_window-position "position"
```

Default is `center,70%,80%`. You can use any options allowed [here](https://man.archlinux.org/man/fzf.1.en#tmux).

### fzf pane preview

```bash
set -g @fzf_pane_switch_preview-pane "[true|false]"
```

Default is `true`

### fzf pane preview position

Only when `@fzf_pane_switch_preview-pane` is `true`.

```bash
set -g @fzf_pane_switch_preview-pane-position "position"
```

Default is `right,,,nowrap`. You can use any options allowed [here](https://man.archlinux.org/man/fzf.1.en#preview~3).

## Acknowledgments

I pretty much retrofitted the [brokenricefilms/tmux-fzf-session-switch](https://github.com/brokenricefilms/tmux-fzf-session-switch) TPM plugin. So, if you're looking for something to switch tmux sessions only, go check it out.


# tmux-fzf-pane-switch

[![asciicast](https://asciinema.org/a/lRfrNLEL5WhqAgNsMnNw4zxY7.svg)](https://asciinema.org/a/lRfrNLEL5WhqAgNsMnNw4zxY7)

This plugin is like the [brokenricefilms/tmux-fzf-session-switch](https://github.com/brokenricefilms/tmux-fzf-session-switch) TPM plugin, but it's for pane switching. Switch to any pane, in any session.

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

Default is `prefix + s`, which replaces the tmux default session select (tmux default: `choose-tree -Zs -O name`)

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

### tmux list-panes format

This is the output format of `tmux list-panes` that you see in the fzf window. You can use this to match on other tmux formats.

```bash
set -g @fzf_pane_switch_list-panes-format "FORMATS"
```

Default is `pane_id session_name window_name pane_title pane_current_command`.

Note: You can use any tmux FORMAT option allowed [here](https://www.man7.org/linux/man-pages/man1/tmux.1.html#FORMATS). String manipulation should also work. For example, the `pane_id` by default is shown with a leading percent symbol (e.g. `%3`). You can remove this by setting `set -g @fzf_pane_switch_list-panes-format "s/%//:pane_id session_name window_name pane_title pane_current_command"`

## Demo Configuration

The demo video was captured using [asciinema](https://asciinema.org).

* TMUX theme is [catppuccin](https://github.com/catppuccin/tmux) (didn't render all that well in asciinema, but it's great!)
* ZSH shell prompt is [starship](https://starship.rs)
* Some of the content in the active panes:

  * [neofetch](https://github.com/dylanaraps/neofetch)
  * `curl wttr.in`

## Acknowledgments

I pretty much retrofitted the [brokenricefilms/tmux-fzf-session-switch](https://github.com/brokenricefilms/tmux-fzf-session-switch) TPM plugin. So, if you're looking for something to switch tmux sessions only, go check it out.

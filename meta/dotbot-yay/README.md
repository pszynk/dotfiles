# Dotbot `yay` Plugin

Plugin for [dotbot](https://github.com/anishathalye/dotbot) that adds a `yay`
directive. It allows installation of packeges using `yay`, and by extension
`pacman`, packages.

This plugin will attempt to install `yay` if not already present. This should make it easier to
set up a new computer.

## Installation

Add it as a submodule of your dotfiles repository.

```bash
git submodule add https://github.com/alexwh/dotbot-yay
```

## Usage

One option is having your packages list in a separate file. This way you can run it separately
from your main configuration.

```bash
./install -p dotbot-yay/yay.py -c packages.conf.yaml
```

Alternatively, you can add the directive directly in `install.conf.yaml` and
modify your `install` script so it automatically enables the `yay` plugin.

```bash
"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" \
  --plugin-dir "${BASEDIR}/dotbot-yay" "${@}"
```

## Configuration

Example of the `packages.conf.yaml`:

```yaml
- yay:
  - zsh
  - neovim
  - atom-editor-bin
  - gitkraken
```

Additionally, if you want to separate your `pacman` packages from your AUR packages, you can put
them in a directive named `pacman`. Both directives are functionally the same, but may allow you to
organize things a little more.

```yaml
- pacman:
  - zsh
  - neovim
- yay:
  - atom-editor-bin
  - gitkraken
```

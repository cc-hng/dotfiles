SHELL = /bin/bash
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OS := $(shell bin/is-supported bin/is-macos macos linux)
PATH := $(DOTFILES_DIR)/bin:$(PATH)
export XDG_CONFIG_HOME := $(HOME)/.config
export STOW_DIR := $(DOTFILES_DIR)

.PHONY: all

all: $(OS)

macos: packages-macos link

linux: packages-linux link

packages-macos:
	$(DOTFILES_DIR)/script/os/install_brew.sh
	$(DOTFILES_DIR)/script/install_common.sh
	$(DOTFILES_DIR)/script/install_zsh_plugin.sh

packages-linux:
	if is-executable apt; then $(DOTFILES_DIR)/script/os/install_apt.sh; fi
	if is-executable paru; then $(DOTFILES_DIR)/script/os/install_paru.sh; fi
	is-executable stow || exit 1
	$(DOTFILES_DIR)/script/install_common.sh
	$(DOTFILES_DIR)/script/install_zsh_plugin.sh

link:
	is-executable stow || exit 1
  # curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh | bash
  # curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	for FILE in $$(\ls -A config); do if [ -d $(XDG_CONFIG_HOME)/$$FILE -a ! -h $(XDG_CONFIG_HOME)/$$FILE ]; then \
		mv -v $(XDG_CONFIG_HOME)/$$FILE{,.bak}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	stow -t $(HOME) runcom
	stow -t $(XDG_CONFIG_HOME) config

unlink:
	is-executable stow || exit 1
	stow --delete -t $(HOME) runcom
	stow --delete -t $(XDG_CONFIG_HOME) config
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done
	for FILE in $$(\ls -A config); do if [ -f $(XDG_CONFIG_HOME)/$$FILE.bak ]; then \
		mv -v $(XDG_CONFIG_HOME)/$$FILE.bak $(XDG_CONFIG_HOME)/$${FILE%%.bak}; fi; done

bash: BASH=/usr/local/bin/bash
bash: SHELLS=/private/etc/shells


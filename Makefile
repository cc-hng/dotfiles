SHELL = /bin/bash
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OS := $(shell bin/is-supported bin/is-macos macos linux)
PATH := $(DOTFILES_DIR)/bin:$(PATH)
export XDG_CONFIG_HOME := $(HOME)/.config
export STOW_DIR := $(DOTFILES_DIR)

.PHONY: all

all: $(OS)

macos: core-macos packages-macos link

linux: core-linux packages-linux link

core-macos: brew
	brew install git git-extras
	brew install ruby

core-linux:
	linux-update

stow-macos: brew
	is-executable stow || brew install stow

stow-linux: core-linux
	is-executable stow || linux-install stow

packages-macos: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true
	npm install -g $(shell cat install/npmfile)

packages-linux:
	$(DOTFILES_DIR)/install/common.sh
	$(DOTFILES_DIR)/install/linux.sh
	sudo npm install -g $(shell cat install/npmfile)

link: stow-$(OS)
  # curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh | bash
  # curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	for FILE in $$(\ls -A config); do if [ -d $(XDG_CONFIG_HOME)/$$FILE -a ! -h $(XDG_CONFIG_HOME)/$$FILE ]; then \
		mv -v $(XDG_CONFIG_HOME)/$$FILE{,.bak}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	stow -t $(HOME) runcom
	stow -t $(XDG_CONFIG_HOME) config

unlink: stow-$(OS)
	stow --delete -t $(HOME) runcom
	stow --delete -t $(XDG_CONFIG_HOME) config
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done
	for FILE in $$(\ls -A config); do if [ -f $(XDG_CONFIG_HOME)/$$FILE.bak ]; then \
		mv -v $(XDG_CONFIG_HOME)/$$FILE.bak $(XDG_CONFIG_HOME)/$${FILE%%.bak}; fi; done

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

bash: BASH=/usr/local/bin/bash
bash: SHELLS=/private/etc/shells


SHELL = /bin/bash
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PATH := $(DOTFILES_DIR)/bin:$(PATH)
OS := $(shell is-supported is-macos macos $(shell is-supported is-win32 win32 linux))
export XDG_CONFIG_HOME := $(HOME)/.config
export STOW_DIR := $(DOTFILES_DIR)

.PHONY: all

all: debug $(OS)

win32: packages-win32 link

macos: packages-macos link

linux: packages-linux link

packages-win32:
	$(DOTFILES_DIR)/scripts/os/install_msys.sh

packages-macos:
	$(DOTFILES_DIR)/scripts/os/install_brew.sh

packages-linux:
	is-executable apt && $(DOTFILES_DIR)/script/os/install_apt.sh || true
	is-executable paru && $(DOTFILES_DIR)/script/os/install_paru.sh || true

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

debug:
	@echo "os: $(OS)"
	@echo "shell: $(SHELL)"
	@echo "dotfiles(root): $(DOTFILES_DIR)"

bash: BASH=/usr/local/bin/bash
bash: SHELLS=/etc/shells


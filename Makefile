ICONS_DIR := $(HOME)/.tomato
IDLE_ICON := $(ICONS_DIR)/tomato_idle.png
ACTIVE_ICON := $(ICONS_DIR)/tomato_active.png

install: copy_icons download_vendors 

copy_icons: $(IDLE_ICON) $(ACTIVE_ICON)

$(IDLE_ICON): | $(ICONS_DIR)
	cp $(PWD)/contrib/tomato_idle.png $(IDLE_ICON)

$(ACTIVE_ICON): | $(ICONS_DIR)
	cp $(PWD)/contrib/tomato_active.png $(ACTIVE_ICON)

$(ICONS_DIR):
	mkdir -p $(ICONS_DIR)

download_vendors:
	git submodule update --init

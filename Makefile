TOMATO_DIR := $(HOME)/.tomato
IDLE_ICON := $(TOMATO_DIR)/tomato_idle.png
ACTIVE_ICON := $(TOMATO_DIR)/tomato_active.png
BEEP_SOUND := $(TOMATO_DIR)/tomato_beep.wav

install: copy_icons copy_sound download_vendors

copy_icons: $(IDLE_ICON) $(ACTIVE_ICON)

$(IDLE_ICON): | $(TOMATO_DIR)
	cp $(PWD)/contrib/tomato_idle.png $(IDLE_ICON)

$(ACTIVE_ICON): | $(TOMATO_DIR)
	cp $(PWD)/contrib/tomato_active.png $(ACTIVE_ICON)

copy_sound: $(BEEP_SOUND)

$(BEEP_SOUND): | $(TOMATO_DIR)
	cp $(PWD)/contrib/tomato_beep.wav $(BEEP_SOUND)

$(TOMATO_DIR):
	mkdir -p $(TOMATO_DIR)

download_vendors:
	git submodule update --init

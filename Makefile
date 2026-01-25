INSTALL_DIR = /usr/local/bin

SCRIPTS = $(wildcard *.sh)

INSTALL_SCRIPTS = $(SCRIPTS:.sh=)

install: 
	@for script in $(SCRIPTS); do \
		if [ -f $$script ]; then \
			install_name=$$(basename $$script .sh); \
			cp $$script $(INSTALL_DIR)/$$install_name; \
			chmod +x $(INSTALL_DIR)/$$install_name; \
		fi \
	done

uninstall:
	@for script in $(INSTALL_SCRIPTS); do \
		if [ -f $(INSTALL_DIR)/$$script ]; then \
			rm -f $(INSTALL_DIR)/$$script; \
		fi \
	done

.PHONY: install uninstall

SHARE_DIR=$(DESTDIR)/usr/share/stconfig
BIN_DIR=$(DESTDIR)/usr/bin
FIND_CMD=find . -not -path '*.svn*'         \
	        -not -path '*debian*'       \
	        -not -name 'Makefile'       \
	        -not -name 'stconfig-setup' \
		-not -name '*stamp*'

clean:
	@true

build:
	@true

install: install-stconfig

install-stconfig: install-files
	install -d -m 755 $(BIN_DIR)
	install -m 755 stconfig-setup $(BIN_DIR)

install-files: install-dirs
	$(FIND_CMD) -type f | xargs -n 1 -i install -m 755 {} $(SHARE_DIR)/{}
	cp $(SHARE_DIR)/stbin/wcopy $(SHARE_DIR)/stbin/wpaste

install-dirs:
	$(FIND_CMD) -type d | xargs -n 1 -i install -d -m 755 $(SHARE_DIR)/{}

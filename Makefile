# Type 'make install' as root to install the scripts to /usr/local/bin
# and set up the systemd service and timer to run this.

SCRIPTS=arch-maint.sh arch-maint-email.sh
SYSTEMD_FILES=arch-maint.service arch-maint.timer

install:
	install -p -t /usr/local/bin $(SCRIPTS)
	install -m 644 -p -t /etc/systemd/system $(SYSTEMD_FILES)
	systemctl start arch-maint.timer
	systemctl enable arch-maint.timer
	systemctl daemon-reload

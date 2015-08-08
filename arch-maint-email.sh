#!/bin/bash

# Run arch-maint and email to root

export PATH=/usr/bin:/usr/local/bin

SUBJECT="arch-maint report for `hostname` on `date +%Y-%m-%d`"
arch-maint.sh | mail -s "$SUBJECT" root

# This seems necessary so systemd won't kill forked processes from
# mail when this script exits.
sleep 10

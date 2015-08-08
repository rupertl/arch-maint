#!/bin/bash

# Maintenance script for Arch Linux systems, intended to be run
# weekly. Should be run as root to do cleanup tasks; if run as normal
# user will still print some useful information.

separator()
{
    echo "======================================================================"
}

sectionStart()
{
    echo
    separator
    echo
    echo "$1"
    echo
}

separator
echo -n "arch-maint report for `hostname` on `date`"

sectionStart "SYSTEM"
uname -a
echo
uptime

sectionStart "PENDING UPDATES"
checkupdates

sectionStart "FAILED SERVICES"
systemctl --failed

sectionStart "HIGH PROFILE LOG ENTRIES"
journalctl --no-pager -p 0..3 -xn

sectionStart "MAIL QUEUE"
mailq

sectionStart "DOCKER CONTAINERS"
docker ps -sa

sectionStart "MIRRORLIST CHANGES"
diff /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.pacnew

sectionStart "ETCKEEPER PENDING CHANGES"
etckeeper vcs status -s

sectionStart "ETCKEEPER RECENT CHANGES"
etckeeper vcs log --since "1 week ago"

sectionStart "REMOVE ORPHANED PACKAGES"
if [[ ! -n $(pacman -Qdt) ]]; then
    echo "No orphans to remove."
else
    pacman --noconfirm -Rns $(pacman -Qdtq)
fi

sectionStart "CLEAR OLD PACKAGE CACHE"
pacman  --noconfirm -Sc

sectionStart "OPTIMISE PACKAGE DATABASE"
pacman-optimize --nocolor

sectionStart "DISK SPACE AFTER CLEANUPS"
df -h
echo
du -hs /var

sectionStart "AUR PACKAGES"
pacman -Qem

sectionStart "EXPLICITLY INSTALLED PACKAGES"
pacman -Qen

separator
echo
echo "Report completed at `date`"

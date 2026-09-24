#!/bin/bash

# Persist include/config.php by symlinking it into a mounted directory.
# (Coolify pre-creates named volumes as plain directories before the
# container starts, so a volume mounted directly onto a single file
# target never works there - mount a directory instead and symlink.)
mkdir -p /var/www/html/config-data
if [ ! -f /var/www/html/config-data/config.php ]; then
    touch /var/www/html/config-data/config.php
    chmod 666 /var/www/html/config-data/config.php
fi
ln -sf /var/www/html/config-data/config.php /var/www/html/include/config.php

# Start cron service
service cron start

# Ensure daily cron jobs are executable
chmod +x /etc/cron.daily/*

# Start Apache in the foreground (keeps the container alive)
apachectl -D FOREGROUND

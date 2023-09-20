#!/bin/sh

CRON_SCHEDULE=${CRON_SCHEDULE:-"0 2 * * *"}

# Always overwrite the cron schedule to substitute it with an environment variable.
{ echo "$CRON_SCHEDULE bash /job/backup-now.sh >> /var/log/backup-now.log 2>&1"; } | crontab -

# start cron in foreground wit log level code 8.
/usr/sbin/crond -f -l 8

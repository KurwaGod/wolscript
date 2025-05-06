#!/bin/bash

SCRIPT_PATH="added.when.i.have.wol.working"

chmod +x "$SCRIPT_PATH"

# Add the cron job to run at 5 PM every day
(crontab -l 2>/dev/null; echo "0 17 * * * $SCRIPT_PATH") | crontab -

echo "Cron job has been set up to run wake_computer.sh at 5 PM daily"

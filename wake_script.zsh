#!/bin/bash

# Configuration
MAC_ADDRESS="00:11:22:33:44:55"  
TARGET_IP="192.168.1.100"        
PING_DURATION=5                  

# Log file for debugging
LOG_FILE="/var/log/wake_computer.log"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Make sure log file exists and is writable
touch "$LOG_FILE" 2>/dev/null || {
    echo "Cannot write to log file $LOG_FILE. Using /tmp/wake_computer.log instead."
    LOG_FILE="/tmp/wake_computer.log"
    touch "$LOG_FILE"
}

log_message "Starting wake-on-lan script"

# Check if etherwake is installed
if ! command -v etherwake &> /dev/null; then
    log_message "Error: etherwake is not installed. Please install it with 'sudo apt-get install etherwake' or equivalent."
    exit 1
fi

# Send WOL packet
log_message "Sending WOL packet to $MAC_ADDRESS"
etherwake -i $(ip route | grep default | awk '{print $5}') "$MAC_ADDRESS" >> "$LOG_FILE" 2>&1

# Check if the command was successful
if [ $? -eq 0 ]; then
    log_message "WOL packet sent successfully"
else
    log_message "Failed to send WOL packet"
    exit 1
fi

# Wait for a moment before pinging
sleep 2

# Ping the computer for the specified duration
log_message "Pinging $TARGET_IP for $PING_DURATION seconds"
timeout "$PING_DURATION" ping -c "$((PING_DURATION * 1))" "$TARGET_IP" >> "$LOG_FILE" 2>&1

log_message "Ping completed"
log_message "Wake-on-LAN script finished"

exit 0

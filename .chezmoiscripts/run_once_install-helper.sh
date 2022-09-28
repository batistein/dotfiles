#!/bin/sh
gem install colorls

# Configure ENOSPC System Limit for file watchers (npm/yarn)
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
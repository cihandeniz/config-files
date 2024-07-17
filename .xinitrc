#!/bin/bash

# Map capslock key to escape
setxkbmap -option caps:swapescape
# restart zsysd service
systemctl restart zsysd

#!/bin/bash

pendingtasks=`task count status:pending`

if [ $pendingtasks -gt "1" ]
  then
    notify-send "TaskWarrior Pending Tasks - " "`task count status:pending`" 
    canberra-gtk-play --file=/usr/share/sounds/gnome/default/alerts/drip.ogg
  else
    notify-send "No Active or Pending Tasks" 
    canberra-gtk-play --file=/usr/share/sounds/gnome/default/alerts/sonar.ogg
fi

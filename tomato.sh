#!/bin/bash

# Copyright (C) 2015 Szymon Kopciewski
#
# This file is part of Tomato
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

IDLE_PID_FILE='/tmp/tomato-idle.pid'
ACTIVE_PID_FILE='/tmp/tomato-active.pid'
TIMER_PID_FILE='/tmp/tomato-timer.pid'
SCRIPT_PATH=`realpath $0`
TRAYTO_PATH=`dirname $SCRIPT_PATH`/vendors/traytor/bin/traytor

CONFIG=~/.tomato/config
### Configurable through config file ###
TIMER_MESSAGE=' !! Take a BREAK !! '
TIMER_MINUTES=25
TIMER_CALLBACK='true'
IDLE_ICON=~/.tomato/tomato_idle.png
ACTIVE_ICON=~/.tomato/tomato_active.png
########################################

function run_tomato_idle
{
  ($TRAYTO_PATH \
   -t "Tomato: idle" \
   -c "$SCRIPT_PATH &> /dev/null" \
   $IDLE_ICON) &
  save_pid_to_file $! $IDLE_PID_FILE
}

function run_tomato_avtive
{
  ($TRAYTO_PATH \
    -t "Tomato: active" \
    -c "$SCRIPT_PATH &> /dev/null" \
    $ACTIVE_ICON) &
  save_pid_to_file $! $ACTIVE_PID_FILE
}

function run_tomato_timer
{
  tomato_timer_commands &
}

function tomato_timer_commands
{
  local seconds=$((60 * $TIMER_MINUTES))
  sleep $seconds && \
    notify-send "$TIMER_MESSAGE" && \
    ($TIMER_CALLBACK) && \
    ($SCRIPT_PATH) & 
  save_pid_to_file $! $TIMER_PID_FILE
}

function stop_tomato_idle
{
  stop_process_from_file $IDLE_PID_FILE
}

function stop_tomato_active
{
  stop_process_from_file $ACTIVE_PID_FILE
}

function stop_tomato_timer
{
  stop_process_from_file $TIMER_PID_FILE
}

function is_tomato_idle
{
  check_process_from_file $IDLE_PID_FILE
}

function is_tomato_active
{
  check_process_from_file $TIMER_PID_FILE || \
    check_process_from_file $ACTIVE_PID_FILE
}

function save_pid_to_file
{
  local pid=$1
  local file=$2
  echo $pid > $file
}

function stop_process_from_file
{
  local file=$1
  [ -f $file ] || return
  pkill -P `cat $file` &> /dev/null
  pkill -F $file &> /dev/null
  rm -f $file
}

function check_process_from_file {
  local file=$1
  pkill -0 -F $file &> /dev/null
  if [ $? -ne 0 ]; then
    rm -f $file
    return 1
  fi
  return 0
}

function prepare_default_config
{
  if [ ! -f $CONFIG ]; then
    mkdir -p $(dirname $CONFIG)
	cat <<- EOF > $CONFIG
		# TIMER_MINUTES=$TIMER_MINUTES
		# TIMER_MESSAGE='$TIMER_MESSAGE'
		# TIMER_CALLBACK='$TIMER_CALLBACK'
		# IDLE_ICON=$IDLE_ICON
		# ACTIVE_ICON=$ACTIVE_ICON
	EOF
  fi
}

#------------------------------------------------------------------------------

prepare_default_config
. $CONFIG

if is_tomato_idle; then
    stop_tomato_idle
    run_tomato_avtive
    run_tomato_timer
else
  if is_tomato_active; then
    stop_tomato_active
    stop_tomato_timer
  fi
  run_tomato_idle
fi

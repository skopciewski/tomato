#!/bin/bash

IDLE_PID_FILE='/tmp/tomato-idle.pid'
ACTIVE_PID_FILE='/tmp/tomato-active.pid'
TIMER_PID_FILE='/tmp/tomato-timer.pid'
SCRIPT_PATH=`realpath $0`

CONFIG=~/.tomato/config
TIMER_MESSAGE=' !! Take a BREAK !! '
TIMER_MINUTES=25
TIMER_CALLBACK='true'
IDLE_ICON=~/.tomato/tomato_idle.png
ACTIVE_ICON=~/.tomato/tomato_active.png

function run_tomato_idle
{
  (/home/szef/sbin/traytor \
   -t "Tomato: idle" \
   -c "$SCRIPT_PATH" \
   $IDLE_ICON) &
  save_pid_to_file $! $IDLE_PID_FILE
}

function run_tomato_avtive
{
  (/home/szef/sbin/traytor \
    -t "Tomato: active" \
    -c "$SCRIPT_PATH" \
    $ACTIVE_ICON) &
  save_pid_to_file $! $ACTIVE_PID_FILE
}

function run_tomato_timer
{
  local seconds=$((60 * $TIMER_MINUTES))
  (sleep $seconds && \
    notify-send "$TIMER_MESSAGE" && \
    $($TIMER_CALLBACK) && \
    ($SCRIPT_PATH)& ) &
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

function save_pid_to_file
{
  local pid=$1
  local file=$2
  echo $pid > $file
}

function stop_process_from_file
{
  local file=$1
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

function is_tomato_idle
{
  check_process_from_file $IDLE_PID_FILE
}

function is_tomato_active
{
  check_process_from_file $ACTIVE_PID_FILE
}

function prepare_default_config
{
  if [ ! -f $CONFIG ]; then
    mkdir -p $(dirname $CONFIG)
	cat <<- EOF > $CONFIG
		# TIMER_MINUTES=$TIMER_MINUTES
		# TIMER_MESSAGE='$TIMER_MESSAGE'
		# TIMER_CALLBACK=$TIMER_CALLBACK
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

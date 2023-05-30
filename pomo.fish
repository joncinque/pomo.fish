#! /usr/bin/env fish

# pomo.fish
#
# This simple script is essentially a wrapper on sleep and notify-send to create
# work timers.  Standard use cases are to start a timer, then let it run in
# the background, ending once the desktop notification appears.  You can pause
# and restart as a normal shell program, using CTRL+Z, `fg`, `bg`.
#

set title_message "pomo.fish timer"
set message "Time is up!"
set alarm "/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga"
set duration 25
set notify 1
set verbose 0
set testing 0

set stopped 0
set fish_dir "$HOME/.local/share/fish"
mkdir -p $fish_dir
set pomo_file "$fish_dir/fish_pomo"

function check_variable_set
  set is_set $argv[1]
  set name $argv[2]
  set current $argv[3]
  if test $is_set = '1'
    printf "%s already set to %s\n" $name $current
    usage
  end
end

function start_timer -d "Start a new timer"
  set duration_already_set 0
  set message_already_set 0
  set alarm_already_set 0

  while set -q argv[1]
    set option $argv[1]
    switch "$option"
      case -l --longbreak
        check_variable_set "$duration_already_set" "Duration" "$duration"
        set duration 10
        set duration_already_set 1
      case -s --shortbreak
        check_variable_set "$duration_already_set" "Duration" "$duration"
        set duration 5
        set duration_already_set 1
      case -p --pomodoro
        check_variable_set "$duration_already_set" "Duration" "$duration"
        set duration 25
        set duration_already_set 1
      case -d --duration
        check_variable_set "$duration_already_set" "Duration" "$duration"
        set --erase argv[1]
        set duration $argv[1]
        set duration_already_set 1
      case -m --message
        check_variable_set "$message_already_set" "Message" "$message"
        set --erase argv[1]
        set message $argv[1]
        set message_already_set 1
      case -a --alarm
        check_variable_set "$alarm_already_set" "Alarm" "$alarm"
        set --erase argv[1]
        set alarm $argv[1]
        set alarm_already_set 1
      case -n --notify-terminal
        set notify 0
      case -t --test
        set testing 1
      case -v --verbose
        set verbose 1
      case -h --help
        usage
      case "*"
        printf "error: Unknown option %s\n" "$option"
        usage
    end
    set --erase argv[1]
  end
  if test $notify = '1'
    switch (uname)
      case Linux FreeBSD NetBSD DragonFly
        if ! test (which notify-send)
          printf "You have chosen to receive a notification, but `notify-send` is not available, so notification will happen in terminal\n"
          set notify 0
        end
      case Darwin
        if ! test (which terminal-notifier)
          printf "You have chosen to receive a notification, but `terminal-notifier` is not available, so notification will happen in terminal\n"
          set notify 0
        end
      case '*'
        printf "Unsupported platform\n"
        usage
    end
  end
  printf "pomo.fish setup. Duration: %s minutes, Message: %s, Notify: %s\n" "$duration" "$message" "$notify"
  printf "You can allow it to keep running in the background\n"
  for i in (seq "$duration" -1 1)
    if test $verbose = '1'
      echo "$i minutes left"
    end
    printf "%s" $i > $pomo_file
    if test $testing = '1'
      sleep 1
    else
      sleep 60
    end
    if ! test -e $pomo_file
      if test $verbose = '1'
        printf "Timer stopped with %s minutes left\n" (math $i - 1)
      end
      set stopped 1
      break
    end
  end
  if test $stopped = '0'
    if test $notify = '1'
      switch (uname)
        case Linux FreeBSD NetBSD DragonFly
          notify-send -i dialog-information "$title_message" "$message"
        case Darwin
          terminal-notifier -title "$title_message" -message "$message"
        case '*'
          printf "Unsupported platform\n"
          usage
      end
    else
      printf "%s\n" "$message"
    end
    if test $alarm != '0' -a (which ogg123)
      ogg123 $alarm 2> /dev/null
    end
    if test -e $pomo_file
      rm $pomo_file
    end
  end
end

function usage -d "Show pomo.fish timer usage"
  echo "Usage: pomo.fish [start|stop|check] [-p] [-l] [-s] [-v] [-n] [-d duration] [-m message]"
  echo "Actions:"
  echo "  start                   Start a new timer"
  echo "  stop                    Stop a running timer"
  echo "  check                   Check an existing timer"
  echo "Start options:"
  echo "  -p --pomodoro           Set duration to pomodoro (25 minutes)"
  echo "  -s --shortbreak         Set duration to short break (5 minutes)"
  echo "  -l --longbreak          Set duration to long break (10 minutes)"
  echo "  -d --duration <minutes> Duration of timer (default: 25)"
  echo "  -m --message  <message> Message to display on completion (default: 'Time is up!')"
  echo "  -n --notify-terminal    Notify on terminal instead of desktop on done"
  echo "  -a --alarm    <file>    Alarm at the end (default: '/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga')"
  echo "  -t --test               Enable testing mode, which sets a minute to 1 second"
  echo "  -v --verbose            Notify on terminal every minute"
  echo "  -h --help               Display this help message"
  exit 1
end

set action $argv[1]
set --erase argv[1]
switch "$action"
  case start
    start_timer $argv &
  case check
    if test -e $pomo_file
      cat $pomo_file
    else
      echo "No timer running"
    end
  case stop
    if test -e $pomo_file
      printf "Stopped running timer at %s minutes left\n" (cat $pomo_file)
      rm $pomo_file
    else
      echo "No timer running"
    end
  case "*"
    printf "Unknown action\n"
    usage
end

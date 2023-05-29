# pomo.fish

Pomodoro timer for the fish shell

## Requirements

* Install [fish](https://fishshell.com/)
* (Optional) `pomo.fish` in your $PATH
* (Optional) A desktop notifier
  - OSX: [terminal-notifier](https://formulae.brew.sh/formula/terminal-notifier)
  - Ubuntu / Debian: [notify-send](https://launchpad.net/ubuntu/+source/libnotify)
  - Arch: [libnotify](https://archlinux.org/packages/extra/x86_64/libnotify/)
* (Optional) An ogg sound player for alarm
  - Ubuntu / Debian: [vorbis-tools](https://packages.debian.org/sid/sound/vorbis-tools)
  - Arch: [vorbis-tools](https://archlinux.org/packages/extra/x86_64/vorbis-tools/)

## General usage

General usage
```fish
Usage: pomo.fish [start|stop|check] [-p] [-l] [-s] [-v] [-n] [-d duration] [-m message]
Actions:
  start                   Start a new timer
  stop                    Stop a running timer
  check                   Check an existing timer
Start options:
  -p --pomodoro           Set duration to pomodoro (25 minutes)
  -s --shortbreak         Set duration to short break (5 minutes)
  -l --longbreak          Set duration to long break (10 minutes)
  -d --duration <minutes> Duration of timer (default: 25)
  -m --message  <message> Message to display on completion (default: 'Time is up!')
  -n --notify-terminal    Notify on terminal instead of desktop on done
  -a --alarm    <file>    Alarm at the end (default: '/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga')
  -v --verbose            Notify on terminal every minute
  -h --help               Display this help message
```

## Examples

NOTE: When starting a timer, you will likely want it to run in the background
to free up the command line.

Run a standard 25-minute pomodoro with a unique message:
```fish
pomo.fish start -p -m "My special message" &
```

Run a 5-minute break:
```fish
pomo.fish start -s &
```

Run a 10-minute break, receiving a terminal notification (instead of desktop):
```fish
pomo.fish start -l -n &
```

Run a custom minute break, receiving a terminal notification every minute:
```fish
pomo.fish start -d 14 -v &
```

Stop a running session
```fish
pomo.fish stop
```

Check minutes left in a running session
```fish
pomo.fish check
```

# Powerline Integration

If you use [Powerline](https://github.com/powerline/powerline) for any of your
tools, there exists a `pomo.fish` segment at the `pomo-fish-powerline` package,
which you can use to keep track of a running Pomo.fish timer, directly in your
terminal!

Here's an example segment, placed to the right:

```
 🍅20m  0.5 0.7 0.7  2023-05-29  17:25 
```

This way, you can keep everything at your fingertips, directly in terminal.

You can see more at the [repo](https://github.com/joncinque/pomo.fish/tree/master/powerline).

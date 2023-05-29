## pomo-fish-powerline

A simple Powerline segment to show how much time is left in a Pomodoro session
started with `pomo.fish`.

### How it works

This just reads the default pomo.fish time file at `~/.local/share/fish/fish_pomo`
and styles it nicely as `🍅20m`, e.g.:

```
 🍅20m  0.5 0.7 0.7  2023-05-29  17:25 
```

And if no timer is active, it will simply say `None`, e.g.:

```
 None  0.5 0.7 0.7  2023-05-29  17:25 
```

### Configuration

* Install the package

```console
$ pip3 install pomo-fish-powerline
```

* Add a `pomo_fish_powerline.segments.pomo` segment to your Powerline theme, e.g.:

```json
{
    "segments": {
        "right": [
            {
                "function": "pomo_fish_powerline.segments.pomo",
                "priority": 10
            }
        ]
    }
}
```

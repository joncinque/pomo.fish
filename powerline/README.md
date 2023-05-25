## powerline-pomo-fish

A simple Powerline segment to show how much time is left in a Pomodoro session
started with `pomo.fish`.

### How it works

This just reads the default pomo.fish time file at `~/.local/share/fish/fish_pomo`
and styles it nicely, e.g. as `🍅20m`. And if no pomodoro is active, it will
simply say `None`.

### Configuration

* Install the package

```console
$ pip3 install powerline-pomo-fish
```

* Add a `powerline_pomo_fish.segments.pomo` segment to your Powerline theme, e.g.:

```json
{
    "segments": {
        "right": [
            {
                "function": "powerline_pomo_fish.segments.pomo",
                "priority": 10
            }
        ]
    }
}
```

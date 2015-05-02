# Tomato - simple pomodoro timer

The pretty simple [Pomodoro Technique][pomodoro] timer which sits in the 
Linux tray (thanks to [sickill/traytor][traytor])

## Installation

Get sources:

```bash
git clone https://github.com/skopciewski/tomato.git
```

go to source dir:

```bash
cd tomato
```

run make:
```bash
make
```
it:
* downloads [sickill/traytor][traytor] into the vendors dir
* creates `~/.tomato` dir
  * copy there default tray icons
  * copy there default 'beep' sound

## Usage

Run:
```bash
./tomato.sh
```

It brings up a gray icon in the system tray. When you click on it, turns to 
red. When the specified time passed, the callback functions will be executed. 
After all (or by clicking again), the icon gets gray again.

By default, it uses `notify-send` to display notifications. And you can add 
your cutom callback by editing `~/.tomato/config`.
For example, to play the sound, set:
```bash
TIMER_CALLBACK="aplay -q ~/.tomato/tomato_beep.wav"
```

## Versioning

See [semver.org][semver]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[pomodoro]: http://pomodorotechnique.com/
[traytor]: https://github.com/sickill/traytor
[semver]: http://semver.org/

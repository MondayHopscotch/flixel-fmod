# Flixel FMOD

A simple flixel-tie in library to make using the [haxe-fmod](https://github.com/Tanz0rz/haxe-fmod) library easy to integrate into flixel projects.

# Features

- Flixel volume control

# Usage/Setup

Before calling `new FlxGame(...)`, set up the `preGameStart` signal to initialize `FlxFmod`:

```haxe
FlxG.signals.preGameStart.add(() -> {
	FlxFmod.init();
});
```

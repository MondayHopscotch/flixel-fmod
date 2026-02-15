package haxefmod;

import flixel.FlxG;
import flixel.FlxState;

import haxefmod.FmodManager;
import haxefmod.FmodEvents.FmodCallback;
import haxefmod.FmodEvents.FmodEvent;
import haxefmod.FmodEvents.FmodEventListener;
import haxefmod.FmodManagerPrivate;


class FlxFmod {
	private static var instance:FlxFmod;

	private static function GetInstance():FlxFmod {
        if (instance == null) {
            instance = new FlxFmod();
            // For some reason the compiler doesn't think instance satisfies the interface
            // FmodManager.RegisterEventListener(instance);
        }
        return instance;
    }

    public static function Init() {
        // disable built-in flixel volume sounds
		FlxG.sound.soundTray.silent = true;

        // Let us handle volume adjustments
        FlxG.sound.onVolumeChange.add(GetInstance().handleVolumeChanged);

        // We don't have a way to be told of the initial volume, so just manually do it at init time
        GetInstance().handleVolumeChanged(FlxG.sound.volume);
    }

    /** 
        Sends the "stop" command to the FMOD API and waits for the
        current song to stop before triggering a state transition
        @param state the state to load after the music stops
    **/
    public static function TransitionToStateAndStopMusic(state:FlxState) {
        GetInstance().handleTransitionToStateAndStopMusic(state);
    }

    /**
        Convenience method that simply calls FlxG.switchState(state)

        Any loaded music will continue to play even after loading the new state
        @param state the state to load
    **/
    public static function TransitionToState(state:FlxState) {
        GetInstance().handleTransitionToState(state);
    }

    private function new() {}

    private function handleVolumeChanged(v:Float):Void {
        // TODO: Change fmod main bus volume level
        trace('handling new volume level: ${v}');
    }

    private function handleTransitionToStateAndStopMusic(state:FlxState) {
        if (!FmodManager.IsSongPlaying()) {
            FlxG.switchState(state.new);
            return;
        }

        FmodManager.CheckIfUpdateIsBeingCalled();

        FmodManager.RegisterCallbacksForSound("SongEventInstance", ()-> {
            FlxG.switchState(state.new);
        }, FmodCallback.STOPPED);

        FmodManager.StopSong();
    }

    private function handleTransitionToState(state:FlxState) {
        FlxG.switchState(state.new);
    }

    // Here to satisfy the interface
    public function ReceiveEvent(e:FmodEvent):Void {

    }
}
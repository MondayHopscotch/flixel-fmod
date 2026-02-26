package haxefmod;


import flixel.FlxG;
import flixel.util.typeLimit.NextState;

import haxefmod.FmodManager;
import haxefmod.FmodEvents.FmodEvent;
import haxefmod.FmodEvents.FmodCallback;


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
        GetInstance().handleVolumeChanged(FlxG.sound.muted ? 0 : FlxG.sound.volume);
    }

    /** 
        Sends the "stop" command to the FMOD API and waits for the
        current song to stop before triggering a state transition
        @param state the state to load after the music stops
    **/
    public static function stopMusicAndSwitchState(state:NextState) {
        GetInstance().handleStopMusicAndSwitchState(state);
    }

    /**
        Convenience method that simply calls FlxG.switchState(state)

        Any loaded music will continue to play even after loading the new state
        @param state the state to load
    **/
    public static function switchState(state:NextState) {
        GetInstance().handleSwitchState(state);
    }

    private function new() {}

    private function handleVolumeChanged(v:Float):Void {
        FmodManager.SetBusVolume("bus:/", v);
    }

    private function handleStopMusicAndSwitchState(nextState:NextState) {
        if (!FmodManager.IsSongPlaying()) {
            FlxG.switchState(nextState);
            return;
        }

        FmodManager.CheckIfUpdateIsBeingCalled();

        FmodManager.RegisterCallbacksForSound("SongEventInstance", ()-> {
            FlxG.switchState(nextState);
        }, FmodCallback.STOPPED);

        FmodManager.StopSong();
    }

    private function handleSwitchState(nextState:NextState) {
        FlxG.switchState(nextState);
    }
}
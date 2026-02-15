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
            FmodManager.RegisterEventListener(instance);
        }
        return instance;
    }

    /** 
        Sends the "stop" command to the FMOD API and waits for the
        current song to stop before triggering a state transition
        @param state the state to load after the music stops
        @see https://tanneris.me/FMOD-AHDSR
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

    private function handleTransitionToStateAndStopMusic(state:FlxState) {
        if (!FmodManager.IsSongPlaying()) {
            FlxG.switchState(state);
            return;
        }

        FmodManager.CheckIfUpdateIsBeingCalled();

        FmodManager.RegisterCallbacksForSound("SongEventInstance", ()-> {
            FlxG.switchState(state);
        }, FmodCallback.STOPPED);

        FmodManager.StopSong();
    }

    private function handleTransitionToState(state:FlxState) {
        FlxG.switchState(state);
    }

    // Here to satisfy the interface
    public function ReceiveEvent(e:FmodEvent):Void {

    }
}
package;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.TouchEvent;
import openfl.events.MouseEvent;

class Main extends Sprite
{
	var gameWidth:Int = 960;
	var gameHeight:Int = 720;
	var initialState:Class<FlxState> = PlayState;
	var zoom:Float = 1;
	var framerate:Int = 30;
	var skipSplash:Bool = true;
	var startFullscreen:Bool = false;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));
		
		// addEventListener(Event.ENTER_FRAME, Touch.update);
	}
}
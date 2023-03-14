package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import haxe.Timer;
import sys.thread.Thread;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	public var canvas:Canvas;
	public var audio:FlxSound;
	public var ready:Bool = false;
	public var startTime:Float = 0;
	public var time:Float = 0;
	public var hue:Float = 0;
	public var sat:Float = 0;
	public var light:Float = 1;
	
	override public function create()
	{
		canvas = new Canvas();
		add(canvas);
		
		audio = FlxG.sound.load("assets/audio.ogg");
		
		Frames.init();
		
		new FlxTimer().start(3, (tmr:FlxTimer) ->
		{
			audio.play();
			startTime = Timer.stamp();
			ready = true;
		}, 1);
			
		super.create();
	}
	
	override public function onFocus():Void
	{
		super.onFocus();
		
		startTime = Timer.stamp() - time;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (ready)
		{
			time = Timer.stamp() - startTime;
			var timeMs:Float = time * 1000;
			if (Math.abs(audio.time - timeMs) >= 50) audio.time = timeMs;
			canvas.contours = Frames.fetchContours(Std.int(time * 30));
			
			hue += FlxG.mouse.wheel * 2;
			if (hue < 0) hue += 360;
			if (hue > 360) hue -= 360;
			
			if (FlxG.keys.justPressed.Q) sat -= 0.05;
			if (FlxG.keys.justPressed.E) sat += 0.05;
			if (sat < 0) sat = 1;
			if (sat > 1) sat = 0;
			
			if (FlxG.keys.justPressed.A) light -= 0.05;
			if (FlxG.keys.justPressed.D) light += 0.05;
			if (light < 0) light = 1;
			if (light > 1) light = 0;
			
			canvas.col = FlxColor.fromHSL(hue, sat, light);
		}
	}
}
package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.system.FlxSound;
import openfl.display.StageQuality;
import haxe.Timer;
import sys.thread.Thread;

class PlayState extends FlxState
{
	// public var canvas:Canvas;
	public var canvas:FlxSprite;
	public var audio:FlxSound;
	public var ready:Bool = false;
	public var startTime:Float = 0;
	public var time:Float = 0;
	public var hue:Float = 0;
	public var sat:Float = 0;
	public var light:Float = 1;
	public var col:FlxColor = FlxColor.WHITE;
	public var contours:Array<Array<Array<Int>>> = [];
	public var lineStyle:LineStyle;
	public var fill:Bool = false;
	
	override public function create()
	{
		// canvas = new Canvas();
		// add(canvas);
		
		#if (mobile)
		FlxG.mouse.visible = false;
		#end
		
		canvas = new FlxSprite();
		canvas.makeGraphic(960, 720, 0, true);
		canvas.screenCenter();
		add(canvas);
		
		Frames.init();
		
		lineStyle = FlxSpriteUtil.getDefaultLineStyle({
			thickness: 3,
			color: col
		});
		
		audio = FlxG.sound.load("assets/audio.ogg");
		new FlxTimer().start(1, (tmr:FlxTimer) ->
		{
			audio.play();
			startTime = Timer.stamp();
			ready = true;
		}, 1);
		
		// trace(FlxG.stage.quality);
		FlxG.stage.quality = StageQuality.LOW;
		
		super.create();
	}
	
	override public function onFocus():Void
	{
		super.onFocus();
		
		startTime = Timer.stamp() - time;
	}
	
	override public function draw()
	{
		FlxSpriteUtil.fill(canvas, 0);
		
		var fillCol:FlxColor = 0;
		if (fill)
		{
			fillCol = col;
			lineStyle.color = FlxColor.BLACK;
		}
		
		for (points in contours)
		{
			if (points.length > 1)
			{
				FlxSpriteUtil.beginDraw(fillCol, lineStyle);
				FlxSpriteUtil.flashGfx.moveTo(points[0][0], points[0][1]);
				for (i in 1...points.length)
				{
					var point:Array<Int> = points[i];
					FlxSpriteUtil.flashGfx.lineTo(point[0], point[1]);
				}
				FlxSpriteUtil.endDraw(canvas, null);
			}
		}
		
		super.draw();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (ready)
		{			
			time = Timer.stamp() - startTime;
			var timeMs:Float = time * 1000;
			if (Math.abs(audio.time - timeMs) >= 50) audio.time = timeMs;
			// canvas.contours = Frames.fetchContours(Std.int(time * 30));
			contours = Frames.fetchContours(Std.int(time * 30));
			
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
			
			// canvas.col = FlxColor.fromHSL(hue, sat, light);
			col = FlxColor.fromHSL(hue, sat, light);
			lineStyle.color = col;
			
			if (FlxG.mouse.justPressed || FlxG.touches.justStarted().length > 0) fill = !fill;
		}
	}
}
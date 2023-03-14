package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;

using flixel.util.FlxSpriteUtil;

class Canvas extends FlxSprite
{
	public var contours:Array<Array<Array<Int>>> = [];
	public var col:FlxColor = FlxColor.WHITE;
	
	public function new()
	{
		super();
		makeGraphic(FlxG.width, FlxG.height, 0, true);
		screenCenter();
	}
	
	override public function draw()
	{
		this.fill(0);
		var old = FlxG.stage.quality;
		FlxG.stage.quality = openfl.display.StageQuality.LOW;

		var lineStyle = FlxSpriteUtil.getDefaultLineStyle({
			thickness: 3,
			color: col
		});

		for (lines in contours)
		{
			// var vertices:Array<FlxPoint> = [];

			if(lines.length > 1) {
				FlxSpriteUtil.beginDraw(0x0, lineStyle);
				FlxSpriteUtil.flashGfx.moveTo(lines[0][0], lines[0][1]);
				for (i in 1...lines.length)
				{
					var p2:Array<Int> = lines[i];
					FlxSpriteUtil.flashGfx.lineTo(p2[0], p2[1]);
				}
				FlxSpriteUtil.endDraw(this, null);
			}

			/*
			for (i in 0...lines.length)
			{
				vertices.push(FlxPoint.get(lines[i][0], lines[i][1]));
			}
			this.drawPolygon(vertices, FlxColor.WHITE);
			*/
		}
		FlxG.stage.quality = old;
		super.draw();
	}
}
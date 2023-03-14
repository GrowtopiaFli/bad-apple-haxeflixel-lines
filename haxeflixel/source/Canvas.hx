package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

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
		for (lines in contours)
		{
			// var vertices:Array<FlxPoint> = [];
			
			for (i in 1...lines.length)
			{
				var p1:Array<Int> = lines[i - 1];
				var p2:Array<Int> = lines[i];
				this.drawLine(p1[0], p1[1], p2[0], p2[1],
				{
					thickness: 3,
					color: col
				});
			}
			
			/*
			for (i in 0...lines.length)
			{
				vertices.push(FlxPoint.get(lines[i][0], lines[i][1]));
			}
			this.drawPolygon(vertices, FlxColor.WHITE);
			*/
		}
		super.draw();
	}
}
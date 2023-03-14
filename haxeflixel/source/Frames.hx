package;

import sys.io.File;
import sys.io.FileInput;
import sys.io.FileSeek;
import haxe.io.Eof;

class Frames
{
	public static var file:FileInput;
	public static var positions:Array<Int> = [];
	
	public static function init():Void
	{
		file = File.read("assets/video.bin", true);
		file.bigEndian = true;
		cachePositions();
	}
	
	public static function cachePositions():Void
	{
		var framesMap:FileInput = File.read("assets/frames.map");
		while (true)
		{
			try
			{
				positions.push(Std.parseInt(framesMap.readLine()));
			}
			catch (e:Eof)
			{
				break;
			}
		}
	}
	
	public static function seek(pos:Int):Void
	{
		file.seek(pos, SeekBegin);
	}
	
	public static function fetchContours(frame:Int):Array<Array<Array<Int>>>
	{
		var contours:Array<Array<Array<Int>>> = [];
		try
		{
			if (frame < positions.length)
			{
				// trace("----");
				// trace("frame: ");
				// trace(frame);
				// trace("-");
				var pos:Int = positions[frame];
				// trace(pos);
				seek(pos);
				var frameSize:Int = file.readUInt16();
				pos += 2;
				var frameSizePos:Int = pos + frameSize;
				// trace("		pos:");
				// trace(pos);
				// trace("		fsize:");
				// trace(frameSize);
				// trace("		fsize_pos:");
				// trace(frameSizePos);
				var readingContour:Bool = false;
				var prevVal:Int = 0;
				var idx:Int = 0;
				var contourSizePos:Int = 0;
				var contourData:Array<Array<Int>> = [];
				
				while (pos <= frameSizePos)
				{
					if (!readingContour)
					{
						var contourSize:Int = file.readUInt16();
						pos += 2;
						// trace("		pos:");
						// trace(pos);
						contourSizePos = pos + contourSize;
						// trace("		con_siz_pos:");
						// trace(contourSizePos);
						readingContour = true;
					}
					else
					{
						var val:Int = file.readUInt16();
						pos += 2;
						if (idx % 2 == 1)
						{
							contourData.push([prevVal, val]);
						}
						else
						{
							prevVal = val;
						}
						idx++;
						if (pos >= contourSizePos)
						{
							// trace("ooooooooooh");
							contours.push(contourData);
							contourData = [];
							idx = 0;
							readingContour = false;
						}
					}
				}
			}
		}
		catch (e:Eof)
		{
		}
		return contours;
	}
}
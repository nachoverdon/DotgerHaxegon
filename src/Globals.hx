package;

import haxegon.*;

class Globals 
{
	static public var backgroundSaturation: Float = 0.3;
	static public var backgroundLightness: Float = 0.3;
	static public var backgroundChangeSpeed: Float = 30;
	
	public function new() 
	{
		
	}
	
	// Changes the color of the game's background.
	static public function changeBackgroundColor() {
		Gfx.clearscreen(
			Col.hsl(
				Core.time * backgroundChangeSpeed,
				Globals.backgroundSaturation,
				Globals.backgroundLightness
			)
		);
	}
}
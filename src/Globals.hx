package;

import haxegon.*;

class Globals 
{
	static public var _MIN_SPEED: Int = 5;
	static public var _MAX_SPEED: Int = 7;
	static public var _MIN_SIZE: Int = 10;
	static public var _MAX_SIZE: Int = 20;
	static public var backgroundSaturation: Float = 0.3;
	static public var backgroundLightness: Float = 0.3;
	static public var backgroundChangeSpeed: Float = 35;
	static public var UI_TEXT_SATURATION: Float = 0.2;
	static public var UI_TEXT_LIGHTNESS: Float = 0.2;
	
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
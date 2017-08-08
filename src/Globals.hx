package;

import haxegon.*;

class Globals 
{
	static public var level: Int = 0;
	static public var _songPlaying: Bool = true;
	static public var _HIGH_SCORE: Int = 0;
	static public var _MIN_SPEED: Int = 5;
	static public var _MAX_SPEED: Int = 7;
	static public var _MIN_SIZE: Int = 10;
	static public var _MAX_SIZE: Int = 20;
	static public var backgroundSaturation: Float = 0.25; // .3
	static public var backgroundLightness: Float = 0.2; // .3
	static public var backgroundChangeSpeed: Float = 35;
	static public var UI_TEXT_SATURATION: Float = 0.35; // .2
	static public var UI_TEXT_LIGHTNESS: Float = 0.35; // .2
	static private var _INIT_SIZE: Float = 35;
	static private var _MAX_CIRCLES_SIZE: Float = 70;
	static private var _BACKGROUND_CIRCLES_INCREASE_SPEED: Float = 1; // _level + 1 !!
	static private var backgroundCirclesAmount = 7;
	static private var size: Float;
	static private var color: Int;
	static private var mult: Float = 1.6;
	static private var X_MID: Int = Gfx.screenwidthmid;
	static private var Y_MID: Int = Gfx.screenheightmid;
	static public var allowBackgroundCircles: Bool = true;
	
	public function new() 
	{

	}
	
	static public function init() {
		//#if windows || linux || mac
			allowBackgroundCircles = true;
		//#else
			//allowBackgroundCircles = false;
		//#end
		size = _INIT_SIZE;	
		updateColor();
		//createBackgroundCircles();
	}
	
	static private function updateColor() {
		color = Col.hsl(
			Core.time * backgroundChangeSpeed,
			backgroundSaturation,
			backgroundLightness
		);
		
	}
	
	static public function checkToggleBackgroundCircles() {
		if (Input.justpressed(Key.B)) {
			if (allowBackgroundCircles) allowBackgroundCircles = false;
			else allowBackgroundCircles = true;
		}
		
	}
	
	static public function checkToggleMusic() {
		if (Input.justpressed(Key.M)) {
			if (_songPlaying) {
				_songPlaying = false;
			} else {
				_songPlaying = true;
			}
		}
	}
	
	// Changes the color of the game's background.
	static public function changeBackgroundColor() {
		X_MID = Gfx.screenwidthmid;
		Y_MID = Gfx.screenheightmid;
		updateColor();
		Gfx.clearscreen(color);
		if (allowBackgroundCircles) updateBackgroundCircles();			
		
		
	}
	
	//static private function createBackgroundCircles() {
		//bg = new Array<Ball>();
		//for (idx in 0 ... backgroundCirclesAmount) {
			//if (idx % 2 == 0) {
				//color = Col.hsl(Core.time * backgroundChangeSpeed, 0.25, 0.175);
			//}
			//bg.push(new Ball(X_MID, Y_MID, size * mult * (idx + 1), color));
//
		//}
		//bg.reverse();
	//}
	
	static private function updateBackgroundCirclesSize() {
		if (size >= _MAX_CIRCLES_SIZE) size = _INIT_SIZE;
		else size += _BACKGROUND_CIRCLES_INCREASE_SPEED + ((level + 1) / 5);
	
	}
	
	//static private function updateBackgroundCircles() {
		//updateBackgroundCirclesSize();
		//for (circle in bg) {
			//var idx = bg.indexOf(circle);
			//if (idx % 2 == 0) {
				//color = Col.hsl(Core.time * backgroundChangeSpeed, 0.25, 0.18); //0.25, 0.3);
			//} else updateColor();
			//circle.size = size * mult * ((bg.length - 1) - (idx + 1));
			//circle.setColor(color);
			//circle.draw();
			////Gfx.fillcircle(X_MID, Y_MID, size * mult * ((bg.length - 1) - (idx + 1)), color);
		//}
	//}
	
		static private function updateBackgroundCircles() {
		updateBackgroundCirclesSize();
		for (idx in 0 ...backgroundCirclesAmount) {
			if (idx % 2 == 0) {
				color = Col.hsl(Core.time * backgroundChangeSpeed, 0.25, 0.18); //0.25, 0.3);
			} else updateColor();
			//color = Col.hsl(Core.time * backgroundChangeSpeed, 0.25, 0.18); //0.25, 0.3);
			var radius = size * mult * (backgroundCirclesAmount - (idx + 1));
			//Gfx.linethickness = 5;//radius / 2;
			Gfx.fillcircle(X_MID, Y_MID, radius, color);
		}
	}
	
	
	
}
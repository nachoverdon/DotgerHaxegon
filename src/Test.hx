package;

import haxegon.*;

class Test 
{
	static private var _INIT_SIZE: Float = 35;
	static private var _MAX_SIZE: Float = 65;
	private var _BACKGROUND_CIRCLES_INCREASE_SPEED: Float = 0.8; // _level + 1 !!
	private var backgroundCirclesAmount = 5;
	private var size: Float;
	public var color: Int;
	public var mult: Float = 1.6;
	public var lightness: Float = 1;
	public var alpha: Float = 1;
	public var X_MID: Int = Gfx.screenwidthmid;
	public var Y_MID: Int = Gfx.screenheightmid;
	public var bg: Array<Ball>;
	
	
	public function new() 
	{
		
	}
	
	function reset() {
		size = _INIT_SIZE;
		handleColor();
		bg = new Array<Ball>();
		
		createBackgroundCircles();
		
	}
	
	function createBackgroundCircles() {
		for (idx in 0 ... backgroundCirclesAmount) {
			if (idx % 2 == 0) {
				color = Col.hsl(Core.time * Globals.backgroundChangeSpeed, 0.25, 0.175);
			}
			bg.push(new Ball(X_MID, Y_MID, size * mult * (idx + 1), color, alpha));

		}
		bg.reverse();
	}
	
	function updateBackgroundCirclesSize() {
		var level = 0;
		
		if (GameScene._level != null) level = GameScene._level + 1;
		else level++;
		
		if (size >= _MAX_SIZE) size = _INIT_SIZE;
		else size += _BACKGROUND_CIRCLES_INCREASE_SPEED + level;
	
	}
	
	function updateBackgroundCircles() {
		updateBackgroundCirclesSize();
		for (circle in bg) {
			var idx = bg.indexOf(circle);
			if (idx % 2 == 0) {
				color = Col.hsl(Core.time * Globals.backgroundChangeSpeed, 0.25, 0.18); //0.25, 0.3);
			} else handleColor();
			circle.size = size * mult * ((bg.length - 1) - (idx + 1));
			circle.setColor(color);
			circle.draw();
		}
	}
	
	function update() {
		Globals.changeBackgroundColor();
		
		
		
		updateBackgroundCircles();
		
		
		
		Core.showstats = true;
		
	}
	
	function handleColor() {
		color = Col.hsl(
			Core.time * Globals.backgroundChangeSpeed,
			Globals.backgroundSaturation,
			Globals.backgroundLightness
		);
		
	}
	
	
}
package;

import haxegon.*;

class Test 
{
	private var ball: Ball;
	public var color: Int; 
	public var lightness: Float = 1;
	public var X_MID: Int = Gfx.screenwidthmid;
	public var Y_MID: Int = Gfx.screenheightmid;
	
	
	public function new() 
	{
		
	}
	
	function reset() {
		ball = new Ball(X_MID, Y_MID, 50, Col.WHITE);
	}
	
	
	function update() {
		handleColor();
		Globals.changeBackgroundColor();
		ball.updateColor();
		ball.draw();

		if (Input.justpressed(Key.DOWN)) ball.shrink(0.04);
		if (Input.justpressed(Key.UP)) ball.blend(0.04);
		if (Input.justpressed(Key.RIGHT)) Gfx.clearscreen(Col.BLUE);
		
		Text.size = 4;
		Text.align(Text.CENTER);
		Text.display(X_MID, Y_MID, 'PLAY', color);
	}
	
	function handleColor() {		
		
		if (lightness <= Globals.backgroundLightness) {
			lightness = Globals.backgroundLightness;
		} else {
			lightness -= 0.01;
		}
		
		color = Col.hsl(
			Core.time * Globals.backgroundChangeSpeed,
			Globals.backgroundSaturation,
			lightness
		);
		
	}
	
}
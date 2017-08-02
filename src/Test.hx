package;

import haxegon.*;

class Test 
{
	private var ball: Ball;
	private var t: Debris;
	private var e: Debris;
	private var s: Debris;
	public var color: Int; 
	public var lightness: Float = 1;
	public var X_MID: Int = Gfx.screenwidthmid;
	public var Y_MID: Int = Gfx.screenheightmid;
	
	
	public function new() 
	{
		
	}
	
	function reset() {
		Gfx.createimage('test', Gfx.screenwidth, Gfx.screenheight);
		ball = new Ball(X_MID, Y_MID, 50, Col.WHITE);
		//Core.delaycall(killHexagon, 2);
		s = new Debris(100, 300, 30, 3);
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
		
		
		//drawHexagon();
		
		
		s.draw();
		
		
		//Gfx.drawtoimage('test');
		//Gfx.drawbox(50, 50, 50, 50, Col.WHITE);
		//Gfx.rotation(Core.time * 133.7, 75, 75);
		//Gfx.drawtoscreen();
		//Gfx.drawimage(0, 0, 'test');
		Core.showstats = true;
		
		
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
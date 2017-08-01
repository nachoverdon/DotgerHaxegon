package;

import haxegon.*;

class Test 
{

	public var color: Int; 
	public var lightness: Float = 1;
	public var X_MID: Int = Gfx.screenwidthmid;
	public var Y_MID: Int = Gfx.screenheightmid;
	
	
	public function new() 
	{
		
	}
	
	function reset() {
		
	}
	
	
	function update() {
		handleColor();
		Globals.changeBackgroundColor();
		
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
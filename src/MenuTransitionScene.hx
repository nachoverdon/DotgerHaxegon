package;

import haxegon.*;

class MenuTransitionScene 
{

	private var BLOOM_DECREASE_SPEED: Float = 0.1;
	private var bloom: Float = 7;
	
	
	public function new() 
	{
		
	}
	
	function update() {
		Globals.changeBackgroundColor();
		screenBloom();
		decreaseBloom();
	}
	
	function screenBloom() {
		Filter.bloom = bloom;
	}
	
	function decreaseBloom() {
		bloom -= BLOOM_DECREASE_SPEED;
		
		if (bloom <= 0) {
			Filter.reset();
			Scene.change(MenuScene);
		}
	}
	
}
package;

import haxegon.*;

class Replay 
{

	public function new() 
	{
		
	}
	
	public function reset() {
		Scene.change(GameScene);
	}
	
	public function update() {
		Globals.changeBackgroundColor();
	}
	
}
package;

import haxegon.*;

class Main 
{
	private var GAME_NAME: String = 'DOTGER';
	private var GAME_BY: String = "A game by Nacho 'bazoo' Verdon";
	private var TEXT_BLENDING_SPEED: Float = 0.01;
	
	private var isChangingScene: Bool = false;
	private var showText: Bool = true;
	private var bloom: Float = 0;
	private var isBlending: Bool = false;
	public var color: Int; 
	public var lightness: Float = 1;
	public var X_MID: Int = Gfx.screenwidthmid;
	public var Y_MID: Int = Gfx.screenheightmid;
	
	public function new() 
	{
		//Scene.change(GameScene);
		Music.loadsong('music/dotger100bpm');
		Music.loadsong('music/dotger110bpm');
		Music.loadsong('music/dotger120bpm');
		Music.loadsong('music/dotger130bpm');
		Music.loadsong('music/dotger140bpm');
		Music.loadsound('playerHitDebris', 0.8);
		Music.loadsound('playerHitPowerUp', 0.4);
		Core.delaycall(startBlending, 2);
	}
	
	function update() {
		Globals.changeBackgroundColor();
		if (isBlending) handleColor();
		updateColor();
		drawText();
		
	}
	
	function drawText() {
		if (showText) {
			var offset = 50;
			Text.size = 4;
			Text.align(Text.CENTER);
			Text.display(Gfx.screenwidthmid, Gfx.screenheightmid - offset, GAME_NAME, color);
			Text.size = 3;
			Text.display(Gfx.screenwidthmid, Gfx.screenheightmid, GAME_BY, color);
		}
	}
	
	function updateColor() {
		color = Col.hsl(
			Core.time * Globals.backgroundChangeSpeed,
			Globals.backgroundSaturation,
			lightness
		);
	}
	
	function handleColor() {		

		if (lightness <= Globals.backgroundLightness) {
			lightness = Globals.backgroundLightness;
			if (!isChangingScene) {
				isChangingScene = true;
				Core.delaycall(goToMenuScene, 1);
			}
		} else {
			lightness -= TEXT_BLENDING_SPEED;
		}

		
	}
	
	function goToMenuScene() {
		Scene.change(MenuScene);
	}
	
	function startBlending() {
		isBlending = true;
	}
	
	
	
}
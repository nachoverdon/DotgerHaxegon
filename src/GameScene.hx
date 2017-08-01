package;

import haxegon.*;

class GameScene {
	private var DEBUG_MODE: Bool = true;
	
	private var _TXT_RESTART: String = '[R]estart';
	
	//private var _PLAYER_MENU_DECREASE_SPEED: Float = 0.005;
	private var _PLAYER_INITIAL_DECREASE_SPEED: Float = 0.02;
	private var _PLAYER_INITIAL_SIZE: Float = 50;
	private var _PLAYER_INITIAL_SATURATION: Float = 0.5;
	private var _PLAYER_MIN_SIZE: Float = 4;
	private var _PLAYER_SPEED_X: Int = 10;
	private var _PLAYER_SPEED_Y: Int = 10;

	private var _playerSize: Float;
	private var _playerDecreaseSpeed: Float;
	private var _playerSaturation: Float;
	private var _playerColor: Int;
	private var _playerAlpha: Float;
	
	private var _playerX: Float;
	private var _playerY: Float;
	
	//private var _backgroundSaturation: Float;
	//private var _backgroundLightness: Float;

	function new() {
		Scene.change(MenuScene);
		//setInitialValues();
	}
	
	// Restarts the game.
	function reset() {
		initialize();
		// TODO: make it that it kills every debris/power up on screen.
	}
	
	function update() {
		Globals.changeBackgroundColor();
		//changeBackgroundColor();
		checkInputs();
		drawPlayer();
		debugGame();
	}
	
	// Initializes all the necessary variables.
	function initialize() {
		_playerSize = _PLAYER_INITIAL_SIZE;
		_playerDecreaseSpeed = _PLAYER_INITIAL_DECREASE_SPEED;
		_playerSaturation = 0.5;
		_playerColor = Col.hsl(Core.time * 30, _playerSaturation, 0.5);
		_playerAlpha = 1;
		_playerX = Gfx.screenwidthmid;
		_playerY = Gfx.screenheightmid;
		
		//_backgroundSaturation = Globals.backgroundSaturation;
		//_backgroundLightness = Globals.backgroundLightness;
	}
		
	// Checks for all the inputs.
	function checkInputs() {
		checkPlayerInputs();
		
		// Restarts the game
		// TODO: Make it that it actually restarts the game lol
		if (Input.justpressed(Key.R)) {
			Text.display(50, 50, "[R]estarting...");
			Scene.change(MenuScene);
		}
	}
	
	// Decreases the size of the player by the given amount, but never below minimum.
	function decreasePlayerSizeBy(amount: Float) {
		_playerSize -= amount;
		
		if (_playerSize < _PLAYER_MIN_SIZE) {
			killPlayer();
		}
	}
	
	// Destroys the player.
	function killPlayer() {
		// TODO: Proper kill animation.
		//	Ask if they want to restart and whatnot
		_playerAlpha = 0;
	}
	
	//// Changes the color of the game's background.
	//function changeBackgroundColor() {
		//Gfx.clearscreen(Col.hsl(Core.time * 30, _backgroundSaturation, _backgroundLightness));
	//}
	
	// Checks for input from the player and moves the ball around.
	function checkPlayerInputs() {	
		// Horizontal movement
		if (Input.pressed(Key.LEFT)) {
			_playerX -= _PLAYER_SPEED_X;
		} else if (Input.pressed(Key.RIGHT)) {
			_playerX += _PLAYER_SPEED_X;
		}
		
		// Vertical movement
		if (Input.pressed(Key.UP)) {
			_playerY -= _PLAYER_SPEED_Y;
		} else if (Input.pressed(Key.DOWN)) {
			_playerY += _PLAYER_SPEED_Y;
		}
		
		// Check bounds
		// Horizontal
		if (_playerX < _playerSize) {
			_playerX = _playerSize;
		} else if (_playerX > Gfx.screenwidth - _playerSize) {
			_playerX = Gfx.screenwidth - _playerSize;
		}
		
		// Vertical
		if (_playerY < _playerSize) {
			_playerY = _playerSize;
		} else if (_playerY > Gfx.screenheight - _playerSize) {
			_playerY = Gfx.screenheight - _playerSize;
		}
	}

	// Draws the player on the screen. Handling it's size and color.
	function drawPlayer() {
		changePlayerColor();
		decreasePlayerSizeBy(_playerDecreaseSpeed);
		Gfx.fillcircle(_playerX, _playerY, _playerSize, _playerColor, _playerAlpha);
	}

	// Changes the color of the ball depending on state.
	function changePlayerColor() {		
		// TODO: Handle saturation variation
		_playerColor = Col.hsl(Core.time * 30, _playerSaturation, 0.5);
	}
	
	// Changes the background saturation and lightness with the arrows.
	function testBackgroundColors() {
		//if (Input.justpressed(Key.DOWN)) Globals.backgroundSaturation -= 0.1;
		//if (Input.justpressed(Key.RIGHT)) Globals.backgroundLightness += 0.1;
		//if (Input.justpressed(Key.UP)) Globals.backgroundSaturation += 0.1;
		//if (Input.justpressed(Key.LEFT)) Globals.backgroundLightness -= 0.1;
	}
	
	// Enables filters on key presses (1 and 2 on, 3 off)
	function testFilters() {
		if (Input.justpressed(Key.ONE)) {
			Filter.reset();
			Filter.bloom = 1;
		}
		if (Input.justpressed(Key.TWO)) {
			Filter.reset();
			Filter.blur = true;
		}
		if (Input.justpressed(Key.THREE)) {
			Filter.reset();
		}
	}
	
	function debugGame() {
		Core.showstats = false;
		
		if (DEBUG_MODE) {
			Core.showstats = true;
			
			testFilters();
			testBackgroundColors();

			Debug.clear();
			Debug.log("FPS:               " + Convert.tostring(Core.fps));
			Debug.log("bg_sat: " + Convert.tostring(Globals.backgroundSaturation));
			Debug.log("bg_lig: " + Convert.tostring(Globals.backgroundLightness));
		}
	}
}
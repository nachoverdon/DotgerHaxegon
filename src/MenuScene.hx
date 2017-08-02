package;

import haxegon.*;

class MenuScene 
{
	private var _PLAYER_INITIAL_SIZE: Float = 50;
	private var _PLAYER_INITIAL_X: Float = Gfx.screenwidthmid;
	private var _PLAYER_INITIAL_Y: Float = Gfx.screenheightmid;
	private var _PLAYER_INITIAL_SATURATION: Float = 0.5;
	private var _PLAYER_INITIAL_LIGHTNESS: Float = 0.5;
	private var _PLAYER_INITIAL_SHRINK_SPEED: Float = 0.05;
	
	private var player: Ball;
	
	private var _HOW_TO: String = 'Arrows';
	private	var _HINT_DELAY: Int = 6;
	private var _HINT_OFFSET: Float = 25;
	private var _SAT_LIG_MAX: Float = 0.05;
	private var _SAT_LIG_SPEED: Float = 0.005;
	private var _sat: Float;
	private var _lig: Float;
	private var _showHint: Bool;
	
	private var _TXT_PLAY: String = 'PLAY';
	private var _TXT_INITIAL_X: Float = 50;
	private var _TXT_INITIAL_Y: Float = Gfx.screenheightmid;
	private var _TXT_SIZE: Float = 3;
	
	private var _txtPlayDisplay: Bool;	
	private var _txtPlayAlpha: Float;
	private var _txtPlayX: Float;
	private var _txtPlayY: Float;

	private var _DOT_INITIAL_X: Float = 40;
	private var _DOT_INITIAL_Y: Float = Gfx.screenheightmid;
	private var _DOT_SATURATION: Float = 0.8;
	private var _DOT_LIGHTNESS: Float = 0.8;
	private var _DOT_SIZE: Float = 10;
	private var _DOT_SPEED: Float = 4;
	private var _DOT_BLEND_SPEED: Float = 0.0025;
	private var _DOT_SHRINK_SPEED: Float = 0.09;
	
	private var dot: Ball;
	
	private var _dotX: Float;
	private var _dotY: Float;
	
	private var _isSequenceRunnning: Bool;
	
	private var _START_GAME_KEYS: Array<Key> = [
		Key.W,
		Key.A,
		Key.S,
		Key.D,
		Key.UP,
		Key.DOWN,
		Key.LEFT,
		Key.RIGHT,
		Key.ENTER,
		Key.SPACE
	];
	
	function new() {}
	
	function update() {
		Globals.changeBackgroundColor();
		displayPlayText();
		drawPlayer();
		drawDot();
		checkStartGame();
		if (_isSequenceRunnning) startGameSequence();
		if (_showHint && !_isSequenceRunnning) displayHint();
	}
	
	function reset() {
		initialize();
		Core.delaycall(enableHint, _HINT_DELAY);
	}
	
	function initialize() {
		_sat = 0;
		_lig = 0;
		_showHint = false;
		_isSequenceRunnning = false;
		_txtPlayX = _TXT_INITIAL_X;
		_txtPlayY = _TXT_INITIAL_Y;
		_txtPlayDisplay = true;
		_txtPlayAlpha = 1;
		
		_dotX = _DOT_INITIAL_X;
		_dotY = _DOT_INITIAL_Y;
		
		player = new Ball(
			_PLAYER_INITIAL_X,
			_PLAYER_INITIAL_Y,
			_PLAYER_INITIAL_SIZE,
			Col.hsl(Core.time * Globals.backgroundChangeSpeed, _PLAYER_INITIAL_SATURATION, _PLAYER_INITIAL_LIGHTNESS)
		);
		
		dot = new Ball(_dotX, _dotY, _DOT_SIZE, Col.hsl(Core.time * Globals.backgroundChangeSpeed, _DOT_SATURATION, _DOT_LIGHTNESS));
		dot.blend(_DOT_BLEND_SPEED);
		dot.shrink(_DOT_SHRINK_SPEED);
		
		player.shrink(_PLAYER_INITIAL_SHRINK_SPEED);
	}
	
	function drawPlayer() {
		player.updateColor();
		player.draw();
		
		if (!player.isShrinking()) {
			player.size = _PLAYER_INITIAL_SIZE;
			player.shrink(_PLAYER_INITIAL_SHRINK_SPEED);
		}
	}
	
	function drawDot() {
		dot.updateColor();
		dot.moveTo(_dotX, _dotY);
		dot.draw();
	
		if (!dot.isBlending() && !_isSequenceRunnning) {
			dot.setSaturation(Ball.INITIAL_SATURATION);
			dot.setLightness(Ball.INITIAL_LIGHTNESS);
			dot.blend(_DOT_BLEND_SPEED);
			dot.size = _DOT_SIZE;
			dot.shrink(_DOT_SHRINK_SPEED);
		}
	}
	
	function startGameSequence() {
		var s = player.size;
		// Animation where the little dot collides with the player, text fades away...
		if (_txtPlayDisplay) _txtPlayDisplay = false;
		
		_dotX += _DOT_SPEED;
		
		if (Geom.inbox(_dotX, _dotY, player.x - s, player.y - s, s * 2, s * 2)) {
			startGame();
		}
	}
	
	function startGame() {
		Scene.change(GameScene);
	}
	
	function checkStartGame() {	
		for (key in _START_GAME_KEYS) {
			if (Input.justpressed(key)) {
				_isSequenceRunnning = true;
				dot.stopBlend();
				dot.stopShrink();
				dot.setSaturation(Ball.INITIAL_SATURATION);
				dot.setLightness(Ball.INITIAL_LIGHTNESS);
				dot.size = _DOT_SIZE;
				return;
			}
			
		}
	}	
	
	function displayPlayText() {
		if (_txtPlayDisplay) {
			Text.size = _TXT_SIZE;
			Text.align(Text.LEFT);
			Text.display(_txtPlayX + _DOT_SIZE, _txtPlayY - _DOT_SIZE, _TXT_PLAY);
		}
	}
	
	function enableHint() {
		_showHint = true;
	}
	
	function displayHint() {
		if (_sat >= _SAT_LIG_MAX && _lig >= _SAT_LIG_MAX) {
			_sat = _SAT_LIG_MAX;
			_lig = _SAT_LIG_MAX;
		} else {
			_sat += _SAT_LIG_SPEED;
			_lig += _SAT_LIG_SPEED;
		}
		
		var color = Col.hsl(
			Core.time * Globals.backgroundChangeSpeed,
			Globals.backgroundSaturation + _sat,
			Globals.backgroundLightness + _lig
		);
		
		var offset = player.size + _HINT_OFFSET;
				
		Text.align(Text.CENTER);
		
		Text.rotation(90, Text.CENTER, Text.CENTER);		
		Text.display(Gfx.screenwidthmid + Convert.toint(Text.height('<') / 2), Gfx.screenheightmid - offset, '<', color);
		
		Text.rotation(90, Text.CENTER, Convert.toint(Text.CENTER / 2));
		Text.display(Gfx.screenwidthmid + Convert.toint(Text.height('>') / 2), Gfx.screenheightmid + offset, '>', color);
		
		Text.rotation(0);
		Text.display(Gfx.screenwidthmid - offset, Gfx.screenheightmid - Convert.toint(Text.height('<') / 2), '<', color);
		Text.display(Gfx.screenwidthmid + offset, Gfx.screenheightmid - Convert.toint(Text.height('>') / 2), '>', color);
	}
	
	
}
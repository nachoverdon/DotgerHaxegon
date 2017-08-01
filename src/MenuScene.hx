package;

import haxegon.*;

class MenuScene 
{
	private var _TXT_PLAY: String = 'Play!';
	private var _TXT_INITIAL_X: Float = 50;
	private var _TXT_INITIAL_Y: Float = Gfx.screenheightmid;
	private var _TXT_SIZE: Float = 3;
	
	private var _txtPlayDisplay: Bool;	
	private var _txtPlayAlpha: Float;
	private var _txtPlayX: Float;
	private var _txtPlayY: Float;

	private var _DOT_INITIAL_X: Float = 30;
	private var _DOT_INITIAL_Y: Float = Gfx.screenheightmid;
	private var _DOT_SATURATION: Float = 0.8;
	private var _DOT_LIGHTNESS: Float = 0.8;
	private var _DOT_SIZE: Float = 10;
	private var _DOT_SPEED: Float = 10;
	private var _DOT_ALPHA_SPEED: Float = 0.01;
	
	private var _dotX: Float;
	private var _dotY: Float;
	private var _dotAlpha: Float;
	
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
		drawDot();
		checkStartGame();
	}
	
	function reset() {
		Filter.reset();
		initialize();
	}
	
	function initialize() {
		_txtPlayX = _TXT_INITIAL_X;
		_txtPlayY = _TXT_INITIAL_Y;
		_txtPlayDisplay = true;
		_txtPlayAlpha = 1;
		
		_dotX = _DOT_INITIAL_X;
		_dotY = _DOT_INITIAL_Y;
		_dotAlpha = 1;
	}
	
	function drawDot() {
		_dotAlpha -= _DOT_ALPHA_SPEED;
		if (_dotAlpha <= 0) {
			_dotAlpha = 1;
		}
		Gfx.fillcircle(_dotX, _dotY, _DOT_SIZE, Col.hsl(Core.time * 30, _DOT_SATURATION, _DOT_LIGHTNESS), _dotAlpha);
	}
	
	function startGameSequence() {
		// Animation where the little dot collides with the player, text fades away...
		startGame();
	}
	
	function startGame() {
		Scene.change(GameScene);
	}
	
	function checkStartGame() {	
		for (key in _START_GAME_KEYS) {
			if (Input.justpressed(key)) {
				startGameSequence();
				return;
			}
			
		}
	}	
	
	function displayPlayText() {
		if (_txtPlayDisplay) {
			Text.size = _TXT_SIZE;
			Text.display(_txtPlayX + _DOT_SIZE, _txtPlayY - _DOT_SIZE, _TXT_PLAY);
			Text.align(Text.LEFT);
		}
	}
}
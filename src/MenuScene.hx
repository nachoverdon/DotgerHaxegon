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
	private	var _HINT_DELAY: Int = 4;
	private var _HINT_OFFSET: Float = 25;
	private var _HINT_OFFSET_EXTRA: Float = 10;
	private var _HINT_OFFSET_EXTRA_SPEED: Float = 0.125;
	private var _SAT_LIG_SPEED: Float = 0.005;
	private var _offsetExtra: Float;
	private var _sat: Float;
	private var _lig: Float;
	private var _showHint: Bool;
	
	private var _TXT_PLAY: String = 'PLAY';
	private var _TXT_INITIAL_X: Float = 50;
	private var _TXT_INITIAL_Y: Float = Gfx.screenheightmid;
	private var _TXT_SIZE: Float = 2;
	
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
		Globals.checkToggleBackgroundCircles();
		Globals.checkToggleMusic();
		//displayPlayText();
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
		_offsetExtra = 0;
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
		if (_offsetExtra >= _HINT_OFFSET_EXTRA) {
			_offsetExtra = 0;
		} else {
			_offsetExtra += _HINT_OFFSET_EXTRA_SPEED;
		}
		
		if (_sat >= Globals.UI_TEXT_SATURATION && _lig >= Globals.UI_TEXT_LIGHTNESS) {
			_sat = Globals.UI_TEXT_SATURATION;
			_lig = Globals.UI_TEXT_LIGHTNESS;
		} else {
			_sat += _SAT_LIG_SPEED;
			_lig += _SAT_LIG_SPEED;
		}
		
		var color = Col.hsl(
			Core.time * Globals.backgroundChangeSpeed,
			Globals.backgroundSaturation + _sat,
			Globals.backgroundLightness + _lig
		);
		
		var playerOffset = player.size + _HINT_OFFSET + _offsetExtra;
		var dotOffset = _HINT_OFFSET + _offsetExtra;
		var charSize = Convert.toint(Text.height('>') / 2);
		
		// Arrows
		Text.align(Text.CENTER);
		Text.size = _TXT_SIZE;
		
		Text.display(_TXT_INITIAL_X + dotOffset, Gfx.screenheightmid - charSize, '>', color);
		
		Text.rotation(90, Text.CENTER, Text.CENTER);		
		Text.display(Gfx.screenwidthmid + charSize, Gfx.screenheightmid - playerOffset, '<', color);
		
		Text.rotation(90, Text.CENTER, Convert.toint(Text.CENTER / 2));
		Text.display(Gfx.screenwidthmid + charSize, Gfx.screenheightmid + playerOffset, '>', color);

		Text.rotation(0);
		Text.display(Gfx.screenwidthmid - playerOffset, Gfx.screenheightmid - charSize, '<', color);
		Text.display(Gfx.screenwidthmid + playerOffset, Gfx.screenheightmid - charSize, '>', color);
		
		// Mute
		Text.align(Text.RIGHT);
		Text.display(Gfx.screenwidthmid - 50, Gfx.screenheight - 100, '[M]usic');
		Text.align(Text.LEFT);
		Text.display(
			Gfx.screenwidthmid - 50 - Text.width('[M]usic') + 2 + Text.width('['),
			Gfx.screenheight - 100,
			'M',
			color
		);
		//Gfx.fillcircle(Gfx.screenwidthmid - 50, Gfx.screenheight - 100, 1, Col.BLACK);
		//Gfx.fillcircle(Gfx.screenwidthmid - 50 - Text.width('[M]usic'), Gfx.screenheight - 100, 1, Col.RED);
		//Gfx.fillcircle(Gfx.screenwidthmid - 50 - Text.width('[M]usic') + 2, Gfx.screenheight - 100, 1, Col.YELLOW);
		//Gfx.fillcircle(Gfx.screenwidthmid - 50 - Text.width('[M]usic') + 2 + Text.width('['), Gfx.screenheight - 100, 1, Col.ORANGE);
		
		if (Globals._songPlaying) Text.display(Gfx.screenwidthmid - 100, Gfx.screenheight - 75, 'ON', color);
		else Text.display(Gfx.screenwidthmid - 100, Gfx.screenheight - 75, 'OFF', color);
		//Gfx.fillcircle(Gfx.screenwidthmid - 100 , Gfx.screenheight - 75, 1, Col.ORANGE);
		//Gfx.fillcircle(Gfx.screenwidthmid - 75 , Gfx.screenheight - 75, 1, Col.WHITE);
		
		// Background
		Text.align(Text.LEFT);
		Text.display(Gfx.screenwidthmid + 50, Gfx.screenheight - 100, '[B]ackground');
		Text.display(
			Gfx.screenwidthmid + 50 + Text.width('[') + 2,
			Gfx.screenheight - 100,
			'B',
			color
		);
		
		
	}
	
	
}
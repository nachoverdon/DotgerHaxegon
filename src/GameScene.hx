package;

import haxegon.*;

class GameScene {
	private var DEBUG_MODE: Bool = false;
	
	private var _songPlaying: Bool;
	private var _actualSong: String;
	private var _VOLUME_DEBRIS: Float = 0.5;
	private var _VOLUME_POWERUP: Float = 0.4;
	
	private var _highScore: Int;
	private var _score: Int;
	private var _SCORE_POWERUP: Int = 2;
	private var _SCORE_DEBRIS: Int = 1;
	private var _SCORE_PENALTY_DEBRIS: Int = 4;
	private var _SCORE_NEXT_LEVEL: Int = 50;
	
	private var RESTART: String = '[R]estart';
	private var GAME_OVER: String = 'GAME OVER';
	
	
	//private var _PLAYER_MENU_DECREASE_SPEED: Float = 0.005;
	private var _PLAYER_INITIAL_DECREASE_SPEED: Float = 0.06;
	private var _PLAYER_INITIAL_SIZE: Float = 50;
	private var _PLAYER_INITIAL_SATURATION: Float = 0.5;
	private var _PLAYER_MIN_SIZE: Float = 4;
	private var _PLAYER_SPEED_X: Int = 10;
	private var _PLAYER_SPEED_Y: Int = 10;
	//private var _PLAYER_HITBOX: Float = 1.0;
	private var _DEBRIS_DAMAGE: Float = 6;

	private var _playerSize: Float;
	private var _playerDecreaseSpeed: Float;
	private var _playerSaturation: Float;
	private var _playerColor: Int;
	private var _playerAlpha: Float;
	private var _isPlayerAlive: Bool;
	
	private var _playerX: Float;
	private var _playerY: Float;
	
	private var _level: Int;
	//private var _backgroundSaturation: Float;
	//private var _backgroundLightness: Float;
	private var _POWERUP_AMOUNTS: Array<Int> = [50, 75, 125, 250, 400];
	private var _POWERUP_MAX_DEVIATION: Int = 15;
	private var _POWERUP_MIN_DEVIATION: Int = 0;
	private var _POWERUP_INITIAL_COOLDOWN: Float = 175;
	private var _POWERUP_SPAWN_COOLDOWN_REDUCTION: Float = 5;
	private var _powerUpSpawnCooldown: Float;
	private var _powerUpActualAmount: Int;
	private var _nextPowerUp: Float;
	private var _powerUpPool: Array<PowerUp>;
	private var _spawnedPowerUpPool: Array<PowerUp>;
	
	
	private var _DEBRIS_AMOUNTS: Array<Int> = [100, 150, 250, 500, 750];
	//private var _DEBRIS_AMOUNTS: Array<Int> = [10, 20, 30, 30, 30];
	private var _DEBRIS_MAX_DEVIATION: Int = 20;
	private var _DEBRIS_MIN_DEVIATION: Int = 5;
	private var _DEBRIS_SPAWN_TUTORIAL: Float = 120;
	private var _DEBRIS_INITIAL_COOLDOWN: Float = 40;
	private var _debrisSpawnCooldown: Float;
	private var _debrisActualAmount: Int;
	private var _nextDebris: Float;
	private var _debrisPool: Array<Debris>;
	private var _spawnedDebrisPool: Array<Debris>;
	

	function new() {
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
		spawnDebris();
		spawnPowerUps();
		drawDebris();
		drawPowerUps();
		debugGame();
		//showLevel();
		showScore();
		if (!_isPlayerAlive) gameOver();
	}
		
	// Initializes all the necessary variables.
	function initialize() {
		_songPlaying = true;
		_level = 0;
		updateMusic();
		//playSong();
		Music.playsound('playerHitPowerUp', _VOLUME_POWERUP);
		_highScore = Globals._HIGH_SCORE;
		_score = 0;
		
		_playerSize = _PLAYER_INITIAL_SIZE;
		_playerDecreaseSpeed = _PLAYER_INITIAL_DECREASE_SPEED;
		_playerSaturation = 0.5;
		_playerColor = Col.hsl(Core.time * Globals.backgroundChangeSpeed, _playerSaturation, 0.5);
		_playerAlpha = 1;
		_isPlayerAlive = true;
		_playerX = Gfx.screenwidthmid;
		_playerY = Gfx.screenheightmid;
		
		PowerUp._MIN_SIZE = PowerUp._INITIAL_MIN_SIZE;
		PowerUp._MAX_SIZE = PowerUp._INITIAL_MAX_SIZE;
		PowerUp._MIN_SPEED = PowerUp._INITIAL_MIN_SPEED;
		PowerUp._MAX_SPEED = PowerUp._INITIAL_MAX_SPEED;
		
		_powerUpSpawnCooldown = _POWERUP_INITIAL_COOLDOWN;
		_powerUpActualAmount = _POWERUP_AMOUNTS[_level];
		_nextPowerUp = _POWERUP_INITIAL_COOLDOWN;
		_powerUpPool = new Array<PowerUp>();
		_spawnedPowerUpPool = new Array<PowerUp>();
		
		//_backgroundSaturation = Globals.backgroundSaturation;
		//_backgroundLightness = Globals.backgroundLightness;
		Debris._MIN_SIZE = Debris._INITIAL_MIN_SIZE;
		Debris._MAX_SIZE = Debris._INITIAL_MAX_SIZE;
		Debris._MIN_SPEED = Debris._INITIAL_MIN_SPEED;
		Debris._MAX_SPEED = Debris._INITIAL_MAX_SPEED;
		_debrisSpawnCooldown = _DEBRIS_INITIAL_COOLDOWN;
		_debrisActualAmount = _DEBRIS_AMOUNTS[_level];
		_nextDebris = 0;
		
		_debrisPool = new Array<Debris>();
		_spawnedDebrisPool = new Array<Debris>();
		createDebris();
		createPowerUps();
	}
	
	function updateMusic() {
		var delay: Float = 0.1;
		Music.fadeout();
		
		switch _level {			
			case 0:
				delay = 0.4;
				_actualSong = 'dotger100bpm';
			case 1:
				_actualSong = 'dotger110bpm';
			case 2:
				_actualSong = 'dotger120bpm';
			case 3:
				_actualSong = 'dotger130bpm';
			case 4:
				_actualSong = 'dotger140bpm';
		}
		
		if (_songPlaying) Core.delaycall(playSong, delay);
	}
	
	function playSong() {
		Music.playsong('music/' + _actualSong);
	}
	
	function getUIColor(): Int {
		return Col.hsl(
				Core.time * Globals.backgroundChangeSpeed,
				Globals.backgroundSaturation + Globals.UI_TEXT_SATURATION,
				Globals.backgroundLightness + Globals.UI_TEXT_LIGHTNESS
			);
	}
	
	function checkHighScore() {
		if (_score > Globals._HIGH_SCORE) Globals._HIGH_SCORE = _score;
	}
	
	function showScore() {
		if (_score > Globals._HIGH_SCORE) _highScore = _score;
		var scoreX;
		var scoreY;
		var highScoreX;
		var highScoreY;
		var score = Convert.tostring(_score);
		var highScore = Convert.tostring(_highScore);
		var highScoreColor = Col.WHITE;
		if (_isPlayerAlive) {
			Text.align(Text.RIGHT);
			Text.size = 3;
			scoreX = Gfx.screenwidth - 10;
			scoreY = 60;
			Text.display(scoreX, scoreY, score, getUIColor());
			
			Text.size = 1;
			highScoreX = Gfx.screenwidth - 10;
			highScoreY = 30;
		} else {
			Text.align(Text.CENTER);
			Text.size = 5;
			scoreX = Gfx.screenwidthmid;
			scoreY = Gfx.screenheightmid - 15;
			Text.display(scoreX, scoreY, score, getUIColor());
			
			Text.size = 3;
			Text.align(Text.CENTER);
			highScoreX = Gfx.screenwidthmid;
			highScoreY = Gfx.screenheightmid - 120;
		}
		
		if (_score == _highScore) highScoreColor = getUIColor();
		
		Text.display(highScoreX, highScoreY, Convert.tostring(Globals._HIGH_SCORE), highScoreColor);
		Text.display(
			highScoreX,
			highScoreY - Text.height('HI-SCORE') - 10,
			'HI-SCORE',
			highScoreColor
		);
		
	}
	
	function showLevel() {
		//Text.size = 1;
		//Text.display(200, 10, 'd minsize' + Convert.tostring(Debris._MIN_SIZE));
		//Text.display(200, 20, 'd maxsize' + Convert.tostring(Debris._MAX_SIZE));
		//Text.display(200, 30, 'd minspd' + Convert.tostring(Debris._MIN_SPEED));
		//Text.display(200, 40, 'd maxspd' + Convert.tostring(Debris._MAX_SPEED));
		//Text.display(300, 10, 'pu minsize' + Convert.tostring(PowerUp._MIN_SIZE));
		//Text.display(300, 20, 'pu maxsize' + Convert.tostring(PowerUp._MAX_SIZE));
		//Text.display(300, 30, 'pu minspd' + Convert.tostring(PowerUp._MIN_SPEED));
		//Text.display(300, 40, 'pu maxspd' + Convert.tostring(PowerUp._MAX_SPEED));
		
		
		if (_isPlayerAlive) {
			Text.size = 2;
			Text.display(50, 50, 'LEVEL: ${_level + 1}');
		}
	}
	
	function gameOver() {
		Music.fadeout();
		Text.align(Text.CENTER);
		Text.size = 4;
		Text.display(Gfx.screenwidthmid, Gfx.screenheightmid - 80, GAME_OVER);
		Text.size = 3;

		
		Text.display(Gfx.screenwidthmid, Gfx.screenheightmid + 50, RESTART);
		Text.align(Text.LEFT);
		Text.display(
			Gfx.screenwidthmid - Math.floor(Text.width(RESTART) / 2) + Text.width('[') + 3,
			Gfx.screenheightmid + 50,
			'R',
			getUIColor()
		);
		
		
		// TODO: Show score
	}
	
	// Checks for all the inputs.
	function checkInputs() {
		if (_isPlayerAlive) checkPlayerInputs();

		if (Input.justpressed(Key.M)) {
			if (_songPlaying) {
				Music.stopsong();
				_songPlaying = false;
			}else {
				playSong();
				_songPlaying = true;
			}
		}
		
		
		// Restarts the game
		// TODO: R -> RESTART, M -> MENU
		if (!_isPlayerAlive) {
			if (Input.justpressed(Key.R)) {
				// Text.display(50, 50, "[R]estarting...");
				if (Globals._HIGH_SCORE == 0) Scene.change(MenuScene);
				else Scene.change(Replay);
			}
		}
	}
	
	// Decreases the size of the player by the given amount, but never below minimum.
	function decreasePlayerSizeBy(amount: Float) {
		if (_playerSize <= _PLAYER_MIN_SIZE && _isPlayerAlive) {
			_playerSize = _PLAYER_MIN_SIZE;
			killPlayer();
		} else if (_isPlayerAlive) {
			_playerSize -= amount;
		}
	}
	
	// Destroys the player.
	function killPlayer() {
		// TODO: Proper kill animation.
		//	Ask if they want to restart and whatnot
		_playerAlpha = 0;
		_isPlayerAlive = false;
		checkHighScore();
	}
	
	// Checks for input from the player and moves the ball around.
	function checkPlayerInputs() {	
		// Horizontal movement
		if (Input.pressed(Key.LEFT) || Input.pressed(Key.A)) {
			_playerX -= _PLAYER_SPEED_X;
		} else if (Input.pressed(Key.RIGHT) || Input.pressed(Key.D)) {
			_playerX += _PLAYER_SPEED_X;
		}
		
		// Vertical movement
		if (Input.pressed(Key.UP) || Input.pressed(Key.W)) {
			_playerY -= _PLAYER_SPEED_Y;
		} else if (Input.pressed(Key.DOWN) || Input.pressed(Key.S)) {
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
		_playerColor = Col.hsl(Core.time * Globals.backgroundChangeSpeed, _playerSaturation, 0.5);
	}
	
	function createPowerUps() {
		function fixDeviation(dir: Int, x: Float, y: Float) {
			var deviation = 0;
			// horizontal
			if (dir == 0) {
				if (y > Gfx.screenheightmid) deviation = Random.int( -_POWERUP_MAX_DEVIATION, _POWERUP_MIN_DEVIATION);
				else if (y < Gfx.screenheightmid) deviation = Random.int(-_POWERUP_MIN_DEVIATION, _POWERUP_MAX_DEVIATION);
			} else if (dir == 180) {
				if (y < Gfx.screenheightmid) deviation = Random.int( -_POWERUP_MAX_DEVIATION, _POWERUP_MIN_DEVIATION);
				else if (y > Gfx.screenheightmid) deviation = Random.int(-_POWERUP_MIN_DEVIATION, _POWERUP_MAX_DEVIATION);
			}
			// vertical
			if (dir == 90) {
				if (x < Gfx.screenwidthmid) deviation = Random.int( -_POWERUP_MAX_DEVIATION, _POWERUP_MIN_DEVIATION);
				else if (x > Gfx.screenwidthmid) deviation = Random.int(-_POWERUP_MIN_DEVIATION, _POWERUP_MAX_DEVIATION);
			} else if (dir == 270) {
				if (x > Gfx.screenwidthmid) deviation = Random.int( -_POWERUP_MAX_DEVIATION, _POWERUP_MIN_DEVIATION);
				else if (x < Gfx.screenwidthmid) deviation = Random.int(-_POWERUP_MIN_DEVIATION, _POWERUP_MAX_DEVIATION);
			}
			return deviation;
		}
		
		
		_powerUpActualAmount = _POWERUP_AMOUNTS[_level];
		var directions = [0, 90, 180, 270];
		for (index in 1 ... _powerUpActualAmount) {
			var dir = Random.pick(directions);
			var size = Random.int(PowerUp._MIN_SIZE, PowerUp._MAX_SIZE);
			var x = Random.int(size, Gfx.screenwidth - size);
			var y = Random.int(size, Gfx.screenheight - size);
			var speed = Random.int(PowerUp._MIN_SPEED, PowerUp._MAX_SPEED);
			var deviation = fixDeviation(dir, x, y);

			
			if (dir == 0) _powerUpPool.push(new PowerUp(-size, y, size, speed, dir + deviation));
			else if (dir == 90) _powerUpPool.push(new PowerUp(x, -size, size, speed, dir + deviation));
			else if (dir == 180) _powerUpPool.push(new PowerUp(Gfx.screenwidth + size, y, size, speed, dir + deviation));
			else if (dir == 270) _powerUpPool.push(new PowerUp(x, Gfx.screenheight + size, size, speed, dir + deviation));

		}
	}
	
	function createDebris() {
		function fixDeviation(dir: Int, x: Float, y: Float) {
			var deviation = 0;
			// horizontal
			if (dir == 0) {
				if (y > Gfx.screenheightmid) deviation = Random.int( -_DEBRIS_MAX_DEVIATION, _DEBRIS_MIN_DEVIATION);
				else if (y < Gfx.screenheightmid) deviation = Random.int(-_DEBRIS_MIN_DEVIATION, _DEBRIS_MAX_DEVIATION);
			} else if (dir == 180) {
				if (y < Gfx.screenheightmid) deviation = Random.int( -_DEBRIS_MAX_DEVIATION, _DEBRIS_MIN_DEVIATION);
				else if (y > Gfx.screenheightmid) deviation = Random.int(-_DEBRIS_MIN_DEVIATION, _DEBRIS_MAX_DEVIATION);
			}
			// vertical
			if (dir == 90) {
				if (x < Gfx.screenwidthmid) deviation = Random.int( -_DEBRIS_MAX_DEVIATION, _DEBRIS_MIN_DEVIATION);
				else if (x > Gfx.screenwidthmid) deviation = Random.int(-_DEBRIS_MIN_DEVIATION, _DEBRIS_MAX_DEVIATION);
			} else if (dir == 270) {
				if (x > Gfx.screenwidthmid) deviation = Random.int( -_DEBRIS_MAX_DEVIATION, _DEBRIS_MIN_DEVIATION);
				else if (x < Gfx.screenwidthmid) deviation = Random.int(-_DEBRIS_MIN_DEVIATION, _DEBRIS_MAX_DEVIATION);
			}
			return deviation;
		}
		
		_debrisActualAmount = _DEBRIS_AMOUNTS[_level];
		var directions = [0, 90, 180, 270];
		for (index in 1 ... _debrisActualAmount) {
			var dir = Random.pick(directions);
			var size = Random.int(Debris._MIN_SIZE, Debris._MAX_SIZE);
			var x = Random.int(Convert.toint(size / 2), Gfx.screenwidth - Convert.toint(size / 2));
			var y = Random.int(Convert.toint(size / 2), Gfx.screenheight - Convert.toint(size / 2));
			var speed = Random.int(Debris._MIN_SPEED, Debris._MAX_SPEED);
			var deviation = fixDeviation(dir, x, y);
			
			if (index == 1 && _level == 0 && Globals._HIGH_SCORE == 0) {
				_debrisPool.push(new Debris(Gfx.screenwidth + size, Gfx.screenheightmid, size, Debris._MIN_SPEED, 180));
				continue;
			}
			
			fixDeviation(dir, x, y);
			if (dir == 0) _debrisPool.push(new Debris(-size, y, size, speed, dir + deviation));
			else if (dir == 90) _debrisPool.push(new Debris(x, -size, size, speed, dir + deviation));
			else if (dir == 180) _debrisPool.push(new Debris(Gfx.screenwidth + size, y, size, speed, dir + deviation));
			else if (dir == 270) _debrisPool.push(new Debris(x, Gfx.screenheight + size, size, speed, dir + deviation));

		}
	}
	
	function spawnPowerUps() {
		if (!_isPlayerAlive) return;
		if (_nextPowerUp == 0 && _powerUpPool.length > 0) {
			_spawnedPowerUpPool.push(_powerUpPool.shift());
			_nextPowerUp = _powerUpSpawnCooldown;
		} else _nextPowerUp--;	
		
		if (_powerUpPool.length == 0) {
			createPowerUps();
		}
	}
	
	function spawnDebris() {
		if (!_isPlayerAlive) return;
		if (_nextDebris == 0 && _debrisPool.length > 0) {
			_spawnedDebrisPool.push(_debrisPool.shift());
			_nextDebris = _debrisSpawnCooldown;
			if (_debrisPool.length == _debrisActualAmount - 1) _nextDebris = _DEBRIS_SPAWN_TUTORIAL;
		} else {
			_nextDebris--;
		}
		
		if (_debrisPool.length == 0) {
			if (_level + 1 < _DEBRIS_AMOUNTS.length) {
				_level++;
				Debris._MIN_SIZE += 1;
				Debris._MAX_SIZE += 2;
				Debris._MIN_SPEED += 1;
				Debris._MAX_SPEED += 2;
				_debrisSpawnCooldown -= 8;
				
				PowerUp._MIN_SIZE += 1;
				PowerUp._MAX_SIZE += 2;
				PowerUp._MIN_SPEED += 1;
				PowerUp._MAX_SPEED += 2;
				_powerUpSpawnCooldown -= _POWERUP_SPAWN_COOLDOWN_REDUCTION;
				_powerUpPool = new Array<PowerUp>();
				createPowerUps();
				
			}
			_score += _SCORE_NEXT_LEVEL * (_level + 1);
			createDebris();
			updateMusic();
		}
	}
		
	function checkOutOfBounds(x: Float, y: Float, size: Float): Bool {
		return x + size < 0 ||
			x - size > Gfx.screenwidth ||
			y + size < 0 ||
			y - size > Gfx.screenheight;
	}
	
	function isPowerUpOutOfBounds(powerUp: PowerUp): Bool {
		var dir = powerUp.getDir();
		var isOutOfBounds = false;
		
		isOutOfBounds = checkOutOfBounds(powerUp.getX(), powerUp.getY(), powerUp.getSize());
		
		return isOutOfBounds;
	}
	
	function isDebrisOutOfBounds(debris: Debris): Bool {
		var dir = debris.getDir();
		var isOutOfBounds = false;
		
		isOutOfBounds = checkOutOfBounds(debris.getX(), debris.getY(), debris.getSize());
		
		return isOutOfBounds;
	}
	
	//function checkCollisionDebrisPlayer(debris: Debris) {
		//// TODO: Fix debris collision offest...
		//if (!_isPlayerAlive) return;
//
		//var debrisHitbox = 1.5;
		//var playerHitbox = 1.5;
		//var playerSize = _playerSize * playerHitbox;
		//var debrisSize = debris.getSize() * debrisHitbox;
		//
		//var player = {
			//x: _playerX - playerSize / 2,
			//y: _playerY - playerSize / 2,
			//w: playerSize,
			//h: playerSize
		//};
		//var deb = {
			//x: debris.getX() - debrisSize / 2,
			//y: debris.getY() - debrisSize / 2,
			//w: debrisSize,
			//h: debrisSize
		//};
		////Gfx.drawcircle(_playerX, _playerY, _playerSize, Col.RED);
		////Gfx.drawbox(player.x, player.y, player.w, player.h, Col.WHITE);
		////Gfx.drawbox(deb.x, deb.y, deb.w, deb.h, Col.WHITE);
		////Text.display(player.x, player.y, Convert.tostring(_playerSize));
		//
		//var isOverlaping = Geom.overlap(
			//player.x, player.y,
			//player.w, player.h,
			//deb.x, deb.y,
			//deb.w, deb.h
		//);
		//
		//if (isOverlaping) {
			//// playerHit();
			//debris.kill();
			//_spawnedDebrisPool.remove(debris);
		//}
	//}
	
	function drawPowerUps() {
		if (!_isPlayerAlive) return;
		if (_spawnedPowerUpPool.length == 0) return;
		for (powerUp in _spawnedPowerUpPool) {
			if (isPowerUpOutOfBounds(powerUp)) {
				_spawnedPowerUpPool.remove(powerUp);
				continue;
			}
			// TODO: PLAYER AND/OR DEBRIS SIZE SHOULD HAVE A SMALLER HITBOX (size * ~0.8)
			if (powerUp.isCollidingWithCircle(_playerX, _playerY, _playerSize)) playerCollidedWithPowerUp(powerUp);
			//playerCollidedWithDebris(debris);
			//checkCollisionDebrisPlayers(debris);
			powerUp.draw();
		}
	}
	
	function drawDebris() {
		//Text.display(50, 50, Convert.tostring(_spawnedDebrisPool.length));
		//Gfx.drawcircle(_playerX, _playerY, _playerSize, Col.RED);
		if (!_isPlayerAlive) return;
		if (_spawnedDebrisPool.length == 0) return;
		for (debris in _spawnedDebrisPool) {
			if (isDebrisOutOfBounds(debris)) {
				_score += _SCORE_DEBRIS;
				_spawnedDebrisPool.remove(debris);
				continue;
			}
			// TODO: PLAYER AND/OR DEBRIS SIZE SHOULD HAVE A SMALLER HITBOX (size * ~0.8)
			if (debris.isCollidingWithCircle(_playerX, _playerY, _playerSize)) playerCollidedWithDebris(debris);
			//playerCollidedWithDebris(debris);
			//checkCollisionDebrisPlayers(debris);
			debris.draw();
		}
	}
	
	function playerCollidedWithPowerUp(powerUp: PowerUp) {
		decreasePlayerSizeBy( -powerUp.getSize());
		_score += _SCORE_POWERUP;
		// SOUND: playerPowerUp
		Music.playsound('playerHitPowerUp', _VOLUME_POWERUP);
		powerUp.kill();
		_spawnedPowerUpPool.remove(powerUp);
	}
	
	function playerCollidedWithDebris(debris: Debris) {
		decreasePlayerSizeBy(_DEBRIS_DAMAGE);
		// SOUND: playerHit
		Music.playsound('playerHitDebris', _VOLUME_DEBRIS);
		debris.kill();
		_spawnedDebrisPool.remove(debris);
		if (_score > _SCORE_PENALTY_DEBRIS) _score -= _SCORE_PENALTY_DEBRIS;
		else _score = 0;
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
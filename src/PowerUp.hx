package;

import haxegon.*;
class PowerUp 
{
	//private var _particles: Array<DebrisParticle>;
	static private var _HITBOX: Float = 1;
	static private var _SATURATION: Float = 0.5;
	static private var _LIGHTNESS: Float = 0.5;
	static public var _INITIAL_MIN_SPEED: Int = 5;
	static public var _INITIAL_MAX_SPEED: Int = 7;
	static public var _INITIAL_MIN_SIZE: Int = 10;
	static public var _INITIAL_MAX_SIZE: Int = 15;
	static public var _MIN_SPEED: Int = 5;
	static public var _MAX_SPEED: Int = 7;
	static public var _MIN_SIZE: Int = 10;
	static public var _MAX_SIZE: Int = 15;
	private var _x: Float;
	private var _y: Float;
	private var _direction: Float;
	private var _speed: Float;
	private var _size: Float;
	private var _color: Int;
	private var _alpha: Float;
	private var _isDead: Bool;
	
	
	public function new(x: Float, y: Float, size: Float, speed: Float,
						direction: Float = 0, alpha: Float = 1) {
		_x = x;
		_y = y;
		_size = size;
		_speed = speed;
		_direction = Geom.toradians(direction);
		_alpha = alpha;
		
		_isDead = false;
		updateColor();	
	}
	
	public function getX() {
		return _x;
	}
	
	public function getY() {
		return _y;
	}
	
	public function getSize() {
		return _size;
	}
	
	public function getDir() {
		return _direction;
	}
	
	private function updateColor() {
		_color = Col.hsl(
			Core.time * Globals.backgroundChangeSpeed,
			_SATURATION,
			_LIGHTNESS
		);
	}
	
	private function move() {
		_x += _speed * Math.cos(_direction);
		_y += _speed * Math.sin(_direction);
	}
	
	public function draw() {
		if (_isDead) return;
		//shrinking();
		//blending();
		
		updateColor();
		move();
		
		Gfx.fillcircle(_x, _y, _size, _color, _alpha);
		//Gfx.drawcircle(_x, _y, _size * _HITBOX, Col.RED);

	}
	
	public function kill() {
		_isDead = true;
	}
	
	public function isCollidingWithCircle(x: Float, y: Float, radius: Float) {
		var dx = _x - x;
		var dy = _y - y;
		
		var distance = Math.sqrt(dx * dx + dy * dy);
		
		return distance < (_size * _HITBOX) + radius;
	}
	
}
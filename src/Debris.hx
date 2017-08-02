package;

import haxegon.*;

class Debris 
{
	//private var _particles: Array<DebrisParticle>;
	private var _x: Float;
	private var _y: Float;
	private var _direction: Float;
	private var _speed: Float;
	private var _size: Float;
	private var _angle: Float;
	private var _color: Int;
	private var _alpha: Float;
	
	
	public function new(x: Float, y: Float, size: Float, speed: Float,
						direction: Float = 0, color: Int = 0xFFFFFF, alpha: Float = 1) {
		_x = x;
		_y = y;
		_size = size;
		_speed = speed;
		_direction = Geom.toradians(direction);
		_color = color;
		_alpha = alpha;
		
		//updateColor();
		updateAngle();
		
	}
	
	private function updateAngle() {
		_angle = Core.time * _speed;
	}
	
	//private function updateColor() {
		//_color = Col.hsl(
			//Core.time * Globals.backgroundChangeSpeed,
			//Globals.backgroundSaturation + 0.1,
			//Globals.backgroundLightness + 0.1
		//);
	//}
	
	private function move() {
		_x += _speed * Math.cos(_direction);
		_y += _speed * Math.sin(_direction);
	}
	
	public function draw() {
		//shrinking();
		//blending();
		
		//updateColor();
		move();
		updateAngle();
		
		Gfx.linethickness = 2;
		Gfx.drawhexagon(_x, _y, _size, _angle, _color, _alpha);

	}
	
}
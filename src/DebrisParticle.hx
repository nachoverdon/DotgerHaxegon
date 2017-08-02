package;

import haxegon.*;

class DebrisParticle 
{
	private var _type: DebrisType;
	private var _direction: Float;
	private var _speed: Float;
	
	private var _x: Float;
	private var _y: Float;
	private var _size: Float;
	private var _angle: Float;
	private var _color: Int;
	private var _alpha: Float;
	
	
	public function new(type: DebrisType, x: Float, y: Float, size: Float, speed: Float) {
		_type = type;
		_x = x;
		_y = y;
		_size = size;
		_speed = speed;
		updateAngle();
		updateColor();
		_alpha = 1;
		
	}
	
	private function updateAngle() {
		_angle = Core.time * _speed;
	}
	
	private function updateColor() {
		_color = Col.hsl(
			Core.time * Globals.backgroundChangeSpeed,
			Globals.backgroundSaturation + 0.1,
			Globals.backgroundLightness + 0.1
		);
	}
	
	public function draw() {
		//shrinking();
		//blending();
		
		updateColor();
		updateAngle();
		
		Gfx.linethickness = 2;
		switch _type {
			case DebrisType.HEXAGON:
				Gfx.drawhexagon(_x, _y, _size, _angle, _color, _alpha);
				
			case DebrisType.SQUARE:
				Gfx.drawbox(_x, _y, _size, _size, _color, _alpha);
			
			case DebrisType.TRIANGLE:
				var half = _size / 2;
				Gfx.drawtri(
					_x, _y,
					_x + _size, _y,
					_x + half, _y - half,
					_color,
					_alpha
				);
		}

	}
	
	//private function shrinking() {
		//if (_size <= _minSize) {
			//_size = _minSize;
			//_isShrinking = false;
			//return;
		//}
		//
		//if (_isShrinking) {
			//_size -= _shrinkSpeed;
		//}
	//}
	//
	//private function blend(speed: Float) {
		//if (_isBlending) return;
		//
		//_blendSpeed = speed;
		//_isBlending = true;
	//}
	//
	//private function blending() {
		//if (_isBlending) {
			//_lightness -= _blendSpeed;
			//_saturation -= _blendSpeed;
		//} else return;
//
		//
		//if (_saturation <= Globals.backgroundLightness) {
			//_saturation = Globals.backgroundLightness;
		//}
		//
		//if (_lightness <= Globals.backgroundLightness) {
			//_lightness = Globals.backgroundLightness;
		//}
		//
		//if (_lightness <= Globals.backgroundLightness
			//&& _saturation <= Globals.backgroundSaturation) {
			//_isBlending = false;
			//return;
		//}
	//}
	//
	//private function updateColor() {
		//setColor(Col.hsl(
			//Core.time * Globals.backgroundChangeSpeed,
			//_saturation,
			//_lightness
		//));
	//}
	//
	//private function hide() {
		//_show = false;
	//}
	//
	//private function show() {
		//_show = true;
	//}
	//
	//private function isShrinking() {
		//return _isShrinking;
	//}
	//
	//private function isBlending() {
		//return _isBlending;
	//}
}
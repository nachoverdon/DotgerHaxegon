package;

import haxegon.*;

class Ball 
{
	static public var INITIAL_SATURATION: Float = 0.5;
	static public var INITIAL_LIGHTNESS: Float = 0.5;
	private var _minSize: Float;
	private var _x: Float;
	private var _y: Float;
	private var _size: Float;
	private var _color: Int;
	private var _saturation: Float;
	private var _lightness: Float;
	private var _alpha: Float;
	private var _show: Bool = true;
	
	private var _isShrinking: Bool = false;
	private var _shrinkSpeed: Float;
	
	private var _isBlending: Bool = false;
	private var _blendSpeed: Float;
	
	public var x(get, set): Float;
	public var y(get, set): Float;
	public var size(get, set): Float;

	
	public function new(x: Float, y: Float, size: Float, color: Int, alpha: Float = 1.0, minSize: Float = 4) {
		_x = x;
		_y = y;
		_size = size;
		_color = color;
		_alpha = alpha;
		_minSize = minSize;
		
		_saturation = INITIAL_SATURATION;
		_lightness = INITIAL_LIGHTNESS;
	}
	
	public function get_x(): Float {
		return _x;
	}

	public function set_x(pos: Float) {
		_x = pos;
		return _x;
	}
	
	public function get_y(): Float {
		return _y;
	}
	
	public function set_y(pos: Float) {
		_y = pos;
		return _y;
	}
	
	public function get_size() {
		return _size;
	}

	public function set_size(size: Float) {
		_size = size;
		return _size;
	}
		
	public function setColor(color: Int) {
		_color = color;
	}
	
	public function setSaturation(saturation: Float) {
		_saturation = saturation;
	}
	
	public function setLightness(lightness: Float) {
		_lightness = lightness;
	}
	
	public function moveTo(x: Float, y: Float) {
		_x = x;
		_y = y;
	}
	
	public function draw() {
		shrinking();
		blending();
		if (_show) Gfx.fillcircle(_x, _y, _size, _color, _alpha);
	}
	
	public function shrink(speed: Float) {
		if (_isShrinking) return;

		_shrinkSpeed = speed;
		_isShrinking = true;
	}
	
	private function shrinking() {
		if (_size <= _minSize) {
			_size = _minSize;
			_isShrinking = false;
			return;
		}
		
		if (_isShrinking) {
			_size -= _shrinkSpeed;
		}
	}
	
	public function blend(speed: Float) {
		if (_isBlending) return;
		
		_blendSpeed = speed;
		_isBlending = true;
	}
	
	private function blending() {
		if (_isBlending) {
			_lightness -= _blendSpeed;
			_saturation -= _blendSpeed;
		} else return;

		
		if (_saturation <= Globals.backgroundLightness) {
			_saturation = Globals.backgroundLightness;
		}
		
		if (_lightness <= Globals.backgroundLightness) {
			_lightness = Globals.backgroundLightness;
		}
		
		if (_lightness <= Globals.backgroundLightness
			&& _saturation <= Globals.backgroundSaturation) {
			_isBlending = false;
			return;
		}
	}
	
	public function updateColor() {
		setColor(Col.hsl(
			Core.time * Globals.backgroundChangeSpeed,
			_saturation,
			_lightness
		));
	}
	
	public function hide() {
		_show = false;
	}
	
	public function show() {
		_show = true;
	}
	
	public function isShrinking() {
		return _isShrinking;
	}
	
	public function isBlending() {
		return _isBlending;
	}
}
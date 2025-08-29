extends SpotLight3D

@export var flicker_speed: float = 10.0
@export var flicker_intensity: float = 0.3

var _base_energy: float = 0.0

func _ready() -> void:
	_base_energy = light_energy

func _process(delta: float) -> void:
	var t: float = Time.get_ticks_msec() / 1000.0
	var sine_wave: float = sin(t * flicker_speed * TAU) * 0.5 + 0.5
	var noise: float = randf_range(-1.0, 1.0) * 0.5
	var flicker: float = clamp(sine_wave + noise, 0.0, 1.0)

	light_energy = _base_energy * (1.0 - flicker_intensity + flicker * flicker_intensity)

extends KinematicBody2D

export var target: = Vector2.ZERO
export var speed: = 100
export var chase_distance: = 300

var velocity: = Vector2()

var state = STATE.IDLE
enum STATE {
	IDLE,
	WALKING
}


func _ready() -> void:
	_switch_state(STATE.WALKING)


func _process(delta: float) -> void:
	_handle_state()


func _handle_state():
	match state:
		STATE.IDLE:
			pass
		STATE.WALKING:
			if target == Vector2.ZERO:
				return
			velocity = position.direction_to(target) * speed
			if position.distance_to(target) > chase_distance:
				velocity = move_and_slide(velocity)


func _switch_state(new_state: int) -> void:
	state = new_state if new_state != state else state

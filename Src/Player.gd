extends KinematicBody2D

const FLOOR_NORMAL: Vector2 = Vector2.ZERO
const SPEED: = 300.0

export var speed: = Vector2(SPEED, SPEED)
var _velocity: = Vector2.ZERO
var _state = STATE.IDLE

enum STATE {
	IDLE,
	WALKING
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Animation.play("idle")


func _physics_process(delta: float) -> void:
	var direction: = get_direction()
	_velocity = direction.normalized() * speed
	if _velocity != Vector2.ZERO:
		_switch_state(STATE.WALKING)
	else:
		_switch_state(STATE.IDLE)
	
	_handle_state()


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up") 
	)


func _switch_state(new_state) -> void:
	if _state == new_state:
		return
	_state = new_state
	
	match _state:
		STATE.IDLE:
			print("switching to IDLE state")
		STATE.WALKING:
			print("switching to WALKING state")


func _handle_state() -> void:
	match _state:
		STATE.IDLE:
			$Animation.play("idle")
		STATE.WALKING:
			$Animation.play("walk")
			_velocity = move_and_slide(_velocity)

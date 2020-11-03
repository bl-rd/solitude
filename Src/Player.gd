extends KinematicBody2D

const FLOOR_NORMAL: Vector2 = Vector2.ZERO
const SPEED: = 300.0

export var speed: = Global.PLAYER_SPEED

export var dodge_speed: = Vector2(1000, 0)
var dodge_direction: = Vector2.ZERO
var dodge_started = false
var can_dodge: = true

var _velocity: = Vector2.ZERO
var _state = STATE.IDLE

enum STATE {
	IDLE,
	WALKING,
	DODGE
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Animation.play("idle")


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("move_dodge") and can_dodge:
		_switch_state(STATE.DODGE)
	
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
		STATE.DODGE:
			print("switching to DODGE state")


func _handle_state() -> void:
	match _state:
		STATE.IDLE:
			$Animation.play("idle")
			if is_direction_pressed():
				_switch_state(STATE.WALKING)
		STATE.WALKING:
			$Animation.play("walk")
			var direction: = get_direction()
			_velocity = direction.normalized() * speed
			_velocity = move_and_slide(_velocity)
			if !is_direction_pressed():
				_switch_state(STATE.IDLE)
		STATE.DODGE:
			$Animation.play("dodge")
			if can_dodge:
				var dir = get_direction()
				dodge_direction = dir * dodge_speed.x if dir != Vector2.ZERO else dodge_speed
				$DodgeTimer.start()
			can_dodge = false
			_velocity = move_and_slide(dodge_direction)


# Helper function to determine if any move button is being pressed
func is_direction_pressed() -> bool:
	var d = Input.is_action_pressed("move_down")
	var u = Input.is_action_pressed("move_up")
	var r = Input.is_action_pressed("move_right")
	var l = Input.is_action_pressed("move_left")
	return d or u or r or l


# Handle what happens when the dodge tween is finished.
func _on_DodgeTween_tween_all_completed() -> void:
	_switch_state(STATE.IDLE)
	$DodgeTimer.start()


# Stop the dodge
# Start a timer to prevent instantaneous dodging!!
func _on_DodgeTimer_timeout() -> void:
	$DodgeTimer.stop()
	$DodgeReset.start()
#	can_dodge = true
	_switch_state(STATE.IDLE)


# Allow the player to dodge again after some time
func _on_DodgeReset_timeout() -> void:
	$DodgeReset.stop()
	can_dodge = true

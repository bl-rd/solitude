extends KinematicBody2D

const FLOOR_NORMAL: Vector2 = Vector2.ZERO
const SPEED: = 300.0

export var speed: = Global.PLAYER_SPEED
export var dodge_speed: = Vector2(250, 0)
var _velocity: = Vector2.ZERO
var _state = STATE.IDLE
var _can_dodge: = true

enum STATE {
	IDLE,
	WALKING,
	DODGE
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Animation.play("idle")


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("move_dodge") and _can_dodge:
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
			if !$DodgeTween.is_active():
				var direction: = get_direction()
				var dodge_vec: = direction * dodge_speed.x if direction != Vector2.ZERO else dodge_speed
				$DodgeTween.interpolate_property(self, "position",
					self.position, self.position + dodge_vec, 0.1,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$DodgeTween.start()
				_can_dodge = false


# Helper function to determine if any move button is being pressed
func is_direction_pressed() -> bool:
	var d = Input.is_action_pressed("move_down")
	var u = Input.is_action_pressed("move_up")
	var r = Input.is_action_pressed("move_right")
	var l = Input.is_action_pressed("move_left")
	return d or u or r or l


# Handle what happens when the dodge tween is finished.
# Start a timer to prevent instantaneous dodging!!
func _on_DodgeTween_tween_all_completed() -> void:
	_switch_state(STATE.IDLE)
	$DodgeTimer.start()


# Let the player dodge again
func _on_DodgeTimer_timeout() -> void:
	$DodgeTimer.stop()
	_can_dodge = true

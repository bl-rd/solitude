extends KinematicBody2D

signal strike

const FLOOR_NORMAL: Vector2 = Vector2.ZERO
const SPEED: = 300.0
const RESET_SCENE_PATH: = "res://Src/Levels/Orbit.tscn"

export var speed: = Global.PLAYER_SPEED
export var damage_power: = 10.0

export var dodge_speed: = Vector2(1000, 0)
var dodge_direction: = Vector2.ZERO
var dodge_started = false
var can_dodge: = true
var is_swinging: = false

var _velocity: = Vector2.ZERO
var _state = STATE.IDLE
var _facing = FACING.RIGHT


enum STATE {
	IDLE,
	WALKING,
	DODGE,
	DEAD,
	SWINGING
}

enum FACING {
	LEFT,
	RIGHT
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Animation.play("idle")


func _process(delta: float) -> void:
	if GlobalScene.loop_finished:
		_switch_state(STATE.DEAD)

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("move_dodge") and can_dodge:
		_switch_state(STATE.DODGE)
	
	_handle_state()
	_update_facing_direction()
	


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up") 
	)


func _switch_state(new_state) -> void:
	if _state == new_state:
		return
	_state = new_state
	
#	match _state:
#		STATE.IDLE:
#			print("switching to IDLE state")
#		STATE.WALKING:
#			print("switching to WALKING state")
#		STATE.DODGE:
#			print("switching to DODGE state")


func _handle_state() -> void:
	match _state:
		STATE.IDLE:
			$Animation.play("idle")
			_handle_swing()
			if is_direction_pressed():
				_switch_state(STATE.WALKING)
		STATE.WALKING:
			$Animation.play("walk")
			_handle_swing()
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
				# if the player is facing left with no input then need to inverse the x direction
				if _facing == FACING.LEFT && dir.x == 0.0:
					dodge_direction.x *= -1.0
				$DodgeTimer.start()
			can_dodge = false
			_velocity = move_and_slide(dodge_direction)
		STATE.DEAD:
			can_dodge = false
			$Animation.play("dead")
			if $DeathTimer.is_stopped():
				$DeathTimer.start()
		STATE.SWINGING:
			var anim = "swing_left" if _facing == FACING.LEFT else "swing_right"
			$StrikeBox/AnimationPlayer.play(anim)


# Helper function to determine if any move button is being pressed
func is_direction_pressed() -> bool:
	var d = Input.is_action_pressed("move_down")
	var u = Input.is_action_pressed("move_up")
	var r = Input.is_action_pressed("move_right")
	var l = Input.is_action_pressed("move_left")
	return d or u or r or l


func _handle_swing() -> void:
	if !is_swinging && Input.is_action_just_pressed("move_swing"):
		is_swinging = true
		_switch_state(STATE.SWINGING)


# Update which what the player is facing...
func _update_facing_direction() -> void:
	if Input.is_action_pressed("move_left"):
		_facing = FACING.LEFT
	elif Input.is_action_pressed("move_right"):
		_facing = FACING.RIGHT


# Stop the dodge
# Start a timer to prevent instantaneous dodging!!
func _on_DodgeTimer_timeout() -> void:
	$DodgeTimer.stop()
	if _state != STATE.DEAD:
		$DodgeReset.start()
		_switch_state(STATE.IDLE)


# Allow the player to dodge again after some time
func _on_DodgeReset_timeout() -> void:
	$DodgeReset.stop()
	can_dodge = true


# Been hit by the boss...
func _on_BossOne_hit() -> void:
	_switch_state(STATE.DEAD)


# Reset the game loop
func _on_DeathTimer_timeout() -> void:
	Global.goto_scene(RESET_SCENE_PATH)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name.begins_with("swing_"):
		is_swinging = false
		$StrikeBox/AnimationPlayer.play("reset")
		_switch_state(STATE.IDLE)


func _on_HitArea_body_entered(body: Node) -> void:
	emit_signal("strike", body)

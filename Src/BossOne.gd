extends KinematicBody2D

signal hit
signal dead

export var target: = Vector2.ZERO
export var speed: = 100
export var chase_distance: = 300
var health: = 100.0

var velocity: = Vector2()

var player_in_danger_zone: = false

var state = STATE.IDLE
enum STATE {
	IDLE,
	WALKING,
	ZAPPING,
	DEAD
}


func _ready() -> void:
	_switch_state(STATE.WALKING)


func _process(delta: float) -> void:
	_handle_state()


func _handle_state():
	match state:
		STATE.IDLE:
			$AnimatedSprite.play("idle")
		STATE.WALKING:
			$AnimatedSprite.play("walk")
			if target == Vector2.ZERO:
				return
			velocity = position.direction_to(target) * speed
			velocity = move_and_slide(velocity)
		STATE.ZAPPING:
			$AnimatedSprite.play("zap")
			if $ZapTimer.is_stopped():
				$ZapTimer.start()
		STATE.DEAD:
			$AnimatedSprite.play("hit")
			if $DeathTimer.is_stopped():
				$DeathTimer.start()


func is_in_chase_distance() -> bool:
	return position.distance_to(target) > chase_distance


func _switch_state(new_state: int) -> void:
	state = new_state if new_state != state else state


func handle_hit(damage: float) -> void:
	health -= damage
	if health <= 0.0:
		_switch_state(STATE.DEAD)


# Player is in the danger zone!
func _on_DangerZone_body_entered(body: Node) -> void:
	if body.name != "Player" || state == STATE.DEAD:
		return
	player_in_danger_zone = true
	_switch_state(STATE.ZAPPING)


# Player has left the danger zone!
func _on_DangerZone_body_exited(body: Node) -> void:
	if body.name != "Player":
		return
	player_in_danger_zone = false


# Zap the player if they are still in the danger zone
func _on_ZapTimer_timeout() -> void:
	if state == STATE.DEAD:
		return
	if player_in_danger_zone:
		emit_signal("hit")
		_switch_state(STATE.IDLE)
	else:
		_switch_state(STATE.WALKING)
	$ZapTimer.stop()


func _on_DeathTimer_timeout() -> void:
	print("emitting dead signal")
	# emit the "dead" signal to tell parent scene to remove from scene
	emit_signal("dead")

extends Node2D

const EXIT_LEFT_PATH = "res://Src/Levels/Entrance.tscn"
const REPEAT_SCENE = "res://Src/Levels/CorridorCentre.tscn"
var can_leave = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_initialise_player_location()


# Update the player position based on where they enter the room
func _initialise_player_location() -> void:
	var directions = Global.PLAYER_TRANSITION_DIRECTION
	# Only entrance points are from the top and right
	match Global.player_direction:
		directions.RIGHT:
			$Player.position = Vector2($Player.position.x, Global.player_pos.y)
		directions.UP:
			$Player.position = Vector2(Global.player_pos.x, 860.0)
		directions.DOWN:
			$Player.position = Vector2(Global.player_pos.x, 100.0)


func _on_ExitLeft_body_exited(body: Node) -> void:
	can_leave = true


func _on_ExitLeft_body_entered(body: Node) -> void:
	if !can_leave or body.name != $Player.name:
		return

	Global.update_player_transition_pos($Player.position, Global.PLAYER_TRANSITION_DIRECTION.LEFT)
	Global.goto_scene(EXIT_LEFT_PATH)


func _on_ExitTop_body_entered(body: Node) -> void:
	if !can_leave or body.name != $Player.name:
		return
	
	Global.update_player_transition_pos($Player.position, Global.PLAYER_TRANSITION_DIRECTION.UP)
	Global.goto_scene(REPEAT_SCENE)


func _on_ExitBottom_body_entered(body: Node) -> void:
	if !can_leave or body.name != $Player.name:
		return
	
	Global.update_player_transition_pos($Player.position, Global.PLAYER_TRANSITION_DIRECTION.DOWN)
	Global.goto_scene(REPEAT_SCENE)


func _on_ExitBottom_body_exited(body: Node) -> void:
	can_leave = true


func _on_ExitRight_body_entered(body: Node) -> void:
	if !can_leave or body.name != $Player.name:
		return
	
	Global.update_player_transition_pos($Player.position, Global.PLAYER_TRANSITION_DIRECTION.RIGHT)
	Global.goto_scene(REPEAT_SCENE)


func _on_ExitRight_body_exited(body: Node) -> void:
	can_leave = true

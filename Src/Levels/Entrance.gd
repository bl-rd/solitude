extends Node2D

const EXIT_TOP_PATH: = "res://Src/Levels/Battle1.tscn"
const EXIT_RIGHT_PATH: = "res://Src/Levels/CorridorCentre.tscn"

# Flag to indicate whether the player can leave through a door
var can_leave = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_initialise_player_location()
	_initialise_game_loop_timer()


# Update the player position based on where they enter the room
func _initialise_player_location() -> void:
	var directions = Global.PLAYER_TRANSITION_DIRECTION
	# Only entrance points are from the top and right
	match Global.player_direction:
		directions.DOWN:
			$Player.position = Vector2(Global.player_pos.x, 0)
		directions.LEFT:
			# TODO - need a way of getting the right hand x coord!
			$Player.position = Vector2(1680.0, Global.player_pos.y)
		_:
			# all other options indicate it is the first time in the room!
			can_leave = true


# start the gameplay loop timer
func _initialise_game_loop_timer() -> void:
	if GlobalScene.get_node("GameLoopTimer").is_stopped():
		print("starting game loop timer")
		GlobalScene.get_node("GameLoopTimer").start()

# Handle when the player hits the top door hitbox
func _on_ExitTop_body_entered(body: Node) -> void:
	if !can_leave or body.name != $Player.name:
		return
	
	Global.update_player_transition_pos($Player.position, Global.PLAYER_TRANSITION_DIRECTION.UP)
	Global.goto_scene(EXIT_TOP_PATH)


# Handle when the player leaves the top door hitbox
func _on_ExitTop_body_exited(body: Node) -> void:
	can_leave = true


# Handle when the player hits the right door hitbox
func _on_ExitRight_body_entered(body: Node) -> void:
	if !can_leave or body.name != $Player.name:
		return
	
	Global.update_player_transition_pos($Player.position, Global.PLAYER_TRANSITION_DIRECTION.RIGHT)
	Global.goto_scene(EXIT_RIGHT_PATH)


func _on_ExitRight_body_exited(body: Node) -> void:
	can_leave = true

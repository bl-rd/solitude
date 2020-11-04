extends Node2D

const EXIT_PATH: = "res://Src/Levels/Entrance.tscn"

# flag to indicate if the player can leave the room through a door
var can_leave: = false


func _ready() -> void:
	_initialise_player_location()


func _process(delta: float) -> void:
	$BossOne.target = $Player.position


# Update the player position based on where they enter the room
func _initialise_player_location() -> void:
	var directions = Global.PLAYER_TRANSITION_DIRECTION
	# Only entrance points are from the top and right
	match Global.player_direction:
		directions.UP:
			$Player.position = Vector2(Global.player_pos.x, $Player.position.y)

func _on_ExitBottom_body_exited(body: Node) -> void:
	can_leave = true


func _on_ExitBottom_body_entered(body: Node) -> void:
	if can_leave:
		Global.update_player_transition_pos($Player.position, Global.PLAYER_TRANSITION_DIRECTION.DOWN)
		Global.goto_scene(EXIT_PATH)

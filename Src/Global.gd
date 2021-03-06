extends Node

const PLAYER_SPEED: = Vector2(500.0, 500.0)
enum PLAYER_TRANSITION_DIRECTION {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var current_scene = null
var player_pos: = Vector2.ZERO
var player_direction = PLAYER_TRANSITION_DIRECTION.UP

# has the core timer loop finished?
var loop_finished: = false

# Is the maze corridor able to be navigated?
var maze_open: = false

func _ready() -> void:
	var root: = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)


func update_player_transition_pos(pos: Vector2, direction: int) -> void:
	player_pos = pos
	player_direction = direction


func _on_GameLoopTimer_timeout() -> void:
	print("game loop timer finished")
	loop_finished = true

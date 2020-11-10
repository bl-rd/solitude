extends Node2D

const START_SCENE_PATH: = "res://Src/Levels/Entrance.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# reset the loop timer
	GlobalScene.loop_finished = false
	
	# start the timer that leads to the next scene
	$ResetTimer.start()


# Go to the next scene when the timer has finished
func _on_ResetTimer_timeout() -> void:
	Global.goto_scene(START_SCENE_PATH)

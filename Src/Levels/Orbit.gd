extends Node2D

const START_SCENE_PATH: = "res://Src/Levels/Entrance.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ResetTimer.start()


func _on_ResetTimer_timeout() -> void:
	print("LET'S GO")
	Global.goto_scene(START_SCENE_PATH)

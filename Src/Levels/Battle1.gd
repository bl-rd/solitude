extends Node2D

const EXIT_PATH: = "res://Src/Levels/Entrance.tscn"
var can_leave: = false


func _on_Area2D_body_exited(body: Node) -> void:
	can_leave = true


func _on_Area2D_body_entered(body: Node) -> void:
	if can_leave:
		Global.goto_scene(EXIT_PATH)

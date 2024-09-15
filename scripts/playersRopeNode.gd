extends Node2D

@onready var win: Label = $"../CanvasLayer/WIN" 
@onready var finish_area: Area2D = $"../Area2D"

func _ready() -> void:
	finish_area.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D and body.is_in_group("Player"):
		print(win.text)
		win.visible = true
		win.show()
		get_tree().paused = true

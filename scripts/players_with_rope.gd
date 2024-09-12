extends Node2D

@onready var player1 = $Player1
@onready var player2 = $Player2

signal pull_player1(dir_vector) 
signal pull_player2(dir_vector)

func _on_rope_pull_both_players() -> void:
	var pull_dir1 = (player2.global_position - player1.global_position).normalized()
	var pull_dir2 = (player1.global_position - player2.global_position).normalized()
	player1.pull_player(pull_dir1)
	player2.pull_player(pull_dir2)

extends Node2D

@onready var edge2 = $Rope6
@onready var edge1 = $Rope1

@export var MAX_DISTANCE = 80
@export var MAX_STRETCHED = 80

enum{
	STRETCHED,
	NORMAL
}

var state = NORMAL
var player1_grabbing = false
var player2_grabbing = false

signal pull_both_players()
func _ready():
	# Conectar las señales de los jugadores
	get_node("../Player1").connect("player_grabbed_wall", Callable(self, "_on_player1_grabbed_wall"))
	get_node("../Player2").connect("player_grabbed_wall", Callable(self, "_on_player2_grabbed_wall"))
	
func _physics_process(delta: float) -> void:
	var distance = edge1.global_position.distance_to(edge2.global_position)
	if(MAX_STRETCHED < distance):
		state = STRETCHED
	
	if state == STRETCHED:
		if MAX_DISTANCE > distance:
			state = NORMAL
		elif not is_one_player_grabbing_wall():
			pull_both_players.emit()
			
#func is_one_player_grabbing_wall(player1_grabbing: bool, player2_grabbing: bool) -> bool:
	#return player1_grabbing or player2_grabbing	
func is_one_player_grabbing_wall() -> bool:
	return player1_grabbing or player2_grabbing

func _on_player1_grabbed_wall(is_grabbing: bool):
	player1_grabbing = is_grabbing

func _on_player2_grabbed_wall(is_grabbing: bool):
	player2_grabbing = is_grabbing

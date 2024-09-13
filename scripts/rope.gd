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

signal pull_both_players()

func _physics_process(delta: float) -> void:
	var distance = edge1.global_position.distance_to(edge2.global_position)
	if(MAX_STRETCHED < distance):
		state = STRETCHED
	
	if state == STRETCHED:
		if MAX_DISTANCE > distance:
			state = NORMAL
		else:
			pull_both_players.emit()
		

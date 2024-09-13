extends Node2D

@onready var player_1: CharacterBody2D = $Player1
@onready var player_2: CharacterBody2D = $Player2
@onready var rope: PackedScene
@onready var players_rope: Node2D = $PlayersRope

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#if rope:
		## Instancia la cuerda desde la escena empaquetada
		#var rope_instance = rope.instantiate()
		#add_child(rope_instance)
		#
		## Obtiene los nodos PinJoint2D en la cuerda
		#var connection1 = rope_instance.get_node("PinJoint2DPlayer1")
		#var connection2 = rope_instance.get_node("PinJoint2DPlayer2")
#
		#if connection1 and connection2:
			## Conecta los extremos de la cuerda a los personajes
			#connection1.node_a = player_1
			#connection1.node_b = rope_instance.get_node("RigidBodyP1")
			#connection2.node_a = player_2
			#connection2.node_b = rope_instance.get_node("RigidBodyP2")
	#else:
		#print("Rope scene is not assigned.")
		#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	players_rope.connect("pull_both_players", Callable(self, "_on_rope_pull_both_players"))

func _on_rope_pull_both_players() -> void:
	var pull_dir1 = (player_2.global_position - player_1.global_position).normalized()
	var pull_dir2 = (player_1.global_position - player_2.global_position).normalized()
	
	if not player_1.is_grabbing_wall:
		player_1.pull_player(pull_dir1)
	if not player_2.is_grabbing_wall:
		player_2.pull_player(pull_dir2)
	
func _process(delta: float) -> void:
	pass

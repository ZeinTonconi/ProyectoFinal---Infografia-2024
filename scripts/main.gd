extends Node2D

@onready var player_1: CharacterBody2D = $Player1
@onready var player_2: CharacterBody2D = $Player2
@onready var rope: PackedScene

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
func _process(delta: float) -> void:
	pass

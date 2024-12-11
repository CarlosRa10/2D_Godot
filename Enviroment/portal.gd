extends Node2D

var send_ninja_to = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(position)
	var portals = get_tree().get_nodes_in_group("portal")
	for i in range (portals.size()):
		if portals[i].position != position:
			print("El portal con posición ", position, "ha detectado el otro portal con posición ", portals[i].position)
			send_ninja_to = portals[i].position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_teletransport_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("ninja"):
		#print("Hola Ninja")
		area.get_parent().position = send_ninja_to

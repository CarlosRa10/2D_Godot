extends Node2D

var floorDetected = false 
var rayCastInitValue = 36 #pixeles iniciales del raycast
var safeTimeOut = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$raycast_floor_detection.target_position.y = rayCastInitValue
	$safeTime.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not floorDetected && safeTimeOut:
		$raycast_floor_detection.target_position.y += 6
		if $raycast_floor_detection.is_colliding():
			floorDetected = true
			$raycast_floor_detection.target_position.y -= 6
			init_spikeball()
			#print("Suelo detectado ", $raycast_floor_detection.target_position.y)
	$SpikedBall.rotation = self.rotation

func init_spikeball():
	var numberOfChains = ($raycast_floor_detection.target_position.y - rayCastInitValue) / 6
	$SpikedBall.position.y += (numberOfChains * 6)
	for i in range(numberOfChains):
		var newRing = preload("res://Scenes/Enemys/One_chain.tscn").instantiate()
		newRing.position = Vector2(0,(6*(i+1)))
		self.add_child(newRing)
	#print(numberOfChains)
	$animation_rotation.play("regular_move")


func _on_safe_time_timeout() -> void:
	safeTimeOut = true


func _on_area_colision_with_map_body_entered(body: Node2D) -> void:
	$animation_rotation.speed_scale *= -1

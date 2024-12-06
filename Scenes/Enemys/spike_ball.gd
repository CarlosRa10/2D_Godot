extends Node2D

var floorDetected = false 
var rayCastInitValue = 30 #pixeles iniciales del raycast
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$raycast_floor_detection.target_position.y = rayCastInitValue


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not floorDetected:
		$raycast_floor_detection.target_position.y += 6
		if $raycast_floor_detection.is_colliding():
			floorDetected = true
			$raycast_floor_detection.target_position.y -= 6
			init_spikeball()
			#print("Suelo detectado ", $raycast_floor_detection.target_position.y)

func init_spikeball():
	var numberOfChains = ($raycast_floor_detection.target_position.y - rayCastInitValue) / 6
	$SpikedBall.position.y += (numberOfChains * 6)
	print(numberOfChains)
	

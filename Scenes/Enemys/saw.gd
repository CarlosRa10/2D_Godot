extends CharacterBody2D
const SPEED = 200
const RAY_FLOOR_POSITION_X = 20
const RAY_WALL_TARGET_POSITION_X = 20

func _ready() -> void:
	velocity.x = SPEED
	$raycast_floor_detection.position.x = RAY_FLOOR_POSITION_X #Donde esta posicionado
	$raycast_wall_detection.target_position.x = RAY_WALL_TARGET_POSITION_X #Donde apunta la flecha
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if not $raycast_floor_detection.is_colliding() || $raycast_wall_detection.is_colliding():
		#velocity.x = velocity.x *-1
		velocity.x *= -1
		$raycast_floor_detection.position.x *= -1
		$raycast_wall_detection.target_position.x *= -1
	
	move_and_slide()

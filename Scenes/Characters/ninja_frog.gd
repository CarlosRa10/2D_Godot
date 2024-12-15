extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var health = 100
var fruitCount = 0
var direction
var block_ninja = false
var allow_animation:bool = false
var leaved_floor:bool = false
var had_jump:bool = false
var max_jumps:int = 2
var count_jumps:int = 0
var double_jump:bool = false
var ray_cast_dimesion = 10.5
var stuck_on_wall:bool = false

func _ready():
	$animaciones.play("appear")
	$rayCast_wallJump.target_position.x = ray_cast_dimesion

func _physics_process(delta):
	if block_ninja: return;
	# Add the gravity.
	if is_on_floor():
		#dejado el suelo
		leaved_floor = false
		#Ha Saltado
		had_jump = false
		#Cuando toca el contador count jams tiene que ser 0
		count_jumps = 0
	if not is_on_floor():
		#Si no estoy tocando suelo
		if not leaved_floor:
			$coyote_timer.start()
			leaved_floor = true
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and right_to_jump():
		if count_jumps == 1:
			double_jump = true
		count_jumps += 1
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#print(velocity)
	if $rayCast_wallJump.get_collider():#verifica si get_collider() devuelve un objeto que no es nulo
		if $rayCast_wallJump.get_collider().is_in_group("wall_jump"):
			#print("Tocando la zona amarilla")
			if velocity.y > 0:
				count_jumps = 0
				velocity.y = 0
				stuck_on_wall = true
		else:
			stuck_on_wall = false
	else:stuck_on_wall = false#si no hay colision wall jump false
	move_and_slide()
	decide_animation()
	#print($rayCast_wallJump.is_colliding())
	#print($rayCast_wallJump.get_collider())


func decide_animation():
	if direction < 0:
		$animaciones.flip_h = true
		$rayCast_wallJump.target_position.x = -ray_cast_dimesion
	elif direction > 0:
		$animaciones.flip_h = false
		$rayCast_wallJump.target_position.x = ray_cast_dimesion
		
	if double_jump:
		double_jump = false
		allow_animation = false
		$animaciones.play("double_jump")
			
	if not allow_animation: return #Si es falso, la función termina y no se ejecuta el resto del código dentro de esa función.
	# EJE DE LAS X
	if stuck_on_wall:
		$animaciones.play("wall_jump")
	else:
		if velocity.x == 0:
			#idle
			$animaciones.play("idle")
		elif velocity.x < 0:
			#izquierda
			$animaciones.play("run")
		elif velocity.x > 0:
			#derecha
			$animaciones.play("run")
		
		# EJE DE LAS Y
		if velocity.y > 0:
			#Caer
			$animaciones.play("jump_down")
		elif velocity.y < 0:
			#Saltar
			$animaciones.play("jump_up")
			
func right_to_jump():
	#la primera vez had_jump = false, así que se pasa al siguiente chequeo
	if had_jump: 
		if count_jumps < max_jumps: return true
		else: return false
	if is_on_floor() || stuck_on_wall:
		had_jump = true #modifica el estado de had_jump para decir que "se le permite saltar"
		return true #retorna true para permitir saltar
	elif not $coyote_timer.is_stopped():
		had_jump = true
		return true
		
func collecteFruit(fruitType):
	var auxString = fruitType + "Points"
	var geinedPoints = GeneralRules[auxString]
	fruitCount += geinedPoints
	print(fruitCount)
	#print(GeneralRules[auxString])
		
##########
#SEÑALES
#########
func _on_animaciones_animation_finished():
	#print($animaciones.animation)
	#if $animaciones.animation == "appear":
		allow_animation = true


func _on_coyote_timer_timeout():
	
	print("Booooom")


func _on_damage_detection_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	health -= 20
	print("Daño detectado")
	print(health)

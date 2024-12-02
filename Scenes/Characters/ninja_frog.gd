extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var allow_animation:bool = false
var leaved_floor:bool = false
var had_jump:bool = false
var max_jumps:int = 2
var count_jumps:int = 0
var double_jump:bool = false
var ray_cast_dimesion = 10.5

func _ready():
	$animaciones.play("appear")
	$rayCast_wallJump.target_position.x = ray_cast_dimesion

func _physics_process(delta):
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
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#print(velocity)
	move_and_slide()
	decide_animation()
	#print($rayCast_wallJump.is_colliding())
	print($rayCast_wallJump.get_collider())
	

func decide_animation():
	if double_jump:
		double_jump = false
		allow_animation = false
		#$animaciones.flip_h = velocity.x < 0 #hace que cuando caiga quede mirando a la derecha
		$animaciones.play("double_jump")
			
	if not allow_animation: return #Si es falso, la función termina y no se ejecuta el resto del código dentro de esa función.
	# EJE DE LAS X
	if velocity.x == 0:
		#idle
		$animaciones.play("idle")
	elif velocity.x < 0:
		#izquierda
		$rayCast_wallJump.target_position.x = -ray_cast_dimesion
		$animaciones.flip_h = true
		$animaciones.play("run")
	elif velocity.x > 0:
		#derecha
		$rayCast_wallJump.target_position.x = ray_cast_dimesion
		$animaciones.flip_h = false
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
	if is_on_floor():
		had_jump = true #modifica el estado de had_jump para decir que "se le permite saltar"
		return true #retorna true para permitir saltar
	elif not $coyote_timer.is_stopped():
		had_jump = true
		return true
		
##########
#SEÑALES
#########
func _on_animaciones_animation_finished():
	#print($animaciones.animation)
	#if $animaciones.animation == "appear":
		allow_animation = true


func _on_coyote_timer_timeout():
	
	print("Booooom")

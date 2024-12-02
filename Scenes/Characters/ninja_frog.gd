extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var appeared:bool = false
var leaved_floor:bool = false
var had_jump:bool = false

func _ready():
	$animaciones.play("appear")

func _physics_process(delta):
	# Add the gravity.
	if is_on_floor():
		#dejado el suelo
		leaved_floor = false
		#Ha Saltado
		had_jump = false
	if not is_on_floor():
		#Si no estoy tocando suelo
		if not leaved_floor:
			$coyote_timer.start()
			leaved_floor = true
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and right_to_jump():
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
	

func decide_animation():
	if not appeared: return
	# EJE DE LAS X
	if velocity.x == 0:
		#idle
		$animaciones.play("idle")
	elif velocity.x < 0:
		#izquierda
		$animaciones.flip_h = true
		$animaciones.play("run")
	elif velocity.x > 0:
		#derecha
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
	if had_jump: return false
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
	print($animaciones.animation)
	if $animaciones.animation == "appear":
		appeared = true


func _on_coyote_timer_timeout():
	
	print("Booooom")

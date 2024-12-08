@tool
extends Node2D

@export_enum("apple","banana","cherry") var fruitType:String = "apple":
	set(value):
		fruitType = value
		#print(value)
		#$animations.play(fruitType)
		$animations.animation = fruitType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		$animations.play(fruitType)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_collect_body_entered(body: Node2D) -> void:
	#print("Hola")
	#body.fruitCount += 1
	#print(body.fruitCount)
	if body.has_method("collecteFruit"):
		body.collecteFruit(fruitType)
	$animations.play("collected")


func _on_animations_animation_finished() -> void:
	self.queue_free()

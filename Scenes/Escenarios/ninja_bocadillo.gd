extends Sprite2D

@export var texto:String = "":
	set(value):
		visible = true
		texto = value
		$Timer.start()

var index = 0;
# Called when the node enters the scene tree for the first time.



func _on_timer_timeout() -> void:
	if index >= texto.length():
		$Timer_escondeB.start()
		$Timer.stop()
	else:
		$Label.text = $Label.text + texto[index]
		index += 1
		print(index)
		print(texto)

func _on_timer_esconde_b_timeout() -> void:
	visible = false
	$Label.text = ""
	index = 0;
	
	

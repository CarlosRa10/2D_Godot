extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().has_node("ninja_frog"):
		$health_ProgressBar.value = get_parent().get_node("ninja_frog").health
		$fruitPointsLabel.text = "Puntuación Frutas: " + str(get_parent().get_node("ninja_frog").fruitCount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$health_ProgressBar.value = get_parent().get_node("ninja_frog").health
	$fruitPointsLabel.text = "Puntuación Frutas: " + str(get_parent().get_node("ninja_frog").fruitCount)
	var currentTime =Time.get_time_dict_from_system()
	if currentTime.minute < 10:
		$Clock.text = str(Time.get_time_dict_from_system().hour) + ":0" + str(Time.get_time_dict_from_system().minute)
		#print(Time.get_time_dict_from_system())
	else:
		$Clock.text = str(Time.get_time_dict_from_system().hour) + ":" + str(Time.get_time_dict_from_system().minute)
		

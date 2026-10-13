extends Node2D

const save_path = "user://userdata.save"
var score = 0

signal score_changed


func save_data():
	var data = {
		"score": score,
	}
	var file = FileAccess.open(save_path ,FileAccess.WRITE)
	file.store_var(data)
	file.close()

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_var()
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			score = data.get("score" ,0)
	else:
		save_data()



func _ready():
	$CanvasLayer/Score.text = str(score)
	load_data()

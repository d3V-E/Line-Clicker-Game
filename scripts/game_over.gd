extends Node2D

var quote = randi_range(1 , 3)
@onready var retry: TextureButton = $CanvasLayer/Retry


func _ready():
	retry.pivot_offset = retry.size / 2
	if quote == 1:
		$CanvasLayer/Quote.text = "Print (Hello World)"
	elif quote == 2:
		$CanvasLayer/Quote.text = "Time wasted today is time saved for tommorow"
	elif quote == 3:
		$CanvasLayer/Quote.text = "To confuse an eney first you must confuse yourself"





func _on_retry_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(retry , "scale" , Vector2(.9 , .9), .1)



func _on_retry_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(retry , "scale" , Vector2(1 , 1), .1)
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

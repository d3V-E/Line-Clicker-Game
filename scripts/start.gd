extends Node2D


@onready var start : TextureButton = $CanvasLayer/Start
@onready var instructions: TextureButton = $CanvasLayer/Instructions


func _ready():
	start.pivot_offset = start.size / 2
	instructions.pivot_offset = instructions.size / 2




func _on_start_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(start , "scale" , Vector2(.9 , .9), .1)




func _on_start_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(start , "scale" , Vector2 ( 1, 1), .1)
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")





func _on_instructions_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(instructions , "scale" , Vector2(.9 , .9), .1)





func _on_instructions_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(instructions , "scale" , Vector2(1 , 1), .1)
	get_tree().change_scene_to_file("res://scenes/instructions.tscn")

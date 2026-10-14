extends Node2D

const save_path = "user://userdata.save"
var score = 0
var speed = 300
var test = 1
var width = 200
var multiplier = 1
var lives = 3
var speedcheckpoint = 10
var clicks = 10

@onready var shopbutton: TextureButton = $"CanvasLayer/Shop Button"
@onready var bar: Sprite2D = $CanvasLayer/LineBar
@onready var green: Sprite2D = $CanvasLayer/LineBar/GreenIndicator
@onready var needle: Sprite2D = $CanvasLayer/Indicator
@onready var hit: Sprite2D = $CanvasLayer/Hit
@onready var hp1 : Sprite2D = $CanvasLayer/Hp1
@onready var hp2 : Sprite2D = $CanvasLayer/Hp2
@onready var hp3 : Sprite2D = $CanvasLayer/Hp3



signal score_changed
signal multiplier_changed


func save_data():
	var data = {
		"score": score,
		"multiplier": multiplier,
		"lives": lives,
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
			multiplier = data.get("multiplier" ,1)
			lives = data.get("lives" ,3)
	else:
		save_data()



func _ready():
	shopbutton.pivot_offset = shopbutton.size / 2
	$CanvasLayer/Score.text = str(score)
	hit.visible = false
	load_data()
	randomize()
	reset_marker()


func _process(delta: float):
	needle.position.x += speed * test * delta
	
	if needle.position.x >= bar.position.x + width:
		test = -1
	elif needle.position.x <= bar.position.x - width:
		test = 1


func _unhandled_input(event: InputEvent):
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT) or (event is InputEventKey and event.pressed and event.keycode == KEY_SPACE):
		var greenmin = bar.position.x + green.position.x - (green.scale.x * 50)
		var greenmax = bar.position.x + green.position.x + (green.scale.x * 50)
		
		if needle.position.x >= greenmin and needle.position.x <= greenmax:
			score += (2 * multiplier)
			$CanvasLayer/Score.text = str(score)
			emit_signal("score_changed")
			clicks += 1
			if clicks > 0 and clicks % 10 == 0:
				speed += 15
		else:
			lives -= 1
			if score >= 1:
				score -= 1
			$CanvasLayer/Score.text = str(score)
			updlives()
			hit.visible = true
			if get_tree():
				await get_tree().create_timer(0.1).timeout
			hit.visible = false
			emit_signal("score_changed")
		reset_marker()


func reset_marker():
	green.scale.x = randf_range(0.3 , 1.0)
	green.position.x = randf_range(-width + 50 , width - 50)


func _on_shop_button_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(shopbutton , "scale" , Vector2(.9 , .9), .1)




func _on_shop_button_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(shopbutton , "scale" , Vector2(1 , 1) ,.1)






func _on_score_update_timeout():
	$CanvasLayer/Score.text = str(score)
	emit_signal("score_changed")
	save_data()


func updlives():
	if lives == 3:
		hp1.visible = true
		hp2.visible = true
		hp3.visible = true
	elif lives == 2:
		hp1.visible = true
		hp2.visible = true
		hp3.visible = false
	elif lives == 1:
		hp1.visible = true
		hp2.visible = false
		hp3.visible = false
	elif lives <= 0:
		hp1.visible = false
		hp2.visible = false
		hp3.visible = false
		lives = 3
		speed = 300
		score = 0
		clicks = 0
		save_data()
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")

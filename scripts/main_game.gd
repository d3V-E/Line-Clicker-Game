extends Node2D

const save_path = "user://userdata.save"
var score = 0
var speed = 300
var test = 1
var width = 200
var multiplier = 1
var lives = 3
var speedcheckpoint = 10
var clicks = 0
var highscore = 0
var totalscore = 0
var multipliercost = 75

@onready var shopbutton: TextureButton = $"CanvasLayer/Shop Button"
@onready var bar: Sprite2D = $CanvasLayer/LineBar
@onready var green: Sprite2D = $CanvasLayer/LineBar/GreenIndicator
@onready var needle: Sprite2D = $CanvasLayer/Indicator
@onready var hit: Sprite2D = $CanvasLayer/Hit
@onready var hp1 : Sprite2D = $CanvasLayer/Hp1
@onready var hp2 : Sprite2D = $CanvasLayer/Hp2
@onready var hp3 : Sprite2D = $CanvasLayer/Hp3
@onready var shopmenu: Sprite2D = $CanvasLayer/Shop
@onready var shopclose : TextureButton = $"CanvasLayer/Shop Close"


signal totalscore_changed
signal score_changed
signal multiplier_changed
signal highscore_changed


func save_data():
	var data = {
		"score": score,
		"multiplier": multiplier,
		"highscore": highscore,
		"totalscore": totalscore,
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
			highscore = data.get("highscore" ,0)
			totalscore = data.get("totalscore" ,0)
	else:
		save_data()



func _ready():
	load_data()
	shopbutton.pivot_offset = shopbutton.size / 2
	shopclose.pivot_offset = shopclose.size / 2
	$CanvasLayer/Score.text = str(score)
	hit.visible = false
	shopmenu.visible = false
	shopbutton.visible = true
	shopclose.visible = false
	$CanvasLayer/Highscore.text = str(highscore)
	$"CanvasLayer/Shop/Total Score".text = str(totalscore)
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
			var tween = get_tree().create_tween()
			tween.tween_property(green , "scale" , Vector2(1.1 , 1.1) , .1)
			score += (2 * multiplier)
			$CanvasLayer/Score.text = str(score)
			emit_signal("score_changed")
			tween.tween_property(green , "scale" , Vector2(1 , 1), .1)
			clicks += 1
			if clicks > 0 and clicks % 10 == 0:
				speed += 25
		else:
			lives -= 1
			if score >= 1:
				score -= 1
			$CanvasLayer/Score.text = str(score)
			updlives()
			if lives <= 0 :
				return
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
	$"CanvasLayer/Shop/Total Score".text = str(totalscore)
	shopbutton.visible = false
	shopmenu.visible = true
	shopclose.visible = true






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
		totalscore += score
		emit_signal("totalscore_changed")
		if score > highscore:
			highscore = score
			emit_signal("highscore_changed")
		lives = 3
		speed = 300
		score = 0
		clicks = 0
		save_data()
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")







func _on_shop_close_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(shopclose , "scale" , Vector2(.9 , .9), .1)





func _on_shop_close_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(shopclose , "scale" , Vector2(1 , 1) , .1)
	shopclose.visible = false
	shopmenu.visible = false
	shopbutton.visible = true

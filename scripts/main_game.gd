extends Node2D

const save_path = "user://userdata.savefile"
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
var slowspeedcost = 150
var checkpointcost = 300
var extra = 50
var combo = 0
var clickcheck = 0



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
@onready var multiplierbuy: TextureButton = $"CanvasLayer/Shop/Multiplier Buy"
@onready var slowspeedbuy: TextureButton = $"CanvasLayer/Shop/Speed Buy"
@onready var checkpoint: TextureButton = $"CanvasLayer/Shop/Checkpoint Buy"
@onready var extralife: TextureButton = $"CanvasLayer/Extra Life"
@onready var extracost: RichTextLabel = $"CanvasLayer/Extra Cost"
@onready var combotext : RichTextLabel = $CanvasLayer/Combo




signal totalscore_changed
signal highscore_changed
signal speed_changed
signal slowspeedcost_changed
signal multiplier_changed
signal multipliercost_changed
signal speedcheckpoint_changed
signal speedcheckpointcost_changed


func save_data():
	var data = {
		"highscore": highscore,
		"totalscore": totalscore,
		"speed": speed,
		"slowspeedcost": slowspeedcost,
		"multiplier": multiplier,
		"multipliercost": multipliercost,
		"speedcheckpoint": speedcheckpoint,
		"checkpointcost": checkpointcost,
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
			highscore = data.get("highscore" ,0)
			totalscore = data.get("totalscore" ,0)
			speed = data.get("speed" , 300)
			slowspeedcost = data.get("slowspeedcost" , 150)
			multiplier = data.get("multiplier" , 1)
			multipliercost = data.get("multipliercost" , 75)
			speedcheckpoint = data.get("speedcheckpont" , 10)
			checkpointcost = data.get("checkpointcost" , 300)
	else:
		save_data()



func _ready():
	load_data()
	hideextra()
	extralife.pivot_offset = extralife.size / 2
	shopbutton.pivot_offset = shopbutton.size / 2
	shopclose.pivot_offset = shopclose.size / 2
	multiplierbuy.pivot_offset = multiplierbuy.size / 2
	slowspeedbuy.pivot_offset = slowspeedbuy.size / 2
	checkpoint.pivot_offset = checkpoint.size / 2
	combotext.visible = false
	$CanvasLayer/Combo.text = "COMBO = 0x"
	$CanvasLayer/Score.text = str(score)
	hit.visible = false
	shopmenu.visible = false
	shopbutton.visible = true
	shopclose.visible = false
	$CanvasLayer/Highscore.text = str(highscore)
	$"CanvasLayer/Shop/Total Score".text = str(totalscore)
	$CanvasLayer/Shop/ShopInfo/Info.text = "Example Information"
	$CanvasLayer/Indicator.modulate.a = 1
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
		if shopmenu.visible == true:
			return
		if needle.position.x >= greenmin and needle.position.x <= greenmax:
			var tween = get_tree().create_tween()
			tween.tween_property(green , "scale" , Vector2(1.1 , 1.1) , .1)
			score += (2 * multiplier)
			combo += 1
			combotext.visible = true
			if combo % 15 == 0:
				needle.modulate = Color(randf(), randf() , randf() , 1)
				if $CanvasLayer/Indicator.modulate.a > 0.3:
					$CanvasLayer/Indicator.modulate.a -= 0.05
			if combo >= 50:
				score += 1
			$CanvasLayer/Combo.text = "COMBO = "+ str(combo)+ "x"
			$CanvasLayer/Score.text = str(score)
			$CanvasLayer/Scoreinfo.text = "+ 2 score"
			tween.tween_property(green , "scale" , Vector2(1 , 1), .1)
			clicks += 1
			if clicks > 0 and clicks % 5 == 0:
				speed += 25
				clickcheck += 1
		else:
			lives -= 1
			combo = 0
			combotext.visible = false
			$CanvasLayer/Combo.text = "COMBO = "+ str(combo)+ "x"
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
			$CanvasLayer/Scoreinfo.text = "- 1 score and - 1 life"
		reset_marker()


func reset_marker():
	var x = randi_range(1 , 2)
	if x == 1:
		test = 1
	elif x == 2:
		test = -1
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
	$"CanvasLayer/Shop/Total Score".text = str(totalscore)
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
		showextra()
		hp1.visible = true
		hp2.visible = false
		hp3.visible = false
	elif lives <= 0:
		hp1.visible = false
		hp2.visible = false
		hp3.visible = false
		totalscore += score
		speed = speed - (clickcheck * 25)
		emit_signal("totalscore_changed")
		if score > highscore:
			highscore = score
			emit_signal("highscore_changed")
		$CanvasLayer/Indicator.modulate.a = 1
		lives = 3
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
	$CanvasLayer/Shop/Multiplier.text = "Multiplier Upgrade\nCurrent Multiplier = "+ str(multiplier) + "\nCost = "+ str(multipliercost)
	$CanvasLayer/Shop/Speed.text = "Slow Speed\nCurrent Speed = "+ str(speed) + "\nCost = "+ str(slowspeedcost)
	$"CanvasLayer/Shop/Speed Checkpoint".text = "Speed Checkpoint\nCurrent Checkpoint = "+str(speedcheckpoint) + "\nCost = " +str(checkpointcost)




func _on_multiplier_buy_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(multiplierbuy , "scale" , Vector2(.9 , .9), .1)




func _on_multiplier_buy_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(multiplierbuy , "scale" , Vector2(1 , 1), .1)
	if totalscore >= multipliercost:
		totalscore -= multipliercost
		multiplier += 0.2
		multipliercost += 45
		$CanvasLayer/Shop/ShopInfo/Info.text = "Bought Multiplier Boost"
		$CanvasLayer/Shop/Multiplier.text = "Multiplier Upgrade\nCurrent Multiplier = "+ str(multiplier) + "\nCost = "+ str(multipliercost)
		emit_signal("totalscore_changed")
		emit_signal("multipliercost_changed")
		emit_signal("multiplier_changed")
	else:
		$CanvasLayer/Shop/ShopInfo/Info.text = "Not enough score."





func _on_speed_buy_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(slowspeedbuy , "scale" , Vector2(.9 , .9), .1)




func _on_speed_buy_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(slowspeedbuy , "scale" , Vector2(1,1), .1)
	if totalscore >= slowspeedcost:
		totalscore -= slowspeedcost
		speed -= 5
		slowspeedcost += 75
		$CanvasLayer/Shop/ShopInfo/Info.text = "Bought Upgrade"
		$CanvasLayer/Shop/Speed.text = "Slow Speed\nCurrent Speed = "+ str(speed) + "\nCost = "+ str(slowspeedcost)
		emit_signal("totalscore_changed")
		emit_signal("slowspeedcost_changed")
		emit_signal("speed_changed")
	else:
		$CanvasLayer/Shop/ShopInfo/Info.text = "Get more score"





func _on_checkpoint_buy_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(checkpoint , "scale" , Vector2(.9 , .9) , .1)





func _on_checkpoint_buy_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(checkpoint , "scale" , Vector2(1 , 1) , .1)
	if totalscore >= checkpointcost:
		totalscore -= checkpointcost
		speedcheckpoint += 5
		checkpointcost += 125
		$CanvasLayer/Shop/ShopInfo/Info.text = "Speed Checkpoint Increased"
		$"CanvasLayer/Shop/Speed Checkpoint".text = "Speed Checkpoint\nCurrent Checkpoint = "+str(speedcheckpoint) + "\nCost = " +str(checkpointcost)
		emit_signal("totalscore_changed")
		emit_signal("speedcheckpointcost_changed")
		emit_signal("speedcheckpoint_changed")
	else:
		$CanvasLayer/Shop/ShopInfo/Info.text = "Need more score to buy"




func hideextra():
	extralife.visible = false
	extracost.visible = false


func showextra():
	extralife.visible = true
	extracost.visible = true




func _on_extra_life_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(extralife , "scale" , Vector2(.9 , .9), .1)




func _on_extra_life_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(extralife , "scale" , Vector2(1 , 1), .1)
	if score >= extra:
		score -= extra
		lives += 1
		extra += 25
		$"CanvasLayer/Extra Cost".text = "COST = "+ str(extra)
		updlives()
		hideextra()






func _on_visual_upd_timeout():
	$CanvasLayer/Scoreinfo.text = ""

extends Node2D

var slide = 1


@onready var next: TextureButton = $CanvasLayer/Next
@onready var previous: TextureButton = $CanvasLayer/Previous
@onready var linebar: Sprite2D = $CanvasLayer/LineBar
@onready var green: Sprite2D = $CanvasLayer/GreenIndicator
@onready var indicator : Sprite2D = $CanvasLayer/Indicator
@onready var greensecond : Sprite2D = $CanvasLayer/Greensecond
@onready var shop: Sprite2D =  $CanvasLayer/ShopButton
@onready var extralife : Sprite2D = $CanvasLayer/ExtraLife


func _ready():
	previous.visible = true
	next.visible = true
	linebar.visible = true
	green.visible = true
	indicator.visible = true
	greensecond.visible = false
	shop.visible = false
	extralife.visible = false
	$CanvasLayer/Context.text = "When the indicator (red thing) is above the green bar you can click or press spacebar to get a score + 2"



func _on_next_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(next , "scale" , Vector2(.9 , .9) , .1)





func _on_next_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(next , "scale" , Vector2(1 , 1) , .1)
	slide += 1
	if slide == 0:
		get_tree().change_scene_to_file("res://scenes/start.tscn")
	if slide == 1:
		previous.visible = true
		next.visible = true
		linebar.visible = true
		green.visible = true
		indicator.visible = true
		greensecond.visible = false
		shop.visible = false
		extralife.visible = false
		$CanvasLayer/Context.text = "When the indicator (red thing) is above the green bar you can click or press spacebar to get a score + 2 and after some number of clicks the speed increases and the indicator color changes"
	elif slide == 2:
		previous.visible = true
		next.visible = true
		linebar.visible = true
		green.visible = false
		indicator.visible = true
		greensecond.visible = true
		shop.visible = false
		extralife.visible = false
		$CanvasLayer/Context.text = "When the indicator (red thing) is not above the green bar and you click you lose -1 score and -1 life you have 3 lives in total after you lose all your lives = game over"
	elif slide == 3:
		previous.visible = true
		next.visible = false
		linebar.visible = false
		green.visible = false
		indicator.visible = false
		greensecond.visible = false
		shop.visible = true
		extralife.visible = true
		$CanvasLayer/Context.text = "The shop button opens a shop where you can buy multiple upgrades to increase your highscore and the extra life option arrives when you are at 1 life and costs to buy a temperory extra life which increases in cost"






func _on_previous_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(previous , "scale" , Vector2(.9 , .9) , .1)




func _on_previous_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(previous , "scale" , Vector2(1 , 1), .1)
	slide -= 1
	if slide == 0:
		get_tree().change_scene_to_file("res://scenes/start.tscn")
	if slide == 1:
		previous.visible = true
		next.visible = true
		linebar.visible = true
		green.visible = true
		indicator.visible = true
		greensecond.visible = false
		shop.visible = false
		extralife.visible = false
		$CanvasLayer/Context.text = "When the indicator (red thing) is above the green bar you can click or press spacebar to get a score + 2 and after some number of clicks the speed increases and the indicator color changes"
	elif slide == 2:
		previous.visible = true
		next.visible = true
		linebar.visible = true
		green.visible = false
		indicator.visible = true
		greensecond.visible = true
		shop.visible = false
		extralife.visible = false
		$CanvasLayer/Context.text = "When the indicator (red thing) is not above the green bar and you click you lose -1 score and -1 life you have 3 lives in total after you lose all your lives = game over"
	elif slide == 3:
		previous.visible = true
		next.visible = false
		linebar.visible = false
		green.visible = false
		indicator.visible = false
		greensecond.visible = false
		shop.visible = true
		extralife.visible = true
		$CanvasLayer/Context.text = "The shop button opens a shop where you can buy multiple upgrades to increase your highscore and the extra life option arrives when you are at 1 life and costs to buy a temperory extra life which increases in cost"

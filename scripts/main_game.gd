extends Node2D

const save_path = "user://userdata.save"
var score = 0
var speed: float = 300
var test = 1
var width = 200

@onready var shopbutton: TextureButton = $"CanvasLayer/Shop Button"
@onready var bar: Sprite2D = $CanvasLayer/LineBar
@onready var green: Sprite2D = $CanvasLayer/LineBar/GreenIndicator
@onready var needle: Sprite2D = $CanvasLayer/Indicator




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
	shopbutton.pivot_offset = shopbutton.size / 2
	$CanvasLayer/Score.text = str(score)
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
			score += 1
			print("test +1")
		else:
			print("test 0")
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

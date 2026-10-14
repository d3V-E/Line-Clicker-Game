extends Node2D

var quote = randi_range(1 , 3)


func _ready():
	if quote == 1:
		$CanvasLayer/Quote.text = "Print (Hello World)"
	elif quote == 2:
		$CanvasLayer/Quote.text = "Time wasted today is time saved for tommorow"
	elif quote == 3:
		$CanvasLayer/Quote.text = "To confuse an eney first you must confuse yourself"

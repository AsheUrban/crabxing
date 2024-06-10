extends Area3D
class_name Craft

var speed = 3.0 # m/s
var start: float
var end: float

func _ready():
	speed = get_parent().speed_limit
	start = get_parent().start_point_x
	end = get_parent().end_point_x

func _process(delta):
	position.x += speed * delta
	if position.x > end:
		position.x = start

extends Area3D
class_name Animal

@export var stride_speed: float = 0.25 # in seconds
@onready var crab = $Crab

var current_position: Vector3
var target_position: Vector3
var position_lerp: float = 1.0 # 0-100% | 1 / 100

var current_rotation: float 
var target_rotation: float
var rotation_lerp: float

func _ready():
	current_position = position
	target_position = position
	area_entered.connect(OnAreaEntered)
	
func _process(delta):
	if position_lerp < 1.0:
		position_lerp += delta / stride_speed
		rotation_lerp += delta / stride_speed
		
		position_lerp = clamp(position_lerp, 0.0, 1.0)
		rotation_lerp = clamp(rotation_lerp, 0.0, 1.0)
		
		position = lerp(current_position, target_position, position_lerp)
		crab.rotation_degrees.y = lerp(current_rotation, target_rotation, rotation_lerp)
	else: 
		current_position = target_position
		current_rotation = target_rotation
		
		if Input.is_action_just_pressed("move_left"):
			target_position = current_position + Vector3.LEFT
			position_lerp = 0.0
			target_rotation = 90.0
			rotation_lerp = 0.0
			
		if Input.is_action_just_pressed("move_right"):
			target_position = current_position + Vector3.RIGHT
			position_lerp = 0.0
			target_rotation = -90.0
			rotation_lerp = 0.0
			
		if Input.is_action_just_pressed("move_forward"):
			target_position = current_position + Vector3.FORWARD # this is equal to Vector3.(0,0,-1)
			position_lerp = 0.0
			target_rotation = 0.0
			rotation_lerp = 0.0
			
		if Input.is_action_just_pressed("move_backward"):
			target_position = current_position + Vector3.BACK
			position_lerp = 0.0
			target_rotation = 180.0
			rotation_lerp = 0.0
			#if current_rotation < 1.0:

func OnAreaEntered(area: Area3D):
	if area is Road:
		print("You made it across the road!", area)
	if area is Vehicle:
		print("XX/ You were hit by a vehicle!", area)
	if area is River:	
		print("Swallowed by the depths!", area)
	if area is Vessel:
		print("Riding the: ", area)
	if area is Roost:
		print("We made it safely to our roost!", area)	
		
	

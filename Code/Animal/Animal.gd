extends Area3D
class_name Animal

@export var stride_speed: float = 0.25 # in seconds
@onready var crab = $Crab

var main: Main

var current_position: Vector3
var target_position: Vector3
var position_lerp: float = 1.0 # 0-100% | 1 / 100

var current_rotation: float 
var target_rotation: float
var rotation_lerp: float

var killed: bool = false
var killed_speed: float = 4.0

var ride: Vessel = null
var ride_offset: Vector3 = Vector3.ZERO

func _ready():
	area_entered.connect(OnAreaEntered)
	main = get_parent()
	current_position = position
	target_position = position
	
func _process(delta):
	if global_position.x > 10 or global_position.x < -10:
		Kill()
		
	if position_lerp < 1.0:
		if ride != null:
			target_position = ride.global_position + ride_offset
			
		if not killed:
			position_lerp += delta / stride_speed
		else:
			position_lerp += delta / killed_speed
		rotation_lerp += delta / stride_speed
		
		position_lerp = clamp(position_lerp, 0.0, 1.0)
		rotation_lerp = clamp(rotation_lerp, 0.0, 1.0)
		
		position = lerp(current_position, target_position, position_lerp)
		crab.rotation_degrees.y = lerp(current_rotation, target_rotation, rotation_lerp)
		
		if position_lerp >= 1.0:
			current_position = target_position
			current_rotation = target_rotation
			killed = false
			crab.show()
			
	else: 
		if ride != null:
			position = ride.global_position + ride_offset
			current_position = position
			
		if Input.is_action_just_pressed("move_left"):
			if ride != null:
				ride_offset += Vector3.LEFT
				if ride.global_rotation.y == 0:
					if ride_offset.x < 0.0:
						Kill()
				else:
					if ride_offset.x < -(ride.seat_count - 1):
						Kill()
			else:
				target_position = current_position + Vector3.LEFT
			position_lerp = 0.0
			target_rotation = 90.0
			rotation_lerp = 0.0
			
		if Input.is_action_just_pressed("move_right"):
			if ride != null:
				ride_offset += Vector3.RIGHT
				if ride.global_rotation.y == 0:
					if ride_offset.x > ride.seat_count - 1:
						Kill()
				else:
					if ride_offset.x > 0.0:
						Kill()
			else:
				target_position = current_position + Vector3.RIGHT
			position_lerp = 0.0
			target_rotation = -90.0
			rotation_lerp = 0.0
			if current_rotation > 90.0: # unwind from 180 degrees
				current_rotation -= 360.0
			
		if Input.is_action_just_pressed("move_forward"):
			ride = null
			target_position = current_position + Vector3.FORWARD # this is equal to Vector3.(0,0,-1)
			position_lerp = 0.0
			target_rotation = 0.0
			rotation_lerp = 0.0
			
		if Input.is_action_just_pressed("move_backward"):
			ride = null
			target_position = current_position + Vector3.BACK
			position_lerp = 0.0
			target_rotation = 180.0
			rotation_lerp = 0.0
			if current_rotation < 0.0: # -90
				current_rotation += 360.0
				
func Kill():
	ride = null
	killed = true 
	current_position = position
	ResetToOrigin()
	main.player_ui.UpdateLives(-1)

func ResetToOrigin():
	crab.hide()
	target_position = Vector3.ZERO
	current_rotation = 0.0
	target_rotation = 0.0	
	position_lerp = 0.0		
	killed_speed = stride_speed * current_position.distance_to(target_position)
	print("Dsitance to origin: ", killed_speed)
			
func OnAreaEntered(area: Area3D):
	if not killed:
		if area is Vehicle or area is River:
		#if area is River:
			if ride == null:
				Kill()
				main.IsGameOver("Game Over")
				print("XX/ You were killed by: ", area)
		
		if area is Roost:
			if not area.animal.visible:
				area.ShowAnimal()
				Kill() #this doesn't really work here
				print("We made it safely to our roost! ", area)	
			main.IsGameOver("You win!")
				
		if area is Vessel:
			ride = area
			ride_offset.x = round(global_position.x - area.global_position.x)
				
			if area.global_rotation.y == 0.0: # Only left and right rivers
				ride_offset.x = clamp(ride_offset.x, 0.0, area.seat_count - 1)
			else:
				ride_offset.x = clamp(ride_offset.x, -(area.seat_count - 1), 0.0)
					
			print("Riding the: ", area)
			print("ride offset = ", ride_offset)
					
		if area is Road:
			main.player_ui.UpdateScore(10)
			print("You made it across the road! ", area)
				
		
	

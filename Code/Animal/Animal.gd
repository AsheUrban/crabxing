extends Area3D
class_name Animal

@export var stride_speed: float = 0.25 # in seconds
@onready var crab = $Crab

var current_position: Vector3
var target_position: Vector3
var lerp_percentage: float = 1.0 # 0-100% | 1 / 100

func _ready():
	current_position = position
	target_position = position
	
func _process(delta):
	
	if lerp_percentage >= 1.0:
		if Input.is_action_just_pressed("move_left"):
			target_position = current_position + Vector3.LEFT
			lerp_percentage = 0.0
			crab.rotation_degrees.y = 90
		if Input.is_action_just_pressed("move_right"):
			target_position = current_position + Vector3.RIGHT
			lerp_percentage = 0.0
			crab.rotation_degrees.y = -90
		if Input.is_action_just_pressed("move_forward"):
			target_position = current_position + Vector3.FORWARD # this is equal to Vector3.(0,0,-1)
			lerp_percentage = 0.0
			crab.rotation_degrees.y = 0
		if Input.is_action_just_pressed("move_backward"):
			target_position = current_position + Vector3.BACK
			lerp_percentage = 0.0
			crab.rotation_degrees.y = 180

	if lerp_percentage < 1.0:
		lerp_percentage += delta / stride_speed
		lerp_percentage = clamp(lerp_percentage, 0.0, 1.0)
		position = lerp(current_position, target_position, lerp_percentage)
	else: 
		current_position = target_position





#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#
#
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()

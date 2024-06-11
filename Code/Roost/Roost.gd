extends Area3D
class_name Roost

@onready var animal = $Graphics/Animal

func _ready():
	animal.hide()
	
func ShowAnimal():
	animal.show()
	
	

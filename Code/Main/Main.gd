extends Node
class_name Main

@onready var game_over = $GameOver
@onready var roosts = $Roosts
@onready var player_ui = $PlayerUI

func _ready():
	game_over.hide()
	
func IsGameOver():
	var is_roost_full = true
	for roost in roosts.get_children():
		if not roost.animal.visible:
			is_roost_full = false
			
	if is_roost_full:
		game_over.show()
	
	

extends Control
class_name PlayerUI

const LIFE = preload("res://PlayerUI/PlayerUI.tscn")

@onready var score_ui = $VBox/ScoreUI
@onready var lives_ui = $VBox/LivesUI

var score = 0
var lives = 0

func _ready():
	UpdateLives(4)

func UpdateScore(delta_score: int):
	score += delta_score
	score_ui.text = "SCORE: " + str(score)
	
func UpdateLives(delta_lives: int):
	lives += delta_lives
	for node in lives_ui.get_children():
		lives_ui.remove_child(node)
	
	for i in lives: 
		var life = LIFE.instantiate() 
		lives_ui.add_child(life)

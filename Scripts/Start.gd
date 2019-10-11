extends Node2D

onready var game = preload("res://Main.tscn")

func _ready():
	Global.score = 0

func _on_Start_pressed():
	get_tree().change_scene_to(game)

func _on_Quit_pressed():
	get_tree().quit()

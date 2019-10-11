extends Node2D

onready var game = load("res://Main.tscn")

func _ready():
	pass


func _on_Retry_pressed():
	get_tree().change_scene_to(game)


func _on_Quit_pressed():
	get_tree().quit()

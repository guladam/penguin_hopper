extends CanvasLayer

signal controls_requested

const LEVEL = preload("res://scenes/level/level.tscn")

@onready var new_game_button: Button = %NewGameButton
@onready var controls_button: Button = %ControlsButton
@onready var exit_button: Button = %ExitButton


func _ready() -> void:
	new_game_button.pressed.connect(
		func(): get_tree().change_scene_to_packed(LEVEL)
	)
	
	controls_button.pressed.connect(
		func(): controls_requested.emit()
	)
	
	exit_button.pressed.connect(
		func(): get_tree().quit()
	)

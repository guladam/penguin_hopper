extends CanvasLayer

const MENU = preload("res://scenes/menu/menu.tscn")

@onready var controls_layer: CanvasLayer = %ControlsLayer
@onready var pause_container: VBoxContainer = $PauseContainer


func _ready() -> void:
	%Back.pressed.connect(_toggle_pause.bind(false))
	
	%Controls.pressed.connect(
		func():
			pause_container.visible = false
			controls_layer.visible = true
	)
	
	controls_layer.controls_close_requested.connect(
		func():
			pause_container.visible = true
			controls_layer.visible = false
	)
	
	%Menu.pressed.connect(
		func():
			get_tree().paused = false
			get_tree().change_scene_to_packed(MENU)
	)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pause(not get_tree().paused)


func _toggle_pause(paused: bool) -> void:
	get_tree().paused = paused
	visible = paused
	pause_container.visible = paused
	controls_layer.visible = false

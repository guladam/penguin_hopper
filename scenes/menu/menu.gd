extends Node3D

@onready var menu_layer: CanvasLayer = $MenuLayer
@onready var controls_layer: CanvasLayer = $ControlsLayer


func _ready() -> void:
	menu_layer.controls_requested.connect(
		func(): 
			menu_layer.visible = false
			controls_layer.visible = true
	)
	
	controls_layer.controls_close_requested.connect(
		func():
			menu_layer.visible = true
			controls_layer.visible = false
	)

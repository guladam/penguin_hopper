extends CanvasLayer

signal controls_close_requested


func _ready() -> void:
	%BackButton.pressed.connect(
		func(): controls_close_requested.emit()
	)

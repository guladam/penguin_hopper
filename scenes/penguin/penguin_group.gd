extends Node3D

var selected: Penguin


func _ready() -> void:
	_select_penguin(0)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_penguin"):
		_select_penguin(wrapi(selected.get_index()+1, 0, get_child_count()))


func _select_penguin(index: int) -> void:
	if selected:
		selected.current = false
	
	var penguin: Penguin = get_child(index) as Penguin
	penguin.current = true
	selected = penguin
